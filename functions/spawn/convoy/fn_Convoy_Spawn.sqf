/*
	Params:
	1 - Object - Spawn Position
	2 - Object - First Waypoint
	3 - Object - Final Waypoint (Where they spread out in the area)
	4 - Side
	5 - Vehicle Array
		1 - Integer - Count of Vehicles
		2 - Array of Classnames or String
		3 - Integer M/S Speed
		4 - Dispersion
	6 - Troop Array
		1 - Bool - Should spawn troop in cargo
		2 - Integer - Max Number of Soldiers per vehicle
	7 - Convoy Array (Array that gets filled with convoy units)
	8 - Should be forced to careless (No reaction from Convoy)
	9 - Should be deleted on reaching final waypoint

	[convoy_1,convoy_2,convoy_3,east,[4,["rhs_btr60_msv"], 6, 25],[true,6],[], false, false] spawn OKS_fnc_Convoy_Spawn;
*/

if(!isServer) exitWith {};

Params [
	["_Spawn",objNull,[objNull]],
	["_Waypoint",objNull,[objNull]],
	["_End",objNull,[objNull]],
	["_Side",east,[sideUnknown]],
	["_VehicleParams",[3,["UK3CB_ARD_O_BMP1"],6,25],[[]]],
	["_CargoParams",[true,4],[[]]],
	["_ConvoyArray",[],[[]]],
	["_ForcedCareless",false,[false]],
	["_DeleteAtFinalWP",false,[false]]
];

Private ["_Vehicles","_Classname"];
private _VehicleArray = [];
private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug",false];
private _NextPreferLeft = true;

_VehicleParams Params ["_Count","_Vehicles","_SpeedKph","_DispersionInMeters"];
_CargoParams Params ["_ShouldHaveCargo","_CargoCount"];
if(isNil "_ConvoyArray") then {
	_ConvoyArray = [];
};

