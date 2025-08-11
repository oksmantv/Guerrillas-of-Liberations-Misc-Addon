/*
    Setup Paradrop Equipment
*/

Params ["_Player"];

[_Player] call zade_boc_fnc_actionOnChest;
_Player unlinkItem "ItemWatch";
_Player linkItem "ACE_Altimeter";
_Player addBackpack "B_Parachute";

systemChat "You have been given a parachute and altimeter. Use the altimeter to deploy your parachute at the right altitude. Your backpack is attached to your chest.";
