/*
    OKS_fnc_EdenSetTriggerIgnoreAAC

    Description:
    Converts selected triggers' activation conditions to ground-only (ignores aircraft, parachutes
    and free-falling players). Uses GW_Common_Fnc_hasGroundPlayer / GW_Common_Fnc_getPlayersInList
    from the GW addon (infantry, ground vehicles and boats count; headless clients do not).
    Detects whether each trigger uses a default spawn condition or a default reaction condition,
    and replaces it with the ground-only equivalent. The trigger's size is left untouched.
    Triggers with custom (non-default) conditions are skipped and reported to
    the user for manual editing. Triggers already using the new condition are left untouched.

    Default spawn condition key markers: "hasAircraftPlayer" (current) or "objectParent" + "thislist" (legacy)
    Default reaction condition key markers: "ace_common_fnc_isAwake" + "getFriend"

    Usage:
    Called from Eden context menu: Right-click trigger > GOL TOOLS > Set Trigger Ignore AAC
    [] call OKS_fnc_EdenSetTriggerIgnoreAAC;

    Returns:
    Nothing
*/

// --- Replacement conditions ---

// Spawn trigger: only activates while a ground player (infantry, ground vehicle, boat) is inside
private _spawnConditionAAC = "call{isServer && {[thisList] call GW_Common_Fnc_hasGroundPlayer}}";

// Reaction trigger: original checks for hostile awake units vs players;
// ground version requires a ground player and ignores aircraft/parachute players
private _reactionConditionAAC = "call{
	if (!isServer) exitWith {false};
	if !([thisList] call GW_Common_Fnc_hasGroundPlayer) exitWith {false};
	private _players = [thisList] call GW_Common_Fnc_getPlayersInList;
	private _ps = side group (_players # 0);
	({ ((side group _x) getFriend _ps) < 0.6 && {[_x] call ace_common_fnc_isAwake} } count thisList) == 0
}";

// --- Helper: classify a trigger condition ---
// Returns: "spawn" | "reaction" | "done" | "custom"
private _fnc_classifyCondition = {
    params ["_condition"];
    // Normalize: lowercase, strip all whitespace for reliable matching
    private _norm = toLower _condition;
    _norm = _norm regexReplace ["\s+", ""];

    // Already converted: ground-only check present, aircraft check absent.
    // (The default condition contains BOTH hasGroundPlayer and hasAircraftPlayer and must be converted.)
    if (
        ("hasgroundplayer" in _norm) &&
        {!("hasaircraftplayer" in _norm)}
    ) exitWith { "done" };

    // Reaction trigger: must contain both key markers (old defaults also had isplayer)
    if (
        ("ace_common_fnc_isawake" in _norm) &&
        {"getfriend" in _norm}
    ) exitWith { "reaction" };

    // Spawn trigger: legacy objectparent + thislist, or current default using hasAircraftPlayer
    if (
        (("objectparent" in _norm) && {"thislist" in _norm}) ||
        {"hasaircraftplayer" in _norm}
    ) exitWith { "spawn" };

    // Anything else is custom
    "custom"
};

// --- Main logic ---
private _triggers = get3DENSelected "trigger";
if (count _triggers == 0) exitWith {
    ["Set Trigger Ignore AAC: No trigger selected.", 1, 5, true] call BIS_fnc_3DENNotification;
    systemChat "Set Trigger Ignore AAC: No trigger selected.";
};

private _countSpawn    = 0;
private _countReaction = 0;
private _customTriggers = [];

{
    private _condition = _x get3DENAttribute "condition" select 0;
    private _type = [_condition] call _fnc_classifyCondition;

    switch (_type) do {
        case "spawn": {
            _x set3DENAttribute ["condition", _spawnConditionAAC];
            _countSpawn = _countSpawn + 1;
        };
        case "reaction": {
            _x set3DENAttribute ["condition", _reactionConditionAAC];
            _countReaction = _countReaction + 1;
        };
        case "done": {};
        case "custom": {
            _customTriggers pushBack _x;
        };
    };
} forEach _triggers;

// --- Feedback ---
private _totalChanged = _countSpawn + _countReaction;
private _totalCustom  = count _customTriggers;

// Success summary
if (_totalChanged > 0) then {
    private _parts = [];
    if (_countSpawn > 0)    then { _parts pushBack format ["%1 spawn", _countSpawn] };
    if (_countReaction > 0) then { _parts pushBack format ["%1 reaction", _countReaction] };
    private _detail = _parts joinString ", ";
    private _msg = format ["Ignore AAC applied: %1 trigger%2 updated (%3).", _totalChanged, ["","s"] select (_totalChanged > 1), _detail];
    [_msg, 0, 5, true] call BIS_fnc_3DENNotification;
    systemChat _msg;
};

// Custom condition warnings
if (_totalCustom > 0) then {
    private _warnMsg = format ["Ignore AAC: %1 trigger%2 skipped (custom condition — edit manually).", _totalCustom, ["","s"] select (_totalCustom > 1)];
    [_warnMsg, 1, 8, true] call BIS_fnc_3DENNotification;
    systemChat _warnMsg;

    // Per-trigger detail so the user can locate them
    {
        private _pos = _x get3DENAttribute "position" select 0;
        private _posStr = format ["[%1, %2, %3]", _pos select 0, _pos select 1, _pos select 2];
        private _detail = format ["  ↳ Custom trigger at %1 — review condition manually.", _posStr];
        systemChat _detail;
    } forEach _customTriggers;
};

// Nothing changed at all
if (_totalChanged == 0 && _totalCustom == 0) then {
    private _msg = "Ignore AAC: Selected triggers are already ground-only or had no recognizable conditions to update.";
    [_msg, 1, 5, true] call BIS_fnc_3DENNotification;
    systemChat _msg;
};
