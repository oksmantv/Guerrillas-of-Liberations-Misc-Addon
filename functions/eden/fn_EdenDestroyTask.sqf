/*
    OKS_fnc_EdenDestroyTask
*/

// Copy example code to clipboard
private _selected = get3DENSelected "object";
private _objectNames = [];

{
    private _nameAttr = (_x get3DENAttribute "name") select 0;
    if (_nameAttr isEqualTo "") then {
        // Assign a new unique name using your function
        private _newName = ["DestroyObject"] call OKS_fnc_next3DENName;
        _x set3DENAttribute ["name", _newName];
        _objectNames pushBack _newName;
    } else {
        _objectNames pushBack _nameAttr;
    };
} forEach _selected;

private _example = format [
    "[%1] spawn OKS_fnc_Destroy_Task;",
    _objectNames
];
copyToClipboard _example;
systemChat format["CopiedToClipboard: %1",_example];