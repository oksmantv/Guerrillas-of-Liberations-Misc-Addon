/*
 * OKS_fnc_BettIR_onStepper
 *
 * Replaces BettIR's "not implemented" Stepper user actions.
 * GOL OX3000 mounted: adjusts its strength (the OX3000 is not a BettIR device).
 * Otherwise: runs the mounted BettIR device's onStepperUp / onStepperDown handler.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Stepper index (0 = Stepper #1, 1 = Stepper #2) <NUMBER>
 * 2: Direction (+1 up / -1 down) <NUMBER>
 */

params [["_unit", objNull, [objNull]], ["_stepperIndex", 0, [0]], ["_direction", 1, [0]]];

if (is3DEN || {isNull _unit} || {!alive _unit}) exitWith {};

private _pointer = (primaryWeaponItems _unit) param [1, ""];
if (_pointer != "" && {_pointer isKindOf ["GOL_OX3000", configFile >> "CfgWeapons"]}) exitWith {
    [_direction] call OKS_fnc_OX3000_AdjustStrength;
};

private _attachmentArray = _unit getVariable ["BettIR_primaryWeaponAttachment", [[], []]];
private _attachment = (_attachmentArray # 0) createHashMapFromArray (_attachmentArray # 1);
private _macro = _attachment getOrDefault ["__BETTIR_MACRO", ""];
if (_macro == "") exitWith {};

private _handler = getText (configFile >> "BettIR_Config" >> "CompatibleAttachments" >> _macro >> (["onStepperDown", "onStepperUp"] select (_direction > 0)));

if (_handler != "") then {
    [_unit, _stepperIndex] call (compile _handler);
};
