/*
	OKS_fnc_DroneDetector_Cleanup
	
	Deactivates detector and cleans up tracking variables.
	Called automatically when detector carrier dies or via ACE action.
	
	Parameters:
	_detectorCarrier - Unit carrying the detector
	
	Returns:
	Nothing
	
	Example:
	[player] call OKS_fnc_DroneDetector_Cleanup;
*/

params [
	["_detectorCarrier", objNull, [objNull]]
];

if (isNull _detectorCarrier) exitWith {};

// Only cleanup if actually active
if !(_detectorCarrier getVariable ["OKS_DetectorActive", false]) exitWith {};

_detectorCarrier setVariable ["OKS_DetectorActive", false];
_detectorCarrier setVariable ["OKS_DetectorHandle", nil];
_detectorCarrier setVariable ["OKS_DetectorActivationTime", nil];

systemChat "Drone detector deactivated";

private _detectorDebug = missionNamespace getVariable ["GOL_Detector_Debug", false];
if (_detectorDebug) then {
	"[DETECTOR] Cleanup complete" spawn OKS_fnc_LogDebug;
};