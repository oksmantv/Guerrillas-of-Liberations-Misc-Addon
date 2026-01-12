/*
	OKS_fnc_DroneJammer_Init

	Initializes jammer carrier with proximity detection and alert system.
	Called via ACE Equipment action when player activates the jammer.

	Parameters:
		_jammerCarrier - Unit carrying the jammer

	Returns:
		Nothing

	Example:
		[player] call OKS_fnc_DroneJammer_Init;
*/

params [
	["_jammerCarrier", objNull, [objNull]]
];

if (isNull _jammerCarrier) exitWith {};

// Prevent double initialization
if (_jammerCarrier getVariable ["OKS_JammerActive", false]) exitWith {
	systemChat "Jammer already active!";
};

// Prevent multiple jammers in same vehicle
private _jammerVehicle = vehicle _jammerCarrier;
if (_jammerVehicle getVariable ["OKS_VehicleJammerActive", false]) exitWith {
	systemChat "Another jammer is already active in this vehicle!";
};

_jammerCarrier setVariable ["OKS_JammerActive", true];
_jammerVehicle setVariable ["OKS_VehicleJammerActive", true];
_jammerCarrier setVariable ["OKS_JammerVehicle", _jammerVehicle];
_jammerCarrier setVariable ["OKS_JammerActivationTime", diag_tickTime];

systemChat "Drone jammer activated";

