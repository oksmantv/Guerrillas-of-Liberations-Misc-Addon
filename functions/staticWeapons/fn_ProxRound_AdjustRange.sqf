/*
 * OKS_fnc_ProxRound_AdjustRange
 *
 * Changes the local gunner's absolute proximity-fuse range by one metre.
 * The range is local because the Fired event handler runs on the gunner's
 * client, which also owns proximity-round tracking.
 *
 * Arguments:
 * 0: Adjustment in metres (+1 or -1) <NUMBER>
 *
 * Return Value:
 * True when the proximity-range control handled the input <BOOL>
 */

params ["_adjustment"];

private _unit = player;
private _vehicle = vehicle _unit;

if (
    _vehicle isEqualTo _unit ||
    {gunner _vehicle != _unit} ||
    {!(_vehicle getVariable ["OKS_ProxRound_Capable", false])} ||
    {!(_vehicle getVariable ["OKS_ProxRound_Active", false])}
) exitWith { false };

private _range = _unit getVariable ["OKS_ProxRound_Range", -1];
if (_range < 1) then {
    _range = currentZeroing _unit;
};

if (_range < 1) exitWith {
    hintSilent parseText (
        "<t align='center'>" +
        "<img image='\a3\ui_f\data\IGUI\Cfg\Actions\ico_ON_ca.paa' size='2'/><br/>" +
        "<t size='1.5' font='PuristaBold' color='#FFFFFF'>Proximity Fuse</t><br/>" +
        "<t size='1.2' color='#FFB300'>LASE TARGET FIRST</t>" +
        "</t>"
    );
    true
};

_range = (_range + _adjustment) max 1;
_unit setVariable ["OKS_ProxRound_Range", _range];
[_range] call OKS_fnc_ProxRound_ShowRangeHint;

true
