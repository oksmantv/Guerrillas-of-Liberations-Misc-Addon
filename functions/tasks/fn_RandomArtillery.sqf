	
	// [targetObject,"rhs_ammo_3of56",6,10,100] sleep OKS_fnc_RandomArtillery;
	
	Params ["_Target","_Munition","_DelayBetweenRounds","_AmountOfRounds","_MunitionSpread"];
	for "_i" from 1 to _AmountOfRounds do {
		_RandomPos = _Target getPos [(random _munitionSpread),(random 360)];
		_Round = createVehicle [_Munition, [(_RandomPos select 0), (_RandomPos select 1), ((_RandomPos select 2) + 120)], [], 20, "CAN_COLLIDE"];
		_Round setVelocity [0,0,-15];
		sleep (_DelayBetweenRounds + (random _DelayBetweenRounds));
	};
	_Target setVariable ["OKS_StrikeComplete",true,true];