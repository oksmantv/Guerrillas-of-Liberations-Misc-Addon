// Example
// [_Vehicle] spawn OKS_fnc_ForceVehicleSpeed;    

Params ["_Vehicle"];

if (hasInterface && !isServer) exitWith {};

sleep 2;

Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug", false];
if (isNull _Vehicle) exitWith {
	if (_Debug) then {
		format ["ForceVehicleSpeed Script, Vehicle was null. Exiting.."] spawn OKS_fnc_LogDebug;
	};
};

if (_Vehicle isKindOf "StaticWeapon" || _Vehicle isKindOf "Air") exitWith {
	Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug", false];
	if (_Debug) then {
		"OKS_ForceVehicleSpeed: Is Static Weapon/Air Exiting.." spawn OKS_fnc_LogDebug;
	};
};

if ((["vehicle_", vehicleVarName _vehicle] call BIS_fnc_inString) || (["mhq_", vehicleVarName _vehicle] call BIS_fnc_inString)) exitWith {
	if (_Debug) then {
		format ["OKS_ForceVehicleSpeed, Vehicle_ or MHQ_, exiting.."] spawn OKS_fnc_LogDebug;
	};
};

if (_vehicle getVariable ["OKS_ForceSpeedActive", false]) exitWith {
	if (_Debug) then {
		format ["OKS_ForceVehicleSpeed, already applied, exiting.."] spawn OKS_fnc_LogDebug;
	};
};
_vehicle setVariable ["OKS_ForceSpeedActive", true, true];

private _Speed = 10;
private _VehicleType = (_Vehicle call BIS_fnc_objectType)#1;

switch (toLower (_VehicleType)) do {
	case "wheeledapc": {
		_Speed = missionNamespace getVariable ["GOL_Enemy_MaxSpeed_WheeledAPCs", 12];
	};
	case "trackedapc": {
		_Speed = missionNamespace getVariable ["GOL_Enemy_MaxSpeed_TrackedAPCs", 8];
	};
	case "tank": {
		_Speed = missionNamespace getVariable ["GOL_Enemy_MaxSpeed_Tanks", 8];
	};
	case "car": {
		_Speed = missionNamespace getVariable ["GOL_Enemy_MaxSpeed_Cars", 12];
	};
};

[_Vehicle, _Speed] remoteExec ["forceSpeed", 0];

Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug", false];
if (_Debug) then {
	format ["%1 forced speed to %2.", typeOf _Vehicle, _Speed] spawn OKS_fnc_LogDebug;
};