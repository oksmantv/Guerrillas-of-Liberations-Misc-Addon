/*
	Author: OksmanTV
	Collects headgear from the gearbox/arsenal compatible items and registers
	them as wireless-intercom-capable for TFAR.  Called from the gear framework
	after the arsenal box is initialised (gearbox case in fnc_Handler).

	Accumulates across factions (Blufor/Opfor/Independent) — each call appends
	rather than overwrites, so the final list contains headgear from every side.

	Arguments:
	0: _helmet          — base helmet pool        <STRING or ARRAY>
	1: _OfficerHelmet   — officer/lead helmet     <STRING or ARRAY or nil>
	2: _compatibleItems — full arsenal item list   <ARRAY>

	Return Value: NONE

	Example:
	[_helmet, _OfficerHelmet, _compatibleItems] call OKS_fnc_CollectIntercomHeadgear;
*/

if (isNil "TFAR_fnc_setIntercomChannel") exitWith {};

params [
	["_helmet", "", ["", []]],
	["_officerHelmet", "", ["", []]],
	["_compatibleItems", [], [[]]]
];

private _existingVal = missionNamespace getVariable ["TFAR_externalIntercomWirelessHeadgear", []];
private _intercomHeadgear = if (_existingVal isEqualType []) then { _existingVal } else { [] };

// Collect base helmet pool
if (_helmet isEqualType []) then {
	{ _intercomHeadgear pushBackUnique _x } forEach _helmet;
} else {
	if (_helmet != "") then { _intercomHeadgear pushBackUnique _helmet };
};

// Collect officer helmet
if (!isNil "_officerHelmet" && {!(_officerHelmet isEqualTo "")}) then {
	if (_officerHelmet isEqualType []) then {
		{ _intercomHeadgear pushBackUnique _x } forEach _officerHelmet;
	} else {
		_intercomHeadgear pushBackUnique _officerHelmet;
	};
};

// Scan compatibleItems for any headgear we may have missed
// (ItemInfo type 605 = headgear in CfgWeapons)
{
	private _cfg = configFile >> "CfgWeapons" >> _x >> "ItemInfo";
	if (isClass _cfg && {getNumber (_cfg >> "type") == 605}) then {
		_intercomHeadgear pushBackUnique _x;
	};
} forEach _compatibleItems;

if (count _intercomHeadgear > 0) then {
	TFAR_externalIntercomWirelessHeadgear = _intercomHeadgear;
	publicVariable "TFAR_externalIntercomWirelessHeadgear";
};
