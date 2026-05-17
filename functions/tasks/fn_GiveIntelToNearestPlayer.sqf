/*
    Function: OKS_fnc_GiveIntelToNearestPlayer

    Description:
    Gives an intel document from a unit to a player, with two paths depending
    on whether the unit is alive or dead at call time.

    ALIVE: Finds the nearest player, gives the document directly via ACE on
      their machine (no interaction required), shows them a local hint, then
      creates and immediately completes the task.

    DEAD: Registers the document on the corpse so players can loot it via
      ACE interaction. Polls nearby players for 60 seconds using a magazine
      snapshot — whoever gains a new acex_intelitems_document is the picker.
      Task resolves SUCCEEDED on pickup or CANCELED on timeout.

    Parameters:
    0: _intelUnit (OBJECT)
        The Man unit carrying the intel. Works on both alive units and corpses.
    1: _customText (STRING)
        Text body of the intel document.
    2: _customHeader (STRING|NIL)
        Header shown when opening the document. nil defaults to "Intel #X".
    3: _parent (STRING|NIL)
        Parent task ID string, or nil for a standalone task.
    4: _markerArray (ARRAY)
        Optional. Markers to set visible (alpha 1) on success.

    Returns: Nothing.

    Examples:
    // Alive rescued survivor hands over documents, nested under rescue task
    [rescued_1, "The prisoner carried a list of supply caches.", "Prisoner Intel", "OKS_RESCUETASK_12345", []] spawn OKS_fnc_GiveIntelToNearestPlayer;

    // Dead scout, standalone task, reveal a cache marker on pickup
    [dead_scout, "Map fragment recovered from the body.", nil, nil, ["cache_marker"]] spawn OKS_fnc_GiveIntelToNearestPlayer;

    // Hook: chain after RescueSurvivorTask
    waitUntil { sleep 1; !isNil { rescued_1 getVariable "OKS_IsRescued" } };
    [rescued_1, "Documents were found on the survivor.", "Survivor Intel", _rescueTaskId, []] spawn OKS_fnc_GiveIntelToNearestPlayer;

    Debug:
    missionNamespace setVariable ["OKS_GiveIntelToNearestPlayer_Debug", true];
*/

if (!isServer) exitWith {};

params [
    ["_intelUnit",    objNull, [objNull]],
    ["_customText",   "",      [""]],
    ["_customHeader", nil,     [""]],
    ["_parent",       nil,     [""]],
    ["_markerArray",  [],      [[]]]
];

private _debug = missionNamespace getVariable ["OKS_GiveIntelToNearestPlayer_Debug", false];

if (isNull _intelUnit || { !(_intelUnit isKindOf "Man") }) exitWith {
    if (_debug) then { "[GiveIntelToNearestPlayer] Invalid unit — must be a Man. Aborting." call OKS_fnc_LogDebug };
};

// -------------------------------------------------------------------------
// 1. Register intel piece globally (consistent with SetupIntel)
// -------------------------------------------------------------------------
private _allIntel = missionNamespace getVariable ["GOL_IntelPieces", []];
_allIntel pushBack _intelUnit;
missionNamespace setVariable ["GOL_IntelPieces", _allIntel, true];

if (isNil "_customHeader") then {
    _customHeader = format ["Intel #%1", count _allIntel];
};

private _unitName     = name _intelUnit;
private _intelDocClass = "acex_intelitems_document";

// Hide markers initially
{ _x setMarkerAlpha 0 } forEach _markerArray;

// -------------------------------------------------------------------------
// 2. Build task ID and optional parent array
// -------------------------------------------------------------------------
private _taskId    = format ["OKS_GiveIntelTask_%1", floor (random 9999999)];
private _taskArray = if (!isNil "_parent" && { !(_parent isEqualTo "") }) then {
    [_taskId, _parent]
} else {
    _taskId
};

if (_debug) then {
    format ["[GiveIntelToNearestPlayer] Unit: %1 (alive: %2), taskId: %3", _unitName, alive _intelUnit, _taskId] call OKS_fnc_LogDebug;
};

