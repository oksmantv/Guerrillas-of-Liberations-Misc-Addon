// Example
// [_Vehicle] spawn OKS_fnc_ForceVehicleSpeed;    

if(!isServer) exitWith { false };

Params ["_Vehicle"];

Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
if(isNull _Vehicle) exitWith {
    if(_Debug) then {
        format ["ForceVehicleSpeed Script, Vehicle was null. Exiting.."] spawn OKS_fnc_LogDebug;
    };
};

if(_Vehicle isKindOf "StaticWeapon" || _Vehicle isKindOf "Air") exitWith {
    Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
    if(_Debug) then {
	    "OKS_ForceVehicleSpeed: Is Static Weapon/Air Exiting.." spawn OKS_fnc_LogDebug;
    };
};

Private _Speed = 10;
private _VehicleType = (_Vehicle call BIS_fnc_objectType)#1;

switch (toLower (_VehicleType)) do {
     case "wheeledapc": { 
        _Speed = 12;
    };   
     case "trackedapc": { 
        _Speed = 8;
    };   
    case "tank": { 
        _Speed = 8;
    };
    case "car": { 
        _Speed = 12;
    };   
};

[_Vehicle,_Speed] remoteExec ["forceSpeed",0];

Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
if(_Debug) then {
    format ["%1 forced speed to %2.",typeOf _Vehicle,_Speed] spawn OKS_fnc_LogDebug;
};