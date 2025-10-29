/*
    Function: AI Helicopter Resupply Drop - Parachute Supply Box Drop System
    
    Creates a supply box attached to a parachute that drops from an aircraft.
    Designed to be called from helicopter flyby systems or standalone.

    Example:
    [
        _helicopter,                // Aircraft to drop from
        "B_supplyCrate_F",         // Supply box classname
        [["arifle_MX_F", 10], ["30Rnd_65x39_caseless_mag", 50]], // Custom items
        true,                      // Add default supplies
        50,                        // Drop delay in meters before endpoint
        true,                      // Enable debug messages
        3                          // Number of supply crates to drop
    ] call OKS_fnc_AI_ResupplyDrop;
*/

if (!isServer) exitWith {};

params [
    ["_aircraft", objNull, [objNull]],
    ["_supplyBoxClass", "B_supplyCrate_F", [""]],
    ["_customItems", [], [[]]],                     // Array of [classname, quantity] arrays
    ["_addDefaultSupplies", true, [false]],         // Add default medical/ammo supplies
    ["_dropDistance", 100, [0]],                    // Distance before target to drop (meters)
    ["_enableDebug", false, [false]],               // Enable debug for this specific drop
    ["_numberOfDrops", 1, [0]]                      // Number of supply crates to drop (default: 1)
];

// Validation
if (isNull _aircraft || !alive _aircraft) exitWith {
    if (_enableDebug) then {
        "[RESUPPLY_DROP] Invalid or destroyed aircraft - drop cancelled" call OKS_fnc_LogDebug;
    };
    objNull
};

// Validate number of drops
if (_numberOfDrops < 1) then {_numberOfDrops = 1};
if (_numberOfDrops > 10) then {_numberOfDrops = 10}; // Reasonable maximum

if (_enableDebug) then {
    format["[RESUPPLY_DROP] Initiating %1 supply drop(s) from %2 at position %3", 
        _numberOfDrops, typeOf _aircraft, getPosATL _aircraft] call OKS_fnc_LogDebug;
};

// Store all dropped supply boxes
private _allSupplyBoxes = [];

