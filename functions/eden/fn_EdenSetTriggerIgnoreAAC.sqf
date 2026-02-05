/*
    OKS_fnc_EdenSetTriggerIgnoreAAC

    Description:
    Converts a trigger's activation condition to ignore aircraft (AAC - Army Air Corps).
    Sets the condition to check for non-aircraft vehicles only.

    Usage:
    Called from Eden context menu: Right-click trigger > GOL TOOLS > Set Trigger Ignore AAC
    [] call OKS_fnc_EdenSetTriggerIgnoreAAC;

    Returns:
    Nothing
*/

// Get selected triggers
private _triggers = get3DENSelected "trigger";

if (count _triggers == 0) exitWith {
    ["Set Trigger Ignore AAC: No trigger selected", 1, 5, true] call BIS_fnc_3DENNotification;
};

// New condition that ignores aircraft
private _newCondition = "{!(vehicle _x isKindOf ""Air"")} count thisList > 0 && isServer";

// Apply condition to all selected triggers
{
    _x set3DENAttribute ["condition", _newCondition];
} forEach _triggers;

// Show success notification
private _triggerCount = count _triggers;
private _message = format ["Trigger condition updated to ignore AAC (%1 trigger%2)", _triggerCount, if (_triggerCount > 1) then {"s"} else {""}];
[_message, 0, 5, true] call BIS_fnc_3DENNotification;
