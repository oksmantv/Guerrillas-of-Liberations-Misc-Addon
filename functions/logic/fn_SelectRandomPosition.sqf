/*
	Function: OKS_fnc_SelectRandomPosition
	Description: Instantly moves a unit to one of several predefined positions with optional direction
	
	Parameters:
	0: _Unit - Unit to move (OBJECT)
	1: _Positions - Array of positions to choose from (ARRAY of positions)
	2: _Directions - Array of directions corresponding to positions (ARRAY of numbers) [Optional]
	
	Example Usage:
	[myUnit, [[100,100,0], [200,200,0]], [90, 180]] call OKS_fnc_SelectRandomPosition;
	[myUnit, [getMarkerPos "pos1", getMarkerPos "pos2"]] call OKS_fnc_SelectRandomPosition;
*/

params [
	["_Unit", objNull, [objNull]],
	["_Positions", [], [[]]],
	["_Directions", [], [[]]]
];

// Get debug setting and cache it
private _EnemyDebug = missionNamespace getVariable ["GOL_Enemy_Debug", false];

// Validate parameters
if (isNull _Unit) exitWith {
	if (_EnemyDebug) then {
		"[RANDOM POSITION] ERROR: Unit parameter is null" spawn OKS_fnc_LogDebug;
	};
	false
};

if (count _Positions == 0) exitWith {
	if (_EnemyDebug) then {
		format["[RANDOM POSITION] ERROR: No positions provided for unit %1", name _Unit] spawn OKS_fnc_LogDebug;
	};
	false
};

// Log function start
if (_EnemyDebug) then {
	format["[RANDOM POSITION] Starting position selection for %1 with %2 positions", name _Unit, count _Positions] spawn OKS_fnc_LogDebug;
};

// Select random position
private _randomIndex = floor(random(count _Positions));
private _selectedPosition = _Positions select _randomIndex;

// Convert position to ASL if needed
private _aslPosition = if (count _selectedPosition == 2) then {
	// If 2D position, convert to 3D and then to ASL
	[_selectedPosition select 0, _selectedPosition select 1, 0]
} else {
	_selectedPosition
};

// Ensure we have ASL coordinates
_aslPosition = AGLToASL _aslPosition;

// Set unit position using ASL
_Unit setPosASL _aslPosition;

if (_EnemyDebug) then {
	format["[RANDOM POSITION] %1 moved to position %2 (ASL: %3)", name _Unit, _selectedPosition, _aslPosition] spawn OKS_fnc_LogDebug;
};

// Handle direction if provided
if (count _Directions > 0 && _randomIndex < count _Directions) then {
	private _selectedDirection = _Directions select _randomIndex;
	
	// Check if unit is a man (infantry) or vehicle
	if (_Unit isKindOf "Man") then {
		// For infantry, set direction (facing)
		_Unit setDir _selectedDirection;
		_Unit doWatch ((getPos _Unit) getPos [3,_selectedDirection]);
		if (_EnemyDebug) then {
			format["[RANDOM POSITION] %1 (infantry) set to face direction %2°", name _Unit, _selectedDirection] spawn OKS_fnc_LogDebug;
		};
	} else {
		// For vehicles, set direction
		_Unit setDir _selectedDirection;
		if (_EnemyDebug) then {
			format["[RANDOM POSITION] %1 (vehicle) set to direction %2°", name _Unit, _selectedDirection] spawn OKS_fnc_LogDebug;
		};
	};
} else {
	if (_EnemyDebug && count _Directions > 0) then {
		format["[RANDOM POSITION] No direction provided for position index %1", _randomIndex] spawn OKS_fnc_LogDebug;
	};
};

// Return the selected position and direction for reference
if (count _Directions > 0 && _randomIndex < count _Directions) then {
	[_selectedPosition, _Directions select _randomIndex, _randomIndex]
} else {
	[_selectedPosition, -1, _randomIndex]
}