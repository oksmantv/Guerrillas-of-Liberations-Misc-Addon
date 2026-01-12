/*
	OKS_fnc_DroneHelper_NormalizePos

	Normalizes a position parameter (object, array, or marker) to ATL array format [x,y,z].
	Ensures consistent position handling across drone systems.

	Parameters:
		0: OBJECT/ARRAY/STRING - Position as object, [x,y] or [x,y,z], or marker name

	Returns:
		ARRAY - Normalized position as [x,y,z] in ATL format

	Example:
		private _pos = [myObject] call OKS_fnc_DroneHelper_NormalizePos;
		private _pos = [[1000,2000]] call OKS_fnc_DroneHelper_NormalizePos;
		private _pos = [_object] call OKS_fnc_DroneHelper_NormalizePos;
*/

params [["_positionOrObject", [0,0,0], [[], objNull, ""]]];

if (_positionOrObject isEqualType objNull) exitWith {
	if (isNull _positionOrObject) then {[0,0,0]} else {getPosATL _positionOrObject}
};

if (_positionOrObject isEqualType "") exitWith {
	if (_positionOrObject == "") then {[0,0,0]} else {getMarkerPos _positionOrObject}
};

if (_positionOrObject isEqualType []) exitWith {
	if ((count _positionOrObject) < 3) then {
		[_positionOrObject param [0,0], _positionOrObject param [1,0], 0]
	} else {
		_positionOrObject
	}
};

[0,0,0]
