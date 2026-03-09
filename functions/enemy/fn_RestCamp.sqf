/*
    OKS_fnc_RestCamp

    Makes a group enter a rest/sleep state. Units are stripped of visible gear
    (weapons, vest, backpack, headgear, goggles, NVGs) and play sleeping or
    resting animations. When any unit's behaviour changes to COMBAT the whole
    group wakes up: each unit waits a random delay, plays a gearing-up
    animation while its loadout is gradually restored, then resumes operations.

    Vehicle crews are dismounted and sleep nearby, then remount their original
    vehicle and seat after waking.

    Parameters:
        _group       - GROUP : the group to put into rest camp
        _delayRange  - ARRAY (optional): [min, max] per-unit wake-up delay
                       in seconds. Default: [10, 30]
        _activeRatio - NUMBER (optional): fraction of units (0–1) that stay
                       active and are unaffected by the script. 0.1 = 10%
                       of units remain on guard. Default: 0

    Usage:
        [_group] spawn OKS_fnc_RestCamp;
        [_group, [5, 20]] spawn OKS_fnc_RestCamp;
        [_group, [5, 20], 0.1] spawn OKS_fnc_RestCamp;

    Notes:
        - Runs on server or HC (exits on player clients).
        - Debug logging via GOL_Enemy_Debug variable.
*/

params [
    "_group",
    ["_delayRange", [10, 30], [[]]],
    ["_activeRatio", 0, [0]]
];

if (hasInterface && !isServer) exitWith {};

private _debug = missionNamespace getVariable ["GOL_Enemy_Debug", false];

// ── Guard: prevent double-execution on the same group ──────────────────────
if (_group getVariable ["OKS_RestCamp_Active", false]) exitWith {
    if (_debug) then {
        format ["[RestCamp] Group %1 already active, exiting.", _group] spawn OKS_fnc_LogDebug;
    };
};
_group setVariable ["OKS_RestCamp_Active", true, true];

// ── Prevent ACEX headless client from transferring this group ───────────────
//    HC transfer breaks local-effect commands (disableAI, switchMove, playMove,
//    animationState) which must execute where the group is local.
_group setVariable ["acex_headless_blacklist", true, true];

// ── Wait until the spawn handler has finished creating all units ───────────
//    GW_Performance_autoDelete starts false and flips true when spawnHandler
//    is done.  30 s safety cap to avoid an infinite hang.
private _spawnTimeout = diag_tickTime + 30;
waitUntil {
    sleep 0.5;
    _group getVariable ["GW_Performance_autoDelete", true]
    || {diag_tickTime > _spawnTimeout}
};

// ── Locality safety net ────────────────────────────────────────────────────
//    If ACEX transferred the group before the blacklist was set (race
//    condition), redirect execution to the machine that owns the group.
sleep 0.5;
private _groupLeader = leader _group;
if (!isNull _groupLeader && {!local _groupLeader}) exitWith {
    if (_debug) then {
        format ["[RestCamp] Group %1 not local (owner: %2), redirecting.",
            _group, owner _groupLeader] spawn OKS_fnc_LogDebug;
    };
    _group setVariable ["OKS_RestCamp_Active", nil, true];
    [[_group, _delayRange, _activeRatio], {
        _this spawn OKS_fnc_RestCamp;
    }] remoteExec ["call", owner _groupLeader];
};

if (_debug) then {
    format [
        "[RestCamp] Init for %1 (%2 units), delay range: %3",
        _group, count units _group, _delayRange
    ] spawn OKS_fnc_LogDebug;
};

// ── Animation pools (unarmed) ──────────────────────────────────────────────
private _lyingAnims = [
    "AinjPpneMstpSnonWrflDnon"              // casualty prone — looks like sleeping on ground
];
private _restingAnims = [
    "AidlPsitMstpSnonWnonDnon_ground00",    // sitting on ground idle
    "AmovPsitMstpSnonWnonDnon_smoking"       // sitting on ground smoking
];

// ── AI features we snapshot per unit so we can restore exactly ─────────────
private _aiFeatures = ["PATH", "ANIM", "MOVE", "TARGET", "AUTOTARGET",
    "AUTOCOMBAT", "COVER", "SUPPRESSION", "FSM", "AIMINGERROR",
    "RADIOPROTOCOL", "MINEDETECTION", "NVG", "LIGHTS", "WEAPONAIM"];

