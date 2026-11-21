/*
 * GOL patch of BettIR_Attachments_fnc_canUnitUseLaserDevice.
 *
 * Same checks as BettIR, plus: the GOL OX3000 is never handled by BettIR.
 * BettIR's L-key hook and power buttons exit here, so the OX3000 only follows
 * the engine light toggle and GOL scripts.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * True when BettIR may drive the unit's laser device <BOOL>
 */

params ["_unit"];

if (!(alive _unit)) exitWith { false };
if ((currentMuzzle _unit) != (primaryWeapon _unit)) exitWith { false };
if ((currentMuzzle _unit) in (getArray (configFile >> "CfgWeapons" >> primaryWeapon _unit >> "muzzles"))) exitWith { false };

private _pointer = (primaryWeaponItems _unit) param [1, ""];
if (_pointer != "" && {_pointer isKindOf ["GOL_OX3000", configFile >> "CfgWeapons"]}) exitWith { false };

true