private _scriptHandle = _jammerCarrier spawn {
	params ["_jammerCarrier"];
	// Use CBA settings for ranges
	private _baseDetectionRange = missionNamespace getVariable ["GOL_Detector_BaseRange", 500];
	private _vehicleDetectionRange = _baseDetectionRange * 2;
	private _jamEffectRange = missionNamespace getVariable ["GOL_Jammer_EffectRange", 350];
	private _checkInterval = 1;

	// Track which drones we've already alerted for
	private _trackedDrones = [];
	private _activeJamDrones = [];

	// Suspension state tracking
	private _isSuspended = false;
	private _wasSuspended = false;

	// Initialize visual HUD (silent operation, visual feedback only)
	if (hasInterface && player == _jammerCarrier) then {
		[_jammerCarrier, "inactive", 0, 0] call OKS_fnc_DroneJammer_UpdateHUD;
	};

	// Simple exit: alive + active variable (ACE action controls the variable)
	while {alive _jammerCarrier && {_jammerCarrier getVariable ["OKS_JammerActive", false]}} do {

		// Check if in vehicle with other active jammers (priority system)
		private _currentVehicle = vehicle _jammerCarrier;
		private _inVehicle = (_currentVehicle != _jammerCarrier);
		
		if (_inVehicle) then {
			private _myActivationTime = _jammerCarrier getVariable ["OKS_JammerActivationTime", 999999];
			private _crewMembers = crew _currentVehicle;
			private _otherActiveJammers = _crewMembers select {
				_x != _jammerCarrier
				&& {_x getVariable ["OKS_JammerActive", false]}
				&& {(_x getVariable ["OKS_JammerActivationTime", 999999]) < _myActivationTime}
			};
			
			_isSuspended = (count _otherActiveJammers > 0);
		} else {
			_isSuspended = false;
		};

		// Log state changes (once per transition)
		if (_isSuspended && !_wasSuspended) then {
			private _masterDebug = missionNamespace getVariable ["GOL_Drones_MasterDebug", false];
			private _jammerDebug = missionNamespace getVariable ["GOL_Jammer_Debug", false];
			if (_masterDebug && _jammerDebug) then {
				"[JAMMER] Suspended | higher priority active" spawn OKS_fnc_LogDebug;
			};
			// Update HUD to show inactive state
			if (hasInterface && player == _jammerCarrier) then {
				[_jammerCarrier, "inactive", 0, 0] call OKS_fnc_DroneJammer_UpdateHUD;
			};
			_wasSuspended = true;
		} else {
			if (!_isSuspended && _wasSuspended) then {
				// Resume: reclaim vehicle lock if in vehicle
				if (_inVehicle) then {
					_currentVehicle setVariable ["OKS_VehicleJammerActive", true];
					_jammerCarrier setVariable ["OKS_JammerVehicle", _currentVehicle];
				};
				
				private _masterDebug = missionNamespace getVariable ["GOL_Drones_MasterDebug", false];
				private _jammerDebug = missionNamespace getVariable ["GOL_Jammer_Debug", false];
				if (_masterDebug && _jammerDebug) then {
					"[JAMMER] Resumed | priority regained" spawn OKS_fnc_LogDebug;
				};
				_wasSuspended = false;
			};
		};

		// Skip operations if suspended
		if (_isSuspended) then {
			sleep _checkInterval;
		} else {
			// Extended range when in vehicle
			private _detectionRange = if (_inVehicle) then {_vehicleDetectionRange} else {_baseDetectionRange};

			// FPV drones inherit from Helicopter_Base_F, not UAV, so use "Air" and filter
			private _nearAircraft = (getPosATL _jammerCarrier) nearEntities [["Air"], _detectionRange];
			private _nearDrones = _nearAircraft select {
				_x isKindOf "UAV" || {typeOf _x find "UAFPV" >= 0}
			};

			// Get crew for local sound playback
			private _crewMembers = crew _currentVehicle;

			// Track drones silently (jammer is passive EW, visual feedback only)
			{
				if (!(_x in _trackedDrones) && {alive _x}) then {
					_trackedDrones pushBack _x;
					private _distance = round(_jammerCarrier distance _x);
					private _masterDebug = missionNamespace getVariable ["GOL_Drones_MasterDebug", false];
					private _jammerDebug = missionNamespace getVariable ["GOL_Jammer_Debug", false];
					if (_masterDebug && _jammerDebug) then {
						format ["[JAMMER] Drone entered detection range | distance=%1m", _distance] spawn OKS_fnc_LogDebug;
					};
				};
			} forEach _nearDrones;

			// Track active jamming drones (terminal phase in fn_DroneHuntZone_Terminal handles actual jamming effect)
			private _currentJamDrones = _nearDrones select {_jammerCarrier distance _x <= _jamEffectRange};
			{
				if (!(_x in _activeJamDrones) && {alive _x}) then {
					_activeJamDrones pushBack _x;
					private _distance = round(_jammerCarrier distance _x);
					private _masterDebug = missionNamespace getVariable ["GOL_Drones_MasterDebug", false];
					private _jammerDebug = missionNamespace getVariable ["GOL_Jammer_Debug", false];
					if (_masterDebug && _jammerDebug) then {
						format ["[JAMMER] Drone entered jam range | distance=%1m | will degrade terminal guidance", _distance] spawn OKS_fnc_LogDebug;
					};
				};
			} forEach _currentJamDrones;

			// Update visual HUD
			if (hasInterface && player == _jammerCarrier) then {
				private _status = if (count _currentJamDrones == 0) then {
					if (count _nearDrones > 0) then {"detecting"} else {"inactive"}
				} else {
					if (count _currentJamDrones >= 3) then {"jamming_multiple"} else {"jamming"}
				};
				private _nearestDist = if (count _currentJamDrones > 0) then {
					private _nearest = _currentJamDrones select 0;
					{if ((_jammerCarrier distance _x) < (_jammerCarrier distance _nearest)) then {_nearest = _x}} forEach _currentJamDrones;
					_jammerCarrier distance _nearest
				} else {0};
				[_jammerCarrier, _status, count _currentJamDrones, _nearestDist] call OKS_fnc_DroneJammer_UpdateHUD;
			};

			// Cleanup tracking for dead/distant drones
			_trackedDrones = _trackedDrones select {alive _x && {_jammerCarrier distance _x < _detectionRange + 100}};
			_activeJamDrones = _activeJamDrones select {alive _x && {_jammerCarrier distance _x < _jamEffectRange + 50}};

			sleep _checkInterval;
		};
	};

	// Auto-cleanup when loop exits (death or deactivation)
	private _masterDebug = missionNamespace getVariable ["GOL_Drones_MasterDebug", false];
	private _jammerDebug = missionNamespace getVariable ["GOL_Jammer_Debug", false];
	if (_masterDebug && _jammerDebug) then {
		"[JAMMER] Loop exited | carrier dead or manually deactivated" spawn OKS_fnc_LogDebug;
	};
	[_jammerCarrier, false] call OKS_fnc_DroneJammer_Cleanup;
};

_jammerCarrier setVariable ["OKS_JammerHandle", _scriptHandle];
