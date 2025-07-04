/*
	How to use:
	[this,["rhsgref_ins_zsu234"],200,2500,100] spawn OKS_fnc_Radar;
*/

Params [
	["_Radar",objNull,[objNull,[]]],
	["_VehicleClassnames",[],[[]]],
	["_ShareDistance",2000,[0]],
	["_MaxRangeAAA",2500,[0]],
	["_MinimumAltitude",100,[0]]
];

_Unit = ((crew _Radar) select 0);

while {Alive _Radar} do {
	_Unit moveInAny _Radar;
	_Targets = (_Radar targets [true]) select {_X isKindOf "AIR"};
	_AaaVehicles = (_Radar nearEntities ["LandVehicle",_ShareDistance]) select {(typeof _X) in _VehicleClassnames && _Radar distance _X <= _ShareDistance};

	{
		_aaa = _X;
		{
			_Unit = _X;
			_RadarKnowledge = _Radar knowsAbout _Unit;

			if(_aaa distance _Unit <= _MaxRangeAAA && (getPos _Unit) select 2 >= _MinimumAltitude) then {
				_aaa reveal [vehicle _Unit,_RadarKnowledge];
				_aaa doTarget (vehicle _Unit);
				systemChat format["%1 revealed to %2 (%3)",vehicle _Unit,_aaa,_RadarKnowledge];
			} else {
				_aaa forgetTarget (vehicle _Unit);
			};
		} foreach _Targets;
	} forEach _AaaVehicles;

	if(count _AaaVehicles > 0 && count _Targets > 0) then {
		sleep 60;
	} else {
		sleep 10;
	};
};
