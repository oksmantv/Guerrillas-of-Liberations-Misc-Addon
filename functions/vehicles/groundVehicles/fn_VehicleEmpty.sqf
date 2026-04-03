if(!isServer) exitWith {};

// Early exit if VehicleEmpty feature is disabled
private _VehicleEmptyEnabled = missionNamespace getVariable ["GOL_VehicleEmpty_Enabled", false];
if (!_VehicleEmptyEnabled) exitWith {
	format["[VEHICLEMPTY] Feature disabled via CBA settings, exiting"] call OKS_fnc_LogDebug;
};

params [
	["_Vehicle", objNull, [objNull]],
	["_Side", missionNameSpace getVariable ["GOL_Friendly_Side", (side group player)], [sideUnknown]]
];
private _originPosition = getPosATL _Vehicle;
private _SetupTarget = {
	params ["_Vehicle","_Side"];

	private _invisibleGroup = createGroup _Side;
	private _className = "";
	switch (_Side) do {
		case west: { _className = "B_Soldier_F"; };
		case east: { _className = "O_Soldier_F"; };
		case independent: { _className = "I_Soldier_F"; };
		default { 
			_className = "B_Soldier_F";
		};
	};
	_VehicleDisplayName = getText (configFile >> "CfgVehicles" >> typeOf _Vehicle >> "displayName");
	_InvisibleSoldier = _invisibleGroup createUnit [_className, getPosATL _Vehicle, [], 0, "NONE"];
	_invisibleGroup setGroupIdGlobal [_VehicleDisplayName];
	
	// Prevent unit from exiting vehicle or moving
	_InvisibleSoldier allowDamage false;
	_InvisibleSoldier hideObjectGlobal true;
	_InvisibleSoldier disableAI "ALL";
	_InvisibleSoldier disableAI "MOVE";
	_InvisibleSoldier disableAI "AUTOTARGET";
	_InvisibleSoldier disableAI "TARGET";
	_InvisibleSoldier disableAI "FSM";
	_InvisibleSoldier disableAI "PATH";
	_InvisibleSoldier setBehaviour "CARELESS";
	_InvisibleSoldier setCombatMode "BLUE";
	_InvisibleSoldier setUnitPos "DOWN";
	
	// DO NOT disable simulation - AI needs to detect this unit to target the vehicle!
	// _InvisibleSoldier enableSimulation false;  // This would make AI ignore them
	
	// Additional hiding - make unit fully invisible
	_InvisibleSoldier setVariable ["BIS_enableRandomization", false];
	_InvisibleSoldier setSpeaker "NoVoice";
	_InvisibleSoldier disableConversation true;
	_InvisibleSoldier setIdentity "Default";
	
	// Remove all gear to reduce visibility
	removeAllWeapons _InvisibleSoldier;
	removeAllItems _InvisibleSoldier;
	removeAllAssignedItems _InvisibleSoldier;
	removeUniform _InvisibleSoldier;
	removeVest _InvisibleSoldier;
	removeBackpack _InvisibleSoldier;
	removeHeadgear _InvisibleSoldier;
	removeGoggles _InvisibleSoldier;
	
	// Move into vehicle and lock them in
	_InvisibleSoldier moveInDriver _Vehicle;
	_Vehicle lockDriver true;
	
	// Re-hide after getting in vehicle (hideObject can be reset by vehicle entry)
	_InvisibleSoldier hideObjectGlobal true;
	
	// Add event handler to force unit back in if somehow ejected
	private _ehIndex = _InvisibleSoldier addEventHandler ["GetOutMan", {
		params ["_unit", "_role", "_vehicle", "_turret"];
		// Force them back in immediately
		_unit moveInDriver _vehicle;
		_unit hideObjectGlobal true;  // Re-hide after any exit attempt
		format["[VEHICLEMPTY] WARNING: Unit attempted to exit vehicle %1, forcing back in", _vehicle] call OKS_fnc_LogDebug;
	}];
	
	// Continuous hide monitor to ensure unit stays hidden
	private _hideMonitor = [_InvisibleSoldier, _Vehicle] spawn {
		params ["_unit", "_vehicle"];
		while {!isNull _unit && alive _unit && !isNull _vehicle} do {
			if (!isObjectHidden _unit) then {
				_unit hideObjectGlobal true;
				format["[VEHICLEMPTY] Re-hiding unit in vehicle: %1", _vehicle] call OKS_fnc_LogDebug;
			};
			// Jittered interval reduces synchronized spikes when many vehicles are monitored
			sleep (8 + random 4);
		};
	};
	
	// Store reference and mark as occupied
	_Vehicle setVariable ["GOL_InvisibleTarget", _InvisibleSoldier, true];
	_Vehicle setVariable ["GOL_VehicleEmpty_Active", true, true];
	_Vehicle setVariable ["GOL_InvisibleTarget_EH", _ehIndex, true];
	_Vehicle setVariable ["GOL_InvisibleTarget_HideMonitor", _hideMonitor, true];

	format["[VEHICLEMPTY] Side %1 - Classname %2", _Side, _className] call OKS_fnc_LogDebug;
	format["[VEHICLEMPTY] Target on %1 - %2", _Vehicle, _VehicleDisplayName] call OKS_fnc_LogDebug;
};
private _ClearTarget = {
	params ["_Vehicle","_Side"];

	_InvisibleSoldier = _Vehicle getVariable ["GOL_InvisibleTarget", objNull];
	if(!isNull _InvisibleSoldier) then {
		// Remove event handler before cleanup
		private _ehIndex = _Vehicle getVariable ["GOL_InvisibleTarget_EH", -1];
		if (_ehIndex >= 0) then {
			_InvisibleSoldier removeEventHandler ["GetOutMan", _ehIndex];
		};
		
		// Terminate hide monitor
		private _hideMonitor = _Vehicle getVariable ["GOL_InvisibleTarget_HideMonitor", scriptNull];
		if (!isNull _hideMonitor) then {
			terminate _hideMonitor;
		};
		
		deleteVehicle _InvisibleSoldier;
	} else {
		format["[VEHICLEMPTY] WARNING: Invisible soldier was already null for vehicle: %1 — forcing cleanup", _Vehicle] call OKS_fnc_LogDebug;
	};

	// Always unlock and reset state, even if invisible soldier was externally deleted
	_Vehicle lockDriver false;
	_Vehicle setVariable ["GOL_InvisibleTarget", nil, true];
	_Vehicle setVariable ["GOL_VehicleEmpty_Active", false, true];
	_Vehicle setVariable ["GOL_InvisibleTarget_EH", nil, true];
	_Vehicle setVariable ["GOL_InvisibleTarget_HideMonitor", nil, true];
	format["[VEHICLEMPTY] Cleared target for vehicle: %1", _Vehicle] call OKS_fnc_LogDebug;
};

