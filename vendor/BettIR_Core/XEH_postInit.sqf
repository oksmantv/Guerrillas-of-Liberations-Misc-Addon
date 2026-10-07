if (!hasInterface) exitWith {};

diag_log "[GOL_IRLLM] PostInit: waiting for player and function registry.";

[] spawn {
	waitUntil {
		sleep 0.1;
		!isNull player
	};

	// The CfgFunctions registry is populated asynchronously during startup.
	// Do not build the compatibility cache until its functions are available.
	waitUntil {
		sleep 0.1;
		!isNil "GOL_IRLLM_fnc_getCompatibleNVGs"
		&& !isNil "GOL_IRLLM_fnc_getCompatibleWeaponAttachments"
		&& !isNil "GOL_IRLLM_fnc_handleVisionModeChange"
	};

	[] call GOL_IRLLM_fnc_initialize;
	diag_log "[GOL_IRLLM] PostInit: runtime initialization complete.";

	// Register after player initialization so initial vision state is reliable.
	["visionMode", {
    params ["_unit", "_newVisionMode", "_oldVisionMode"];

	// check if we're currently switching to/from nightvision
	_isNightvision = _newVisionMode == 1;
	// call the handler function
	[_isNightvision] spawn GOL_IRLLM_fnc_handleVisionModeChange; 


	}, true] call CBA_fnc_addPlayerEventHandler;

	// A player can enter the mission with night vision already enabled, in
	// which case no visionMode event is emitted after registration.
	if (currentVisionMode player == 1) then {
		[true] spawn GOL_IRLLM_fnc_handleVisionModeChange;
	};
};
