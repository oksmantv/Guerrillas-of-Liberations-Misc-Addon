/*
    Function: OKS_fnc_Destroy_Task

    Description:
        Creates a destroy or kill task for one or more target objects/units.
        Automatically sets icon to "kill" for infantry or "destroy" for vehicles.
        Supports single targets and arrays of targets. When all targets are dead
        or destroyed, the task auto-completes.

    Parameters:
        0: _Target                   - OBJECT or ARRAY   - Target object or array of targets (required)
        1: _CustomTitle              - STRING             - Task title (default: auto-generated from target name)
        2: _CustomDisplayName        - STRING             - Target display name override (default: auto-detected)
        3: _CustomDescription        - STRING             - Task description. %1 = target name, %2 = target count
        4: _CustomIcon               - STRING             - Task icon type (default: "destroy" or "kill")
        5: _TaskParent               - STRING             - Parent task ID (default: nil)
        6: _ShouldShowPosition       - BOOL               - Show target position on map (default: true)
        7: _ShouldPopUpNotification  - BOOL               - Show popup notification (default: true)

    Returns:
        Nothing

    Example:
        [officer_1] spawn OKS_fnc_Destroy_Task;
        [[officer_1, officer_2, officer_3]] spawn OKS_fnc_Destroy_Task;
        [officer_1, "Kill the Officer", "Enemy Officer", "You need to kill this %1", "kill", nil, true, true] spawn OKS_fnc_Destroy_Task;
*/

if(!isServer) exitWith {};

Params [
    ["_Target",objNull,[objNull,[]]],
    ["_CustomTitle",nil,[""]],
    ["_CustomDisplayName",nil,[""]],
    ["_CustomDescription",nil,[""]],
    ["_CustomIcon","destroy",[""]],
    ["_TaskParent",nil,[""]],
    ["_ShouldShowPosition",true,[true]],
    ["_ShouldPopUpNotification",true,[true]]    
];

private ["_TaskInfo","_TargetDisplayName","_TaskId"];
private _TaskPosition = objNull;
private _TaskIcon = "destroy";
private _TargetArray = [];

if(typeName _target == "OBJECT") then {
    if(_target isKindOf "Man") then {
        _TargetDisplayName = name _target;
        _TaskIcon = "kill";
    };
    if(_target isKindOf "LandVehicle") then {
        _TargetDisplayName = [configFile >> "CfgVehicles" >> typeOf _target] call BIS_fnc_displayName;
        _TaskIcon = "destroy";
    } else {
        _TargetDisplayName = [configFile >> "CfgVehicles" >> typeOf _target] call BIS_fnc_displayName;
        _TaskIcon = "destroy";
    };
    _target lock true;
    _TargetArray pushBackUnique _target;
	if(_ShouldShowPosition) then {	
		_TaskPosition = getPos _target;
	};
};
if(typeName _target == "ARRAY") then {
    _TargetArray = _target;
    _selectedTarget = selectRandom _target;
    {
        _X lock true;
    } foreach _TargetArray;
    if(_selectedTarget isKindOf "Man") then {
        _TargetDisplayName = name _selectedTarget;
        _TaskIcon = "kill";
    };
    if(_selectedTarget isKindOf "LandVehicle") then {
        _TargetDisplayName = [configFile >> "CfgVehicles" >> typeOf _selectedTarget] call BIS_fnc_displayName;
        _TaskIcon = "destroy";
    } else {
        _TargetDisplayName = [configFile >> "CfgVehicles" >> typeOf _selectedTarget] call BIS_fnc_displayName;
        _TaskIcon = "destroy";
    };    
	if(_ShouldShowPosition) then {
		_TaskPosition = [0, 0, 0];
		{
			_TaskPosition = _TaskPosition vectorAdd (getPosWorld _x);
		} forEach _TargetArray;
		_TaskPosition = _TaskPosition vectorMultiply (1 / (count _TargetArray));	
	}
};

if(isNil "_CustomTitle") then {
    _CustomTitle = format["Eliminate %1",_TargetDisplayName];
};
if(isNil "_CustomDescription") then {
    _CustomDescription = format["You have been tasked with eliminating %2 valueable targets: %1",_TargetDisplayName, count _TargetArray];
};
if(!isNil "_CustomDisplayName") then {
    _TargetDisplayName = _CustomDisplayName;
};
if(!isNil "_CustomIcon") then {
    _TaskIcon = _CustomIcon;
};

_TaskId = format["OKS_DestroyTask_%1",random 9999 + (random 9999)];
_TaskData = _TaskId;
if(!isNil "_TaskParent") then {
	_TaskData = [_TaskId,_TaskParent]
};
_TaskInfo = [
	true,
	_TaskData,
	[format[_CustomDescription,_TargetDisplayName,count _TargetArray], format["%1",_CustomTitle], ""],
	_TaskPosition,
	"AUTOASSIGNED",
	-1,
	_ShouldPopUpNotification,
	_TaskIcon
] call BIS_fnc_taskCreate;

waitUntil {sleep 5; {Alive _X} count _TargetArray == 0};
[_TaskId,"SUCCEEDED",_ShouldPopUpNotification] call BIS_fnc_taskSetState;