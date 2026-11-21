/*
 * OKS_fnc_OX3000_ComposeClass
 *
 * Class composer for the GOL OX3000 (mode/strength to classname).
 *
 * Arguments:
 * 0: Configurable values with "Mode" and "Power" <HASHMAP>
 *
 * Return Value:
 * OX3000 class name <STRING>
 */

params [["_attachment", createHashMap, [createHashMap]]];

private _className = format [
    "GOL_OX3000_%1_%2",
    _attachment getOrDefault ["Mode", "DP"],
    _attachment getOrDefault ["Power", "P1"]
];

if (!isClass (configFile >> "CfgWeapons" >> _className)) exitWith { "GOL_OX3000" };

_className
