if(!isServer) exitWith {};

Params [
	["_Vehicle", ObjNull, [ObjNull]],
	["_Side", missionNameSpace getVariable ["GOL_Friendly_Side", (side group player)], [sideUnknown]]
];
private _originPosition = getPos _Vehicle;
private _SetupTarget = {
	params ["_Vehicle","_Side"];

	private _invisibleGroup = createGroup _Side;
	private _className = "";
	switch (_Side) do {
		case west: { _className = "B_Soldier_F"; };
		case east: { _className = "O_Soldier_F"; };
		case independent: { _className = "I_Soldier_F"; };
		default { 
			_className = "B_Soldier_F";
		};
	};

	_InvisibleSoldier = _invisibleGroup createUnit [_className, getPos _Vehicle, [], 0, "NONE"];
	_Number = (missionNamespace getVariable ["GOL_VehicleEmpty_Count",0]) + 1;
	(missionNamespace setVariable ["GOL_VehicleEmpty_Count",_Number,true]);
	_invisibleGroup setGroupIdGlobal [format["PLAYER VEHICLE #%1", _Number]];
	_InvisibleSoldier allowDamage false;
	_InvisibleSoldier hideObjectGlobal true;
	_InvisibleSoldier disableAI "ALL";
	_InvisibleSoldier setBehaviour "CARELESS";
	_InvisibleSoldier setCombatMode "BLUE";
	_InvisibleSoldier moveInDriver _Vehicle;
	_Vehicle setVariable ["GOL_InvisibleTarget", _InvisibleSoldier, true];

	format["[VEHICLEMPTY] Side %1 - Classname %2", _Side, _className] call OKS_fnc_LogDebug;
	format["[VEHICLEMPTY] Target on PLAYER VEHICLE #%2 - %1", _Vehicle, _Number] call OKS_fnc_LogDebug;
};
private _ClearTarget = {
	params ["_Vehicle","_Side"];

	_InvisibleSoldier = _Vehicle getVariable ["GOL_InvisibleTarget", objNull];
	if(!isNull _InvisibleSoldier) then {
		deleteVehicle _InvisibleSoldier;
		format["[VEHICLEMPTY] Cleared target for vehicle: %1", _Vehicle] call OKS_fnc_LogDebug;
	};
};

waitUntil {
	sleep 20;
	_Vehicle distance _originPosition > 150 ||
	!alive _Vehicle ||
	{isNull _Vehicle} 
};
format["[VEHICLEMPTY] Vehicle left starting area: %1", _Vehicle] call OKS_fnc_LogDebug;

while {alive _Vehicle} do {
	if (count crew _Vehicle == 0 && {_X distance _Vehicle < 50} count allPlayers == 0 ) then {
		[_Vehicle, _Side] call _SetupTarget;
		waitUntil {
			sleep 5;
			{
				_X distance _Vehicle < 50
			} count allPlayers > 0 || !alive _Vehicle || {isNull _Vehicle}
		};
		[_Vehicle, _Side] call _ClearTarget;
	};
	sleep 5;
};