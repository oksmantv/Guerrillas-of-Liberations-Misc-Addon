/*
	Function: OKS_fnc_Stealth_Tracker
	
	Description:
		Makes an AI group actively search for and follow player footprint trails.
		When tracks are found, the group follows them with flares and waypoints.
	
	Parameter(s):
		0: GROUP - The AI tracker group
	
	Returns:
		Nothing
	
	Example:
		[group this] spawn OKS_fnc_Stealth_Tracker;
*/

params ["_TrackerGroup"];

private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];

if (_debug) then {
	format ["[STEALTH] Tracker group %1 initialized and searching for footprints", groupId _TrackerGroup] spawn OKS_fnc_LogDebug;
};

_TrackerGroup setVariable ["acex_headless_blacklist", true, true];

private _trackerRange = missionNamespace getVariable ["GOL_OKS_Tracker_Range", 500];

while {{alive _x || [_x] call ace_common_fnc_isAwake} count units _TrackerGroup > 0} do {

	if ({_x distance (leader _TrackerGroup) < _trackerRange} count allPlayers > 0 && !(_TrackerGroup getVariable ["OKS_isTracking", false])) then {
		_HuntedGroups = OKS_HuntedGroups;
		_TracksArray = [];
		{
			{
				_TracksArray pushBackUnique _x;		
			} forEach (_x getVariable ["OKS_GroupTracks", []]);	
		} forEach _HuntedGroups;

		if ({leader _TrackerGroup distance _x < 10} count _TracksArray > 0) then {
			_random = random 1;
			_chance = 0.25;
			if (_random < _chance) then {

				if (_debug) then {
					format ["[STEALTH] Tracker group %1 found footprints! Following trail...", groupId _TrackerGroup] spawn OKS_fnc_LogDebug;
				};
				_TracksArray = _TracksArray select {!isNull _x};
				_SelectedTrack = ([_TracksArray, [], {(leader _TrackerGroup) distance _x}, "ASCEND"] call BIS_fnc_sortBy) select 0;

				private _SelectedTracksArray = [];
				{
					_Array = _x getVariable ["OKS_GroupTracks", []];
					if (_SelectedTrack in _Array) then {
						_SelectedTracksArray = _Array;
					};
				} forEach _HuntedGroups;
				_TracksArray = _SelectedTracksArray select {(_SelectedTracksArray find _x) >= (_SelectedTracksArray find _SelectedTrack)};

				{
					deleteWaypoint [_TrackerGroup, 0];
				} forEach (waypoints _TrackerGroup);

				{
					_WP = _TrackerGroup addWaypoint [getPos _x, 0];
					_WP setWaypointType "MOVE";
					_WP setWaypointBehaviour "AWARE";
					_WP setWaypointSpeed "NORMAL";	
					_WP setWaypointCompletionRadius 15;
				} forEach _TracksArray;

				[_TrackerGroup, _TracksArray] spawn {
					params ["_TrackerGroup", "_TracksArray"];
					waitUntil {(leader _TrackerGroup) distance (_TracksArray select ((count _TracksArray) - 1)) < 20};
					_TrackerGroup setVariable ["OKS_isTracking", false, true];	
				};

				[_TrackerGroup] spawn {
					params ["_TrackerGroup"];
					while {{alive _x} count (units _TrackerGroup) > 0} do {
						{
							if (!([_x] call ace_common_fnc_isAwake)) then {
								_x setDamage 1;
							};					
						} forEach (units _TrackerGroup);
						sleep 30;
					};
				};

				// Flare
				_Position = getPosATL (leader _TrackerGroup);
				_Temp = createVehicle ["F_40mm_Red", [(_Position select 0), (_Position select 1), ((_Position select 2) + 140)], [], 20, "CAN_COLLIDE"];
				_Temp setVelocity [0, 0, -10];
				sleep 3;
			playSound3D ["A3\Sounds_F\weapons\Flare_Gun\flaregun_2_shoot.wss", (leader _TrackerGroup), false, [(_Position select 0), (_Position select 1), (_Position select 2)], 8, 1, 300];
			_TrackerGroup setVariable ["OKS_isTracking", true, true];
		} else {
			if (_debug) then {
				format ["[STEALTH] Tracker group %1 failed to spot track (roll: %2, chance: %3)", groupId _TrackerGroup, _random toFixed 2, _chance toFixed 2] spawn OKS_fnc_LogDebug;
			};
			sleep 15;
		};
	};
};	sleep 5;
};
