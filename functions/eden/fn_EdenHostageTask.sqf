/*
    OKS_fnc_EdenHostageTask
    _this: [position, ...] from Eden context menu
*/

params ["_Position"];
private _selected = get3DENSelected "object";
private _groupName = "";

{
    if (_x isKindOf "Man") then {
        private _init = (_x get3DENAttribute "init") select 0;
        if (_init isEqualTo "") then {
            _init = '[this,"MOVE"] remoteExec ["disableAI",0];';
        } else {
            if (!(_init find '[this,"MOVE"] remoteExec ["disableAI",0];' > -1)) then {
                _init = _init + ' [this,"MOVE"] remoteExec ["disableAI",0];';
            };
        };
        _x set3DENAttribute ["init", _init];
    };
} forEach _selected;

{
    private _group = group _x;
    if (!isNull _group) then {
        _groupName = (_group get3DENAttribute "name") select 0;
        if (_groupName isEqualTo "") then {
            _groupName = ["HostageGroup"] call OKS_fnc_next3DENName;
            _group set3DENAttribute ["name", _groupName];
        };
        breakOut "main";
    };
} forEach _selected;

if (_groupName isEqualTo "") then {
    _groupName = ["HostageGroup"] call OKS_fnc_next3DENName;
    _hostageName = ["Hostage"] call OKS_fnc_next3DENName;
    private _dir = 0;
    private _firstUnit = create3DENEntity ["Object", "C_man_1", _Position getPos [0, 0]];
    _firstUnit set3DENAttribute ["name", _hostageName];
    _firstUnit set3DENAttribute ["init", '[this,"MOVE"] remoteExec ["disableAI",0];'];
    private _grp = group _firstUnit;
    _grp set3DENAttribute ["name", _groupName];
    _dir = _dir + 45;
    for "_i" from 2 to 3 do {
        private _unit = _grp create3DENEntity ["Object", "C_man_1", _Position getPos [3, _dir]];
        _unit set3DENAttribute ["name", format ["Hostage_%1", _i]];
        _unit set3DENAttribute ["presence", 1];
        _unit set3DENAttribute ["init", '[this,"MOVE"] remoteExec ["disableAI",0];'];
        _dir = _dir + 45;
    };
    systemChat "No group found in Eden selection. Example group of 3 civilians created.";
};
private _example = format [
    "[%1] spawn OKS_fnc_Hostage;",
    _groupName
];
copyToClipboard _example;
systemChat format["CopiedToClipboard: %1",_example];