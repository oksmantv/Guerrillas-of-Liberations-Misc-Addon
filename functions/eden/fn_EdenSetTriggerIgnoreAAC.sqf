/*
    OKS_fnc_EdenSetTriggerIgnoreAAC

    Description:
    Converts selected triggers' activation conditions to ignore aircraft (AAC - Army Air Corps).
    Detects whether each trigger uses a default spawn condition or a default reaction condition,
    and replaces it with the AAC-ignoring equivalent. Also sets the trigger's vertical size (sizeC)
    to -1 (unlimited) so aircraft at any altitude still enter thisList and get properly filtered
    by the condition. Triggers with custom (non-default) conditions are skipped and reported to
    the user for manual editing.

    Default spawn condition key markers: "objectParent" + "thislist"
    Default reaction condition key markers: "ace_common_fnc_isAwake" + "getFriend" + "isPlayer"

    Usage:
    Called from Eden context menu: Right-click trigger > GOL TOOLS > Set Trigger Ignore AAC
    [] call OKS_fnc_EdenSetTriggerIgnoreAAC;

    Returns:
    Nothing
*/

// --- Replacement conditions ---

// Spawn trigger: original checks for units on foot; AAC version adds air vehicle exclusion
private _spawnConditionAAC = "call{!({(isNull (objectParent _x)) && {!(vehicle _x isKindOf ""Air"")}} count thislist isEqualTo 0) && isServer}";

// Reaction trigger: original checks for hostile awake units vs players;
// AAC version ensures players inside aircraft do not activate the trigger
private _reactionConditionAAC = "call{
	if (!isServer) exitWith {false};
	private _players = thisList select {isPlayer _x && {!(vehicle _x isKindOf ""Air"")}};
	if (_players isEqualTo []) exitWith {false};
	private _ps = side group (_players # 0);
	({ ((side group _x) getFriend _ps) < 0.6 && {[_x] call ace_common_fnc_isAwake} } count thisList) == 0
}";

// --- Helper: classify a trigger condition ---
// Returns: "spawn" | "reaction" | "custom"
private _fnc_classifyCondition = {
    params ["_condition"];
    // Normalize: lowercase, strip all whitespace for reliable matching
    private _norm = toLower _condition;
    _norm = _norm regexReplace ["\s+", ""];

    // Reaction trigger: must contain all three key markers
    if (
        ("ace_common_fnc_isawake" in _norm) &&
        {"getfriend" in _norm} &&
        {"isplayer" in _norm}
    ) exitWith { "reaction" };

    // Spawn trigger: must contain objectparent + thislist
    if (
        ("objectparent" in _norm) &&
        {"thislist" in _norm}
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
            private _curSize = _x get3DENAttribute "size3" select 0;
            _x set3DENAttribute ["size3", [_curSize select 0, _curSize select 1, -1]];
            _countSpawn = _countSpawn + 1;
        };
        case "reaction": {
            _x set3DENAttribute ["condition", _reactionConditionAAC];
            private _curSize = _x get3DENAttribute "size3" select 0;
            _x set3DENAttribute ["size3", [_curSize select 0, _curSize select 1, -1]];
            _countReaction = _countReaction + 1;
        };
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
    private _msg = format ["Ignore AAC applied: %1 trigger%2 updated (%3). SizeC set to -1 (unlimited Z).", _totalChanged, ["","s"] select (_totalChanged > 1), _detail];
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
    private _msg = "Ignore AAC: Selected triggers had no recognizable conditions to update.";
    [_msg, 1, 5, true] call BIS_fnc_3DENNotification;
    systemChat _msg;
};
