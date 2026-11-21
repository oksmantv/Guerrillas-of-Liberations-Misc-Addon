/*
 * OKS_fnc_OX3000_ParseClass
 *
 * Class parser for the GOL OX3000 (mode/strength from CfgWeapons).
 * Reads the mode and strength from the CfgWeapons class, so legacy aliases resolve too.
 *
 * Arguments:
 * 0: OX3000 class name <STRING>
 *
 * Return Value:
 * Configurable values ["Mode", "Power"] <HASHMAP>
 */

params [["_className", "", [""]]];

private _config = configFile >> "CfgWeapons" >> _className;
private _mode = getText (_config >> "GOL_OX3000_Mode");
private _power = getText (_config >> "GOL_OX3000_Power");

if !(_mode in ["DP", "LS", "FL"]) then { _mode = "DP"; };
if !(_power in ["P1", "P2", "P3", "P4", "P5"]) then { _power = "P1"; };

createHashMapFromArray [["Mode", _mode], ["Power", _power]]
