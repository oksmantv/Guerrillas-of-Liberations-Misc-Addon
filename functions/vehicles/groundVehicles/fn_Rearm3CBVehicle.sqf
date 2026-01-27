/*
    Rearm 3CB vehicles that rely on cargo magazines (e.g., UK3CB vehicles).

    Behavior:
    - Only applies to vehicles with classname prefix "UK3CB_BAF"
    - Determines required magazine classnames from turret config (CfgVehicles >> Turrets >> magazines[])
    - Only considers vehicle cargo (getMagazineCargo)
    - Tops each required magazine up to a maximum of 6 in cargo
    - Never removes magazines
    - If nothing needed, reports to the requesting player: "This vehicle does not require resupply."

    Usage:
    [_vehicle] call OKS_fnc_Rearm3CBVehicle;                 // server-only, no message
    [_vehicle, player] call OKS_fnc_Rearm3CBVehicle;         // will message player if nothing was added
*/

params [
    ["_vehicle", objNull, [objNull]],
    ["_player", objNull, [objNull]]
];

if (!isServer) exitWith {
    // Run on server so cargo updates replicate globally.
    [_vehicle, _player] remoteExec ["OKS_fnc_Rearm3CBVehicle", 2];
};

if (isNull _vehicle || {!alive _vehicle}) exitWith {
    if (!isNull _player) then {
        ["This vehicle does not require resupply."] remoteExecCall ["systemChat", _player];
    };
};

private _type = typeOf _vehicle;
if ((_type find "UK3CB_BAF") != 0) exitWith {
    if (!isNull _player) then {
        ["This vehicle does not require resupply."] remoteExecCall ["systemChat", _player];
    };
};

// Prevent spam/double execution.
if (_vehicle getVariable ["OKS_Rearm3CBVehicle_busy", false]) exitWith {};
_vehicle setVariable ["OKS_Rearm3CBVehicle_busy", true, true];

private _requiredMags = _vehicle getVariable ["OKS_3CB_requiredMags", []];

if (_requiredMags isEqualTo []) then {
    private _mags = [];
    private _turrets = allTurrets [_vehicle, true];
    {
        private _turretCfg = [_vehicle, _x] call BIS_fnc_turretConfig;
        if (!isNull _turretCfg) then {
            _mags append (getArray (_turretCfg >> "magazines"));
        };
    } forEach _turrets;

    // Unique + only 3CB mag classes.
    _mags = _mags arrayIntersect _mags;
    _mags = _mags select {
        _x isEqualType "" &&
        {_x != ""} &&
        {(_x find "UK3CB_BAF_") == 0} &&
        {isClass (configFile >> "CfgMagazines" >> _x)}
    };

    _requiredMags = _mags;
    _vehicle setVariable ["OKS_3CB_requiredMags", _requiredMags, true];
};

if (_requiredMags isEqualTo []) exitWith {
    _vehicle setVariable ["OKS_Rearm3CBVehicle_busy", false, true];
    if (!isNull _player) then {
        ["This vehicle does not require resupply."] remoteExecCall ["systemChat", _player];
    };
};

private _cargo = getMagazineCargo _vehicle;
private _cargoMags = _cargo # 0;
private _cargoCounts = _cargo # 1;

private _addedAny = false;
{
    private _mag = _x;
    private _idx = _cargoMags find _mag;
    private _count = if (_idx >= 0) then {_cargoCounts # _idx} else {0};

    if (_count < 6) then {
        _vehicle addMagazineCargoGlobal [_mag, 6 - _count];
        _addedAny = true;
    };
} forEach _requiredMags;

_vehicle setVariable ["OKS_Rearm3CBVehicle_busy", false, true];

if (!_addedAny && {!isNull _player}) then {
    ["This vehicle does not require resupply."] remoteExecCall ["systemChat", _player];
};
