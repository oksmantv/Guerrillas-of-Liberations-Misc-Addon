/*
    OKS_fnc_Convoy_DismountAndTaskCode
    Makes a group dismount from a vehicle and assigns a task.
    Usage: [_Group, _VehicleObject, _type] call OKS_fnc_Convoy_DismountAndTaskCode;
*/
params ["_Group", "_VehicleObject", "_type",["_shouldDismount", false]];


if(_shouldDismount) then {
	_Group leaveVehicle _VehicleObject;
	{
		unassignVehicle _x;
		doGetOut _x;
	} forEach (units _Group);
};

if(!_shouldDismount && toLower _type == "defend") then {
	_type = "hold";
};

switch (toLower _type) do {
	case "rush": {
		[
			_Group,
			1500,
			30,
			[],
			[],
			false
		] spawn lambs_wp_fnc_taskRush;
	};

	case "hold": {
		_GuardWP = _Group addWaypoint [getPos _VehicleObject, 0];
		_GuardWP setWaypointType "GUARD";
	};

	case "hunt": {
		[
			_Group,
			1500,
			60,
			[],
			[],
			false
		] spawn lambs_wp_fnc_taskHunt;
		sleep 5;
		_Group setBehaviour "AWARE";
	};
	case "defend": {
		_nearestSuitableBuildings = (getPos _VehicleObject nearObjects ["House", 400]) select { count ([_X] call BIS_fnc_buildingPositions) >= count units _Group && (_X getVariable ["GOL_isGarrisoned", false])};
		if(count _nearestSuitableBuildings == 0) then {
			[
				_Group,
				getPos _VehicleObject,
				200,
				4,
				getPos _VehicleObject,
				true,
				true
			] spawn lambs_wp_fnc_taskPatrol;
			sleep 5;
			_Group setBehaviour "AWARE";
		};
		_nearestBuilding = selectRandom _nearestSuitableBuildings;
		if(isNil "_nearestBuilding") exitWith {
			[
				_Group,
				getPos _VehicleObject,
				200,
				4,
				getPos _VehicleObject,
				true,
				true
			] spawn lambs_wp_fnc_taskPatrol;
			sleep 5;
			_Group setBehaviour "AWARE";
		};
		_nearestBuilding setVariable ["GOL_isGarrisoned", true, true];
		waitUntil {
			sleep 2;
			{!Alive _X || vehicle _X == _X} count units _Group == count units _Group
		};
		[
			_Group,
			getPos _nearestBuilding,
			25,
			getPos _nearestBuilding,
			false,
			false,
			0,
			true
		] spawn lambs_wp_fnc_taskGarrison;
	};
	case "patrol": {	
		[
			_Group,
			getPos _VehicleObject,
			200,
			4,
			getPos _VehicleObject,
			true,
			true
		] spawn lambs_wp_fnc_taskPatrol;
		sleep 5;
		_Group setBehaviour "AWARE";		
	};
	case "assault": {

		_NearbyPlayerTargets = allPlayers select { _Group knowsAbout _X > 2.0 && vehicle _X == _X && side _Group getFriend (side group _X) < 0.6 };
		if (count _NearbyPlayerTargets > 0) then {
			_Target = selectRandom _NearbyPlayerTargets;
			[
				_Group,
				getPos _Target
			] spawn lambs_wp_fnc_taskAssault;
		} else {
			_NearbyPlayerTargets = allPlayers select { _Group knowsAbout _X > 0 && vehicle _X == _X && side _Group getFriend (side group _X) < 0.6 };
			_Target = selectRandom _NearbyPlayerTargets;
			if(!isNil "_Target") then {
				[
					_Group,
					getPos _Target
				] spawn lambs_wp_fnc_taskAssault;
			};
		};
	};

	default { 
		[
			_Group,
			1500,
			30,
			[],
			[],
			false
		] spawn lambs_wp_fnc_taskRush;
	};
};

