private _DismountAndRushCode = {
	params ["_Group", "_VehicleObject"];
	_Group leaveVehicle _VehicleObject;
	{
		unassignVehicle _x;
		doGetOut _x;
	} forEach (units _Group);
	[
		_Group,
		1500,
		30,
		[],
		[],
		false
	] spawn lambs_wp_fnc_taskRush;
};

private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug", false];

params ["_VehicleObject", "_CrewGroup", "_CargoGroup"];

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
	(_VehicleObject getVariable ["OKS_Convoy_AAEngaging", false])
	|| ({behaviour _x isEqualTo "COMBAT"} count (units _CrewGroup) > 0)
	|| ({behaviour _x isEqualTo "COMBAT"} count (units _CargoGroup) > 0)
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

_CargoGroup setBehaviour "COMBAT";
_CrewGroup setBehaviour "COMBAT";
_CargoGroup setCombatMode "RED";
_CrewGroup setCombatMode "RED";

if (_ConvoyDebug) then {
	"[CONVOY-AMBUSHD] Halting convoy." spawn OKS_fnc_LogDebug;
};

_VehicleObject forceSpeed 0;
_VehicleObject setFuel 0;
_VehicleObject setVehicleLock "UNLOCKED";
[_CargoGroup, _VehicleObject] spawn _DismountAndRushCode;

private _IsArmedVehicle = (
	(!isNull (gunner _VehicleObject)) || ((_VehicleObject emptyPositions "gunner") > 0)
) || (
	(!isNull (commander _VehicleObject)) || ((_VehicleObject emptyPositions "commander") > 0)
);

if (_IsArmedVehicle) then {
	if (_ConvoyDebug) then {
		"[CONVOY] Vehicle is armed, applying hunt task." spawn OKS_fnc_LogDebug;
	};
	sleep (30 + (random 30));
	_VehicleObject limitSpeed 15;
	_VehicleObject forceSpeed (15 / 3.6);
	_VehicleObject setFuel 1;

	if (_ConvoyDebug) then {
		format [
			"[CONVOY] Hunt applied to %1 in %2 - %3",
			_CrewGroup,
			_VehicleObject,
			[configFile >> "CfgVehicles" >> typeOf _VehicleObject] call BIS_fnc_displayName
		] spawn OKS_fnc_LogDebug;
	};
	[
		_CrewGroup,
		1500,
		60,
		[],
		[],
		false
	] spawn lambs_wp_fnc_taskHunt;
	sleep 5;
	_CrewGroup setBehaviour "AWARE";
} else {
	if (_ConvoyDebug) then {
		"[CONVOY] Vehicle is unarmed, dismount and rush." spawn OKS_fnc_LogDebug;
	};
	[_CrewGroup, _VehicleObject] spawn _DismountAndRushCode;
};