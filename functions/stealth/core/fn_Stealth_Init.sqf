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

private _russianRadio = ["\OKS_GOL_Misc\functions\stealth\audio\Russian\Radio", 1, 20] call _buildNumberedPaths;

private _arabTalk = ["\OKS_GOL_Misc\functions\stealth\audio\Arab\talk_", 1, 27] call _buildNumberedPaths;
private _arabYell = ["\OKS_GOL_Misc\functions\stealth\audio\Arab\yell_", 1, 9] call _buildNumberedPaths;
private _arabRadio = ["\OKS_GOL_Misc\functions\stealth\audio\Arab\Radio", 1, 5] call _buildNumberedPaths;

private _vietTalkN = ["\OKS_GOL_Misc\functions\stealth\audio\Vietnamese\vn-talks-n-", 1, 30, true] call _buildNumberedPaths;
private _vietTalkY = [
    "\OKS_GOL_Misc\functions\stealth\audio\Vietnamese\vn-talks-y-07.ogg",
    "\OKS_GOL_Misc\functions\stealth\audio\Vietnamese\vn-talks-y-08.ogg",
    "\OKS_GOL_Misc\functions\stealth\audio\Vietnamese\vn-talks-y-09.ogg",
    "\OKS_GOL_Misc\functions\stealth\audio\Vietnamese\vn-talks-y-17.ogg",
    "\OKS_GOL_Misc\functions\stealth\audio\Vietnamese\vn-talks-y-20.ogg",
    "\OKS_GOL_Misc\functions\stealth\audio\Vietnamese\vn-talks-y-26.ogg"
];
private _vietRadio = [
    "\OKS_GOL_Misc\functions\stealth\audio\Vietnamese\vn-radio-y-05.ogg",
    "\OKS_GOL_Misc\functions\stealth\audio\Vietnamese\vn-radio-y-09.ogg",
    "\OKS_GOL_Misc\functions\stealth\audio\Vietnamese\vn-radio-y-17.ogg",
    "\OKS_GOL_Misc\functions\stealth\audio\Vietnamese\vn-radio-y-18.ogg",
    "\OKS_GOL_Misc\functions\stealth\audio\Vietnamese\vn-radio-y-19.ogg"
];


private _languageRadio = createHashMapFromArray [
    ["NONE", []],
    ["ARAB", _arabRadio],
    ["RUSSIAN", _russianRadio],
    ["VIETNAMESE", _vietRadio]
];

private _languageTalk = createHashMapFromArray [
    ["NONE", []],
    ["ARAB", _arabTalk],
    ["RUSSIAN", _russianRadio],
    ["VIETNAMESE", _vietTalkN]
];

private _languageReaction = createHashMapFromArray [
    ["NONE", []],
    ["ARAB", _arabYell],
    ["RUSSIAN", _russianRadio],
    ["VIETNAMESE", _vietTalkY]
];

private _resolveSideLanguage = {
    params ["_sideTag"];

    private _lang = missionNamespace getVariable [format ["GOL_Stealth_Language_%1", _sideTag], ""];

    // Backward compatibility for missions that still have old profile settings persisted.
    if (_lang isEqualTo "") then {
        _lang = missionNamespace getVariable [format ["GOL_Stealth_ProfileRadio_%1", _sideTag], "RUSSIAN"];
    };

    _lang = toUpper _lang;
    if !(_lang in ["NONE", "ARAB", "RUSSIAN", "VIETNAMESE"]) then {
        _lang = "NONE";
    };

    _lang
};

private _radioPatrolBySide = createHashMap;
private _talkCalmBySide = createHashMap;
private _talkReactionBySide = createHashMap;
private _radioHelpBySide = createHashMap;

{
    _x params ["_sideValue", "_sideTag"];

    private _sideLanguage = [_sideTag] call _resolveSideLanguage;

    private _radioPatrolPaths = _languageRadio getOrDefault [_sideLanguage, []];
    private _talkCalmPaths = _languageTalk getOrDefault [_sideLanguage, []];
    private _talkReactionPaths = _languageReaction getOrDefault [_sideLanguage, []];
    private _radioHelpPaths = _languageRadio getOrDefault [_sideLanguage, []];

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
    if !(missionNamespace getVariable ["GOL_Stealth_InitDebugLogged", false]) then {
        missionNamespace setVariable ["GOL_Stealth_InitDebugLogged", true];
        [format ["[Stealth] Init complete. BLUFOR=%1 OPFOR=%2 INDEP=%3", _radioPatrolBySide getOrDefault [str west, []], _radioPatrolBySide getOrDefault [str east, []], _radioPatrolBySide getOrDefault [str independent, []]], false, false, true] spawn OKS_fnc_LogDebug;
    };
};

true
