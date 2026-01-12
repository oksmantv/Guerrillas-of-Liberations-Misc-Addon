/*
	OKS_fnc_DroneJammer_UpdateHUD
	
	Updates visual HUD overlay for jammer status using RscTitle.
	Integrates with vanilla UI Layout system (movable in Options > Game > Layout).
	Shows icon with color coding: White (active), Yellow (1), Orange (2), Red (3+).
	
	Parameters:
	_jammerCarrier - Unit carrying the jammer
	_status - Status: "inactive", "detecting", "jamming", "jamming_multiple"
	_droneCount - Number of drones in jam range (default: 0)
	_nearestDistance - distance to nearest drone (default: 0)
	
	Returns:
	Nothing
	
	Example:
	[player, "jamming", 2, 150] call OKS_fnc_DroneJammer_UpdateHUD;
*/

params [
	["_jammerCarrier", objNull, [objNull]],
	["_status", "inactive", [""]],
	["_droneCount", 0, [0]],
	["_nearestDistance", 0, [0]]
];

if (isNull _jammerCarrier || !hasInterface || player != _jammerCarrier) exitWith {};

// Show HUD using RscTitle (integrates with vanilla UI Layout)
private _display = uiNamespace getVariable ["OKS_JammerHUD_Display", displayNull];
private _needsCreate = isNull _display;

if (_needsCreate) then {
	"OKS_JammerHUD" cutRsc ["OKS_JammerHUD", "PLAIN"];
	// Small delay to let display initialize
	uiSleep 0.01;
	_display = uiNamespace getVariable ["OKS_JammerHUD_Display", displayNull];
	if (isNull _display) exitWith {};
};

// get controls from the RscTitle display
private _ctrlIcon = _display displayCtrl 95001;
private _ctrlIndicator = _display displayCtrl 95002;
private _ctrlBg = _display displayCtrl 95003;
private _ctrlCountText = _display displayCtrl 95004;

if (isNull _ctrlIcon || isNull _ctrlIndicator) exitWith {};

// Icon color based on drone count: White (active), Yellow (1), Orange (2), Red (3+)
private _iconColor = switch (true) do {
	// White - active but no drones
	case (_droneCount == 0): {
		[1, 1, 1, 0.7]
	}; 
	// Yellow - 1 drone
	case (_droneCount == 1): {
		[0.8, 0.8, 0.2, 1]
	};
	// Orange - 2 drones
	case (_droneCount == 2): {
		[1, 0.5, 0, 1]
	};  
	// Red - 3+ drones
	case (_droneCount >= 3): {
		[1, 0, 0, 1]
	};
	// Gray - inactive
	default {
		[0.5, 0.5, 0.5, 0.5]
	};
};

_ctrlIcon ctrlSetTextColor _iconColor;

// Indicator dot color matches icon color
_ctrlIndicator ctrlSetBackgroundColor _iconColor;

// Pulse effect based on drone count (faster = more drones)
if (_droneCount > 0) then {
	private _pulseSpeed = 1 - (_droneCount min 5) * 0.15; // Faster pulse with more drones
	_ctrlIndicator ctrlSetFade (0.3 + 0.7 * (sin (time * 5 * _pulseSpeed)));
	_ctrlIndicator ctrlCommit 0;
};

// Update count text (show number if drones present, always white)
if (!isNull _ctrlCountText) then {
	if (_droneCount > 0) then {
		_ctrlCountText ctrlSetText str _droneCount;
		_ctrlCountText ctrlSetTextColor [1, 1, 1, 1];
	} else {
		_ctrlCountText ctrlSetText "";
	};
};