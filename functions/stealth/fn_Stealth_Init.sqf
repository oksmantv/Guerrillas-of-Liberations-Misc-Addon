/*
	Function: OKS_fnc_Stealth_Init
	
	Description:
		Initializes the OKS Stealth system including player tracking, AI trackers, 
		enemy radio chatter, and ambient dialogue.
	
	Parameter(s):
		None
	
	Returns:
		BOOL - True if initialization successful
	
	Example:
		[] call OKS_fnc_Stealth_Init;
*/

if (!isServer && !hasInterface) exitWith {false};

// ACE fallback for isAwake function
if (isNil "ace_common_fnc_isAwake") then {
	ace_common_fnc_isAwake = {params ["_unit"]; alive _unit};
};

// Initialize global variables
OKS_HuntedGroups = [];
GOL_OKS_Stealth_Mission = 1;
publicVariable "GOL_OKS_Stealth_Mission";
publicVariable "OKS_HuntedGroups";

// Only run on server/HC
if (hasInterface && !isServer) exitWith {false};

private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];

if (_debug) then {
	format ["[STEALTH] Initializing stealth system..."] spawn OKS_fnc_LogDebug;
};

// Apply camouflage coefficient to all existing players
{
	if (isPlayer _x) then {
		[_x] call OKS_fnc_Stealth_ApplyCamouflage;
	};
} forEach allUnits;

// Start Enemy Radio system if enabled
if (missionNamespace getVariable ["GOL_OKS_Enemy_Radio", false]) then {
	private _enemyFaction = missionNamespace getVariable ["GOL_OKS_Enemy_Faction", east];
	[_enemyFaction] spawn OKS_fnc_Stealth_Enemy_Radio;
	if (_debug) then {
		format ["[STEALTH] Enemy Radio system started for faction: %1", _enemyFaction] spawn OKS_fnc_LogDebug;
	};
};

// Start Tracker system if enabled
if (missionNamespace getVariable ["GOL_OKS_Tracker", false]) then {
	waitUntil {sleep 5; !isNil "OKS_fnc_Stealth_Hunted"};
	{
		if (isPlayer (leader _x)) then {
			[_x] spawn OKS_fnc_Stealth_Hunted;
			if (_debug) then {
				format ["[STEALTH] Started tracking for player group: %1", groupId _x] spawn OKS_fnc_LogDebug;
			};
		};
	} forEach allGroups;
	if (_debug) then {
		format ["[STEALTH] Player tracking system initialized"] spawn OKS_fnc_LogDebug;
	};
};

if (_debug) then {
	format ["[STEALTH] Stealth system initialization complete"] spawn OKS_fnc_LogDebug;
};
true
