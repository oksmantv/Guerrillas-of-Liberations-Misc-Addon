/*
	OKS_fnc_DroneJammer_Cleanup

	Stops jammer monitoring loop and cleans up variables.
	Called automatically when jammer is deactivated or carrier dies.

	Parameters:
		_jammerCarrier - Unit carrying the jammer

	Returns:
		Nothing

	Example:
		[player] call OKS_fnc_DroneJammer_Cleanup;
*/

params [
	["_jammerCarrier", objNull, [objNull]],
	["_isManualDeactivation", true, [true]]
];

if (isNull _jammerCarrier) exitWith {};

private _scriptHandle = _jammerCarrier getVariable ["OKS_JammerHandle", scriptNull];
if (!isNull _scriptHandle && _isManualDeactivation) then {
	terminate _scriptHandle;
};

// Clear vehicle jammer state
private _jammerVehicle = _jammerCarrier getVariable ["OKS_JammerVehicle", objNull];
if (!isNull _jammerVehicle) then {
	_jammerVehicle setVariable ["OKS_VehicleJammerActive", false];
};

_jammerCarrier setVariable ["OKS_JammerHandle", nil];
_jammerCarrier setVariable ["OKS_JammerActive", false];
_jammerCarrier setVariable ["OKS_JammerActivationTime", nil];
_jammerCarrier setVariable ["OKS_JammerVehicle", nil];

// Hide visual HUD (RscTitle)
if (hasInterface && player == _jammerCarrier) then {
	"OKS_JammerHUD" cutText ["", "PLAIN"];
	uiNamespace setVariable ["OKS_JammerHUD_Display", nil];
};

if (_isManualDeactivation) then {
	systemChat "Drone jammer deactivated";
} else {
	private _masterDebug = missionNamespace getVariable ["GOL_Drones_MasterDebug", false];
	private _jammerDebug = missionNamespace getVariable ["GOL_Jammer_Debug", false];
	if (_masterDebug && _jammerDebug) then {
		"[JAMMER] Auto-cleanup | carrier dead" spawn OKS_fnc_LogDebug;
	};
};
