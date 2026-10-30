/*
 * OKS_fnc_ProxRound_ShowRangeHint
 *
 * Displays the current absolute proximity-fuse range to the local gunner.
 *
 * Arguments:
 * 0: Original lased range in metres <NUMBER>
 * 1: Proximity fuse offset in metres <NUMBER>
 *
 * Return Value:
 * None
 */

params ["_laseRange", ["_offset", 0, [0]]];
_laseRange = round _laseRange;
_offset = round _offset;

private _rangeText = if (_offset isEqualTo 0) then {
    format ["%1 m", _laseRange]
} else {
    format ["%1 %2%3 m", _laseRange, if (_offset > 0) then {"+"} else {""}, _offset]
};

private _token = diag_tickTime;
missionNamespace setVariable ["OKS_ProxRound_HintToken", _token];

hintSilent parseText (
    "<t align='center'>" +
    "<img image='\a3\ui_f\data\IGUI\Cfg\Actions\ico_ON_ca.paa' size='2'/><br/>" +
    "<t size='1.5' font='PuristaBold' color='#FFFFFF'>Proximity Fuse</t><br/>" +
    "<t size='1.2' color='#66FF66'>RANGE SET</t><br/>" +
    format ["<t size='1.5' font='PuristaBold' color='#FFFFFF'>%1</t>", _rangeText] +
    "</t>"
);

[{
    params ["_token"];
    if (_token isEqualTo (missionNamespace getVariable ["OKS_ProxRound_HintToken", -1])) then {
        hintSilent "";
    };
}, [_token], 3.0] call CBA_fnc_waitAndExecute;
