/*
    Global Killed Event Handler for all units.
    Registers a missionEventHandler ["EntityKilled", ...] on all clients (server, HC, players).
    Ensures only one global score addition per kill using a variable on the killed unit.
*/

// Only run on server and headless clients (not player clients),
// but allow if this is a local server (hasInterface && isServer) for debugging
if (hasInterface && !isServer) exitWith {};

private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug", false];
if(_Debug) then {
	format["[KILLS] Registering Global Killed Event Handler"] spawn OKS_fnc_LogDebug;
};

if (isNil "GOL_GlobalKilledEventHandler_Registered") then {
    GOL_GlobalKilledEventHandler_Registered = true;
    
    addMissionEventHandler ["EntityKilled", {
        params ["_unit", "_killer", "_instigator"];
        private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug", false];

        // Only process if not already handled
        if (_unit getVariable ["GOL_ScoreAdded", false]) exitWith {};
        _unit setVariable ["GOL_ScoreAdded", true, true]; // sync to all
        
        // Only update global score on server
        if (isServer) then {
			if(isPlayer _killer || isPlayer _instigator) then {
				// Combatant Killed Logic
				if (!(_unit getVariable ["GOL_NonCombatant", false]) && side (group _unit) != civilian) then {
					if (_unit getVariable ["GOL_ScoreAdded", false]) exitWith {};

					// Eneky Killed Logic
					if ((side (group _unit)) getFriend (side (group _killer)) > 0.6 || (side (group _unit)) getFriend (side (group _instigator)) < 0.6) then {
						private _enemyKilledCount = missionNamespace getVariable ["GOL_EnemiesKilled", 0];
						_enemyKilledCount = _enemyKilledCount + 1;
						missionNamespace setVariable ["GOL_EnemiesKilled", _enemyKilledCount, true];
						// Debug/logging
						private _name = name _unit;
						if (isNil "_name" || {_name isEqualTo ""}) then { _name = typeOf _unit; };
						
						if (_Debug) then {
							format["[KILLS] %1 killed by %2 - Total Score: %3", _name, name _killer, _enemyKilledCount] spawn OKS_fnc_LogDebug;
						};
					};
					// Friendly fire check
					if ((side (group _unit)) getFriend (side (group _killer)) > 0.6 || (side (group _unit)) getFriend (side (group _instigator)) > 0.6) then {
						private _friendlyFireKills = missionNamespace getVariable ["GOL_FriendlyFireKills", 0];
						_friendlyFireKills = _friendlyFireKills + 1;
						missionNamespace setVariable ["GOL_FriendlyFireKills", _friendlyFireKills, true];
						format["[KILLS] Friendly Fire AI: %1 killed by %2 (%3)", _name, name _instigator, name _killer] spawn OKS_fnc_LogDebug;
					};
				};

				// Civilian kill logic
				if (_unit getVariable ["GOL_NonCombatant", true] && side (group _unit) == civilian) then {
					if (_unit getVariable ["GOL_ScoreAdded", false]) exitWith {};
					
					private _civilianKilledCount = missionNamespace getVariable ["GOL_CiviliansKilled", 0];
					_civilianKilledCount = _civilianKilledCount + 1;
					missionNamespace setVariable ["GOL_CiviliansKilled", _civilianKilledCount, true];
					[10] call OKS_fnc_IncreaseMultiplier;

					private _name = name _unit;
					if (isNil "_name" || {_name isEqualTo ""}) then { _name = typeOf _unit; };
					if (_Debug) then {
						format["[KILLS] %1 killed (civilian) by %2 - Total Civilians: %3", _name, name _killer, _civilianKilledCount] spawn OKS_fnc_LogDebug;
					};
				};

				// Captive kill logic
				if (_unit getVariable ["GOL_CaptiveKilled", false]) exitWith {};
				if (_unit getVariable ["GOL_IsCaptive", false]) then {
					_unit setVariable ["GOL_CaptiveKilled", true, true];
					if (_unit getVariable ["GOL_ScoreAdded", false]) exitWith {};
					private _civilianKilledCount = missionNamespace getVariable ["GOL_CiviliansKilled", 0];
					_civilianKilledCount = _civilianKilledCount + 1;
					missionNamespace setVariable ["GOL_CiviliansKilled", _civilianKilledCount, true];

					[15] call OKS_fnc_IncreaseMultiplier;
					if (_Debug) then {
						format["[KILLS] %1 killed (captive) by %2 - Total Captives: %3", _name, name _killer, _captiveKilledCount] spawn OKS_fnc_LogDebug;
					};
				};
			} else {
				// Killed by environment or unknown
				private _name = name _unit;
				if (isNil "_name" || {_name isEqualTo ""}) then { _name = typeOf _unit; };
				if (_Debug) then {
					format["[KILLS] NotPlayer: %1 killed by %2 (%3) - Instigator %4 (%5)", _name, name _killer, _killer, name _instigator, _instigator] spawn OKS_fnc_LogDebug;
				};
			}
        };
    }];
}
