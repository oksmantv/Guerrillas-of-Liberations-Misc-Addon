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

// Get all terrain objects in range
private _allTerrain = nearestTerrainObjects [_searchPos, [], _searchRange, false, true];

// Filter by model name or classname
if (_modelName != "") then {
    _foundObjects = _allTerrain select {
        private _objModel = toLower (getModelInfo _x select 1);
        _objModel find (toLower _modelName) >= 0
    };
} else {
    _foundObjects = _allTerrain select {typeOf _x == _objectClass};
};

if (count _foundObjects == 0) exitWith {
    systemChat "Copy & Elevate Objects: No matching objects found!";
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
    
    // Get original properties
    private _pos = getPosATL _obj;
    
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
    
    private _vectorDir = vectorDir _obj;
    private _dir = getDir _obj;
    
    // Create new position with height offset
    private _newPos = [_pos select 0, _pos select 1, (_pos select 2) + _heightOffset];
    
    // Create the new object in Eden Editor
    private _newObj = create3DENEntity ["Object", _objectClass, _newPos];
    
    if (!isNil "_newObj") then {
        // Set position
        _newObj set3DENAttribute ["Position", _newPos];
        
        // Calculate pitch based on VectorDir.z sign
        private _rawPitch = asin (_vectorDir select 2);
        private _edenPitch = if ((_vectorDir select 2) < 0) then {
            _rawPitch * -1
        } else {
            _rawPitch
        };
        
        // Set rotation (pitch, bank=0 for terrain objects, direction)
        _newObj set3DENAttribute ["rotation", [_edenPitch, 0, _dir]];
        
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
