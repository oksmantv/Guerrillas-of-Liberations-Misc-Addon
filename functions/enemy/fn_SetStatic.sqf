	// OKS_SetStatic
	// [_Group] spawn OKS_fnc_SetStatic;

	Params ["_Group"];
 	Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];

	_Units = units _Group;
	{_X disableAI "PATH"; _X setUnitPos "UP"} foreach _Units;

	if(_Debug) then {
		systemChat format["[DEBUG] %1 set to static units",_Group];
	};