// =========================================================================
// ALIVE PATH — give document directly to the nearest player
// =========================================================================
if (alive _intelUnit) then {

    private _players = allPlayers select { isPlayer _x };

    if (_players isNotEqualTo []) then {

        // Find nearest player
        private _nearestPlayer = _players select 0;
        {
            if (_x distance _intelUnit < _nearestPlayer distance _intelUnit) then {
                _nearestPlayer = _x;
            };
        } forEach (_players - [_nearestPlayer]);

        if (_debug) then {
            format ["[GiveIntelToNearestPlayer] Alive path — nearest player: %1 (%.0fm).", name _nearestPlayer, _nearestPlayer distance _intelUnit] call OKS_fnc_LogDebug;
        };

        // Give the document directly to the player on their machine.
        // This mirrors the pattern in OKS_fnc_Request_Intel and adds the document
        // to the player's ACE items without requiring any interaction.
        [_nearestPlayer, _intelDocClass, _customText, _customHeader] remoteExecCall ["ace_intelitems_fnc_addIntel", _nearestPlayer];

        // Local hint on the receiving player's machine
        [format ["%1 gave you intel documents.", _unitName]] remoteExec ["hint", _nearestPlayer];

        // Create task and mark as immediately succeeded with notification
        [
            true,
            _taskArray,
            [
                format ["Intel documents received from %1. Open your map and use ACE Self-Interact to view them.", _unitName],
                _customHeader,
                "Intel"
            ],
            getPosATL _intelUnit,
            "SUCCEEDED",
            -1,
            true,
            "intel",
            true
        ] call BIS_fnc_taskCreate;

        { _x setMarkerAlpha 1 } forEach _markerArray;

        if (_debug) then {
            format ["[GiveIntelToNearestPlayer] Task %1 SUCCEEDED. Document given directly to %2.", _taskId, name _nearestPlayer] call OKS_fnc_LogDebug;
        };

    } else {
        if (_debug) then { "[GiveIntelToNearestPlayer] Alive path — no players found. Aborting." call OKS_fnc_LogDebug };
    };

// =========================================================================
// DEAD PATH — register on corpse, poll nearby players for loot pickup (60s)
// =========================================================================
} else {

    // Register document on the corpse via ACE so players can interact and take it.
    // GW_Common_isPlayer is set to allow the Framework inventory handler to permit
    // ACE interaction with this unit's body.
    [_intelUnit, _intelDocClass, _customText, _customHeader] call ace_intelitems_fnc_addIntel;
    _intelUnit setVariable ["GW_Common_isPlayer", true, true];

    if (_debug) then {
        format ["[GiveIntelToNearestPlayer] Dead path — intel registered on %1. Polling for loot (60s).", _unitName] call OKS_fnc_LogDebug;
    };

    // Create task as ASSIGNED
    [
        true,
        _taskArray,
        [
            format ["Recover the intel document from %1's body.", _unitName],
            _customHeader,
            "Intel"
        ],
        getPos _intelUnit,
        "ASSIGNED",
        -1,
        false,
        "intel",
        false
    ] call BIS_fnc_taskCreate;

    // --- Snapshot-based pickup detection -----------------------------------
    // Track each player's document ownership at the moment they first enter
    // range. If they later gain the document class, they are the picker.
    private _deadTime     = time;
    private _snapPlayers  = [];
    private _snapHasDoc   = [];
    private _picker       = objNull;

    waitUntil {
        sleep 0.2;

        // Register any new player that comes within 6m of the body
        private _nearby = ((getPos _intelUnit) nearEntities ["Man", 6]) select { isPlayer _x };
        {
            if ((_snapPlayers find _x) < 0) then {
                _snapPlayers pushBack _x;
                _snapHasDoc pushBack (
                    _intelDocClass in (magazines _x) || { _intelDocClass in (items _x) }
                );
            };
        } forEach _nearby;

        // Check if any tracked player newly has the document
        {
            private _idx = _snapPlayers find _x;
            if (_idx >= 0) then {
                private _hadDoc = _snapHasDoc select _idx;
                private _hasDoc = _intelDocClass in (magazines _x) || { _intelDocClass in (items _x) };
                if (_hasDoc && { !_hadDoc }) exitWith {
                    if (_debug) then {
                        format ["[GiveIntelToNearestPlayer] Pickup detected: %1.", name _x] call OKS_fnc_LogDebug;
                    };
                    _picker = _x;
                };
            };
        } forEach _nearby;

        (!isNull _picker) || { time > _deadTime + 60 }
    };

    // --- Resolve task -------------------------------------------------------
    private _succeeded  = !isNull _picker;
    private _finalState = if (_succeeded) then { "SUCCEEDED" } else { "CANCELED" };
    private _finalTitle = if (_succeeded) then { "Intel Secured" } else { "Intel Lost" };
    private _finalDesc  = if (_succeeded) then {
        format ["Intel secured by %1. Open your map and use ACE Self-Interact to view it.", name _picker]
    } else {
        format ["The intel on %1's body was not recovered in time.", _unitName]
    };

    [
        true,
        _taskId,
        [_finalDesc, _finalTitle, "Intel"],
        getPos _intelUnit,
        _finalState,
        -1,
        true,
        "intel",
        true
    ] call BIS_fnc_taskCreate;

    if (_succeeded) then {
        { _x setMarkerAlpha 1 } forEach _markerArray;
        if (_debug) then {
            format ["[GiveIntelToNearestPlayer] Task SUCCEEDED. Picked up by %1.", name _picker] call OKS_fnc_LogDebug;
        };
    } else {
        if (_debug) then { "[GiveIntelToNearestPlayer] Task CANCELED — no pickup within 60s." call OKS_fnc_LogDebug };
    };

};
