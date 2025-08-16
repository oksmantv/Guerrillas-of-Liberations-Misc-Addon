/*
    Undercover AI Function

    [_this] spawn OKS_fnc_UndercoverAI;
*/
params [
    "_Unit",
    ["_UndercoverArrayString",missionNamespace getVariable ["GOL_UndercoverAI_WeaponsArray",""],[[]]]
];

_Debug = missionNamespace getVariable ["GOL_UndercoverAI_Debug", false];
if(_UndercoverArrayString == "") exitWith {
    if(_Debug) then {
        "[UndercoverAI] No weapons array defined, exiting." spawn OKS_fnc_LogDebug;
    };
};

private _UndercoverArray = call compile _UndercoverArrayString;
_WeaponsArray = selectRandom _UndercoverArray;
_WeaponsArray params ["_WeaponClass","_MagazineClass"];
if(_Debug) then {
    format ["[UndercoverAI] Unit: %1 | WeaponsArray: %2", _Unit, _WeaponsArray] spawn OKS_fnc_LogDebug;
};

waitUntil {sleep 2; _Unit getVariable ["GOL_SelectedRole",[]] isNotEqualTo []};
_Unit addVest "UK3CB_V_Invisible";
_Unit addMagazines [_MagazineClass, 10];
_Unit setVariable ["GOL_UndercoverAI", true, true];
_Unit setVariable ["GOL_UndercoverAI_Weapon", _WeaponClass, true];
if(_Debug) then {
    format ["[UndercoverAI] Ready: %1 added Vest and Magazines.", _Unit] spawn OKS_fnc_LogDebug;
};