/*
    OKS_fnc_EdenMarkOrgStrength
    
    Description:
        Creates organization strength markers on top of existing military markers.
        Adds a strength indicator marker 3 meters north of each selected marker.
        Optionally creates a flag marker 15 meters north of the original marker.
        
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
    
    Returns:
        NUMBER - Count of strength markers created
    
    Example:
        ["group_5", false] call OKS_fnc_EdenMarkOrgStrength;  // Platoon without flag
        ["group_5", true, "BLUFOR"] call OKS_fnc_EdenMarkOrgStrength;   // Platoon with BLUFOR flag
        ["group_5", true, "OPFOR"] call OKS_fnc_EdenMarkOrgStrength;    // Platoon with OPFOR flag
*/

params [
    ["_strengthType", "group_3", [""]],
    ["_addFlag", false, [false]],
    ["_side", "BLUFOR", [""]]
];

// Get selected marker NAMES (strings, not entities!)
private _selectedMarkerNames = get3DENSelected "marker";

if (_selectedMarkerNames isEqualTo []) exitWith {
    systemChat "No markers selected! Please select markers in the editor first.";
    0
};

systemChat format ["Processing %1 selected marker(s)...", count _selectedMarkerNames];

// Get all marker entities from Eden
private _allMarkers = all3DENEntities select 5; // Index 5 is markers

private _createdCount = 0;

// Process each selected marker name
{
    private _markerName = _x;
    
    // Find the marker entity from all markers by matching the string representation
    private _markerEntity = objNull;
    private _found = false;
    {
        private _entityString = str _x;
        
        // Remove quotes from the entity string for comparison
        private _cleanEntityName = _entityString select [1, (count _entityString) - 2];
        
        // Check if marker name matches
        if (_cleanEntityName == _markerName) exitWith {
            _markerEntity = _x;
            _found = true;
        };
    } forEach _allMarkers;
    
    if (!_found) then {
        systemChat format ["Warning: Could not find marker entity for '%1', skipping...", _markerName];
    } else {
        // Get the marker's position (this is one of the few attributes that works)
        private _posResult = _markerEntity get3DENAttribute "position";
        private _markerPos = if (count _posResult > 0) then {_posResult select 0} else {[0,0,0]};
        
        // Calculate new position 3 meters north (add to Y coordinate), at ground level
        private _strengthPos = [
            (_markerPos select 0),
            (_markerPos select 1) + 10,
            0
        ];
        
        // Create new strength marker name
        private _strengthMarkerName = format ["%1_strength", _markerName];
        
        // Create the strength marker in Eden Editor
        private _newMarker = create3DENEntity ["Marker", _strengthType, _strengthPos];
        
        if (!isNil "_newMarker") then {
            // Set marker attributes
            _newMarker set3DENAttribute ["name", _strengthMarkerName];
            _newMarker set3DENAttribute ["color", "ColorBlack"];  // Default color since we can't read source
            _newMarker set3DENAttribute ["alpha", 1];
            _newMarker set3DENAttribute ["angle", 0];
            _newMarker set3DENAttribute ["size2", [1, 1]];
            
            _createdCount = _createdCount + 1;
            systemChat format ["Created '%1' at position %2", _strengthMarkerName, _strengthPos];
        } else {
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
            
            // Calculate flag position 15 meters north of original (add to Y coordinate), at ground level
            private _flagPos = [
                (_markerPos select 0),
                (_markerPos select 1) + 90,
                0
            ];
            
            // Create flag marker name
            private _flagMarkerName = format ["%1_flag", _markerName];
            
            // Create the flag marker
            private _flagMarker = create3DENEntity ["Marker", _flagType, _flagPos];
            
            if (!isNil "_flagMarker") then {
                // Set flag marker attributes
                _flagMarker set3DENAttribute ["name", _flagMarkerName];
                _flagMarker set3DENAttribute ["color", "Default"];  // Default color for flags
                _flagMarker set3DENAttribute ["alpha", 1];
                _flagMarker set3DENAttribute ["angle", 0];
                _flagMarker set3DENAttribute ["size2", [0.5, 0.5]];  // Smaller flag marker
                
                systemChat format ["Created flag marker '%1' (%2) at position %3", _flagMarkerName, _side, _flagPos];
            } else {
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
} else {
    systemChat "Failed to create any markers. Please ensure markers are properly selected.";
};

_createdCount
