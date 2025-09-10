	Params ["_Position"];

	_fire = createVehicle ["test_EmptyObjectForFireBig", [_Position#0,_Position#1,(_Position#2 - 2)], [], -1, "CAN_COLLIDE"];
	createVehicle ["test_EmptyObjectForSmoke", _Position, [], -1, "CAN_COLLIDE"];
	createVehicle ["ace_fire_logic", _Position, [], -1, "CAN_COLLIDE"];

	_light = createVehicle ["#lightpoint", [_Position#0,_Position#1,(_Position#2 + 8)], [], -1, "CAN_COLLIDE"];
	_light setLightColor [1, 0.5, 0.3];	  // Warm, not too orange ([R,G,B])
	_light setLightBrightness 3.0;		   // Strong, intense brightness
	_light setLightAttenuation [0.1, 0, 0, 2, 60, 1200]; // Much wider effective range
	_light attachTo [_fire, [0,0,8]];	   // Position light slightly above the flame

	[_fire,_Position] spawn {
		params ["_fire","_Position"];

		while {alive _fire} do {
			_fireSoundArray = selectRandom [
				["A3\Sounds_F\sfx\fire1_loop.wss",8.5],
				["A3\Sounds_F\sfx\fire2_loop.wss",12.55],
				["A3\Sounds_F\sfx\fire3_loop.wss",6.75]
			];
			_fireSoundArray params ["_SfxPath","_Delay"];
			playSound3D [_SfxPath, _fire, false, _Position, 5, 1, 100];
			sleep _Delay;
		};
	};