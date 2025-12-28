/*
    Convert packed drones into throwable FPV drone magazines.
    Uses BOT_FPV_Enhanced deploy logic (BOT_fnc_fpv_deploy) when thrown.
*/

private _args = _this;
if (_args isEqualType objNull) then {
    _args = [_args];
};

if (_args isEqualType []) then {
    // ACE/CBA progress callbacks sometimes wrap args in an extra array: [[...]]
    if ((count _args) == 1 && {(_args select 0) isEqualType []}) then {
        _args = _args select 0;
    };

    // Sometimes first param comes as [player] instead of player (or [[player], "AP"]). Flatten that.
    if ((count _args) >= 1 && {(_args select 0) isEqualType []}) then {
        private _first = _args select 0;
        if ((count _first) >= 1 && {(_first select 0) isEqualType objNull}) then {
            _args = [(_first select 0)] + (_args select [1]);
        };
    };
};

_args params [["_player", objNull, [objNull]], ["_variant", "", [""]]];

if (isNull _player) exitWith {false};

private _packedItem = "";
private _throwMag = "";

switch (toUpper _variant) do {
    case "AT": {
        _packedItem = "GOL_Packed_Drone_AT";
        _throwMag = "GOL_Mag_FPV_AT_Throw";
    };
    case "AP": {
        _packedItem = "GOL_Packed_Drone_AP";
        _throwMag = "GOL_Mag_FPV_AP_Throw";
    };
    default {
        _packedItem = _variant;
    };
};

if (_packedItem isEqualTo "" || _throwMag isEqualTo "") exitWith {
    systemChat "Invalid drone conversion type.";
    false
};

if (vehicle _player != _player) exitWith {
    systemChat "You must be on foot to convert drones.";
    false
};

private _hasItem = [_player, _packedItem, true] call BIS_fnc_hasItem;
if (!_hasItem) exitWith {
    systemChat "You do not have that packed drone.";
    false
};

if !(_player canAdd _throwMag) exitWith {
    systemChat "No inventory space for throwable drone.";
    false
};

_player removeItem _packedItem;
_player addMagazine _throwMag;
systemChat "Converted packed drone to throwable.";
true
