/*
    OKS_fnc_Convoy_DismountAndTaskCode
    Makes a group dismount from a vehicle and assigns a combat task.

    If OKS_Convoy_FlankingRoute is stored on the vehicle, infantry groups walk that
    route first before their task fires. Armed mounted groups spawn OKS_fnc_VehicleAttachSquad
    to escort the infantry and wait for infantry arrival before their own task fires.
    An empty or absent route skips flanking entirely (backwards compatible).

    Params:
    0 - Group  - The group being tasked (cargo group or crew group)
    1 - Object - Vehicle the group belongs to (used to read flanking/cargo variables)
    2 - String - Task type: "rush" | "attack" | "hold" | "hunt" | "defend" | "patrol" | "assault"
    3 - Bool   - Should dismount from vehicle (true = force get-out)
    4 - Bool   - Was ambushed (true = overrides defend/patrol to attack)

    Usage: [_Group, _VehicleObject, _type, _shouldDismount, _wasAmbushed] spawn OKS_fnc_Convoy_DismountAndTaskCode;
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

// --- Flanking Route ---
// Read from vehicle variable so WaitUntilCombat needs no changes (backwards compatible).
private _flankingRoute = if (!(isNull _VehicleObject)) then {
	_VehicleObject getVariable ["OKS_Convoy_FlankingRoute", []]
} else { [] };

if (count _flankingRoute > 0) then {
	private _fnExtractPos = {
		params ["_entry"];
		if (_entry isEqualType "") then { markerPos _entry }
		else { if (_entry isEqualType []) then { _entry } else { getPos _entry } }
	};

	if (_shouldDismount) then {
		// --- Infantry branch ---
		// Wait for all units to physically exit the vehicle before adding waypoints.
		waitUntil {
			sleep 0.5;
			({vehicle _x == _x} count units _Group == count units _Group) || ({alive _x} count units _Group == 0)
		};

		[_Group] call OKS_fnc_Convoy_DeleteAllWaypoints;
		{
			private _pos = [_x] call _fnExtractPos;
			private _wp = _Group addWaypoint [_pos select [0, 2], 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointBehaviour "AWARE";
			_wp setWaypointCombatMode "YELLOW";
			_wp setWaypointCompletionRadius 50;
		} forEach _flankingRoute;

		private _lastPos = [_flankingRoute select (count _flankingRoute - 1)] call _fnExtractPos;

		if (_ConvoyDebug) then {
			format ["[CONVOY-FLANK] %1 walking flanking route (%2 WPs).", _Group, count _flankingRoute] spawn OKS_fnc_LogDebug;
		};

		// Wait until infantry reaches the last waypoint or is wiped.
		waitUntil {
			sleep 2;
			private _ldr = leader _Group;
			(!(isNull _ldr) && {_ldr distance2D _lastPos < 50})
			|| ({alive _x} count units _Group == 0)
		};

		// Signal the escorting vehicle (if any) that infantry has arrived.
		if (!(isNull _VehicleObject)) then {
			_VehicleObject setVariable ["OKS_Convoy_FlankingComplete", true, true];
			_VehicleObject setVariable ["OKS_VehicleAttachSquad_Active", false, true];
			_VehicleObject setVariable ["OKS_Convoy_FlankingRoute", [], true];
		};

		if (_ConvoyDebug) then {
			format ["[CONVOY-FLANK] %1 reached flanking destination.", _Group] spawn OKS_fnc_LogDebug;
		};

	} else {
		// --- Mounted armed vehicle branch ---
		// Find the infantry group this vehicle should escort.
		private _targetGroup = grpNull;

		if (!(isNull _VehicleObject)) then {
			// Prefer this vehicle's own cargo group.
			private _cargoGroup = _VehicleObject getVariable ["OKS_Convoy_CargoGroup", grpNull];
			if (!(isNull _cargoGroup) && {({alive _x} count units _cargoGroup) > 0}) then {
				_targetGroup = _cargoGroup;
			};

			// Fallback: find nearest live cargo group from any other convoy vehicle.
			if (isNull _targetGroup) then {
				private _convoyArray = _VehicleObject getVariable ["OKS_Convoy_VehicleArray", []];
				private _nearestDist = 1e10;
				{
					private _otherVehicle = _x;
					if (!(_otherVehicle isEqualTo _VehicleObject)) then {
						private _otherCargo = _otherVehicle getVariable ["OKS_Convoy_CargoGroup", grpNull];
						if (!(isNull _otherCargo) && {({alive _x} count units _otherCargo) > 0}) then {
							private _d = _VehicleObject distance2D (leader _otherCargo);
							if (_d < _nearestDist) then {
								_nearestDist = _d;
								_targetGroup = _otherCargo;
							};
						};
					};
				} forEach _convoyArray;
			};
		};

		if (!(isNull _targetGroup) && {count units _targetGroup > 0}) then {
			if (_ConvoyDebug) then {
				format ["[CONVOY-FLANK] %1 escorting group %2.", _VehicleObject, _targetGroup] spawn OKS_fnc_LogDebug;
			};
			_VehicleObject setVariable ["OKS_Convoy_EscortEnded", false, true];
			[_VehicleObject, _targetGroup] spawn OKS_fnc_VehicleAttachSquad;

			// Wait for infantry to arrive (sets FlankingComplete) OR escort to self-terminate.
			waitUntil {
				sleep 2;
				(_VehicleObject getVariable ["OKS_Convoy_FlankingComplete", false])
				|| (_VehicleObject getVariable ["OKS_Convoy_EscortEnded", false])
				|| (!alive _VehicleObject)
				|| ({alive _x} count units _targetGroup == 0)
			};
		} else {
			if (_ConvoyDebug) then {
				format ["[CONVOY-FLANK] %1 — no squad to escort, skipping to task.", _VehicleObject] spawn OKS_fnc_LogDebug;
			};
		};

		// Clear route so recursive patrol-fallback calls inside the switch don't re-run this block.
		if (!(isNull _VehicleObject)) then {
			_VehicleObject setVariable ["OKS_Convoy_FlankingRoute", [], true];
		};
	};
};
// --- End Flanking Route ---

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
		_NearbyTargets = (leader _Group nearEntities ["Land", 2500]) select { side _Group getFriend (side group _X) < 0.6 && getPos vehicle _X select 2 < 10 };
		if (count _NearbyTargets > 0) then {
			_Target = selectRandom _NearbyTargets;
			_SADWP = _Group addWaypoint [getPos _Target, 0];
			_SADWP setWaypointType "SAD";
			_SADWP setWaypointBehaviour "AWARE";
			_SADWP setWaypointSpeed "FULL";
		} else {
			_NearbyTargets = (leader _Group nearEntities ["Land", 3500]) select { side _Group getFriend (side group _X) < 0.6 && getPos vehicle _X select 2 < 10 };
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
		_HoldWP = _Group addWaypoint [getPos _VehicleObject, 0];
		_HoldWP setWaypointType "HOLD";
	};

	case "hunt": {
		[
			_Group,
			1500,
			60,
			[],
			[],
			false,
			false,
			false
		] spawn lambs_wp_fnc_taskHunt;
		sleep 5;
		_Group setBehaviour "AWARE";
	};
	
	case "defend": {
		[_Group] call OKS_fnc_Convoy_DeleteAllWaypoints;
		_nearestSuitableBuildings = (nearestObjects [getPos _VehicleObject,["House","Building"], 1000] ) select { count ([_X] call BIS_fnc_buildingPositions) >= count units _Group && (_X getVariable ["GOL_isGarrisoned", false])};
		if(count _nearestSuitableBuildings == 0) then {
			[
				_Group,
				getPos _VehicleObject,
				50,
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
			100,
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

