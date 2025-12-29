/*
    OKS_fnc_Deliver_Supplies

    Creates a "Deliver Supplies" parent task (once) + a subtask for a specific supply type.
    Completes the subtask when the required amount of matching supply objects are inside
    the destination trigger area.

    Notes:
    - Intended to run on server.
    - Supply objects must be physically placed inside the trigger area (not attached).

    Params:
        0: OBJECT|STRING (required) destination trigger (object or variable name)
        1: STRING (optional) type: "ammo" | "water" | "food" | "fuel" (default: "ammo")
        2: NUMBER (optional) amount required (default: 1)
        3: STRING (optional) parent task id (default: "OKS_Delivery_MainTask")
        4: STRING (optional) parent objective name (default: "Delivery to Area")
        5: STRING (optional) sub objective name (default: "Deliver Ammo")
        6: STRING (optional) marker color (default: "colorCivilian")
        7: STRING (optional) marker brush (default: "SolidBorder")

    Example:
        [DeliveryTrigger_1, "ammo", 1] spawn OKS_fnc_Deliver_Supplies;
*/

if (!isServer) exitWith {};

params [
    ["_triggerRef", objNull, [objNull, ""]],
    ["_type", "ammo", [""]],
    ["_amount", 1, [0]],
    ["_parentTask", "OKS_Delivery_MainTask", [""]],
    ["_parentObjectiveName", "Delivery to Area", [""]],
    ["_subObjectiveName", "Deliver Ammo", [""]],
    ["_markerColor", "colorCivilian", [""]],
    ["_markerBrush", "SolidBorder", [""]]
];

private _resolveTrigger = {
    params ["_ref"];
    if (_ref isEqualType objNull) exitWith {
        if (!isNull _ref) then { _ref } else { objNull };
    };
    if (_ref isEqualType "") exitWith {
        if (_ref isEqualTo "") then { objNull } else { missionNamespace getVariable [_ref, objNull] };
    };
    objNull
};

private _trg = [_triggerRef] call _resolveTrigger;
if (isNull _trg) exitWith {
    diag_log "OKS Deliver Supplies: destination trigger is required (object or variable name)";
};

private _typeLower = toLower _type;
private _class = switch (_typeLower) do {
    case "ammo": { "CargoNet_01_box_F" };
    case "water": { "Land_WaterBottle_01_stack_F" };
    case "food": { "Land_FoodSacks_01_large_brown_idap_F" };
    case "fuel": { "CargoNet_01_barrels_F" };
    default { "" };
};

if (_class isEqualTo "") exitWith {
    diag_log format ["OKS Deliver Supplies: invalid type '%1'", _type];
};

// Parent task (created once)
if (!([_parentTask] call BIS_fnc_taskExists)) then {
    [
        true,
        _parentTask,
        [
            "You have been tasked to deliver supplies to this area. Check the sub-tasks for the required supplies.",
            _parentObjectiveName,
            "Drop Off"
        ],
        getPos _trg,
        "CREATED",
        1,
        true,
        "truck"
    ] call BIS_fnc_taskCreate;

    // Minimal marker around the trigger area (no dependency on external helper).
    private _area = triggerArea _trg;
    _area params ["_a", "_b", "_angle", "_isRect"];

    private _mName = "";
    for "_i" from 0 to 50 do {
        private _candidate = format ["OKS_DeliverSupplies_%1", floor (random 1000000)];
        if (getMarkerColor _candidate isEqualTo "") exitWith { _mName = _candidate; };
    };

    if !(_mName isEqualTo "") then {
        private _m = createMarker [_mName, getPosATL _trg];
        _m setMarkerShape (if (_isRect) then {"RECTANGLE"} else {"ELLIPSE"});
        _m setMarkerSize [_a, _b];
        _m setMarkerDir _angle;
        _m setMarkerColor _markerColor;
        _m setMarkerBrush _markerBrush;
        _m setMarkerAlpha 0.6;
    };

    // Auto-complete parent when all children complete.
    [_parentTask] spawn {
        params ["_pt"];
        waitUntil {
            sleep 1;
            private _children = _pt call BIS_fnc_taskChildren;
            private _count = count _children;
            (_count > 0) && ({ _x call BIS_fnc_taskCompleted } count _children == _count)
        };
        [_pt, "SUCCEEDED"] call BIS_fnc_taskSetState;
    };
};

private _taskId = format ["OKS_Delivery_SecondaryTask_%1", floor (random 1000000)];
[
    true,
    [_taskId, _parentTask],
    [
        format ["You have been tasked to deliver %1 units of %2 to this area.", _amount, _typeLower],
        format ["%1: %2", _subObjectiveName, _amount],
        "Drop Off"
    ],
    nil,
    "CREATED",
    1,
    false,
    "box"
] call BIS_fnc_taskCreate;

waitUntil {
    sleep 10;
    private _valid = (list _trg) select { _x isKindOf _class && isNull (attachedTo _x) };
    (count _valid) >= _amount
};

private _delivered = (list _trg) select { _x isKindOf _class };

if (!isNil "ace_dragging_fnc_setDraggable") then {
    {
        [_x, false] call ace_dragging_fnc_setDraggable;
        [_x, false] call ace_dragging_fnc_setCarryable;
    } forEach _delivered;
};

[_taskId, "SUCCEEDED"] call BIS_fnc_taskSetState;
