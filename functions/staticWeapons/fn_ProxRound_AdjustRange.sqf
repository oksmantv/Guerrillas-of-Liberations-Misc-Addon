/*
 * OKS_fnc_ProxRound_AdjustRange
 *
 * Changes the local gunner's proximity-fuse offset by the supplied adjustment.
 * The offset is constrained to -5 to +5 metres from the last lased FCS solution;
 * native Arma zeroing is intentionally never modified.
 * The range is local because the Fired event handler runs on the gunner's
 * client, which also owns proximity-round tracking.
 *
 * Arguments:
 * 0: Adjustment in metres (+1 or -1 for default controls) <NUMBER>
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

private _laseRange = _unit getVariable ["OKS_ProxRound_LaseRange", -1];
if (_laseRange < 1) then {
    _laseRange = round (currentZeroing _unit);
};

if (_laseRange < 1) exitWith {
    hintSilent parseText (
        "<t align='center'>" +
        "<img image='\a3\ui_f\data\IGUI\Cfg\Actions\ico_ON_ca.paa' size='2'/><br/>" +
        "<t size='1.5' font='PuristaBold' color='#FFFFFF'>Proximity Fuse</t><br/>" +
        "<t size='1.2' color='#FFB300'>LASE TARGET FIRST</t>" +
        "</t>"
    );
    true
};

private _offset = _unit getVariable ["OKS_ProxRound_RangeOffset", 0];
_offset = ((_offset + _adjustment) max -5) min 5;
private _range = (_laseRange + _offset) max 1;

_unit setVariable ["OKS_ProxRound_LaseRange", _laseRange];
_unit setVariable ["OKS_ProxRound_RangeOffset", _offset];
_unit setVariable ["OKS_ProxRound_Range", _range];
[_laseRange, _offset] call OKS_fnc_ProxRound_ShowRangeHint;

true