// Wait until vehicle has moved from spawn or is destroyed
waitUntil {
	sleep 20;
	isNull _Vehicle ||
	!alive _Vehicle ||
	_Vehicle distance _originPosition > 150
};

if (isNull _Vehicle || !alive _Vehicle) exitWith {
	format["[VEHICLEMPTY] Vehicle destroyed before activation: %1", _Vehicle] call OKS_fnc_LogDebug;
};

format["[VEHICLEMPTY] Vehicle left starting area, monitoring begins: %1", _Vehicle] call OKS_fnc_LogDebug;

// Main monitoring loop
while {!isNull _Vehicle && alive _Vehicle} do {
	// Check if vehicle is empty and no players nearby
	private _crewCount = count crew _Vehicle;
	private _playerCount = count ((_Vehicle nearEntities ["CAManBase", 50]) select {isPlayer _x});
	private _isActive = _Vehicle getVariable ["GOL_VehicleEmpty_Active", false];
	
	// If empty and no players near, add invisible driver
	if (_crewCount == 0 && _playerCount == 0 && !_isActive) then {
		[_Vehicle, _Side] call _SetupTarget;
		
		// Wait until players approach or vehicle is destroyed
		waitUntil {
			sleep (2 + random 3);
			isNull _Vehicle || !alive _Vehicle || (count ((_Vehicle nearEntities ["CAManBase", 50]) select {isPlayer _x}) > 0)
		};
		
		// Remove invisible driver when players are near
		if (!isNull _Vehicle) then {
			[_Vehicle, _Side] call _ClearTarget;
		};
	};
	
	// Jittered interval reduces synchronized spikes across many vehicles
	sleep (4 + random 3);
};

// Final cleanup
if (!isNull _Vehicle) then {
	[_Vehicle, _Side] call _ClearTarget;
};

format["[VEHICLEMPTY] Monitoring ended for vehicle: %1", _Vehicle] call OKS_fnc_LogDebug;