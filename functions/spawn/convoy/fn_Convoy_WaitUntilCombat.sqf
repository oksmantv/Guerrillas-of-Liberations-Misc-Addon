private _DismountCode = {
	Params ["_Group","_Vehicle"];
	_Group leaveVehicle _Vehicle;
	{unassignVehicle _X; doGetOut _X;} foreach units _Group;
	[_Group,1500,30,[],[],false] spawn lambs_wp_fnc_taskRush;
};
private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug",false];

Params ["_Vehicle","_Crew","_CargoGroup"];
waitUntil {
	sleep 0.5;
	{behaviour _X isEqualTo "COMBAT"} count units _Crew > 0
	||
	{behaviour _X isEqualTo "COMBAT"} count units _CargoGroup > 0
};
_CargoGroup setBehaviour "COMBAT";
_Crew setBehaviour "COMBAT";
_CargoGroup setCombatMode "RED"; 
_Crew setCombatMode "RED"; 
if(_ConvoyDebug) then {
	format [systemChat "[CONVOY] Ambush Detected. Halting Convoy.."] spawn OKS_fnc_LogDebug;
};
_Vehicle forceSpeed 0;
_Vehicle setFuel 0;
_Vehicle setVehicleLock "UNLOCKED";
[_CargoGroup,_Vehicle] spawn _DismountCode;

if(((!isNull gunner _Vehicle) || (_Vehicle emptyPositions "gunner" > 0)) || ((!isNull commander _Vehicle) || (_Vehicle emptyPositions "commander" > 0))) then {
	if(_ConvoyDebug) then {
		format ["[CONVOY] Vehicle is armed, will apply hunt."] spawn OKS_fnc_LogDebug;
	};
	sleep (30 + (Random 30));
	_vehicle limitSpeed 15;
	_vehicle forceSpeed (15 / 3.6);
	_Vehicle setFuel 1;

	if(_ConvoyDebug) then {
		format ["[CONVOY] Hunt Applied to %1 in %2 - %3",_Crew,_Vehicle,[configFile >> "CfgVehicles" >> typeOf _Vehicle] call BIS_fnc_displayName] spawn OKS_fnc_LogDebug
	};
	[_Crew, 1500, 60, [], [], false] spawn lambs_wp_fnc_taskHunt;
	sleep 5;
	_Crew setBehaviour "AWARE";
} else {
	if(_ConvoyDebug) then {
		format ["[CONVOY] Vehicle is unarmed, dismount and rush."] spawn OKS_fnc_LogDebug;
	};
	[_Crew,_Vehicle] spawn _DismountCode;
};