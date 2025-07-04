//	[AI Group, Player, Zone, Update Frequency] Spawn NEKY_Hunt_Hunting;
//
//	This handles updating the AI group with waypoints and information about the one they're hunting.
//
//	Returns: Script_Handle.
//
//	Made by NeKo-ArroW

Params ["_Grp","_Player","_Zone","_UpdateFreq","_Distance","_Number","_Code","_ForceRespawnMultiplier","_Repeat","_WaypointBehaviour"];
Private ["_WP1","_WP2","_WPs"];

if(isNil "_Grp") exitWith {
	systemChat "Exited Hunting. _Grp not defined.";
};

if (_Grp getVariable ["NEKY_Hunt_GroupEnabled",false]) exitWith {}; // Exit if Group is already hunting
_Grp setVariable ["NEKY_Hunt_GroupEnabled",true];

_AI = Units _Grp;
_Leader = Leader _Grp;
_PlayerGrp = Group _Player;
{ deleteWaypoint _x } forEach (Waypoints _Grp);


// Add waypoints that later can be moved around
// Waypoint 300m away from the prey
_WP1 = _Grp addWaypoint [_Leader, 25, 1];

if(!isNull objectParent(Leader _Grp)) then {
	_WP1 setWaypointBehaviour "SAFE";
}
else
{
	_WP1 setWaypointBehaviour "AWARE";
};

if(!isNil "_WaypointBehaviour") then {
	_WP1 setWaypointBehaviour _WaypointBehaviour;
};

// Waypoint at the prey's last updated position
_WP2 = _Grp addWaypoint	[_Leader, 25, 2];
_WP2 setWaypointBehaviour "COMBAT";


// Force Respawn distance
_ForceRespawnDistance = _ForceRespawnMultiplier * _Distance;

While { 
	Alive _Player && 
	({ (Alive _x) &&
	!(Captive _x) } count _AI) != 0 &&
	(Vehicle _Player) in (List _Zone) &&
	!(_Zone getVariable ["NEKY_Hunt_Disabled",false]) &&
	(((getPosATL _Player) select 2) < 6) &&
	((
		{((_Leader distance2D _x) < _ForceRespawnDistance)} count AllPlayers
	) != 0) 
} do {
	// Move waypoint if Prey WP is more than 100m away from prey
	if (((WaypointPosition _WP2) distance2D _Player) > 100) then
	{
		_Leader = Leader _Grp;
		_RelPos = _Player getPos [150, _Player getDir _Leader];
		_WP1 SetWaypointPosition [_RelPos,75];
		if(isNull objectParent(Leader _Grp)) then {
			_WP2 SetWaypointPosition [_Player,75];
			_WPs = [_WP1,_WP2];
		}
		else
		{
			_WP2 SetWaypointPosition [_RelPos,50];
			_WPs = [_WP1,_WP2];
		};
		_WPs Apply {[(WaypointPosition _x) distance2D _Leader]};
		_WPs sort True;
		_Grp setCurrentWaypoint (_WPs select 0);
		_Grp setFormation "WEDGE";
	};

	// Reveal prey and its group.
	if ((_Leader distance2D _Player) < 300) then
	{
		if ((_Grp knowsAbout _Player) < 1.5) then
		{
			{
				_Grp Reveal [_x, 1.5];
			} forEach (Units _PlayerGrp);
		};
	} else {
		{
			if(isNull objectParent(Leader _Grp)) then {
				_Grp Reveal [_x, 0.1];
			};
		} forEach (Units _PlayerGrp);
	};
	Sleep _UpdateFreq;
};

_Grp setVariable ["NEKY_Hunt_GroupEnabled",False];

// Delete group if no players within Force Respawn Distance
_Leader = Leader _Grp;
if ( {(_Leader distance2D _x) >= _ForceRespawnDistance} count AllPlayers != 0 ) then
{
	{ if !(Captive _x) then {deleteVehicle _x} } forEach (Units _Grp);
	_Repeat = _Repeat +1; // Restore loop for "relocating" the hunting team
	Sleep 1;
};

// Repeat or Terminate if AI group is dead or captured
if (({ (Alive _x) && !(Captive _x) } count _AI) == 0) exitWith
{
	if (_Repeat > 0) then
	{
		_Repeat = _Repeat -1;
		[(Side _Grp), _Number, _Zone, _Distance, _UpdateFreq, _Repeat, _Code] spawn OKS_fnc_HuntRun;
	} else {
		False;
	};
};
// Select a new prey and continue hunting
[_Grp, _Number, _Zone, _Distance, _UpdateFreq, _Repeat, _Code] spawn OKS_fnc_HuntRun;