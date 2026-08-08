/*
	Author: OksmanTV from Guerrillas of Liberation
	Steps the M6 range card display to the next or previous charge.
	Arguments:
	0: Delta <NUMBER> — +1 for next charge, -1 for previous, 0 to refresh
	Return Value: none
*/

params ["_delta"];
format ["[M6RangeCard] Step called with delta: %1", _delta] spawn OKS_fnc_LogDebug;

private _display = uiNamespace getVariable ["OKS_M6RangeCard_Display", displayNull];
if (isNull _display) exitWith {
    "[M6RangeCard] Step exitWith: display is null" spawn OKS_fnc_LogDebug;
};

private _current = uiNamespace getVariable ["OKS_M6_CurrentCharge", 0];
private _new = (_current + _delta) max 0 min 3;
uiNamespace setVariable ["OKS_M6_CurrentCharge", _new];

private _imagePath = format ["\UK3CB_BAF_Weapons\addons\UK3CB_BAF_Weapons_Static\data\M6_charge%1_ca.paa", _new];
format ["[M6RangeCard] Setting image: %1", _imagePath] spawn OKS_fnc_LogDebug;

(_display displayCtrl 9602) ctrlSetText _imagePath;
