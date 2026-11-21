/*
 * OKS_fnc_OX3000_AdjustStrength
 *
 * Steps the mounted OX3000 strength (P1-P5) up or down for the local player.
 * Only applies on foot, with the primary weapon selected, in DP or FL mode.
 * The variant is swapped in place and the light is switched back on if it was on.
 *
 * Arguments:
 * 0: Step (+1 / -1). 0 only checks whether the input would be handled <NUMBER>
 *
 * Return Value:
 * True when the strength control handled the input <BOOL>
 */

params [["_step", 0, [0]]];

private _unit = player;
private _weapon = primaryWeapon _unit;

if (
    !alive _unit ||
    {_weapon == ""} ||
    {vehicle _unit != _unit} ||
    {currentWeapon _unit != _weapon} ||
    {_unit getVariable ["ace_dragging_isCarrying", false]} ||
    {_unit getVariable ["ace_dragging_isDragging", false]}
) exitWith { false };

private _item = (primaryWeaponItems _unit) param [1, ""];
if (_item == "" || {!(_item isKindOf ["GOL_OX3000", configFile >> "CfgWeapons"])}) exitWith { false };

private _showHint = {
    params ["_title", "_text"];
    private _image = getText (configFile >> "CfgWeapons" >> _item >> "picture");
    if (_image == "") then { _image = "\A3\weapons_F\Data\UI\gear_accv_pointer_CA.paa" };
    hintSilent parseText format [
        "<t align='center'><img image='%1' size='2'/><br/>" +
        "<t size='1.5' font='PuristaBold' color='#FFFFFF'>%2</t><br/>" +
        "<t size='1.2' color='#FFFFFF'>%3</t></t>",
        _image,
        _title,
        _text
    ];
    [{ hintSilent "" }, [], 3.5] call CBA_fnc_waitAndExecute;
};

private _state = [_item] call OKS_fnc_OX3000_ParseClass;
if ((_state get "Mode") == "LS") exitWith {
    if (_step != 0) then {
        ["OX3000 IR", "No strength setting"] call _showHint;
    };
    false
};

if (_step == 0) exitWith { true };

// Ignore wheel bursts until the previous variant swap has been applied.
if (diag_tickTime < (missionNamespace getVariable ["OKS_OX3000_NextAdjustTime", 0])) exitWith { true };

private _steps = ["P1", "P2", "P3", "P4", "P5"];
private _index = _steps find (_state get "Power");
private _newIndex = ((_index + _step) max 0) min ((count _steps) - 1);
private _modeName = ["OX3000 Dual", "OX3000 Flashlight"] select ((_state get "Mode") == "FL");

if (_newIndex != _index) then {
    _state set ["Power", _steps select _newIndex];
    private _newClass = [_state] call OKS_fnc_OX3000_ComposeClass;
    private _wasOn = (_unit isIRLaserOn _weapon) || {_unit isFlashlightOn _weapon};
    if (_wasOn) then {
        _unit action ["IRLaserOff", _unit];
        _unit action ["GunLightOff", _unit];
    };
    _unit addPrimaryWeaponItem _newClass;
    // Light parameters only refresh when toggled after the swap frame.
    if (_wasOn) then {
        [{
            params ["_unit"];
            if (alive _unit) then {
                _unit action ["IRLaserOn", _unit];
                _unit action ["GunLightOn", _unit];
            };
        }, [_unit], 0.1] call CBA_fnc_waitAndExecute;
    };
    missionNamespace setVariable ["OKS_OX3000_NextAdjustTime", diag_tickTime + 0.15];
    playSound "ClickSoft";
};

[_modeName, format ["Strength %1%%", (_newIndex + 1) * 20]] call _showHint;

true
