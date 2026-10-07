/*
	OKS_fnc_VehicleAttachSquad
	Attaches a vehicle to an infantry group, escorting them dynamically.
	The vehicle tracks the group leader every 8 seconds.
	When the leader is in forest terrain the vehicle moves to the nearest open
	position (nearest road preferred, then a spiral open-field search outward).

	Stop conditions (any cause a clean exit and set OKS_Convoy_EscortEnded):
	- OKS_VehicleAttachSquad_Active set to false externally
	- Vehicle destroyed
	- Group empty or all units dead
	- Vehicle > 500m from group leader (gives up, task fires)
	- Spiral search finds no open position (pure forest) → exits immediately to task

	External disable:
		myVehicle setVariable ["OKS_VehicleAttachSquad_Active", false, true];

	Usage: [_vehicle, _group] spawn OKS_fnc_VehicleAttachSquad;
*/

params ["_vehicle", "_group"];
private _convoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug", false];

if (!alive _vehicle) exitWith {
	_vehicle setVariable ["OKS_Convoy_EscortEnded", true, true];
};

private _vehicleGroup = group (driver _vehicle);
if (isNull _vehicleGroup) exitWith {
	_vehicle setVariable ["OKS_Convoy_EscortEnded", true, true];
};

_vehicle setVariable ["OKS_VehicleAttachSquad_Active", true, true];

if (_convoyDebug) then {
	format ["[CONVOY-ESCORT] VehicleAttachSquad started — %1 escorting %2", typeOf _vehicle, _group] spawn OKS_fnc_LogDebug;
};

while {true} do {
	_convoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug", false];

	// --- Exit checks (top of every iteration) ---
	if (!(_vehicle getVariable ["OKS_VehicleAttachSquad_Active", false])) exitWith {};
	if (!alive _vehicle) exitWith {};
	if ({alive _x} count units _group == 0) exitWith {};

	private _leader = leader _group;
	if (isNull _leader) exitWith {};

	private _leaderPos = getPos _leader;
	private _dist = _vehicle distance2D _leaderPos;

	// Give up if infantry is too far — task will fire via DismountAndTaskCode waitUntil
	if (_dist > 500) then {
		if (_convoyDebug) then {
			format ["[CONVOY-ESCORT] %1 is >500m from infantry — giving up escort.", typeOf _vehicle] spawn OKS_fnc_LogDebug;
		};
		_vehicle setVariable ["OKS_VehicleAttachSquad_Active", false, true];
	} else {
		// Terrain check at infantry leader position
		private _treeCount = count (nearestTerrainObjects [_leaderPos, ["TREE"], 50, false]);
		private _isForest = _treeCount > 10;
		private _targetPos = [];

		if (!_isForest) then {
			// Open terrain — follow directly
			_targetPos = _leaderPos;
		} else {
			// Forest: try nearest road first (within 200m)
			private _nearRoads = _leaderPos nearRoads 200;
			if (count _nearRoads > 0) then {
				_targetPos = getPos (_nearRoads select 0);
				if (_convoyDebug) then {
					format ["[CONVOY-ESCORT] %1 — infantry in forest, routing to nearest road.", typeOf _vehicle] spawn OKS_fnc_LogDebug;
				};
			} else {
				// Spiral search outward from infantry for an open position
				private _found = false;
				{
					private _r = _x;
					if (!_found) then {
						{
							private _a = _x;
							private _candidatePos = [
								(_leaderPos select 0) + (_r * sin _a),
								(_leaderPos select 1) + (_r * cos _a),
								0
							];
							if (count (nearestTerrainObjects [_candidatePos, ["TREE"], 30, false]) < 10) exitWith {
								_targetPos = _candidatePos;
								_found = true;
							};
						} forEach [0, 45, 90, 135, 180, 225, 270, 315];
					};
				} forEach [20, 40, 60, 80, 100];

				if (!_found) then {
					// Pure forest — abort escort so vehicle proceeds directly to its task
					if (_convoyDebug) then {
						format ["[CONVOY-ESCORT] %1 — pure forest, no open position found. Aborting escort.", typeOf _vehicle] spawn OKS_fnc_LogDebug;
					};
					_vehicle setVariable ["OKS_VehicleAttachSquad_Active", false, true];
				};
			};
		};

		// Update vehicle waypoint when a drivable target was resolved
		if (count _targetPos > 0) then {
			[_vehicleGroup] call OKS_fnc_Convoy_DeleteAllWaypoints;
			private _wp = _vehicleGroup addWaypoint [_targetPos select [0, 2], 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointCompletionRadius 25;

			// Speed: catch-up when far behind, escort pace when close
			private _speedKph = if (_dist > 200) then { 40 } else { 20 };
			_vehicle limitSpeed _speedKph;
			_vehicle forceSpeed (_speedKph / 3.6);

			if (_convoyDebug) then {
				format ["[CONVOY-ESCORT] %1 routing to %2 at %3 kph (dist: %4m, forest: %5)",
					typeOf _vehicle, _targetPos, _speedKph, round _dist, _isForest] spawn OKS_fnc_LogDebug;
			};
		};
	};

	sleep 8;
};

// Signal DismountAndTaskCode that escort has ended (all exit paths reach here)
_vehicle setVariable ["OKS_Convoy_EscortEnded", true, true];

if (_convoyDebug) then {
	format ["[CONVOY-ESCORT] VehicleAttachSquad ended — %1", typeOf _vehicle] spawn OKS_fnc_LogDebug;
};
