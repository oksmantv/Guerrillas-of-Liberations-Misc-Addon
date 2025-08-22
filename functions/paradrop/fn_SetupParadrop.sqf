/*
    Setup Paradrop Equipment
*/

Params [
    "_Player",
    ["_StaticParachuteEnabled", (missionNamespace getVariable ["STATIC_PARACHUTE_ENABLED", false]), [true]]
];

private _Text = "";
[_Player] call zade_boc_fnc_actionOnChest;
_Player unlinkItem "ItemWatch";
_Player linkItem "ACE_Altimeter";

if(_StaticParachuteEnabled) then {
    _Player addBackpack "rhsusf_eject_Parachute_backpack";
    _Text = "static";
} else {
    _Player addBackpack "B_Parachute";
    _Text = "steerable";
};

systemChat format["You have been given a %1 parachute and altimeter. Your backpack has been attached to your chest.",_Text];
