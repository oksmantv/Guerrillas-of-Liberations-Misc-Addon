	
	/*

		Random Artillery

		Description: Randomly calls artillery strikes around a target object.

		Example:
	 	[targetObject,"rhs_ammo_3of56",6,10,100] spawn OKS_fnc_RandomArtillery;
	*/	
	if(!isServer) exitWith {};
	
	Params ["_Target","_Munition","_DelayBetweenRounds","_AmountOfRounds","_MunitionSpread"];
	for "_i" from 1 to _AmountOfRounds do {
		_RandomPos = _Target getPos [(random _munitionSpread),(random 360)];
		_Round = createVehicle [_Munition, [(_RandomPos select 0), (_RandomPos select 1), ((_RandomPos select 2) + 1000)], [], 20, "CAN_COLLIDE"];
		_Round setVelocity [0,0,-200];
		sleep (_DelayBetweenRounds + (random _DelayBetweenRounds));
	};

	if(!(_Target isEqualType objNull)) then {
		_Target setVariable ["OKS_StrikeComplete",true,true];
	};