// ── Determine which units stay active (unaffected by the script) ───────────
private _allUnits = units _group select {alive _x};
private _activeCount = round (count _allUnits * (_activeRatio min 1 max 0));
private _activeUnits = if (_activeCount > 0) then {
    // Pick random units to remain on guard
    private _shuffled = _allUnits call BIS_fnc_arrayShuffle;
    _shuffled select [0, _activeCount];
} else {
    []
};

if (_debug && count _activeUnits > 0) then {
    format ["[RestCamp] %1 of %2 units stay active (unaffected).",
        count _activeUnits, count _allUnits] spawn OKS_fnc_LogDebug;
};

// ── Phase 1 — strip gear & play sleep anims ────────────────────────────────
private _unitData = [];   // [ [unit, loadout, vehicleData, aiState, unitPos, isLying, holder], … ]

{
    private _unit = _x;
    if (!alive _unit) then { continue };

    // Skip units designated to stay active
    if (_unit in _activeUnits) then { continue };

    // Store full loadout for perfect restoration later
    private _loadout = getUnitLoadout _unit;

    // ── Handle vehicle crews ───────────────────────────────────────────────
    private _vehicleData = [];
    if (vehicle _unit != _unit) then {
        private _veh  = vehicle _unit;
        private _role = assignedVehicleRole _unit;

        // assignedVehicleRole may return [] if moveIn* was used without assign*
        // Fall back to fullCrew lookup to reliably determine the seat
        if (count _role == 0) then {
            private _crewEntry = (fullCrew _veh) select { _x # 0 == _unit };
            if (count _crewEntry > 0) then {
                private _entry = _crewEntry # 0;   // [unit, role, cargoIndex, turretPath, isPersonTurret]
                private _seatRole = _entry # 1;     // "driver", "gunner", "commander", "turret", "cargo"
                if (_seatRole == "gunner" || _seatRole == "turret") then {
                    _role = ["Turret", _entry # 3];
                } else {
                    _role = [_seatRole];
                };
            };
        };

        _vehicleData  = [_veh, _role];

        moveOut _unit;
        sleep 0.5;

        // Place the unit to the side / rear of the vehicle
        private _dir = (getDir _veh) + 120 + (random 120);
        private _pos = _veh getPos [3 + random 3, _dir];
        _unit setPos _pos;
        _unit setDir (random 360);

        if (_debug) then {
            format [
                "[RestCamp] %1 dismounted from %2 (role: %3)",
                _unit, typeOf _veh, _role
            ] spawn OKS_fnc_LogDebug;
        };
    };

    // ── Snapshot current AI state before we touch anything ─────────────────
    private _aiState = [];   // array of [feature, enabled]
    { _aiState pushBack [_x, _unit checkAIFeature _x] } forEach _aiFeatures;
    private _unitPos = unitPos _unit;

    // ── Strip visible gear (uniform + its contents stay) ───────────────────
    // Capture items BEFORE removing so we can populate the ground holder
    private _weaponsItems  = weaponsItems _unit;     // [[weapon, muzzle, pointer, optic, mag, mag2, bipod], …]
    private _vestClass     = vest _unit;
    private _backpackClass = backpack _unit;
    private _headgearClass = headgear _unit;
    private _gogglesClass  = goggles _unit;
    private _nvgClass      = hmd _unit;

    removeAllWeapons _unit;
    removeVest       _unit;
    removeBackpack   _unit;
    removeHeadgear   _unit;
    removeGoggles    _unit;
    if (_nvgClass != "") then { _unit unlinkItem _nvgClass };

    // ── Create GroundWeaponHolder with stripped gear visible on ground ─────
    private _dropDir = getDir _unit;
    private _dropPos = _unit getPos [1, _dropDir];
    private _holder = createVehicle ["GroundWeaponHolder", [0,0,0], [], 0, "NONE"];
    _holder setPosATL [_dropPos # 0, _dropPos # 1, getPosATL _unit # 2];

    // Weapons with attachments
    { if (_x isNotEqualTo []) then {
        _holder addWeaponWithAttachmentsCargoGlobal [_x, 1];
    }} forEach _weaponsItems;

    // Vest, backpack, headgear
    if (_vestClass != "")     then { _holder addItemCargoGlobal [_vestClass, 1] };
    if (_backpackClass != "") then { _holder addBackpackCargoGlobal [_backpackClass, 1] };
    if (_headgearClass != "") then { _holder addItemCargoGlobal [_headgearClass, 1] };
    if (_gogglesClass != "")  then { _holder addItemCargoGlobal [_gogglesClass, 1] };
    if (_nvgClass != "")      then { _holder addItemCargoGlobal [_nvgClass, 1] };

    _holder enableSimulationGlobal false;

    // Prevent GW performance cleanup from deleting our holder
    _holder setVariable ["GW_Performance_ObjectRemovalTimer", 9999];

    // ── Disable AI features for sleeping ───────────────────────────────────
    _unit disableAI "PATH";

    // ── Pick and play sleep / rest animation ───────────────────────────────
    //    Lying only when enclosed (inside a building); sitting when exposed.
    private _isExposed = [_unit] call OKS_fnc_Has_Sight;
    private _isLying = if (_isExposed) then { false } else { (random 1) < 0.3 };
    private _anim = if (_isLying) then {
        selectRandom _lyingAnims
    } else {
        selectRandom _restingAnims
    };

    // Random facing direction for a natural look
    _unit setDir (random 360);

    _unit switchMove _anim;
    _unit disableAI "ANIM";                          // Lock the animation in place

    _unitData pushBack [_unit, _loadout, _vehicleData, _aiState, _unitPos, _isLying, _holder];

    _unit setVariable ["OKS_RestCamp_Sleeping", true, true];

    // ── Killed EH — clean up variables & ground holder if unit dies ─────────
    private _ehID = _unit addEventHandler ["Killed", {
        params ["_unit"];
        _unit setVariable ["OKS_RestCamp_Sleeping", nil];
        private _h = _unit getVariable ["OKS_RestCamp_Holder", objNull];
        if (!isNull _h) then { deleteVehicle _h };
        _unit setVariable ["OKS_RestCamp_Holder", nil];
        _unit removeEventHandler ["Killed", _thisEventHandler];
    }];
    _unit setVariable ["OKS_RestCamp_KilledEH", _ehID];
    _unit setVariable ["OKS_RestCamp_Holder", _holder];

    if (_debug) then {
        format ["[RestCamp] %1 sleeping (%2)", _unit, _anim] spawn OKS_fnc_LogDebug;
    };

    sleep 0.2;   // Stagger to spread the load
} forEach units _group;

// Set the group to SAFE so the COMBAT transition is a clear signal
_group setBehaviour "SAFE";

if (_debug) then {
    format [
        "[RestCamp] All units sleeping. Monitoring %1 for COMBAT behaviour…",
        _group
    ] spawn OKS_fnc_LogDebug;
};

// ── Phase 2 — monitor for combat ──────────────────────────────────────────
waitUntil {
    sleep 5;
    if ({alive _x} count units _group == 0) exitWith { true };
    ({alive _x && {behaviour _x == "COMBAT"}} count units _group) > 0
};

// Exit early if the entire group was wiped while sleeping
if ({alive _x} count units _group == 0) exitWith {
    _group setVariable ["OKS_RestCamp_Active", nil];
    if (_debug) then {
        format ["[RestCamp] Group %1 wiped while sleeping.", _group] spawn OKS_fnc_LogDebug;
    };
};

if (_debug) then {
    format ["[RestCamp] Group %1 COMBAT detected! Waking all units.", _group]
        spawn OKS_fnc_LogDebug;
};

// ── Phase 3 — wake every alive sleeping unit ──────────────────────────────
{
    _x params ["_unit", "_loadout", "_vehicleData", "_aiState", "_unitPos", "_wasLying", "_holder"];
    if (alive _unit && {_unit getVariable ["OKS_RestCamp_Sleeping", false]}) then {
        [_unit, _loadout, _vehicleData, _delayRange, _aiState, _unitPos, _wasLying, _holder] spawn OKS_fnc_RestCamp_WakeUp;
    };
} forEach _unitData;

_group setVariable ["OKS_RestCamp_Active", nil];
