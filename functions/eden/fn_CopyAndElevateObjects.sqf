/*
    OKS_fnc_CopyAndElevateObjects
    
    Description:
    Finds all terrain objects of a specified type within a given position and range,
    then creates duplicates at the same position with specified altitude offset.
    Preserves exact rotation using Eden rotation attributes.
    Skips objects that already have an elevated copy (prevents duplicates).
    
    Parameters:
    0: ARRAY or STRING - Position [x,y,z] or Eden menu data
    1: NUMBER - Search radius in meters (default: 100)
    2: STRING - Classname of object to create (default: "")
    3: STRING - Model name to search for (default: "") - case-insensitive substring match
    4: NUMBER - Height offset in meters (default: 0.5)
    
    Returns:
    ARRAY - Array of created 3DEN entities
    
    Usage:
    [_clickPos, 100, "Land_TimberPile_05_F", "timberpile_05_f.p3d", 0.5] call OKS_fnc_CopyAndElevateObjects;
*/

params [
    ["_positionOrMenuData", [0,0,0], [[], ""]],
    ["_searchRange", 100, [0]],
    ["_objectClass", "", [""]],
    ["_modelName", "", [""]],
    ["_heightOffset", 0.5, [0]]
];

// Extract position from Eden menu data
private _searchPos = [0,0,0];

if (_positionOrMenuData isEqualType []) then {
    _searchPos = _positionOrMenuData;
} else {
    private _menuData = _positionOrMenuData;
    if (_menuData isEqualType "") then {
        try {
            private _parsed = call compile _menuData;
            if (_parsed isEqualType []) then {
                _searchPos = _parsed select 0;
            };
        } catch {};
    };
};

private _foundObjects = [];
private _createdObjects = [];

// Debug position
systemChat format ["Searching at position: %1 with range: %2m", _searchPos, _searchRange];

// Get all 3DEN entities (terrain objects are in the "Object" layer)
private _all3DENObjects = (all3DENEntities select 0); // Index 0 = objects

// Filter objects within range
private _objectsInRange = _all3DENObjects select {
    private _objPos = _x get3DENAttribute "position" select 0;
    (_objPos distance _searchPos) <= _searchRange
};

systemChat format ["Found %1 total objects in range", count _objectsInRange];

// Filter by model name or classname
if (_modelName != "") then {
    _foundObjects = _objectsInRange select {
        private _obj3DEN = _x;
        private _type = _obj3DEN get3DENAttribute "ItemClass" select 0;
        private _objModel = toLower (getText (configFile >> "CfgVehicles" >> _type >> "model"));
        (_objModel find (toLower _modelName) >= 0)
    };
    systemChat format ["Filtered to %1 objects matching model: %2", count _foundObjects, _modelName];
} else {
    _foundObjects = _objectsInRange select {
        private _type = _x get3DENAttribute "ItemClass" select 0;
        _type == _objectClass
    };
    systemChat format ["Filtered to %1 objects matching class: %2", count _foundObjects, _objectClass];
};

if (count _foundObjects == 0) exitWith {
    systemChat "Copy & Elevate Objects: No matching objects found!";
    systemChat format ["Search criteria: Class='%1' Model='%2'", _objectClass, _modelName];
    []
};

// Initialize global tracking array if it doesn't exist
if (isNil "OKS_CopyElevate_ProcessedObjects") then {
    OKS_CopyElevate_ProcessedObjects = [];
};

private _skippedCount = 0;

// Process each found object
{
    private _obj = _x;
    
    // Get original properties from 3DEN entity
    private _pos = _obj get3DENAttribute "position" select 0;
    private _rotation = _obj get3DENAttribute "rotation" select 0;
    private _itemClass = _obj get3DENAttribute "ItemClass" select 0;
    
    // Check if this position has already been processed (within 0.1m tolerance)
    private _alreadyProcessed = false;
    {
        private _processedPos = _x;
        if ((_pos distance2D _processedPos) < 0.1 && (abs ((_pos select 2) - (_processedPos select 2))) < 0.1) exitWith {
            _alreadyProcessed = true;
        };
    } forEach OKS_CopyElevate_ProcessedObjects;
    
    // Skip if already processed
    if (_alreadyProcessed) exitWith {
        _skippedCount = _skippedCount + 1;
    };
    
    // Create new position with height offset
    private _newPos = [_pos select 0, _pos select 1, (_pos select 2) + _heightOffset];
    
    // Create the new object in Eden Editor
    private _newObj = create3DENEntity ["Object", _itemClass, _newPos];
    
    if (!isNil "_newObj") then {
        // Set position
        _newObj set3DENAttribute ["Position", _newPos];
        
        // Copy rotation from original (Eden stores as [pitch, bank, yaw])
        _newObj set3DENAttribute ["rotation", _rotation];
        
        // Mark this position as processed
        OKS_CopyElevate_ProcessedObjects pushBack _pos;
        
        _createdObjects pushBack _newObj;
    };
    
} forEach _foundObjects;

// Success notification
private _statusMsg = format ["Copy & Elevate Objects: Created %1 elevated copies (+%2m)", count _createdObjects, _heightOffset];
if (_skippedCount > 0) then {
    _statusMsg = _statusMsg + format [" | Skipped %1 already processed", _skippedCount];
};
systemChat _statusMsg;

_createdObjects
