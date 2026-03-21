	Params ["_Unit"];
	
	format["[Mortar] AI Reset: %1",name _Unit] spawn OKS_fnc_LogDebug;
	if (Alive _Unit) then
	{
		_Unit enableAI "MOVE";
		_Unit enableAI "AUTOTARGET";
		_Unit enableAI "FSM";
		UnassignVehicle _Unit;
		[_Unit] OrderGetIn False;
		(group _Unit) setBehaviour "Combat";
		(group _Unit) setCombatMode "RED";

		WaitUntil {sleep 30; !Alive _Unit};
		sleep 300;
		DeleteVehicle _Unit;
	};