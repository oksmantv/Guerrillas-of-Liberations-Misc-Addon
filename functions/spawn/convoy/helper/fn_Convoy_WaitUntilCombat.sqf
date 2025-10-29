// Now using OKS_fnc_Convoy_DismountAndTaskCode

private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug", false];

params ["_VehicleObject", "_CrewGroup", ["_CargoGroup", grpNull, [grpNull]], ["_DismountType", "rush",[""]], ["_WasAmbushed", false, [false]]];

// Early-out guard: if this vehicle is currently handling AA engagement, skip ambush logic entirely
if (_VehicleObject getVariable ["OKS_Convoy_AAEngaging", false]) exitWith {
	if (_ConvoyDebug) then {
		format [
			"[CONVOY-AMBSKIP-AA] %1",
			_VehicleObject
		] spawn OKS_fnc_LogDebug;
	};
};

waitUntil {
	sleep 0.5;
	_ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug", false];
	
	// Check if this specific vehicle reached its destination individually
	private _individualArrival = _VehicleObject getVariable ["OKS_Convoy_IndividualArrival", false];
	
	// Only trigger on: AA engagement, individual arrival, or combat from ambush (not other vehicles' arrivals)
	(_VehicleObject getVariable ["OKS_Convoy_AAEngaging", false])
	|| _individualArrival
	|| (({behaviour _x isEqualTo "COMBAT"} count (units _CrewGroup) > 0) && !_individualArrival && (_VehicleObject getVariable ["GOL_ConvoyAmbushed", false]))
	|| ((!isNull _CargoGroup) && ({behaviour _x isEqualTo "COMBAT"} count (units _CargoGroup) > 0) && !_individualArrival && (_VehicleObject getVariable ["GOL_ConvoyAmbushed", false]))
};

// If AA engagement kicked in while waiting, abort safely
if (_VehicleObject getVariable ["OKS_Convoy_AAEngaging", false]) exitWith {
	if (_ConvoyDebug) then {
		format [
			"[CONVOY-AMBABORT-AA] %1",
			_VehicleObject
		] spawn OKS_fnc_LogDebug;
	};
};

_VehicleObject setVariable ["OKS_Convoy_Stopped", true, true];

if (!isNull _CargoGroup) then {
	_CargoGroup setBehaviour "COMBAT";
	_CargoGroup setCombatMode "RED";
};
_CrewGroup setBehaviour "COMBAT";
_CrewGroup setCombatMode "RED";

if (_ConvoyDebug) then {
	if (_IndividualArrival) then {
		format ["[CONVOY-INDIVIDUAL-DEPLOY] %1 reached its herringbone position, deploying individually.", _VehicleObject] spawn OKS_fnc_LogDebug;
	} else {
		format ["[CONVOY-AMBUSHED] %1 halting convoy due to combat.", _VehicleObject] spawn OKS_fnc_LogDebug;
	};
};
_WasAmbushed = _VehicleObject getVariable ["GOL_ConvoyAmbushed", false];
_IndividualArrival = _VehicleObject getVariable ["OKS_Convoy_IndividualArrival", false];

// Only delete waypoints if ambushed, not if individually arrived at destination
if(_WasAmbushed && !_IndividualArrival) then {
	[_CrewGroup] call OKS_fnc_Convoy_DeleteAllWaypoints;
	[_CargoGroup] call OKS_fnc_Convoy_DeleteAllWaypoints;

	_pullOffPos = [_VehicleObject, [10, 8], "AWARE", "YELLOW", true, []] call OKS_fnc_Convoy_PullOffHelper;
	if(isNil "_pullOffPos") then {
		_pullOffPos = getPos _VehicleObject
	};
	_time = time;
	waitUntil{
		sleep 1;
		_ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug", false];
		(_VehicleObject distance2D _pullOffPos) < 10 || ((time - _time) > 6)
	};
};

sleep 2;
_VehicleObject forceSpeed 5;
_VehicleObject setVehicleLock "UNLOCKED";
if (!isNull _CargoGroup) then {
	if (_ConvoyDebug) then {
		format["[CONVOY] %1 has cargo. Deploying troops.",[configFile >> "CfgVehicles" >> typeOf _VehicleObject] call BIS_fnc_displayName] spawn OKS_fnc_LogDebug;
	};	
	[_CargoGroup, _VehicleObject, _DismountType, true, _WasAmbushed] spawn OKS_fnc_Convoy_DismountAndTaskCode;
};

private _IsArmedVehicle = (
	(!isNull (gunner _VehicleObject)) || ((_VehicleObject emptyPositions "gunner") > 0)
) || (
	(!isNull (commander _VehicleObject)) || ((_VehicleObject emptyPositions "commander") > 0)
);
private _isArtilleryVehicle = {
	[_X, typeOf _VehicleObject] call BIS_fnc_inString;
} count ["mortar","prp3"] > 0;

if(_isArtilleryVehicle) exitWith {
	if (_ConvoyDebug) then {
		format["[CONVOY] %1 is a mortar, setting up for mortar task.",[configFile >> "CfgVehicles" >> typeOf _VehicleObject] call BIS_fnc_displayName] spawn OKS_fnc_LogDebug;
	};	
	[_VehicleObject, side (group gunner _vehicleObject), "precise", "light", ["auto", 75], 150, 1000, 30] spawn OKS_fnc_Mortars;
};

if (_IsArmedVehicle) exitWith {
	if (_ConvoyDebug) then {
		format["[CONVOY] %1 is armed, setting up for task.",[configFile >> "CfgVehicles" >> typeOf _VehicleObject] call BIS_fnc_displayName] spawn OKS_fnc_LogDebug;
	};
	sleep (15 + (random 15));
	_VehicleObject limitSpeed 13;
	_VehicleObject forceSpeed (13 / 3.6);

	if (_ConvoyDebug) then {
		format [
			"[CONVOY] %4 task applied to %1 in %2 - %3",
			_CrewGroup,
			_VehicleObject,
			[configFile >> "CfgVehicles" >> typeOf _VehicleObject] call BIS_fnc_displayName,
			_DismountType
		] spawn OKS_fnc_LogDebug;
	};
	[_CrewGroup, _VehicleObject, _DismountType, false, _WasAmbushed] spawn OKS_fnc_Convoy_DismountAndTaskCode;
	sleep 5;
	_CrewGroup setBehaviour "AWARE";
};

if (_ConvoyDebug) then {
	format["[CONVOY] %1 is unarmed, dismount and engage.",[configFile >> "CfgVehicles" >> typeOf _VehicleObject] call BIS_fnc_displayName] spawn OKS_fnc_LogDebug;
};
[_CrewGroup, _VehicleObject, _DismountType, true, _WasAmbushed] spawn OKS_fnc_Convoy_DismountAndTaskCode;
