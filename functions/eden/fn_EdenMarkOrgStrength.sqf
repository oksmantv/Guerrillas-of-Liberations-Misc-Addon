/*
    OKS_fnc_EdenMarkOrgStrength
    
    Description:
        Creates organization strength markers on top of existing military markers.
        Adds a strength indicator marker 3 meters north of each selected marker.
        Optionally creates a flag marker further north of the original marker.

        If no markers are selected, attempts to create a new base marker at the
        3DEN context-click position (or mouse position fallback) and then applies
        the same strength/flag logic relative to that new marker.
        
        Note: Due to Eden Editor limitations, marker attributes cannot be read,
        so the new markers will use default color (ColorBlack) and alpha (1).
        You should manually select organizational markers (b_*, o_*, i_*) before running.
    
    Parameter(s):
        _strengthType - STRING: The type of strength marker to create
                        Options: "group_0" through "group_11"
                        - group_0: Fire Team
                        - group_1: Squad
                        - group_2: Section
                        - group_3: Platoon
                        - group_4: Company
                        - group_5: Battalion
                        - group_6: Regiment
                        - group_7: Brigade
                        - group_8: Division
                        - group_9: Corps
                        - group_10: Army
                        - group_11: Army Group
        
        _addFlag - BOOL: Whether to create a flag marker above the original marker (default: false)
        
        _side - STRING: Which side's flag to use ("BLUFOR", "OPFOR", "INDEP") - only used if _addFlag is true

        _category - STRING (optional): Marker category/branch (e.g. "INFANTRY", "MECHANIZED", "AIR").
                Currently unused by this function; reserved for menu grouping / future behavior.

        _menuData - ARRAY (optional): 3DEN context menu data (usually BIS_fnc_3DENEntityMenu_data).
                Only used when no markers are selected.
    
    Returns:
        NUMBER - Count of strength markers created
    
    Example:
        ["group_5", false] call OKS_fnc_EdenMarkOrgStrength;  // Platoon without flag
        ["group_5", true, "BLUFOR"] call OKS_fnc_EdenMarkOrgStrength;   // Platoon with BLUFOR flag
        ["group_5", true, "OPFOR"] call OKS_fnc_EdenMarkOrgStrength;    // Platoon with OPFOR flag
*/

private _menuData = [];
private _strengthType = "group_3";
private _addFlag = false;
private _side = "BLUFOR";
private _category = "";

// Supports both calling conventions:
// - Eden menu legacy: [strengthType, addFlag, side, category?, menuData?] call ...
// - RepeatLastAction: [menuData, strengthType, addFlag, side, category?] call ...
if ((count _this) > 0 && {(_this select 0) isEqualType []}) then {
    _menuData = _this param [0, [], [[]]];
    _strengthType = _this param [1, "group_3", [""]];
    _addFlag = _this param [2, false, [false]];
    _side = _this param [3, "BLUFOR", [""]];
    _category = _this param [4, "", [""]];
} else {
    _strengthType = _this param [0, "group_3", [""]];
    _addFlag = _this param [1, false, [false]];
    _side = _this param [2, "BLUFOR", [""]];
    _category = _this param [3, "", [""]];
    _menuData = _this param [4, [], [[]]];
};

private _logPrefix = "[OKS][3DEN][OrgStrength]";

private _aoLayer = ["Area of Operations Markers"] call OKS_fnc_EdenGetOrCreateLayer;
private _aoLayerValid = (_aoLayer isEqualType 0 && {_aoLayer >= 0}) || {(_aoLayer isEqualType objNull) && {!isNull _aoLayer}};

private _allMarkers = all3DENEntities select 5; // Index 5 is markers

// Build a list of existing marker names (Eden marker identifiers).
private _existingMarkerNames = [];
{
    private _markerEntityAsString = str _x;
    if ((count _markerEntityAsString) >= 2) then {
        private _n = _markerEntityAsString select [1, (count _markerEntityAsString) - 2];
        _existingMarkerNames pushBackUnique _n;
    };
} forEach _allMarkers;

private _makeUniqueMarkerName = {
    params ["_base"];
    private _candidate = _base;
    private _suffixIndex = 1;
    while { _candidate in _existingMarkerNames } do {
        _candidate = format ["%1_%2", _base, _suffixIndex];
        _suffixIndex = _suffixIndex + 1;
    };
    _existingMarkerNames pushBack _candidate;
    _candidate
};

// Get selected marker NAMES (strings, not entities!)
private _selectedMarkerNames = get3DENSelected "marker";

