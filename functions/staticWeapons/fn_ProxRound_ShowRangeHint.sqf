/*
 * OKS_fnc_ProxRound_ShowRangeHint
 *
 * Displays the current absolute proximity-fuse range to the local gunner.
 *
 * Arguments:
 * 0: Range in metres <NUMBER>
 *
 * Return Value:
 * None
 */

params ["_range"];

private _token = diag_tickTime;
missionNamespace setVariable ["OKS_ProxRound_HintToken", _token];

hintSilent parseText (
    "<t align='center'>" +
    "<img image='\a3\ui_f\data\IGUI\Cfg\Actions\ico_ON_ca.paa' size='2'/><br/>" +
    "<t size='1.5' font='PuristaBold' color='#FFFFFF'>Proximity Fuse</t><br/>" +
    "<t size='1.2' color='#66FF66'>RANGE SET</t><br/>" +
    format ["<t size='1.5' font='PuristaBold' color='#FFFFFF'>%1 m</t>", _range] +
    "</t>"
);

[{
    params ["_token"];
    if (_token isEqualTo (missionNamespace getVariable ["OKS_ProxRound_HintToken", -1])) then {
        hintSilent "";
    };
}, [_token], 3.0] call CBA_fnc_waitAndExecute;
