/*
	OKS_fnc_DroneDetector_Init
	
	Initializes detector carrier with proximity detection and alert system.
	Detector only provides alerts - NO jamming functionality.
	Called via ACE Equipment action when player activates the detector.
	
	Parameters:
	_detectorCarrier - Unit carrying the detector
	
	Returns:
	Nothing
	
	Example:
	[player] call OKS_fnc_DroneDetector_Init;
*/

params [
	["_detectorCarrier", objNull, [objNull]]
];

if (isNull _detectorCarrier) exitWith {};

// Prevent double initialization
if (_detectorCarrier getVariable ["OKS_DetectorActive", false]) exitWith {
	systemChat "Detector already active!";
};

_detectorCarrier setVariable ["OKS_DetectorActive", true];
_detectorCarrier setVariable ["OKS_DetectorActivationTime", diag_tickTime];
systemChat "Drone detector activated";

private _scriptHandle = _detectorCarrier spawn {
	params ["_detectorCarrier"];
	// Use CBA settings for ranges
	private _baseDetectionRange = missionNamespace getVariable ["GOL_Detector_BaseRange", 500];
	private _vehicleDetectionRange = _baseDetectionRange * 2;
	private _checkInterval = 0.1;  // Fast loop for responsive beeping

	// Track which drones we've already alerted for
	private _trackedDrones = [];

	// Simple exit: alive + active variable (ACE action controls the variable)
	while {
		alive _detectorCarrier && {
			_detectorCarrier getVariable ["OKS_DetectorActive", false]
		}
	} do {
		// Check if in vehicle
		private _currentVehicle = vehicle _detectorCarrier;
		private _inVehicle = (_currentVehicle != _detectorCarrier);
		
		// Get crew members for sound/hint playback
		private _crewMembers = if (_inVehicle) then {
			crew _currentVehicle
		} else {
			[_detectorCarrier]
		};

		// Extended range when in vehicle
		private _detectionRange = if (_inVehicle) then {
			_vehicleDetectionRange
		} else {
			_baseDetectionRange
		};

		// FPV drones inherit from Helicopter_Base_F, not UAV, so use "Air" and filter
		private _nearAircraft = (getPosATL _detectorCarrier) nearEntities [["Air"], _detectionRange];
		private _carrierSide = side group _detectorCarrier;
		private _nearDrones = _nearAircraft select {
			(_x isKindOf "UAV" || {typeOf _x find "UAFPV" >= 0}) && {
				side group _x getFriend _carrierSide < 0.6  // Only detect hostile/unknown drones
			}
		};

		// Debug: Log what we're finding
		private _masterDebug = missionNamespace getVariable ["GOL_Drones_MasterDebug", false];
		private _detectorDebug = missionNamespace getVariable ["GOL_Detector_Debug", false];
		if (_masterDebug && _detectorDebug && {count _nearDrones > 0}) then {
			format ["[DETECTOR] nearEntities found %1 drones | types: %2", count _nearDrones, _nearDrones apply {typeOf _x}] spawn OKS_fnc_LogDebug;
		};

		// Track new drones for hint updates
		{
			if (!(_x in _trackedDrones) && {alive _x}) then {
				_trackedDrones pushBack _x;
				private _distance = round(_detectorCarrier distance _x);
				systemChat format ["[DETECTOR] New drone detected at %1m", _distance];
			};
		} forEach _nearDrones;

		// Proximity-based burst beeps (steady rate increasing with proximity)
		// More granular levels for definitive audio cues
		if (count _nearDrones > 0) then {
			// Find closest drone
			private _closestDrone = _nearDrones select 0;
			private _closestDistance = _detectorCarrier distance _closestDrone;
			{
				private _dist = _detectorCarrier distance _x;
				if (_dist < _closestDistance) then {
					_closestDrone = _x;
					_closestDistance = _dist;
				};
			} forEach _nearDrones;

			// Calculate burst interval with more granular levels (8 distinct audio cues)
			private _burstInterval = switch (true) do {
				case (_closestDistance > 500): {3.0};   // Very distant - slow pulse
				case (_closestDistance > 400): {2.0};   // Distant
				case (_closestDistance > 300): {1.2};   // Approaching
				case (_closestDistance > 200): {0.8};   // Getting closer
				case (_closestDistance > 150): {0.5};   // Close
				case (_closestDistance > 100): {0.3};   // Very close
				case (_closestDistance > 50): {0.15};   // Danger close - rapid
				default {0};                             // Immediate - continuous
			};

			// Check if it's time for next burst (or continuous mode)
			private _timeSinceLastBurst = _detectorCarrier getVariable ["OKS_DetectorLastBurst", -999];
			if (_burstInterval == 0 || {diag_tickTime - _timeSinceLastBurst >= _burstInterval}) then {
				_detectorCarrier setVariable ["OKS_DetectorLastBurst", diag_tickTime];
				
				// Debug: Log beep with distance and interval
				private _masterDebug = missionNamespace getVariable ["GOL_Drones_MasterDebug", false];
				private _detectorDebug = missionNamespace getVariable ["GOL_Detector_Debug", false];
				if (_masterDebug && _detectorDebug) then {
					format ["[DETECTOR] Beep | distance=%1m interval=%2s", round(_closestDistance), _burstInterval] spawn OKS_fnc_LogDebug;
				};
				
				// Play single beep for all crew - frequency increases with proximity
				{
					playSound3D ["\rhsusf\addons\rhsusf_uav\sounds\watchBeep_single.ogg", _x, false, getPosASL _x, 0.5, 1, 25];
				} forEach _crewMembers;
			};
		};

		// Update distance/direction for tracked drones every 5 seconds
		if (diag_tickTime % 5 < _checkInterval) then {
			{
				if (alive _x && {
					_detectorCarrier distance _x <= _detectionRange
				}) then {
					private _distance = round(_detectorCarrier distance _x);
					private _direction = [_detectorCarrier, _x] call BIS_fnc_dirTo;
					private _directionText = [_direction] call OKS_fnc_DirectionToText;

					// Update hint for crew
					{
						[format ["Tracking drone: %1m %2", _distance, _directionText], 3] remoteExec ["hintSilent", _x];
					} forEach _crewMembers;
				};
			} forEach _trackedDrones;
		};

		// Cleanup tracking for dead/distant drones
		_trackedDrones = _trackedDrones select {
			alive _x && {
				_detectorCarrier distance _x < _detectionRange + 100
			}
		};

		sleep _checkInterval;
	};

	// Auto-cleanup when loop exits (death or deactivation)
	private _masterDebug = missionNamespace getVariable ["GOL_Drones_MasterDebug", false];
	private _detectorDebug = missionNamespace getVariable ["GOL_Detector_Debug", false];
	if (_masterDebug && _detectorDebug) then {
		"[DETECTOR] Loop exited | carrier dead or manually deactivated" spawn OKS_fnc_LogDebug;
	};
	[_detectorCarrier] call OKS_fnc_DroneDetector_Cleanup;
};

_detectorCarrier setVariable ["OKS_DetectorHandle", _scriptHandle];