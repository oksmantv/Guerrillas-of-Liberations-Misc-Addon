/*
 * OKS_fnc_NVGIllum_Adjust
 *
 * Steps the local player's BettIR NVG illuminator strength (20-100%).
 * Only while NVGs are down and the illuminator is on. The level is public so
 * every client lights this player the same, and saved to the profile.
 *
 * Arguments:
 * 0: Step (+1 / -1) <NUMBER>
 *
 * Return Value:
 * True when the input was handled <BOOL>
 */

params [["_step", 0, [0]]];

private _unit = player;

if (
    !alive _unit ||
    {currentVisionMode _unit == 0} ||
    {!(_unit getVariable ["BettIR_nvg_illuminator_on", false])}
) exitWith { false };

private _level = ((_unit getVariable ["OKS_NVGIllum_Level", 2]) max 1) min 5;
private _newLevel = ((_level + _step) max 1) min 5;

if (_newLevel != _level) then {
    _unit setVariable ["OKS_NVGIllum_Level", _newLevel, true];
    profileNamespace setVariable ["OKS_NVGIllum_Level", _newLevel];
    [_unit, true] call BettIR_NVG_fnc_validateUnitLight;
    playSound "ClickSoft";
};

private _image = getText (configFile >> "CfgWeapons" >> ([_unit] call BettIR_NVG_fnc_getUnitNvgDevice) >> "picture");
if (_image == "") then { _image = "\A3\weapons_F\Data\UI\gear_nvg_CA.paa" };

hintSilent parseText format [
    "<t align='center'><img image='%1' size='2'/><br/>" +
    "<t size='1.5' font='PuristaBold' color='#FFFFFF'>%2</t><br/>" +
    "<t size='1.2' color='#FFFFFF'>%3</t></t>",
    _image,
    "NVG Illuminator",
    format ["Strength %1%%", _newLevel * 20]
];
[{ hintSilent "" }, [], 3.5] call CBA_fnc_waitAndExecute;

true
