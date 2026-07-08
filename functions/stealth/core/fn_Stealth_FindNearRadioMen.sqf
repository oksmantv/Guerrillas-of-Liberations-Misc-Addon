/*
    Finds nearby friendly units with radios for a given unit or group.

    Returns:
    [BOOL hasRadioNearby, ARRAY radioUnits]
*/

params ["_unitOrGroup"];

private _nearFriendliesWithRadio = [];

switch (typeName _unitOrGroup) do {
    case "OBJECT": {
        private _unit = _unitOrGroup;
        private _side = side group _unit;
        _nearFriendliesWithRadio = (_unit nearEntities ["Man", 100]) select {
            !isPlayer _x
            && { side group _x == _side }
            && { _x getVariable ["GOL_HasRadio", false] }
            && { alive _x }
            && { isNil "ace_common_fnc_isAwake" || { [_x] call ace_common_fnc_isAwake } }
        };
    };
    case "GROUP": {
        _nearFriendliesWithRadio = units _unitOrGroup select {
            _x getVariable ["GOL_HasRadio", false]
            && { alive _x }
            && { isNil "ace_common_fnc_isAwake" || { [_x] call ace_common_fnc_isAwake } }
        };
    };
    default {
        _nearFriendliesWithRadio = [];
    };
};

[count _nearFriendliesWithRadio > 0, _nearFriendliesWithRadio]
