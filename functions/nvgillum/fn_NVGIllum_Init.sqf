/*
 * OKS_fnc_NVGIllum_Init
 *
 * Publishes the saved NVG illuminator level on the player unit (also after
 * respawn / unit change), so every client renders this player's light the same.
 */

["unit", {
    params ["_unit"];
    private _level = ((profileNamespace getVariable ["OKS_NVGIllum_Level", 2]) max 1) min 5;
    _unit setVariable ["OKS_NVGIllum_Level", _level, true];
}, true] call CBA_fnc_addPlayerEventHandler;
