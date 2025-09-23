/// Diagnostic event handler for debugging vehicle damage
/// Copy and paste this into debug console and execute on a vehicle
/// Usage: [vehicle player] execVM "this_file.sqf"; or paste directly into debug console

params ["_vehicle"];

if (isNull _vehicle) exitWith {
    systemChat "No vehicle provided for damage debugging";
};

systemChat format["Setting up damage debugging for: %1", typeOf _vehicle];

_vehicle addEventHandler ["HandleDamage", {
    params ["_unit", "_selection", "_newDamage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit"];
    
    // Get current damage state
    private _currentDamage = _unit getHitPointDamage _hitPoint;
    private _oldDamage = _unit getVariable [format["GOL_oldDamage_%1", _hitPoint], 0];
    private _addedDamage = _newDamage - _oldDamage;
    
    // Check if this vehicle should have damage reduction
    private _shouldHaveReduction = (
        ["FV432", typeOf _unit] call BIS_fnc_inString ||
        ["BTR60", typeOf _unit] call BIS_fnc_inString ||
        ["BTR70", typeOf _unit] call BIS_fnc_inString ||
        ["BTR80", typeOf _unit] call BIS_fnc_inString ||
        ["BMP1", typeOf _unit] call BIS_fnc_inString ||
        ["BMP2", typeOf _unit] call BIS_fnc_inString ||
        ["BMP3", typeOf _unit] call BIS_fnc_inString ||
        ["BMD", typeOf _unit] call BIS_fnc_inString ||
        ["M1126", typeOf _unit] call BIS_fnc_inString ||
        ["AAV", typeOf _unit] call BIS_fnc_inString ||
        ["LAV25", typeOf _unit] call BIS_fnc_inString ||
        ["SPRUT", typeOf _unit] call BIS_fnc_inString
    );
    
    // Check critical components
    private _criticalComponents = ["hithull", "hitengine", "hitfuel", "hitgun"];
    private _isCritical = (toLower _hitPoint) in _criticalComponents;
    
    // Get projectile information
    private _projectileType = _projectile;
    private _isSpallDamage = (_projectileType find "spall" != -1);
    private _isPenetratorDamage = (_projectileType find "penetrator" != -1);

    
    // Get vehicle armor and health info
    private _vehicleArmor = getNumber(configFile >> "CfgVehicles" >> typeOf _unit >> "armor");
    private _currentArmor = _unit getVariable ["BIS_armor", -1];
    private _vehicleAlive = alive _unit;
    private _canMove = canMove _unit;
    private _canFire = canFire _unit;
    
    // Get all hit points and their current damage
    private _allHitPoints = getAllHitPointsDamage _unit;
    private _hitPointNames = if (count _allHitPoints > 0) then {_allHitPoints select 0} else {[]};
    private _hitPointDamages = if (count _allHitPoints > 0) then {_allHitPoints select 2} else {[]};
    
    // Calculate expected damage reduction
    private _expectedMultiplier = 0.25; // Default for normal components
    if (_isCritical) then {
        _expectedMultiplier = 0.1; // Critical components
    };
    if (_isSpallDamage || _isPenetratorDamage) then {
        _expectedMultiplier = _expectedMultiplier * 0.5; // Additional spall/penetrator reduction
    };
    
    private _expectedDamage = _oldDamage + ((_newDamage - _oldDamage) * _expectedMultiplier);
    
    // Get time information
    private _currentTime = time;
    private _missionTime = missionNamespace getVariable ["BIS_fnc_timeToString_time", time];
    
    // Build comprehensive debug output using proper line breaks
    private _debugOutput = 
        "=== VEHICLE DAMAGE DEBUG REPORT ===" + toString [13,10] +
        "Time: " + str _currentTime + toString [13,10] +
        "Mission Time: " + str _missionTime + toString [13,10] +
        toString [13,10] +
        "VEHICLE INFORMATION:" + toString [13,10] +
        "Vehicle Type: " + str (typeOf _unit) + toString [13,10] +
        "Vehicle Class Name: " + str (configName (configFile >> "CfgVehicles" >> typeOf _unit)) + toString [13,10] +
        "Vehicle Display Name: " + str ([configFile >> "CfgVehicles" >> typeOf _unit] call BIS_fnc_displayName) + toString [13,10] +
        "Vehicle Alive: " + str _vehicleAlive + toString [13,10] +
        "Can Move: " + str _canMove + toString [13,10] +
        "Can Fire: " + str _canFire + toString [13,10] +
        "Config Armor: " + str _vehicleArmor + toString [13,10] +
        "Current Armor Variable: " + str _currentArmor + toString [13,10] +
        toString [13,10] +
        "DAMAGE REDUCTION STATUS:" + toString [13,10] +
        "Should Have Reduction: " + str _shouldHaveReduction + toString [13,10] +
        "HIT POINT ANALYSIS:" + toString [13,10] +
        "Hit Point: " + str _hitPoint + toString [13,10] +
        "Selection: " + str _selection + toString [13,10] +
        "Hit Index: " + str _hitIndex + toString [13,10] +
        "Is Critical Component: " + str _isCritical + toString [13,10] +
        "Current Hit Point Damage: " + str _currentDamage + toString [13,10] +
        "Stored Old Damage: " + str _oldDamage + toString [13,10] +
        "Incoming New Damage: " + str _newDamage + toString [13,10] +
        "Calculated Added Damage: " + str _addedDamage + toString [13,10] +
        toString [13,10] +
        "DAMAGE SOURCE ANALYSIS:" + toString [13,10] +
        "Source Type: " + str (typeOf _source) + toString [13,10] +
        "Source Class: " + str (if (isNil "_source") then {"NULL"} else {configName (configFile >> "CfgVehicles" >> typeOf _source)}) + toString [13,10] +
        "Instigator Type: " + str (typeOf _instigator) + toString [13,10] +
        "Direct Hit: " + str _directHit + toString [13,10] +
        toString [13,10] +
        "PROJECTILE ANALYSIS:" + toString [13,10] +
        "Projectile Object: " + str _projectile + toString [13,10] +
        "Projectile Type: " + _projectileType + toString [13,10] +
        "Projectile Class Name: " + str (if (isNil "_projectile") then {"NULL"} else {configName (configFile >> "CfgAmmo" >> _projectile)}) + toString [13,10] +
        "Is Spall Damage: " + str _isSpallDamage + toString [13,10] +
        "Is Penetrator Damage: " + str _isPenetratorDamage + toString [13,10] +
        toString [13,10] +
        "DAMAGE PREDICTION:" + toString [13,10] +
        "Expected Damage Multiplier: " + str _expectedMultiplier + toString [13,10] +
        "Expected Final Damage: " + str _expectedDamage + toString [13,10] +
        "Reduction Should Apply: " + str (_shouldHaveReduction && _expectedMultiplier < 1) + toString [13,10] +
        toString [13,10] +
        "ALL HIT POINTS STATUS:" + toString [13,10];
    
    // Add all hit points and their damage levels
    if (count _hitPointNames > 0) then {
        for "_i" from 0 to (count _hitPointNames - 1) do {
            private _hpName = _hitPointNames select _i;
            private _hpDamage = _hitPointDamages select _i;
            _debugOutput = _debugOutput + format ["%1: %2%3", _hpName, _hpDamage, toString [13,10]];
        };
    } else {
        _debugOutput = _debugOutput + "No hit points found" + toString [13,10];
    };
    
    _debugOutput = _debugOutput + 
        toString [13,10] +
        "DEBUG VARIABLES:" + toString [13,10] +
        "GOL_PlayerVehicle_Debug: " + str (missionNamespace getVariable ["GOL_PlayerVehicle_Debug", "NOT SET"]) + toString [13,10] +
        "GOL_PlayerVehicleDamage_Debug: " + str (missionNamespace getVariable ["GOL_PlayerVehicleDamage_Debug", "NOT SET"]) + toString [13,10] +
        toString [13,10] +
        "=== END DAMAGE REPORT ===" + toString [13,10];
    
    // Copy to clipboard
    copyToClipboard _debugOutput;
    
    // Also display summary in chat
    systemChat format["DAMAGE: %1->%2 (%3) | %4 | Critical:%5 | Reduction:%6", 
        _hitPoint, 
        _newDamage, 
        _addedDamage, 
        _projectileType,
        _isCritical,
        _shouldHaveReduction
    ];
    
    // Return the original damage value to not interfere
    _newDamage
}];

systemChat "Damage debugging enabled - comprehensive damage info will be copied to clipboard on each hit";