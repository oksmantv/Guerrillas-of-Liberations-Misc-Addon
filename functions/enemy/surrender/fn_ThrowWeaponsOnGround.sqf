/*
    Drops all weapons (primary, handgun, launcher) with their attachments and loaded magazines/items.
    Usage: [unit] spawn OKS_fnc_ThrowWeaponsOnGround;
*/

params ["_unit", ["_targetContainer", objNull, [objNull]], ["_clearItems", true, [true]]];

if(hasInterface && !isServer) exitWith {};

if (isNil "_unit") exitWith {};
if (isNull _unit) exitWith {};

private _direction = getDir _unit;
private _dropPosition = _unit getPos [0.5, _direction];
private _dropAltitude = getPosATL _unit select 2;

// Wait for reload animation to finish (optional)
waitUntil {
    private _anim = animationState _unit;
    !(_anim find "reload" > -1)
};

_GetCorrectWeaponsItems = {
    params ["_unit"];
    _PrimaryItems = [];
    _SecondaryItems = [];
    _HandgunItems = [];
    {
        if(_X find (primaryWeapon _unit) == 0) then {
            _PrimaryItems = _X;
        };
        if(_X find (secondaryWeapon _unit) == 0) then {
            _SecondaryItems = _X;
        };    
        if(_X find (handgunWeapon _unit) == 0) then {
            _HandgunItems = _X;
        };                
    } forEach weaponsItems _unit;

    [_PrimaryItems,_SecondaryItems,_HandgunItems]
};

if(isServer) then {
    private _dest = if (!isNull _targetContainer && {alive _targetContainer}) then {
        _targetContainer
    } else {
        private _groundHolder = createVehicle ["GroundWeaponHolder", [0,0,0], [], 0, "NONE"];
        _groundHolder setPosATL [_dropPosition select 0, _dropPosition select 1, _dropAltitude];
        _groundHolder enableSimulationGlobal false;
        _groundHolder
    };

    _WeaponsArray = [_unit] call _GetCorrectWeaponsItems;
    {
        if(_X isNotEqualTo []) then {
            _dest addWeaponWithAttachmentsCargoGlobal [_X, 1];
        };
    } foreach _WeaponsArray;
};
    
// Remove weapons and optionally all items from the unit.
// When _clearItems is false, use per-weapon removal so loose magazines
// in containers are preserved (removeAllWeapons strips all mags too).
if (_clearItems) then {
    removeAllWeapons _unit;
    removeAllItems _unit;
    removeAllAssignedItems _unit;
} else {
    private _weapons = [primaryWeapon _unit, handgunWeapon _unit, secondaryWeapon _unit, binocular _unit] select {_x != ""};
    {_unit removeWeapon _x} forEach _weapons;
};

// Debug message
private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];
if(_surrenderDebug) then {
    format ["[SURRENDER] %1 dropped all weapons and gear.", name _unit] spawn OKS_fnc_LogDebug;
};

sleep 2;
_ThrownWeaponsOnGround = _unit getVariable ["GOL_ThrownWeaponOnGround",false];
if(_ThrownWeaponsOnGround) exitWith {
    // If weapons have already been thrown on the ground once, exits the function.
};

// Set the variable to indicate that weapons have been thrown on the ground once already.
_unit setVariable ["GOL_ThrownWeaponOnGround",true,true];
[_unit] spawn OKS_fnc_ThrowWeaponsOnGround;
