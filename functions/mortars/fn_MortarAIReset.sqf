	
	Private ["_Unit","_This"];
	
	_Unit = (_This select 0);
	
	systemChat format["Mortar AI Reset: %1",name _Unit];

	if (Alive _Unit) then
	{
		_Unit enableAI "MOVE";
		_Unit enableAI "AUTOTARGET";
		_Unit enableAI "FSM";
		UnassignVehicle _Unit;
		[_Unit] OrderGetIn False;
		_Unit setBehaviour "Combat";
		_Unit setCombatMode "RED";
		_Unit remoteExec ["GW_SetDifficulty_fnc_setSkill",0];
		WaitUntil {sleep 30; !Alive _Unit};
		sleep 600;
		DeleteVehicle _Unit;
	};