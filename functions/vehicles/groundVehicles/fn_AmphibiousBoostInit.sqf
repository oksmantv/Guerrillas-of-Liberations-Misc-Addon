/*
    OKS_fnc_AmphibiousBoostInit

    Client-side amphibious IFV water-speed boost.

    Design goals:
    - Runs only where the vehicle is local (typically the driver client).
    - Uses setVelocityModelSpace to add a small, clamped forward delta (reduced jitter).
    - Only active while driver holds Shift ("turbo") and is pressing forward.

    Settings (CBA):
    - GOL_AmphIFVBoost_Enabled (bool)
    - GOL_AmphIFVBoost_Debug (bool)

    Behaviour (hard-coded to avoid "crazy speeds"):
    - Activates only if current forward speed >= 10 km/h
    - Boosts smoothly up to 25 km/h (ceiling)
    - 10 -> 25 km/h takes ~5 seconds (linear accel)
*/

if (!hasInterface) exitWith {};

private _existing = missionNamespace getVariable ["OKS_AmphIFVBoost_PFH", -1];
if (_existing isNotEqualTo -1) exitWith {};

private _defaultBaseClasses = [
    "APC_Wheeled_01_base_F",
    "APC_Wheeled_02_base_F",
    "APC_Wheeled_03_base_F",
    "APC_Tracked_01_base_F",
    "APC_Tracked_02_base_F",
    "APC_Tracked_03_base_F",
    "B_T_APC_Wheeled_01_cannon_F",

    // Fennek / MRAP-03 variants (some mod packs use custom classnames)
    "I_MRAP_03_F",
	"I_MRAP_03_hmg_F",
    "I_MRAP_03_gmg_F",
    "Fennek_wd",
    "Fennek_gmg_e",
    "Fennek_gmg_d",
    "Fennek_gmg_wd",
    "Fennek_hmg_e",
    "Fennek_hmg_d",
    "Fennek_hmg_wd"
];

private _minSpeed = 10 / 3.6; // m/s
private _maxSpeed = 25 / 3.6; // m/s
private _accel = ((_maxSpeed - _minSpeed) / 5) max 0; // m/s^2 (10->25 km/h in ~5s)
private _rampSeconds = 5;

// Performance: the boost doesn't need every-frame polling.
// 0.05 = 20Hz (good balance between responsiveness and MP client cost).
private _pfhInterval = 0.05;

if (missionNamespace getVariable ["GOL_AmphIFVBoost_Debug", true]) then {
    [
        "[AMPHIB_IFV_BOOST] Init: adding PFH",
        false,
        false,
        true
    ] spawn OKS_fnc_LogDebug;
};

