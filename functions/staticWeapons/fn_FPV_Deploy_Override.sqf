/*
    Deploy a throwable FPV drone using per-side CBA settings.

    This replaces the BOT_fnc_fpv_deploy selection mechanism (which relies on config BOT_vehicleSide[])
    so missions can change the spawned vehicle class at runtime per faction.

    Params:
      0: Projectile <OBJECT>
*/

params ["_projectile"];

if (isNull _projectile) exitWith {};
if (!local _projectile) exitWith {};

// Let the projectile travel a bit (ACE throwing especially).
sleep 1;

if (isNull _projectile) exitWith {};

private _unit = getShotParents _projectile # 0;
if (isNull _unit) exitWith {};

private _ammoClass = typeOf _projectile;
private _pPosASL = getPosASL _projectile;
private _pVel = velocity _projectile;
private _uDir = getDir _unit;

_projectile setPosASL [0, 0, 0];
deleteVehicle _projectile;

private _sideKey = switch (side group _unit) do {
    case WEST: {"BLUFOR"};
    case EAST: {"OPFOR"};
    case independent: {"INDEPENDENT"};
    default {"BLUFOR"};
};

private _spawnSettingBase = getText (configFile >> "CfgAmmo" >> _ammoClass >> "GOL_spawnSetting");
private _spawnClass = "";

if !(_spawnSettingBase isEqualTo "") then {
    _spawnClass = missionNamespace getVariable [format ["%1_%2", _spawnSettingBase, _sideKey], ""];
    if (_spawnClass isEqualTo "") then {
        _spawnClass = missionNamespace getVariable [_spawnSettingBase, ""];
    };
};

if (_spawnClass isEqualTo "") then {
    private _sidesUAV = getArray (configFile >> "CfgAmmo" >> _ammoClass >> "BOT_vehicleSide");
    if !(_sidesUAV isEqualTo []) then {
        _spawnClass = switch (side group _unit) do {
            case WEST: { _sidesUAV select 0 };
            case EAST: { _sidesUAV select 1 };
            case independent: { _sidesUAV select 2 };
            case civilian: { _sidesUAV select 3 };
        };
    };
};

if (_spawnClass isEqualTo "") exitWith {
    diag_log format ["OKS_GOL_Misc: FPV deploy aborted (no spawn class). Ammo=%1 Side=%2", _ammoClass, _sideKey];
};

private _uav = createVehicle [_spawnClass, [0, 0, 0], [], 0, "FLY"];
createVehicleCrew _uav;

_uav setPosASL _pPosASL;
_uav setDir _uDir;
_uav setVelocity _pVel;

private _flyHeight = (ASLToAGL eyePos driver _uav) # 2;
_uav flyInHeight _flyHeight;

// Always try to connect the thrower on their client.
if (isPlayer _unit && {!(isNil "OKS_fnc_FPV_Connect_Client")}) then {
    [_uav] remoteExecCall ["OKS_fnc_FPV_Connect_Client", _unit];
};
