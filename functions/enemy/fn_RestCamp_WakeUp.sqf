/*
    OKS_fnc_RestCamp_WakeUp

    Per-unit wake-up handler called internally by OKS_fnc_RestCamp.
    Waits a random delay, then plays a kneeling gearing-up animation while
    the unit's loadout is restored in visible phases over ~12 seconds.
    Vehicle crew members run back and remount their original seat.

    Parameters:
        _unit        - OBJECT : the unit to wake up
        _loadout     - ARRAY  : stored loadout from getUnitLoadout
        _vehicleData - ARRAY  : [vehicle, roleArray] or [] if infantry
        _delayRange  - ARRAY  : [min, max] delay in seconds
        _aiState     - ARRAY  : [[feature, enabled], …] snapshot from before sleep
        _unitPos     - STRING : original unitPos (e.g. "UP", "AUTO", "DOWN")
        _wasLying    - BOOL   : true if unit was in a lying/prone sleep anim
        _holder      - OBJECT : GroundWeaponHolder with the unit's stripped gear

    Usage (internal — spawned by fn_RestCamp):
        [_unit, _loadout, _vehicleData, [10, 30], _aiState, _unitPos, true, _holder] spawn OKS_fnc_RestCamp_WakeUp;
*/

params ["_unit", "_loadout", "_vehicleData", "_delayRange", "_aiState", "_unitPos", "_wasLying", "_holder"];

if (!alive _unit) exitWith {};

private _debug = missionNamespace getVariable ["GOL_Enemy_Debug", false];