private _pfhId = [{
    params ["_state", "_pfhId"];

    private _now = diag_tickTime;

    // Zeus/Curator: never apply boost while the curator UI is open.
    // Shift+W and similar controls are used for curator camera movement and can otherwise trigger boost logic.
    if (!isNull (findDisplay 312)) exitWith {
        // Ensure we don't keep any ramp state while curator is open.
        if ((count _state) > 11 && {(_state#11) != 0}) then { _state set [11, 0]; };
        if ((count _state) > 4 && {(_state#4)}) then { _state set [4, false]; };
    };

    // Backward-compat: older PFH state arrays (from previous builds) may be shorter.
    if ((count _state) < 13) then {
        _state resize 13;
    };
    if (isNil { _state#10 }) then { _state set [10, _now]; };
    if (isNil { _state#11 }) then { _state set [11, 0]; };
    if (isNil { _state#12 }) then { _state set [12, 5]; };

    private _dt = (_now - (_state#10)) max 0;
    _state set [10, _now];

    private _debug = missionNamespace getVariable ["GOL_AmphIFVBoost_Debug", true];
    private _verbose = missionNamespace getVariable ["GOL_AmphIFVBoost_DebugVerbose", true];
    private _enabled = missionNamespace getVariable ["GOL_AmphIFVBoost_Enabled", false];

	// Fast exit when feature is disabled and we're not actively debugging.
	if (!_enabled && {!_debug}) exitWith {};

    private _player = player;
    if (isNull _player) exitWith {};

    private _veh = vehicle _player;
    private _isInVehicle = !(_veh isEqualTo _player);
	if (!_isInVehicle) exitWith {
		// On-foot: do nothing. (Optional verbose heartbeat is throttled.)
		if (_debug && _verbose) then {
			private _lastHb = _state#9;
			if ((_now - _lastHb) > 15) then {
				[
					format ["[AMPHIB_IFV_BOOST] Heartbeat enabled=%1 inVeh=false", _enabled],
					false,
					false,
					true
				] spawn OKS_fnc_LogDebug;
				_state set [9, _now];
			};
		};
	};

    private _isDriver = _isInVehicle && {driver _veh isEqualTo _player};
    private _isLocal = _isInVehicle && {local _veh};

    private _isInWater = false;
    if (_isInVehicle) then {
        // Use only documented/standard surface test (avoid relying on uncertain commands).
        _isInWater = surfaceIsWater (getPosATL _veh);
        if (!_isInWater) then {
            // Fallback: some objects behave better with world-space position.
            _isInWater = surfaceIsWater (getPosWorld _veh);
        };
    };

    // Ignore canFloat: some amphibious-capable mod vehicles don't advertise canFloat correctly.
    // Still exclude actual ships.
    private _isAllowedKind = _isInVehicle && {!(_veh isKindOf "Ship")};

    // Input polling is relatively expensive; only do it for the local driver.
    private _turbo = 0;
    private _fastFwd = 0;
    private _forwardInput = 0;
    private _hasShiftAndForward = false;
    private _shiftLikePressed = false;

    if (_isDriver && {_isLocal} && {(_enabled || _debug)}) then {
        // Some control schemes report Shift+W as carFastForward rather than turbo.
        _turbo = inputAction "turbo";
        _fastFwd = inputAction "carFastForward";
        {
            _forwardInput = _forwardInput max (inputAction _x);
        } forEach ["carForward", "carFastForward", "moveForward", "tankForward", "tankFastForward"];
        _hasShiftAndForward = (_fastFwd > 0.1) || {(_turbo > 0.1) && (_forwardInput > 0.1)};
        _shiftLikePressed = (_turbo > 0.1) || (_fastFwd > 0.1);
    };

    // Class filter: default IFV/APC base classes.
    private _allowed = _state#0;
    private _classAllowed = _isInVehicle && {(_allowed findIf {_veh isKindOf _x}) isNotEqualTo -1};

    private _velMS = if (_isInVehicle) then { velocityModelSpace _veh } else { [0,0,0] };
    private _fwd = _velMS#1; // m/s (forward)

    // Verbose: state snapshot + heartbeat so we know the PFH is alive.
    // Throttled and only while in a vehicle.
    if (_debug && _verbose && {_isInVehicle}) then {
        private _lastHb = _state#9;
        if ((_now - _lastHb) > 10) then {
            [
                format ["[AMPHIB_IFV_BOOST] Heartbeat enabled=%1 inVeh=%2 isDriver=%3 local=%4 water=%5", _enabled, _isInVehicle, _isDriver, _isLocal, _isInWater],
                false,
                false,
                true
            ] spawn OKS_fnc_LogDebug;
            _state set [9, _now];
        };

        private _snap = format [
            "enabled=%1 inVeh=%2 veh=%3 driver=%4 local=%5 water=%6 classOk=%7 speed=%.1f turbo=%.2f fastFwd=%.2f fwd=%.2f",
            _enabled,
            _isInVehicle,
            if (_isInVehicle) then {typeOf _veh} else {"<none>"},
            _isDriver,
            _isLocal,
            _isInWater,
            _classAllowed,
            (_fwd * 3.6),
            _turbo,
            _fastFwd,
            _forwardInput
        ];
        if (_snap != (_state#7) && {(_now - (_state#8)) > 2}) then {
            [
                format ["[AMPHIB_IFV_BOOST] SNAP %1", _snap],
                false,
                false,
                true
            ] spawn OKS_fnc_LogDebug;
            _state set [7, _snap];
            _state set [8, _now];
        };
    };

    private _shouldBoost = false;
    private _reason = "";
    if (!_enabled) then {
        _reason = "DISABLED";
    } else {
        if (!_isInVehicle) then {
            _reason = "ON_FOOT";
        } else {
            if (!_isDriver) then {
                _reason = "NOT_DRIVER";
            } else {
                if (!_isLocal) then {
                    _reason = "NOT_LOCAL";
                } else {
                    if (!_isInWater) then {
                        _reason = "NOT_WATER";
                    } else {
                        if (!_isAllowedKind) then {
                            _reason = "SHIP_BLOCKED";
                        } else {
                            if (!_classAllowed) then {
                                _reason = "CLASS_BLOCKED";
                            } else {
                                if (!_hasShiftAndForward) then {
                                    _reason = "NO_SHIFT_OR_FORWARD";
                                } else {
                                    if (_fwd < _state#1) then {
                                        _reason = "BELOW_MIN_SPEED";
                                    } else {
                                        if (_fwd >= _state#2) then {
                                            _reason = "AT_CAP";
                                        } else {
                                            _shouldBoost = true;
                                            _reason = "BOOSTING";
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        };
    };

    // Throttled debug logging.
    if (_debug) then {
        private _wasBoosting = _state#4;
        private _lastAt = _state#5;
        private _lastReason = _state#6;
        // _now is computed once at PFH start (perf).

        if (_shouldBoost && {!_wasBoosting}) then {
            format [
                "[AMPHIB_IFV_BOOST] ON veh=%1 speed=%.1f kph turbo=%.2f fastFwd=%.2f fwd=%.2f water=%3 local=%4",
                typeOf _veh,
                _fwd * 3.6,
                _turbo,
                _fastFwd,
                _forwardInput,
                _isInWater,
                _isLocal
            ] spawn OKS_fnc_LogDebug;
        };

        if (!_shouldBoost && {_wasBoosting}) then {
            format [
                "[AMPHIB_IFV_BOOST] OFF veh=%1 reason=%2 speed=%.1f kph",
                typeOf _veh,
                _reason,
                _fwd * 3.6
            ] spawn OKS_fnc_LogDebug;
        };

        // Diagnostic log while trying to boost (shift pressed) but not boosting.
        if (!_shouldBoost && {_shiftLikePressed} && {(_now - _lastAt) > 1} && {(_reason != _lastReason) || {(_now - _lastAt) > 4}}) then {
            [
                format [
                    "[AMPHIB_IFV_BOOST] Blocked reason=%1 veh=%2 speed=%.1f kph turbo=%.2f fastFwd=%.2f fwd=%.2f driver=%3 water=%4 local=%5",
                    _reason,
                    if (_isInVehicle) then {typeOf _veh} else {"<none>"},
                    _fwd * 3.6,
                    _turbo,
                    _fastFwd,
                    _forwardInput,
                    _isDriver,
                    _isInWater,
                    _isLocal
                ],
                false,
                false,
                true
            ] spawn OKS_fnc_LogDebug;
            _state set [5, _now];
            _state set [6, _reason];
        };

        _state set [4, _shouldBoost];
    };

    if (!_shouldBoost) exitWith {
        // Not boosting: reset ramp timer.
        if ((_state#11) != 0) then { _state set [11, 0]; };
    };

    // Apply boost (local only)
    // Water drag can cancel small incremental deltas; instead enforce a ramped minimum forward speed.
    // While boosting: minSpeed -> maxSpeed over ~5 seconds.
    private _boostT = ((_state#11) + _dt) max 0;
    private _ramp = _state#12;
    _boostT = _boostT min _ramp;
    _state set [11, _boostT];

    private _alpha = if (_ramp > 0) then { _boostT / _ramp } else { 1 };
    private _desired = (_state#1) + ((_state#2) - (_state#1)) * (_alpha min 1);
    private _newFwd = (_fwd max _desired) min (_state#2);
    _velMS set [1, _newFwd];
    _veh setVelocityModelSpace _velMS;
}, _pfhInterval, [
    +_defaultBaseClasses,
    _minSpeed,
    _maxSpeed,
    _accel,
    false,
    0,
    "",
    "",
    0,
    0,
    diag_tickTime,
    0,
    _rampSeconds
]] call CBA_fnc_addPerFrameHandler;

missionNamespace setVariable ["OKS_AmphIFVBoost_PFH", _pfhId];
