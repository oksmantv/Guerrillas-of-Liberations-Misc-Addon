/*
	Author: IR0NSIGHT

	Description:
		Unit will fire large volleys at all nearby enemy aircraft without hitting them, if they are inside detection range, and outside lethal range.
		can set unit to always be 100% ambient. Enemy aircraft are detected magically, bypassing all game mechanincs like radar and stealth.
		Does only work with cannons, seeking missiles will not track.

	Parameter(s):
		0:	object - AA Gun
		1:  side - Side of Gunner
		2:	number - lethal range, meters from object, anything closer will be enganged with deadly accuracy. use -1 for always ambient.
			Optional, default = -1 => always ambient
		3:  number - detection range, meters from object, anything closer will be "magically" detected and engaged.
			Optional, default = 3000
		4: number - multiplier for lead (_time to impact * _multiplier) higher for less accuracy.

	Returns:
		nothing

	Examples:
		[myAAGun, east, -1, 3000] spawn OKS_fnc_aaAmbient;	//pure ambient AA that shoots at anything within 3 kms
		[myGunTruck, east, 1500,3000] spawn OKS_fnc_aaAmbient; //AA will shoot ambient at anything within 3kms and kill anything within 1.5 kms

		//outside control of object:
		myAAGun setVariable ["irn_amb_aa_mode", 0]	//set AA gun to ambient while its running already
		myAAGun setVariable ["irn_amb_aa_mode", 1]	//set AA gun to "dual mode" where it uses lethal range
*/

params [
	["_unit", objNull, [objNull]],
	["_side", east, [sideUnknown]],
	["_lethalRange",-1,[420]],	//will kill anything closer than that range. -1 to be pure ambient
	["_detectionRange",3000,[420]],
	["_leadMultiplier", 2, [0]],
	["_dismountRange", 200, [0]]	//if a player is closer than this to the gunner, dismount him.
];
if (!isServer) exitWith {};
if (!canSuspend) exitWith {
	 ["Function can not be called in unsuspendable context. Use 'spawn' instead"] call BIS_fnc_error;
};

//0: ambient, 1: hybrid
_mode = 0;
if (_lethalRange > 0) then {
	_mode = 1
};
_modeVarName = "irn_amb_aa_mode";
_unit setVariable [_modeVarName,_mode];	//outside control variable

