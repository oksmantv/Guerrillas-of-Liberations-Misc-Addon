/*
	Function: OKS_fnc_Stealth_Hunted
	
	Description:
		Creates a tracking system for player groups that leaves physical "footprint" 
		objects as they move through the map. AI tracker groups can follow these trails.
	
	Parameter(s):
		0: GROUP - The player group to track
		1: OBJECT (Optional) - Trigger area to limit tracking zone
	
	Returns:
		Nothing
	
	Example:
		[group player] spawn OKS_fnc_Stealth_Hunted;
		[group player, Trigger_1] spawn OKS_fnc_Stealth_Hunted;
*/

params [
	["_HuntedGroup", grpNull, [grpNull]],
	["_HuntedTriggerArea", nil, [objNull]]
];

private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];

OKS_HuntedGroups pushBackUnique _HuntedGroup;
publicVariable "OKS_HuntedGroups";

if (_debug) then {
	format ["[STEALTH] Started tracking player group %1", groupId _HuntedGroup] spawn OKS_fnc_LogDebug;
};

private _debugMessages = _debug;
private _debugObject = false;

private ["_TrackObject", "_OriginBasePosition", "_TracksArray", "_PlayerWithMostNearestPlayers", "_PlayerWithMostNearestPlayersList", "_Condition"];
_OriginBasePosition = getMarkerPos format["respawn_%1", side _HuntedGroup];

if (_OriginBasePosition isEqualTo [0,0,0]) exitWith {
	diag_log format["OKS Stealth: Hunted script failed to find respawn_%1 marker. Exiting..", side _HuntedGroup];
};

_TracksArray = [];

if (_debugObject) then {
	_TrackObject = "Sign_Arrow_Green_F";
} else {
	_TrackObject = "Land_ClutterCutter_small_F";
};

_Condition = {{(alive _x || [_x] call ace_common_fnc_isAwake)} count units _HuntedGroup > 0};
if (!isNil "_HuntedTriggerArea") then {
	_Condition = {{(alive _x || [_x] call ace_common_fnc_isAwake) && _x inArea _HuntedTriggerArea} count units _HuntedGroup > 0}
};

while _Condition do {
	if (_debugMessages) then { diag_log "OKS Stealth: Track loop start." };
	
	_PlayerWithMostNearestPlayersList = 
	([
		units _HuntedGroup,
		[],
		{
			count (_x nearEntities ["Man", 20] select {isPlayer _x})
		}, "DESCEND"
	] call BIS_fnc_sortBy)
	select {
		_Player = _x;
		_x distance _OriginBasePosition > 10 && {_Player distance _x < 10} count _TracksArray == 0
	};

	if (count _PlayerWithMostNearestPlayersList > 0) then {		
		_PlayerWithMostNearestPlayers = _PlayerWithMostNearestPlayersList select 0;	
		if (_debugMessages) then { diag_log format["OKS Stealth: %1 matched filter. Will create track.", name _PlayerWithMostNearestPlayers] };
	} else {
		if (_debugMessages) then { diag_log "OKS Stealth: No players matched filter. Will not create track." };
		sleep 5;
		continue;
	};	

	_track = createVehicle [_TrackObject, getPosATL _PlayerWithMostNearestPlayers, [], 0, "CAN_COLLIDE"];
	_track setVariable ["OKS_isTrack", true, true];
	
	[_HuntedGroup, _track, _TracksArray] spawn {
		params ["_HuntedGroup", "_track"];

		sleep 300;
		_TracksArray = _HuntedGroup getVariable ["OKS_GroupTracks", []];
		_TracksArray deleteAt (_TracksArray find _track);
		_HuntedGroup setVariable ["OKS_GroupTracks", _TracksArray, true];
		deleteVehicle _track;
	};
	
	_TracksArray = _HuntedGroup getVariable ["OKS_GroupTracks", []];
	_TracksArray pushBackUnique _track;

	_NullTracks = [];
	{
		if (isNull _x) then {
			_NullTracks pushBackUnique _x;		
		}
	} forEach _TracksArray;
	{
		_TracksArray deleteAt (_TracksArray find _x);
	} forEach _NullTracks;
	
	_HuntedGroup setVariable ["OKS_GroupTracks", _TracksArray, true];
	if (_debugMessages) then { diag_log format["OKS Stealth: Created track at %1", getPosATL _PlayerWithMostNearestPlayers] };

	waitUntil {sleep 2; {_PlayerWithMostNearestPlayers distance _x < 10} count _TracksArray == 0};
	if (_debugMessages) then { diag_log "OKS Stealth: WaitUntil bypassed. Looping." };
};

sleep 30;
[_HuntedGroup, _HuntedTriggerArea] spawn OKS_fnc_Stealth_Hunted;
