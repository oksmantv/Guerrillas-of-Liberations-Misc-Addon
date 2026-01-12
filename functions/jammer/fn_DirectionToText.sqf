/*
	OKS_fnc_DirectionToText
	
	Converts numerical direction (0-360) to compass text (N, NE, E, etc.)
	
	Parameters:
	_direction - direction in degrees (0-360)
	
	Returns:
	String - Compass direction text
	
	Example:
[45] call OKS_fnc_DirectionToText; // Returns "NE"
*/

params [
	["_direction", 0, [0]]
];

// Normalize to 0-360
_direction = _direction % 360;
if (_direction < 0) then {
	_direction = _direction + 360
};

// Convert to 8-way compass
private _compassPoints = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"];
private _index = round(_direction / 45) % 8;

_compassPoints select _index