For "_i" from 0 to (_Count - 1) do {
	waitUntil {
		sleep 1;
		if(_ConvoyDebug) then {
			"[CONVOY] Waiting for clearance near _Spawn" spawn OKS_fnc_LogDebug;
		};
		(getPos _Spawn nearEntities ["LandVehicle", _DispersionInMeters]) isEqualTo []
	};
	if(_ConvoyDebug) then {
		"[CONVOY] Spawning Vehicle.." spawn OKS_fnc_LogDebug;
	};

	if(_Vehicles isNotEqualTo []) then {
		_Classname = _Vehicles select 0;
		_Vehicles deleteAt 0;
		if(_ConvoyDebug) then{
			format ["[CONVOY] Vehicle Class: %1 Remaining Vehicles: %2",_Classname,_Vehicles] spawn OKS_fnc_LogDebug;
		}		
	};
	_Vehicle = CreateVehicle [_Classname,getPos _Spawn];
	_Vehicle setVariable ["OKS_ForceSpeedActive", true, true];
	_Vehicle setVariable ["OKS_LimitSpeedBase", _SpeedKph, true];
	_Vehicle setDir (getDir _Spawn);
	_Vehicle setVehicleLock "LOCKED";
	_VehicleArray pushBack _Vehicle;

	private _PreviousVehicle = objNull;
	private _CargoGroup = grpNull;
	if(count _VehicleArray > 1) then {
		_PreviousVehicle = _VehicleArray select (_i - 1);
	};
	[_Vehicle, _PreviousVehicle, _SpeedKph, _DispersionInMeters] spawn OKS_fnc_Convoy_CheckAndAdjustSpeeds;

	// Catch-up booster: if this vehicle falls behind its leader by more than 1.5x dispersion,
	// temporarily uncap speed until within dispersion range again.
	if (!isNull _PreviousVehicle) then {
		[_Vehicle, _PreviousVehicle, _SpeedKph, _DispersionInMeters] spawn {
			params ["_veh","_prev","_baseKph","_disp"];
			private _boosting = false;
			while { alive _veh && {canMove _veh} } do {
				if (isNull _prev || {!alive _prev}) exitWith {};
				private _dist = _veh distance _prev;
				private _thresh = (_disp max 10) * 1.5;
				if (!_boosting && {_dist > _thresh}) then { _boosting = true; };
				if (_boosting && {_dist <= _disp}) then { _boosting = false; };
				if (_boosting) then {
					// Let it run free to catch up
					_veh limitSpeed 999; _veh forceSpeed -1;
				} else {
					// Hand control back to normal speed control
					_veh forceSpeed -1; _veh limitSpeed (_baseKph max 10);
				};
				sleep 0.5;
			};
		};
	};

    _Group = createGroup [_Side,true];
	_CargoGroup = createGroup [_Side,true];
    if(_ConvoyDebug) then {
		format ["[CONVOY] Group: %1 Side: %2",_Group,_Side] spawn OKS_fnc_LogDebug;
	};
	_Group = [_Vehicle,_Side, 0, 0, true] call OKS_fnc_AddVehicleCrew;
    _Vehicle limitSpeed _SpeedKph;
	_NewSpeedMps = _SpeedKph / 3.6;
	_Vehicle forceSpeed _NewSpeedMps;

    _Group setBehaviour "CARELESS"; _Group setCombatMode "BLUE";
    _WP = _Group addWaypoint [getPos _Waypoint,0]; _WP setWaypointType "MOVE";

	private _FirstVehicle = false;
	if(_i == 0) then {
		_FirstVehicle = true;
	};
	private _hbResult = [_End, _FirstVehicle, _NextPreferLeft] call OKS_fnc_Convoy_SetupHerringBone; // returns [posATL, isLeft]
	private _EndPosition = _hbResult select 0;
	private _ActualIsLeft = _hbResult select 1;
	// Alternate side for next vehicle based on actual chosen side (handles obstacle flips)
	_NextPreferLeft = !_ActualIsLeft;

	_EndWP = _Group addWaypoint [_EndPosition,1]; _EndWP setWaypointType "MOVE";

	if(_DeleteAtFinalWP) then {
		_EndWP setWaypointCompletionRadius 200;
		_EndWP setWaypointStatements ["true","{ _unit = this; if(_unit != _X) then {deleteVehicle _X}}foreach crew (vehicle this); deleteVehicle (objectParent this); deleteVehicle (this); "];
	} else {
		_EndWP setWaypointCompletionRadius 2;
		_EndWP setWaypointStatements ["true","{_x setBehaviour 'COMBAT'; _x setCombatMode 'RED';} foreach units this;"];
	};

    if(_ShouldHaveCargo) then {
		_CargoGroup = [_Vehicle, _Side, -1, _CargoCount, true] call OKS_fnc_AddVehicleCrew;
    };
	_CargoGroup setBehaviour "CARELESS"; _CargoGroup setCombatMode "BLUE";
    _ConvoyArray pushBackUnique _Group; _ConvoyArray pushBackUnique _CargoGroup;

	if(_ForcedCareless) then {
		_Vehicle setCaptive true;
		{_X setCaptive true; _X setBehaviour "CARELESS"; _X setCombatMode "BLUE"; } foreach units _Group;
		{_X setCaptive true; _X setBehaviour "CARELESS"; _X setCombatMode "BLUE"; } foreach units _CargoGroup;
		_Vehicle setBehaviour "CARELESS"; _Vehicle setCombatMode "BLUE";
	} else {
		[_Vehicle, _Group, _CargoGroup] spawn OKS_fnc_Convoy_WaitUntilCombat;
	};

	{[_x] remoteExec ["GW_SetDifficulty_fnc_setSkill",0]} foreach units _Group;
	{[_x] remoteExec ["GW_SetDifficulty_fnc_setSkill",0]} foreach units _CargoGroup; 
};

_LeadVehicle = _VehicleArray select 0;
_LeadVehicle setVariable ["OKS_Convoy_VehicleArray", _VehicleArray, true];
// Store a pointer to the lead vehicle on every convoy vehicle for quick access later
{
	_x setVariable ["OKS_Convoy_LeadVehicle", _LeadVehicle, true];
} forEach _VehicleArray;
{
	deleteVehicle _x
} forEach (nearestObjects [_End, ["Land_ClutterCutter_large_F"], 500] select {
	_x getVariable ["GOL_Convoy_Cutter", false]
});
{
	deleteVehicle _X
} foreach [_Spawn, _Waypoint, _End];

[_ConvoyArray] spawn OKS_fnc_Convoy_WaitUntilCasualties;
[_ConvoyArray] spawn OKS_fnc_Convoy_WaitUntilTargets;
// Start monitoring for enemy air targets (AA handler)
[_VehicleArray] spawn OKS_fnc_Convoy_WaitUntilAirTarget;