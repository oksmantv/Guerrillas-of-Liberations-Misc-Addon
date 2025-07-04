/*
    Drops all weapons (primary, handgun, launcher) with their attachments and loaded magazines/items.
    Usage: [unit] spawn OKS_fnc_ThrowWeaponsOnGround;
*/

params ["_unit"];

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
    // Create the ground weapon holder at the drop position
    private _groundHolder = createVehicle ["GroundWeaponHolder", [0,0,0], [], 0, "NONE"];
    _groundHolder setPosATL [_dropPosition select 0, _dropPosition select 1, _dropAltitude];

    _WeaponsArray = [_unit] call _GetCorrectWeaponsItems;
    {
        if(_X isNotEqualTo []) then {
            _groundHolder addWeaponWithAttachmentsCargoGlobal [_X, 1];
        };
    } foreach _WeaponsArray;

    _groundHolder enableSimulationGlobal false;
};
    
// Remove all weapons, magazines, and items from the unit
removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;

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