// If nothing is selected, try to place a new base marker at the click position.
if (_selectedMarkerNames isEqualTo []) then {
    private _md = _menuData;
    if (_md isEqualTo []) then {
        _md = uiNamespace getVariable ["BIS_fnc_3DENEntityMenu_data", []];
    };

    private _clickPos = [];

    // Some Eden contexts pass menuData as [x,y,z] directly.
    if (_md isEqualType []) then {
        _clickPos = [_md] call OKS_fnc_EdenPosFromArray;
    };

    // Other contexts pass menuData as [[x,y,z], <entity>, ...] or [<entity>, ...].
    if (_clickPos isEqualTo []) then {
        private _md0 = _md param [0, []];
        if (_md0 isEqualType objNull) then {
            if (!isNull _md0) then { _clickPos = getPosATL _md0; };
        } else {
            if (_md0 isEqualType []) then { _clickPos = [_md0] call OKS_fnc_EdenPosFromArray; };
        };
    };

    if (_clickPos isEqualTo []) then {
        _clickPos = [get3DENMousePosition] call OKS_fnc_EdenPosFromArray;
    };

    if (_clickPos isEqualTo []) exitWith {
        diag_log format ["%1 no markers selected and no valid click position | menuData=%2", _logPrefix, _md];
        systemChat "OrgStrength: no markers selected and no valid click position.";
        0
    };

    _clickPos set [2, 0];
    _clickPos = [_clickPos] call OKS_fnc_EdenSanitizePos;

    private _cat = toUpper _category;
    if (_cat isEqualTo "") then { _cat = "INFANTRY"; };

    private _sidePrefix = switch (toUpper _side) do {
        case "BLUFOR": { "b_" };
        case "OPFOR": { "o_" };
        case "INDEP": { "n_" };
        default { "b_" };
    };

    private _suffix = switch (_cat) do {
        case "INFANTRY": { "inf" };
        case "MOTORISED": { "motor_inf" };
        case "MECHANIZED": { "mech_inf" };
        case "ARMORED": { "armor" };
        case "AIR": { "plane" };
        case "HELICOPTER": { "air" };
        case "SUPPORT": { "support" };
        case "ARTILLERY": { "art" };
        case "MORTARS": { "mortar" };
        case "SERVICE": { "service" };
        case "NAVAL": { "naval" };
        case "INSTALLATION": { "installation" };
        case "LOGISTICS": { "service" };
        case "MEDICAL": { "med" };
        case "RECON": { "recon" };
        case "AA": { "antiair" };
        case "ENGINEER": { "maint" };
        default { "inf" };
    };

    private _baseMarkerType = format ["%1%2", _sidePrefix, _suffix];
    if !(isClass (configFile >> "CfgMarkers" >> _baseMarkerType)) then {
        diag_log format ["%1 unknown base marker type in CfgMarkers | requested=%2 side=%3 category=%4 -> falling back to inf", _logPrefix, _baseMarkerType, _side, _cat];
        _baseMarkerType = format ["%1inf", _sidePrefix];
    };
    private _baseMarker = create3DENEntity ["Marker", _baseMarkerType, _clickPos];
    if (isNil "_baseMarker") exitWith {
        diag_log format ["%1 failed to create base marker | type=%2 pos=%3", _logPrefix, _baseMarkerType, _clickPos];
        systemChat format ["OrgStrength: failed to create base marker type '%1'", _baseMarkerType];
        0
    };

    if (_aoLayerValid) then {
        [_baseMarker, _aoLayer] call OKS_fnc_EdenSetLayerSafe;
    };

    private _baseName = [format ["ORG_%1", _cat]] call _makeUniqueMarkerName;
    _baseMarker set3DENAttribute ["name", _baseName];
    _baseMarker set3DENAttribute ["markerName", _baseName];
	_baseMarker set3DENAttribute ["text", _baseName];
	_baseName set3DENAttribute ["size2", [0.7, 0.7]];

	private _createdAsString = str _baseMarker;
	private _createdName = if ((count _createdAsString) >= 2) then { _createdAsString select [1, (count _createdAsString) - 2] } else { "" };
	if (_createdName != _baseName) then {
		diag_log format ["%1 base marker rename mismatch | wanted=%2 got=%3 type=%4 pos=%5", _logPrefix, _baseName, _createdName, _baseMarkerType, _clickPos];
	};

    diag_log format ["%1 created base marker | name=%2 type=%3 side=%4 category=%5 pos=%6", _logPrefix, _baseName, _baseMarkerType, _side, _cat, _clickPos];
    systemChat format ["Created base marker '%1' (%2) at %3", _baseName, _baseMarkerType, _clickPos];
    _selectedMarkerNames = [_baseName];
};

systemChat format ["Processing %1 selected marker(s)...", count _selectedMarkerNames];
diag_log format ["%1 start | strengthType=%2 addFlag=%3 side=%4 category=%5 selectedMarkers=%6", _logPrefix, _strengthType, _addFlag, _side, _category, _selectedMarkerNames];

private _createdCount = 0;

