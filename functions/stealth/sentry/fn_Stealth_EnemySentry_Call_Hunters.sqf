/*
	[_Group,500] call OKS_fnc_Stealth_EnemySentry_Call_Hunters;
*/

params ["_Group", "_NearbyHunterRange", "_Target"];
private ["_DetectedPlayer"];

if (!(_Group getVariable ["LAMBS_HUNTING", false]) && !(_Group getVariable ["GOL_IsStatic", false])) then {
	_Group setVariable ["LAMBS_HUNTING", true, true];
	_Group setBehaviour "AWARE";
	_Group setSpeedMode "FULL";
	{ _X disableAI "FSM"; _X enableAttack false } forEach units _Group;

	while {(count (waypoints _Group)) > 0} do {
		deleteWaypoint ((waypoints _Group) select 0);
	};

	_DetectedPlayer = selectRandom ((_Target targets [true]) select {
		_Target distance _X < 200 &&
		_Target knowsAbout _X > 2.5 &&
		!((vehicle _X) isKindOf "AIR") &&
		!((_X getVariable ["GOL_SelectedRole", [""]] select 0) in ["p", "jetp"])
	});

	if (isNil "_DetectedPlayer") then { _DetectedPlayer = _Target };
	private _WP = _Group addWaypoint [getPos _DetectedPlayer, 30];
	_WP setWaypointBehaviour "AWARE";
	_WP setWaypointSpeed "FULL";

	[_Group] call OKS_fnc_Stealth_SendDetectionFlare;
	_Group setVariable ["OKS_isTracking", true, true];

	[_Group, _WP, _DetectedPlayer, _NearbyHunterRange] spawn {
		params ["_Group", "_WP", "_DetectedPlayer", "_NearbyHunterRange"];
		waitUntil { sleep 5; { _X distance (getWPPos _WP) < 25 } count units _Group > 0 };
		[_Group, getPos _DetectedPlayer, _NearbyHunterRange, 5, [], true, true] call lambs_wp_fnc_taskPatrol;
		_Group setVariable ["OKS_isTracking", false, true];
	};
};