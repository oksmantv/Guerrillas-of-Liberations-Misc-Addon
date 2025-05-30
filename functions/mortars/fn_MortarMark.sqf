	Private ["_Daytime","_Temp","_SunRise","_SunSet","_Position"];
	
	_Position = _This select 0;	
	#include "fn_Mortar_Settings.sqf"

	systemChat "Marking Mortar Target";
	
	if ((dayTime > _Sunrise) and (dayTime < _Sunset)) then {_DayTime = True} else {_Daytime = False};

	if (_Daytime) then
	{
		_Temp = CreateVehicle [_MarkSmoke, [(_Position select 0), (_Position select 1), ((_Position select 2) + 100)], [], 20, "CAN_COLLIDE"];
		sleep 1;
		_Temp SetVelocity [0,0,-50];
	} else {
		_Temp = createVehicle [_MarkFlare, [(_Position select 0), (_Position select 1), ((_Position select 2) + 140)], [], 20, "CAN_COLLIDE"];
		_Temp setVelocity [0,0,-10];
		UIsleep 3.1;
		playSound3D ["A3\Sounds_F\weapons\Flare_Gun\flaregun_2_shoot.wss", _Flare, false, [(_Position select 0), (_Position select 1), (_Position select 2) + 140], 8, 1, 300];
	};		