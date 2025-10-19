/*
    OKS_fnc_Convoy_DismountAndTaskCode
    Makes a group dismount from a vehicle and assigns a task.
    Usage: [_Group, _VehicleObject, _type] spawn OKS_fnc_Convoy_DismountAndTaskCode;
*/
params ["_Group", ["_VehicleObject", objNull, [objNull, ""]], "_type",["_shouldDismount", false],["_wasAmbushed", false]];
private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug", false];

if(_shouldDismount && !isNil "_VehicleObject") then {
	_Group leaveVehicle _VehicleObject;
	{
		unassignVehicle _x;
		doGetOut _x;
	} forEach (units _Group);
};

if(!_shouldDismount && toLower _type == "defend" && !isNil "_VehicleObject") then {
	_type = "hold";
};

if(_wasAmbushed && _type in ["defend","patrol"]) then {
	if(_ConvoyDebug) then {
		"[CONVOY-AMBDISMOUNT] Ambush detected, overriding dismount task to ATTACK." spawn OKS_fnc_LogDebug;
	};
	_type = "attack";
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

	case "attack": {
		[_Group] call OKS_fnc_Convoy_DeleteAllWaypoints;
		_NearbyTargets = (leader _Group nearEntities ["Land", 1500]) select { side _Group getFriend (side group _X) < 0.6 && getPos vehicle _X select 2 < 10 };
		if (count _NearbyTargets > 0) then {
			_Target = selectRandom _NearbyTargets;
			_SADWP = _Group addWaypoint [getPos _Target, 0];
			_SADWP setWaypointType "SAD";
			_SADWP setWaypointBehaviour "AWARE";
			_SADWP setWaypointSpeed "FULL";
		} else {
			_NearbyTargets = (leader _Group nearEntities ["Land", 1500]) select { side _Group getFriend (side group _X) < 0.6 && getPos vehicle _X select 2 < 10 };
			_Target = selectRandom _NearbyTargets;
			if(!isNil "_Target") then {
				_Target = selectRandom _NearbyTargets;
				_SADWP = _Group addWaypoint [getPos _Target, 0];
				_SADWP setWaypointType "SAD";
				_SADWP setWaypointBehaviour "AWARE";
				_SADWP setWaypointSpeed "FULL";
			} else {
				[_Group, _VehicleObject, "patrol", _shouldDismount, false] spawn OKS_fnc_Convoy_DismountAndTaskCode;
			};
		};
	};

	case "hold": {
		[_Group] call OKS_fnc_Convoy_DeleteAllWaypoints;
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
		[_Group] call OKS_fnc_Convoy_DeleteAllWaypoints;
		_nearestSuitableBuildings = (getPos _VehicleObject nearObjects ["House", 1000]) select { count ([_X] call BIS_fnc_buildingPositions) >= count units _Group && (_X getVariable ["GOL_isGarrisoned", false])};
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
			[_Group, _VehicleObject, "patrol", _shouldDismount,_wasAmbushed] spawn OKS_fnc_Convoy_DismountAndTaskCode;
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
		[_Group] call OKS_fnc_Convoy_DeleteAllWaypoints;
		[
			_Group,
			getPos _VehicleObject,
			500,
			4,
			getPos _VehicleObject,
			true,
			true
		] spawn lambs_wp_fnc_taskPatrol;
		sleep 5;
		_Group setBehaviour "AWARE";		
	};

	case "assault": {
		[_Group] call OKS_fnc_Convoy_DeleteAllWaypoints;
		_NearbyTargets = (leader _Group nearEntities ["Land", 1500]) select { side _Group getFriend (side group _X) < 0.6 && getPos vehicle _X select 2 < 10 };
		if (count _NearbyTargets > 0) then {
			_Target = selectRandom _NearbyTargets;
			[
				_Group,
				getPos _Target
			] spawn lambs_wp_fnc_taskAssault;
		} else {
			_NearbyTargets = (leader _Group nearEntities ["Land", 3000]) select { side _Group getFriend (side group _X) < 0.6 && getPos vehicle _X select 2 < 10  };
			_Target = selectRandom _NearbyTargets;
			if(!isNil "_Target") then {
				[
					_Group,
					getPos _Target
				] spawn lambs_wp_fnc_taskAssault;
			} else {
				[_Group, _VehicleObject, "patrol", _shouldDismount,false] spawn OKS_fnc_Convoy_DismountAndTaskCode;
			}
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

