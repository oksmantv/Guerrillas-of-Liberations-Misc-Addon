/*
	Author: OksmanTV from Guerrillas of Liberation
	onLoad handler for the OKS_M6RangeCard display.
	Arguments:
	0: Display
	Return Value: none
*/

private _display = _this select 0;
uiNamespace setVariable ["OKS_M6RangeCard_Display", _display];

_display displayAddEventHandler ["unload", {
    uiNamespace setVariable ["OKS_M6RangeCard_Display", nil];
}];

_display displayAddEventHandler ["mouseButtonDown", {
    params ["_disp", "_btn"];
    if (_btn == 1) then { _disp closeDisplay 0; };
}];

[0] call OKS_fnc_M6RangeCardStep;