//will move dummy target near helo if timeout over, return target
_updateTarget = {
	params["_Helicopter","_unit","_dummies","_leadMultiplier"];
	_dummy = objNull;
	//select correct target, matching the side
	switch (side _Helicopter) do {
		case west: {_dummy = _dummies#0};
		case east: {_dummy = _dummies#1};
		case independent: {_dummy = _dummies#2};
	};

	_last = _dummy getVariable ["lastMoved",-1];
	if (_last + 2 < time) then {
		_radius = (sizeOf (typeOf _Helicopter)) * 3;
		_center = getPos _Helicopter;
		//add velocity*forward
		_time =(_Helicopter distance _unit)/980; //time the bullet needs to travel
		_lead = ((velocity  _Helicopter) vectorMultiply (_time * 2));
		_center = _center vectorAdd _lead;
		_offset = (vectorNormalized [selectRandom [1,-1],selectRandom [1,-1],0.2]);
		_offset = (_offset vectorMultiply _radius);
		_offset = _center vectorAdd _offset;
		_dummy setPos _offset;
		_Helicopter setVariable ["lastMoved",time];
	};
	//return
	_dummy
};

//is this helo a legitimate target for unit?
_legalHelo = {
	params["_Helicopter","_unit"];
	_out = !isNull _Helicopter && alive _Helicopter && ([side _Helicopter, side _unit] call BIS_fnc_sideIsEnemy) && (getPosATL _Helicopter) select 2 > 20;
	_out
};

_getHelo = {
	params["_unit","_Helicopter","_lastTime","_range"];
	//keep helo if legal, for ~6 seconds
	if (_lastTime + 6 > time && [_Helicopter,_unit] call _legalHelo) exitWith {
		_Helicopter
	};

	//choose new helo
	_Helicopters = ((getPos _unit) nearObjects ["Air",_range]) select {[_x,_unit] call _legalHelo};
	_Helicopters = [_Helicopters, [_unit], {_x distance _input0}, "ASCEND"] call BIS_fnc_sortBy;
	if (count _Helicopters == 0) exitWith {
		objNull;
	};
	_Helicopter = selectRandom [_Helicopters#0,selectRandom _Helicopters]; //either closest one or a random one.
	_Helicopter
};

_i = 0;
_vehicle = vehicle _unit;
_group = [_vehicle,_side,2] call OKS_fnc_AddVehicleCrew;
waitUntil {!isNull (gunner _vehicle)};
_gunner = gunner _vehicle;
_gunner setSkill ["aimingAccuracy",1];

//run parallel loop that force fires whenever the gun is aimedAtTarget
[_gunner,_dismountRange] spawn {
	params ["_gunner","_dismountRange"];
	while {(alive _gunner)} do {
		sleep 0.2;
		_nearTargetOnGround = ({_x distance _gunner < _dismountRange && (getPosATL _x) select 2 < 5} count AllPlayers > 0);
		if(_nearTargetOnGround) exitWith {
			_vehicle = (vehicle _gunner);
			_gunner leaveVehicle _vehicle;
			_vehicle lock true;
		};
		_Helicopter = _gunner getVariable ["irn_amb_aa_Helicopter",objNull];
		_target = _gunner getVariable ["irn_amb_aa_target",objNull];
		_muzzle = ((vehicle _gunner) weaponsTurret [0]) select 0;
		if (!isNull _target && alive _Helicopter) then {

			//fire burst while aimed
			vehicle _gunner setVehicleAmmo 1;
			_i = 0;
			_max = random 25 + 15;
			while {vehicle _gunner aimedAtTarget [_target] > 0.8 && _i < _max} do {
				_i = _i + 1;
				vehicle _gunner fireAtTarget [_target,_muzzle];
				sleep 0.05;
			};	
		} else {
			sleep 1;
		};
	};
};

_unit setVariable ["irn_amb_aa",true,true];

//create a dummy target for each side
_dummies = [];
{
	_d = createVehicle [_x,[0,0,0]];
	_dummies pushBack _d;
} forEach ["CBA_B_InvisibleTargetAir","CBA_O_InvisibleTargetAir","CBA_I_InvisibleTargetAir"];
_timeStampHelo = time;
_Helicopter = objNull;
while {alive _unit && ((vehicle _unit) != _unit)} do {
	(group _unit) setCombatMode "BLUE";

	_nearTargetOnGround = ({_x distance _gunner < _dismountRange && (getPosATL _x) select 2 < 5} count AllPlayers > 0);
	if(_nearTargetOnGround) exitWith {
		_gunner leaveVehicle _vehicle;
		_vehicle lock true;
		(group _gunner) setCombatMode "YELLOW";
		_gunner enableAI "AUTOTARGET";
		_gunner enableAI "TARGET";	
	};	

	//timeout if disabled Sim
	while {!simulationEnabled _unit} do {
		sleep 5;
	};
	sleep 1;

	_isHybrid = 1 == (_unit getVariable [_modeVarName,0]); //ambient for 1km+, deadly for <1km
	_HelicopterOld = _Helicopter;
	_Helicopter = [_unit, _Helicopter,_timeStampHelo,_detectionRange] call _getHelo;
	if (_Helicopter isNotEqualTo _HelicopterOld) then {
		_timeStampHelo = time;
	};
	if (isNull _Helicopter) then {
		sleep 2;
		continue;
	};

	//select firemode
	_fireMode = 0;
	if (_isHybrid && _Helicopter distance _unit < (_lethalRange)) then {_fireMode = 1};

	_target = objNull;
	//choose target
	if (_fireMode == 1) then {
		//hybrid mode and helo is closer than 50% -> direct fire
		(group _unit) setCombatMode "RED";
		_target = _Helicopter;
		_gunner doFire _target;
		_unit enableAI "AUTOTARGET";
		_unit enableAI "TARGET";
	} else {
		//helo is farther than 50% OR not hybrid -> ambient fire
		_target = [_Helicopter,_unit,_dummies,_leadMultiplier] call _updateTarget; 		//get (pseudo) target
		(group _unit) forgetTarget _Helicopter;
		_unit disableAI "AUTOTARGET";
		_unit disableAI "TARGET";

	};

	//set target as var, reveal and watch target.
	_gunner setVariable ["irn_amb_aa_target",_target];
	_gunner setVariable ["irn_amb_aa_Helicopter",_Helicopter];
	_gunner reveal [_target, 4];

	//_gunner doWatch getPos _target;
	_gunner doWatch getPos _target;
};

{
	deleteVehicle _x
} forEach _dummies;