// Process each selected marker name
{
    private _markerName = _x;

	// Treat selected marker values as Eden marker identifiers (strings like "marker_12" or renamed ones).
	private _posResult = _markerName get3DENAttribute "position";
	if (_posResult isEqualTo []) then {
		diag_log format ["%1 could not read marker position | markerName=%2", _logPrefix, _markerName];
		systemChat format ["Warning: Could not read marker position for '%1', skipping...", _markerName];
	} else {
        private _markerPos = if (count _posResult > 0) then {_posResult select 0} else {[0,0,0]};
        
        // Calculate new position 3 meters north (add to Y coordinate), at ground level
        private _strengthPos = [
            (_markerPos select 0),
            (_markerPos select 1) + 10,
            0
        ];
        
        // Create new strength marker name (unique)
        private _strengthMarkerName = [format ["%1_strength", _markerName]] call _makeUniqueMarkerName;
        
        // Create the strength marker in Eden Editor
        private _newMarker = create3DENEntity ["Marker", _strengthType, _strengthPos];
        
        if (!isNil "_newMarker") then {
            if (_aoLayerValid) then {
                [_newMarker, _aoLayer] call OKS_fnc_EdenSetLayerSafe;
            };
            // Set marker attributes
            _newMarker set3DENAttribute ["name", _strengthMarkerName];
            _newMarker set3DENAttribute ["color", "ColorBlack"];  // Default color since we can't read source
            _newMarker set3DENAttribute ["alpha", 1];
            _newMarker set3DENAttribute ["angle", 0];
            _newMarker set3DENAttribute ["size2", [1, 1]];
            
            _createdCount = _createdCount + 1;
            systemChat format ["Created '%1' at position %2", _strengthMarkerName, _strengthPos];
            diag_log format ["%1 created strength marker | base=%2 strengthName=%3 type=%4 pos=%5", _logPrefix, _markerName, _strengthMarkerName, _strengthType, _strengthPos];
        } else {
            diag_log format ["%1 failed to create strength marker | base=%2 strengthName=%3 type=%4 pos=%5", _logPrefix, _markerName, _strengthMarkerName, _strengthType, _strengthPos];
            systemChat format ["Failed to create strength marker '%1'", _strengthMarkerName];
        };
        
        // Create flag marker if requested
        if (_addFlag) then {
            // Get flag type based on specified side
            private _flagType = switch (toUpper _side) do {
                case "BLUFOR": { OKS_Eden_FlagMarker_BLUFOR };
                case "OPFOR": { OKS_Eden_FlagMarker_OPFOR };
                case "INDEP": { OKS_Eden_FlagMarker_INDEP };
                default { 
                    systemChat format ["Warning: Unknown side '%1', defaulting to BLUFOR", _side];
                    OKS_Eden_FlagMarker_BLUFOR 
                };
            };
            
            // Calculate flag position north of original (add to Y coordinate), at ground level
            private _flagPos = [
                (_markerPos select 0),
                (_markerPos select 1) + 125,
                0
            ];
            
            // Create flag marker name (unique)
            private _flagMarkerName = [format ["%1_flag", _markerName]] call _makeUniqueMarkerName;
            
            // Create the flag marker
            private _flagMarker = create3DENEntity ["Marker", _flagType, _flagPos];
            
            if (!isNil "_flagMarker") then {
                if (_aoLayerValid) then {
                    [_flagMarker, _aoLayer] call OKS_fnc_EdenSetLayerSafe;
                };
                // Set flag marker attributes
                _flagMarker set3DENAttribute ["name", _flagMarkerName];
                _flagMarker set3DENAttribute ["color", "Default"];  // Default color for flags
                _flagMarker set3DENAttribute ["alpha", 1];
                _flagMarker set3DENAttribute ["angle", 0];
                _flagMarker set3DENAttribute ["size2", [0.5, 0.5]];  // Smaller flag marker
                
                systemChat format ["Created flag marker '%1' (%2) at position %3", _flagMarkerName, _side, _flagPos];
                diag_log format ["%1 created flag marker | base=%2 flagName=%3 flagType=%4 side=%5 pos=%6", _logPrefix, _markerName, _flagMarkerName, _flagType, _side, _flagPos];
            } else {
                diag_log format ["%1 failed to create flag marker | base=%2 flagName=%3 flagType=%4 side=%5 pos=%6", _logPrefix, _markerName, _flagMarkerName, _flagType, _side, _flagPos];
                systemChat format ["Failed to create flag marker '%1'", _flagMarkerName];
            };
        };
    };
} forEach _selectedMarkerNames;

// Notify user
if (_createdCount > 0) then {
    private _flagText = if (_addFlag) then {" (with flags)"} else {""};
    systemChat format ["Successfully created %1 organization strength marker(s) of type '%2'%3", _createdCount, _strengthType, _flagText];
    systemChat "Note: Markers created with default color (black). Adjust manually if needed.";

    ["OKS_fnc_EdenMarkOrgStrength", [_strengthType, _addFlag, _side, _category], []] call OKS_fnc_EdenRememberLastAction;
} else {
    systemChat "Failed to create any markers. Please ensure markers are properly selected.";
};

_createdCount
