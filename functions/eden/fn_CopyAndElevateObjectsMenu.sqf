/*
    OKS_fnc_CopyAndElevateObjectsMenu
    
    Description:
    Menu wrapper for OKS_fnc_CopyAndElevateObjects.
    If an object is selected in Eden, uses that object's classname and model.
    Otherwise uses hardcoded defaults.
    
    Usage:
    Called from Eden context menu: Right-click terrain > GOL SCRIPTS > AMBIENCE > Copy & Elevate Objects
    (uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_CopyAndElevateObjectsMenu;
*/

params [["_menuData", [0,0,0], [[], ""]]];

// Extract position from menu data
private _clickPos = [0,0,0];
if (_menuData isEqualType []) then {
    _clickPos = _menuData;
} else {
    try {
        private _parsed = call compile _menuData;
        if (_parsed isEqualType []) then {
            _clickPos = _parsed select 0;
        };
    } catch {};
};

// Check if an object is selected in Eden
private _defaultClass = "Land_TimberPile_05_F";
private _defaultModel = "timberpile_05_f.p3d";
private _selected = get3DENSelected "object";

if (count _selected > 0) then {
    private _selectedObj = _selected select 0;
    _defaultClass = typeOf _selectedObj;
    private _modelInfo = getModelInfo _selectedObj;
    if (count _modelInfo > 1) then {
        private _modelPath = _modelInfo select 1;
        // Extract just the filename from the full path
        private _parts = _modelPath splitString "\";
        _defaultModel = _parts select (count _parts - 1);
    };
    systemChat format ["Using selected object: %1 (model: %2)", _defaultClass, _defaultModel];
};

// Use defaults: 100m range, 0.5m height offset
private _range = 100;
private _height = 0.5;

systemChat format ["Searching %1m radius for '%2' objects...", _range, _defaultModel];

// Call the main function
[_clickPos, _range, _defaultClass, _defaultModel, _height] call OKS_fnc_CopyAndElevateObjects;