// ── Random wake-up delay ───────────────────────────────────────────────────
private _delay = (_delayRange # 0) + random ((_delayRange # 1) - (_delayRange # 0));

if (_debug) then {
    format ["[RestCamp] %1 waking in %2s…", _unit, round _delay] spawn OKS_fnc_LogDebug;
};

sleep _delay;
if (!alive _unit) exitWith {};

// Clean up the sleeping-phase killed EH (we manage lifecycle from here)
private _ehID = _unit getVariable ["OKS_RestCamp_KilledEH", -1];
if (_ehID >= 0) then {
    _unit removeEventHandler ["Killed", _ehID];
    _unit setVariable ["OKS_RestCamp_KilledEH", nil];
};

// ── Phase 1 — transition from sleeping to kneeling ─────────────────────────
//    Keep ANIM disabled throughout Phase 1 & 2 so the AI doesn't override
//    our scripted animations. We use switchMove (instant) for forced states
//    and playMove only after briefly enabling ANIM for that specific transition.

// Helper: temporarily enable ANIM, play a transition, wait for it, then
// re-disable ANIM so the AI can't override subsequent scripted anims.
private _playTransition = {
    params ["_u", "_animName", ["_timeout", 15]];
    _u enableAI "ANIM";
    _u playMove _animName;
    private _t = diag_tickTime + _timeout;
    // Wait for the engine to start the requested anim
    waitUntil { sleep 0.1; !alive _u || {animationState _u == _animName} || {diag_tickTime > _t} };
    // Wait for it to finish (transitions away)
    waitUntil { sleep 0.1; !alive _u || {animationState _u != _animName} || {diag_tickTime > _t} };
    if (alive _u) then { _u disableAI "ANIM" };
};

if (_wasLying) then {
    // Roll over from injured prone (face-down → face-up)
    [_unit, "AinjPpneMstpSnonWrflDnon_rolltofront", 15] call _playTransition;
    if (!alive _unit) exitWith {};
    // Snap to canonical prone (Wnon), then transition to crouch
    _unit switchMove "AmovPpneMstpSnonWnonDnon";
    sleep 0.3;
    [_unit, "AmovPpneMstpSnonWnonDnon_AmovPknlMstpSnonWnonDnon", 15] call _playTransition;
    if (!alive _unit) exitWith {};
} else {
    // Snap to canonical sitting, then sit → stand → kneel
    _unit switchMove "AmovPsitMstpSnonWnonDnon_ground";
    sleep 0.3;
    [_unit, "AmovPsitMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon_ground", 15] call _playTransition;
    if (!alive _unit) exitWith {};
    [_unit, "AmovPercMstpSnonWnonDnon_AmovPknlMstpSnonWnonDnon", 15] call _playTransition;
    if (!alive _unit) exitWith {};
};

// Hold the kneeling stance throughout the gearing phase
_unit setUnitPos "MIDDLE";
sleep 0.3;
if (!alive _unit) exitWith {};

// ── Phase 2 — gearing-up animation with phased loadout restoration ─────────
//   Gear reappears in stages while the medic/bandaging animation plays.
//   ANIM remains disabled — we use switchMove for forced animation control.
//   Disable MOVE so the unit doesn't rotate toward targets while animating.
_unit disableAI "MOVE";

// Play the medic / bandaging animation (forced via switchMove since ANIM is off)
_unit switchMove "AinvPknlMstpSnonWnonDnon_medic0";

if (_debug) then {
    format ["[RestCamp] %1 gearing up…", _unit] spawn OKS_fnc_LogDebug;
};

// Helper: remove item from ground holder (safe if holder already gone)
private _removeFromHolder = {
    params ["_h", "_class"];
    if (isNull _h || _class isEqualTo "") exitWith {};
    _h addItemCargoGlobal [_class, -1];
};

// Phase 2a — headgear + goggles (~3 s in)
sleep 3;
if (!alive _unit) exitWith {};

private _headgear = _loadout # 6;
if (_headgear isNotEqualTo "") then {
    _unit addHeadgear _headgear;
    [_holder, _headgear] call _removeFromHolder;
};

private _facewear = _loadout # 7;
if (_facewear isNotEqualTo "") then {
    _unit addGoggles _facewear;
    [_holder, _facewear] call _removeFromHolder;
};

// Phase 2b — NVGs (~5 s in)
sleep 2;
if (!alive _unit) exitWith {};

private _linkedItems = _loadout # 9;
if (count _linkedItems > 5) then {
    private _nvg = _linkedItems # 5;
    if (_nvg isNotEqualTo "") then {
        _unit linkItem _nvg;
        [_holder, _nvg] call _removeFromHolder;
    };
};

// Phase 2c — vest (~7 s in)
sleep 2;
if (!alive _unit) exitWith {};

private _vestData = _loadout # 4;
if (_vestData isNotEqualTo []) then {
    _unit addVest (_vestData # 0);
    [_holder, _vestData # 0] call _removeFromHolder;
};

// Phase 2d — backpack (~9 s in)
sleep 2;
if (!alive _unit) exitWith {};

private _backpackData = _loadout # 5;
if (_backpackData isNotEqualTo []) then {
    _unit addBackpack (_backpackData # 0);
    // Remove backpack from holder (backpacks use different cargo command)
    if (!isNull _holder) then {
        clearBackpackCargoGlobal _holder;
    };
};

// Replay the medic animation to cover the final restoration phase
_unit switchMove "AinvPknlMstpSnonWnonDnon_medic0";

// Phase 2e — full loadout restore (~12 s in)
sleep 3;
if (!alive _unit) exitWith {};

// setUnitLoadout guarantees a pixel-perfect restoration of every item,
// attachment, magazine round-count, etc., regardless of what was already
// added during the visual phases above.
_unit setUnitLoadout _loadout;

// Delete the ground holder now that everything is restored
if (!isNull _holder) then { deleteVehicle _holder };
_unit setVariable ["OKS_RestCamp_Holder", nil];

// Play the inventory "grab weapon" exit animation — smoothly transitions
// from kneeling inventory back to kneeling stance with weapon equipped.
// switchMove to the inventory loop first so playTransition has a valid source.
_unit switchMove "AinvPknlMstpSnonWnonDnon";
sleep 0.1;
[_unit, "AinvPknlMstpSnonWnonDnon_AmovPknlMstpSnonWnonDnon", 15] call _playTransition;
if (!alive _unit) exitWith {};

// ── Phase 3 — restore AI state to pre-sleep snapshot ────────────────────────

// Re-enable ANIM — the AI now controls animations again
_unit enableAI "ANIM";

// Re-enable MOVE now that gearing animation is done
_unit enableAI "MOVE";

// Restore every AI feature to its original enabled/disabled state
{
    _x params ["_feature", "_wasEnabled"];
    if (_wasEnabled) then {
        _unit enableAI _feature;
    } else {
        _unit disableAI _feature;
    };
} forEach _aiState;

// Restore original unit stance
_unit setUnitPos _unitPos;

_unit setVariable ["OKS_RestCamp_Sleeping", nil];

if (_debug) then {
    format ["[RestCamp] %1 fully geared and combat-ready (unitPos: %2).", _unit, _unitPos]
        spawn OKS_fnc_LogDebug;
};

// ── Phase 4 — remount vehicle (if applicable) ──────────────────────────────
if (_vehicleData isNotEqualTo []) then {
    private _veh  = _vehicleData # 0;
    private _role = _vehicleData # 1;

    if (alive _veh && {!isNull _veh}) then {
        if (_debug) then {
            format [
                "[RestCamp] %1 remounting %2 (role: %3)",
                _unit, typeOf _veh, _role
            ] spawn OKS_fnc_LogDebug;
        };

        // Assign seat so the AI knows where to go
        if (count _role > 0) then {
            private _roleName = toLower (_role # 0);
            switch (_roleName) do {
                case "driver":    { _unit assignAsDriver _veh };
                case "turret";
                case "gunner":    { _unit assignAsTurret [_veh, _role # 1] };
                case "cargo":     { _unit assignAsCargo  _veh };
                case "commander": { _unit assignAsCommander _veh };
                default           { _unit assignAsCargo  _veh };
            };
        } else {
            _unit assignAsCargo _veh;
        };

        // Order the unit to mount up (they will walk/run to the vehicle)
        [_unit] orderGetIn true;

        // Wait until inside or timeout (45 s)
        private _timeout = diag_tickTime + 45;
        waitUntil {
            sleep 1;
            !alive _unit
            || {vehicle _unit == _veh}
            || {diag_tickTime > _timeout}
        };

        // If they timed out and are still alive, force them in
        if (alive _unit && {vehicle _unit != _veh}) then {
            if (count _role > 0) then {
                private _roleName = toLower (_role # 0);
                switch (_roleName) do {
                    case "driver":    { _unit moveInDriver _veh };
                    case "turret";
                    case "gunner":    { _unit moveInTurret [_veh, _role # 1] };
                    case "cargo":     { _unit moveInCargo  _veh };
                    case "commander": { _unit moveInCommander _veh };
                    default           { _unit moveInCargo  _veh };
                };
            } else {
                _unit moveInAny _veh;
            };
            if (_debug) then {
                format ["[RestCamp] %1 timed out walking — forced into %2.", _unit, typeOf _veh]
                    spawn OKS_fnc_LogDebug;
            };
        };

        if (_debug) then {
            format ["[RestCamp] %1 remounted %2.", _unit, typeOf _veh] spawn OKS_fnc_LogDebug;
        };
    } else {
        if (_debug) then {
            format ["[RestCamp] Vehicle destroyed — %1 staying dismounted.", _unit]
                spawn OKS_fnc_LogDebug;
        };
    };
};
