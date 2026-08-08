/*
Author: OksmanTV from Guerrillas of Liberation
Opens the M6 mortar range card display if not already open.
Arguments: none
Return Value: none
*/

if !(isNull (uiNamespace getVariable ["OKS_M6RangeCard_Display", displayNull])) exitWith {};

uiNamespace setVariable ["OKS_M6_CurrentCharge", 0];
(findDisplay 46) createDisplay "OKS_M6RangeCard";
