/*
 * GOL patch of BettIR_NVG_fnc_validateUnitLight.
 *
 * Same reconcile logic as BettIR NVG (events + 1 s correction loop), but the lit
 * intensity follows the unit's GOL level instead of BettIR's fixed 0.75.
 * OKS_NVGIllum_Level 1-5 = 20-100%, where 100% = 0.2625 (35% of BettIR stock 0.75).
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Nightvision state from an event payload (optional) <BOOL>
 */

params ["_unit", ["_inNV", nil]];

private _wantsLight = _unit getVariable ["BettIR_nvg_illuminator_on", false];
private _light = _unit getVariable ["BettIR_nvg_illuminator", objNull];

if (!_wantsLight && {isNull _light}) exitWith {};

if (isNil "_inNV") then {
    _inNV = (currentVisionMode _unit) != 0;
};

private _shouldBeLit = _wantsLight
    && {_inNV}
    && {([_unit] call BettIR_NVG_fnc_getUnitNvgDevice) != ""};

if (_shouldBeLit) exitWith {
    if (isNull _light) then {
        _light = [_unit] call BettIR_NVG_fnc_createLight;
    };
    private _level = ((_unit getVariable ["OKS_NVGIllum_Level", 2]) max 1) min 5;
    _light setLightIntensity (_level * 0.0672);
};

if (!isNull _light) then {
    _light setLightIntensity 0;
};
