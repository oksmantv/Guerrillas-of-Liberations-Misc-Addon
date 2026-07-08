/*
    Stealth subsystem bootstrap.
    Server-only initializer for shared state used by radio/hunted/tracker features.

    Usage:
    [] call OKS_fnc_Stealth_Init;
*/

if (!isServer) exitWith { false };

private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];

if (isNil "OKS_HuntedGroups") then {
    OKS_HuntedGroups = [];
};

if (isNil "OKS_Radios") then {
    OKS_Radios = [];
};

private _twoDigits = {
    params ["_num"];
    if (_num < 10) exitWith { format ["0%1", _num] };
    str _num
};

private _buildNumberedPaths = {
    params ["_prefix", "_from", "_to", ["_padTwoDigits", false, [false]]];
    private _out = [];
    for "_i" from _from to _to do {
        private _n = if (_padTwoDigits) then { [_i] call _twoDigits } else { str _i };
        _out pushBack format ["%1%2.ogg", _prefix, _n];
    };
    _out
};

private _arabRadio = ["\\OKS_GOL_Misc\\functions\\stealth\\audio\\Arab\\Radio", 1, 5] call _buildNumberedPaths;
private _russianRadio = ["\\OKS_GOL_Misc\\functions\\stealth\\audio\\Russian\\Radio", 1, 20] call _buildNumberedPaths;
private _vietRadio = [
    "\\OKS_GOL_Misc\\functions\\stealth\\audio\\Vietnamese\\vn-radio-y-05.ogg",
    "\\OKS_GOL_Misc\\functions\\stealth\\audio\\Vietnamese\\vn-radio-y-09.ogg",
    "\\OKS_GOL_Misc\\functions\\stealth\\audio\\Vietnamese\\vn-radio-y-17.ogg",
    "\\OKS_GOL_Misc\\functions\\stealth\\audio\\Vietnamese\\vn-radio-y-18.ogg",
    "\\OKS_GOL_Misc\\functions\\stealth\\audio\\Vietnamese\\vn-radio-y-19.ogg"
];

private _arabTalk = ["\\OKS_GOL_Misc\\functions\\stealth\\audio\\Arab\\talk_", 1, 27] call _buildNumberedPaths;

private _vietTalkN = ["\\OKS_GOL_Misc\\functions\\stealth\\audio\\Vietnamese\\vn-talks-n-", 1, 30, true] call _buildNumberedPaths;
private _vietTalkY = [
    "\\OKS_GOL_Misc\\functions\\stealth\\audio\\Vietnamese\\vn-talks-y-07.ogg",
    "\\OKS_GOL_Misc\\functions\\stealth\\audio\\Vietnamese\\vn-talks-y-08.ogg",
    "\\OKS_GOL_Misc\\functions\\stealth\\audio\\Vietnamese\\vn-talks-y-09.ogg",
    "\\OKS_GOL_Misc\\functions\\stealth\\audio\\Vietnamese\\vn-talks-y-17.ogg",
    "\\OKS_GOL_Misc\\functions\\stealth\\audio\\Vietnamese\\vn-talks-y-20.ogg",
    "\\OKS_GOL_Misc\\functions\\stealth\\audio\\Vietnamese\\vn-talks-y-26.ogg"
];

private _arabYell = ["\\OKS_GOL_Misc\\functions\\stealth\\audio\\Arab\\yell_", 1, 9] call _buildNumberedPaths;
private _russianReactionRadio = ["\\OKS_GOL_Misc\\functions\\stealth\\audio\\Russian\\Radio", 6, 10] call _buildNumberedPaths;

private _profileRadioPatrol = createHashMapFromArray [
    ["NONE", []],
    ["ARAB", _arabRadio],
    ["RUSSIAN", _russianRadio],
    ["VIETNAMESE", _vietRadio]
];

private _profileTalkCalm = createHashMapFromArray [
    ["NONE", []],
    ["ARAB", _arabTalk],
    ["RUSSIAN", _russianRadio],
    ["VIETNAMESE", _vietTalkN]
];

private _profileTalkReaction = createHashMapFromArray [
    ["NONE", []],
    ["YELL_GENERIC", _arabYell],
    ["ARAB", _arabYell],
    ["RUSSIAN", _russianReactionRadio],
    ["VIETNAMESE_Y", _vietTalkY]
];

private _profileRadioHelp = createHashMapFromArray [
    ["NONE", []],
    ["LEGACY_HELP", _arabRadio],
    ["ARAB", _arabRadio],
    ["RUSSIAN", _russianRadio],
    ["VIETNAMESE", _vietRadio]
];

private _radioPatrolBySide = createHashMap;
private _talkCalmBySide = createHashMap;
private _talkReactionBySide = createHashMap;
private _radioHelpBySide = createHashMap;

{
    _x params ["_sideValue", "_sideTag"];

    private _radioPatrolProfile = missionNamespace getVariable [format ["GOL_Stealth_ProfileRadio_%1", _sideTag], "NONE"];
    private _talkCalmProfile = missionNamespace getVariable [format ["GOL_Stealth_ProfileTalk_%1", _sideTag], "NONE"];
    private _talkReactionProfile = missionNamespace getVariable [format ["GOL_Stealth_ProfileReaction_%1", _sideTag], "NONE"];
    private _radioHelpProfile = missionNamespace getVariable [format ["GOL_Stealth_ProfileRadioHelp_%1", _sideTag], "NONE"];

    private _radioPatrolPaths = _profileRadioPatrol getOrDefault [toUpper _radioPatrolProfile, []];
    private _talkCalmPaths = _profileTalkCalm getOrDefault [toUpper _talkCalmProfile, []];
    private _talkReactionPaths = _profileTalkReaction getOrDefault [toUpper _talkReactionProfile, []];
    private _radioHelpPaths = _profileRadioHelp getOrDefault [toUpper _radioHelpProfile, []];

    _radioPatrolBySide set [str _sideValue, _radioPatrolPaths];
    _talkCalmBySide set [str _sideValue, _talkCalmPaths];
    _talkReactionBySide set [str _sideValue, _talkReactionPaths];
    _radioHelpBySide set [str _sideValue, _radioHelpPaths];
} forEach [
    [west, "BLUFOR"],
    [east, "OPFOR"],
    [independent, "INDEPENDENT"]
];

missionNamespace setVariable ["GOL_Stealth_RadioPatrolBySide", _radioPatrolBySide];
missionNamespace setVariable ["GOL_Stealth_TalkCalmBySide", _talkCalmBySide];
missionNamespace setVariable ["GOL_Stealth_TalkReactionBySide", _talkReactionBySide];
missionNamespace setVariable ["GOL_Stealth_RadioHelpBySide", _radioHelpBySide];

if (_debug) then {
    [format ["[Stealth] Init complete. Patrol=%1 Calm=%2 Reaction=%3 Help=%4", _radioPatrolBySide, _talkCalmBySide, _talkReactionBySide, _radioHelpBySide], false, false, true] spawn OKS_fnc_LogDebug;
};

true
