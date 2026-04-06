/*
	OKS_fnc_ModuleSHORAD

	Module function for OKS_Module_SHORAD.
	Called by the engine when the module activates (immediate or via synced trigger).

	Sync a SHORAD vehicle to use it directly. If no vehicle is synced,
	one is spawned from the fallback classname at the module position.

	Standard module signature: [_logic, _units, _activated]
*/

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!_activated) exitWith {};
if (isNull _logic) exitWith {};
if (hasInterface && !isServer) exitWith {};

// --- Read module attributes ---
private _fallbackVehicle = _logic getVariable ["FallbackVehicle", "O_APC_Tracked_02_AA_F"];
private _missileType     = _logic getVariable ["MissileType", "medium"];
private _ammo            = _logic getVariable ["Ammo", 4];
private _reloadTime      = _logic getVariable ["ReloadTime", 10];
private _delay           = _logic getVariable ["Delay", 0];

// --- Delay ---
if (_delay > 0) then { sleep _delay; };

// --- Resolve synced vehicle ---
private _shoradObj = objNull;
{
	if (_x isKindOf "Logic" || _x isKindOf "EmptyDetector") then { continue; };
	if (_x isKindOf "AllVehicles") then {
		if (isNull _shoradObj) then { _shoradObj = _x; };
	};
} forEach (synchronizedObjects _logic);

// Fallback: spawn vehicle at module position
if (isNull _shoradObj) then {
	private _spawnPos = getPosATL _logic;
	_spawnPos set [2, 0];
	_shoradObj = createVehicle [_fallbackVehicle, _spawnPos, [], 0, "CAN_COLLIDE"];
	if (isNull _shoradObj) exitWith {
		format ["[Module SHORAD] ERROR: Failed to spawn vehicle %1", _fallbackVehicle] spawn OKS_fnc_LogDebug;
	};
	_shoradObj setDir (getDir _logic);
	format ["[Module SHORAD] Spawned SHORAD: %1 at %2", _fallbackVehicle, _spawnPos] spawn OKS_fnc_LogDebug;
};

// --- Build args and call core script ---
private _args = [
	_shoradObj,
	_missileType,
	_ammo,
	_reloadTime
];

format ["[Module SHORAD] Executing with args: %1", _args] spawn OKS_fnc_LogDebug;

_args spawn OKS_fnc_SHORAD;

// Clean up module logic
deleteVehicle _logic;