// Loop for multiple drops
for "_dropIndex" from 1 to _numberOfDrops do {
    
    // Get current aircraft position and velocity for each drop
    private _aircraftPos = getPosASL _aircraft; // Use ASL for water compatibility
    private _aircraftVel = velocity _aircraft;
    private _aircraftDir = getDir _aircraft;
    
    if (_enableDebug) then {
        format["[RESUPPLY_DROP] Drop %1/%2: Aircraft at %3 (ASL), direction: %4°", 
            _dropIndex, _numberOfDrops, _aircraftPos, round _aircraftDir] call OKS_fnc_LogDebug;
    };

    // Calculate position 10m behind aircraft using proper trigonometry
    private _dropPos = [
        (_aircraftPos select 0) + (10 * sin(_aircraftDir + 180)), // 10m behind on X axis
        (_aircraftPos select 1) + (10 * cos(_aircraftDir + 180)), // 10m behind on Y axis  
        (_aircraftPos select 2) - 5                                // 5m below aircraft
    ];

    // Create supply box at calculated drop position
    private _supplyBox = createVehicle [_supplyBoxClass, _dropPos, [], 0, "CAN_COLLIDE"];
    if (isNull _supplyBox) exitWith {
        if (_enableDebug) then {
            format["[RESUPPLY_DROP] Failed to create supply box %1", _supplyBoxClass] call OKS_fnc_LogDebug;
        };
        objNull
    };

    // Set box position precisely using ASL for water compatibility
    _supplyBox setPosASL _dropPos;

// Apply aircraft velocity to box for realistic drop physics
_supplyBox setVelocity _aircraftVel;

// Clear existing cargo
clearWeaponCargoGlobal _supplyBox;
clearMagazineCargoGlobal _supplyBox;
clearItemCargoGlobal _supplyBox;
clearBackpackCargoGlobal _supplyBox;

// Add default supplies if requested
if (_addDefaultSupplies) then {
    // Medical supplies
    _supplyBox addItemCargoGlobal ["FirstAidKit", 10];
    _supplyBox addItemCargoGlobal ["Medikit", 2];
    _supplyBox addItemCargoGlobal ["ACE_fieldDressing", 20];
    _supplyBox addItemCargoGlobal ["ACE_morphine", 10];
    _supplyBox addItemCargoGlobal ["ACE_epinephrine", 5];
    _supplyBox addItemCargoGlobal ["ACE_bloodIV", 5];
    
    // Basic ammunition
    _supplyBox addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag", 30];
    _supplyBox addMagazineCargoGlobal ["20Rnd_762x51_Mag", 20];
    _supplyBox addMagazineCargoGlobal ["HandGrenade", 10];
    _supplyBox addMagazineCargoGlobal ["SmokeShell", 10];
    
    // Equipment
    _supplyBox addItemCargoGlobal ["ToolKit", 2];
    _supplyBox addItemCargoGlobal ["acc_flashlight", 5];
    _supplyBox addItemCargoGlobal ["optic_Holosight", 3];
};

// Add custom items
{
    private _itemClass = _x select 0;
    private _quantity = _x select 1;
    
    // Determine item type and add accordingly
    private _itemConfig = configFile >> "CfgWeapons" >> _itemClass;
    if (isClass _itemConfig) then {
        _supplyBox addWeaponCargoGlobal [_itemClass, _quantity];
    } else {
        _itemConfig = configFile >> "CfgMagazines" >> _itemClass;
        if (isClass _itemConfig) then {
            _supplyBox addMagazineCargoGlobal [_itemClass, _quantity];
        } else {
            _itemConfig = configFile >> "CfgVehicles" >> _itemClass;
            if (isClass _itemConfig) then {
                _supplyBox addBackpackCargoGlobal [_itemClass, _quantity];
            } else {
                // Default to item
                _supplyBox addItemCargoGlobal [_itemClass, _quantity];
            };
        };
    };
    
    if (_enableDebug) then {
        format["[RESUPPLY_DROP] Added %1x %2 to supply box", _quantity, _itemClass] call OKS_fnc_LogDebug;
    };
} forEach _customItems;

    // Create parachute at the same position as the supply box
    private _parachutePos = _dropPos; // Use same calculated position

    private _parachute = createVehicle ["B_Parachute_02_F", _parachutePos, [], 0, "NONE"];
    if (isNull _parachute) exitWith {
        if (_enableDebug) then {
            "[RESUPPLY_DROP] Failed to create parachute - supply box will fall freely" call OKS_fnc_LogDebug;
        };
        _supplyBox
    };

    // Set parachute position precisely using ASL for water compatibility
    _parachute setPosASL _parachutePos;

    // Apply aircraft velocity to both box and parachute for synchronized movement
    _parachute setVelocity _aircraftVel;

    // Immediately attach supply box to parachute (no delay)
    _supplyBox attachTo [_parachute, [0, 0, -1.5]];

if (_enableDebug) then {
    format["[RESUPPLY_DROP] Supply box attached to parachute immediately at %1m - beginning descent", 
        round(_parachutePos select 2)] call OKS_fnc_LogDebug;
};

// Monitor parachute descent and handle landing
[_supplyBox, _parachute, _enableDebug] spawn {
    params ["_box", "_chute", "_debug"];
    
    
    // Monitor parachute descent and handle landing
    while {!isNull _chute && alive _chute && (getPosATL _chute select 2) > 3} do {
        sleep 1;
    };
    
    // Detach box from parachute when close to ground
    if (!isNull _box && !isNull _chute) then {
        detach _box;
        
        // Small delay to let physics settle
        sleep 2;
        
        // Clean up parachute
        if (!isNull _chute) then {
            deleteVehicle _chute;
        };
        
        if (_debug) then {
            format["[RESUPPLY_DROP] Supply drop landed at %1 - parachute cleaned up", 
                getPosATL _box] call OKS_fnc_LogDebug;
        };
    };
};

    // Add this supply box to the collection
    _allSupplyBoxes pushBack _supplyBox;
    
    if (_enableDebug) then {
        format["[RESUPPLY_DROP] Drop %1/%2: Supply box created successfully - %3", 
            _dropIndex, _numberOfDrops, _supplyBox] call OKS_fnc_LogDebug;
    };
    
    // Add spacing between drops (except for the last drop)
    if (_dropIndex < _numberOfDrops) then {
        if (_enableDebug) then {
            format["[RESUPPLY_DROP] Waiting 1.5 seconds before next drop (%1/%2)", 
                _dropIndex + 1, _numberOfDrops] call OKS_fnc_LogDebug;
        };
        sleep 1.5; // 1.5 seconds between each drop for spacing
    };
}; // End of drop loop

// Return all supply boxes (or just the first one for backward compatibility)
if (_enableDebug) then {
    format["[RESUPPLY_DROP] All %1 supply drop(s) initiated successfully - boxes: %2", 
        _numberOfDrops, _allSupplyBoxes] call OKS_fnc_LogDebug;
};

// Return first supply box for backward compatibility, or all boxes if multiple
if (_numberOfDrops == 1) then {
    _allSupplyBoxes select 0
} else {
    _allSupplyBoxes
}