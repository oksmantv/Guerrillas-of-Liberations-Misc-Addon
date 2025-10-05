/*
    Global Killed Event Handler for all units.
    Registers a missionEventHandler ["EntityKilled", ...] on all non-interface clients (server & HC).
    Ensures only one global score addition per kill using a variable on the killed unit.
*/

// Only run on server and headless clients (not player clients),
// but allow if this is a local server (hasInterface && isServer) for debugging
private _Debug = missionNamespace getVariable ["GOL_Kills_Debug", false];
if (hasInterface && !isServer) exitWith {
	if(_Debug) then {
		format["[KILLS] HasInterface and isn't server. Exiting"] spawn OKS_fnc_LogDebug;
	};
};

if(_Debug) then {
	format["[KILLS] Registering Global Killed Event Handler."] spawn OKS_fnc_LogDebug;
};

if (isNil "GOL_GlobalKilledEventHandler_Registered") then {
    GOL_GlobalKilledEventHandler_Registered = true;
    
    addMissionEventHandler ["EntityKilled", {
        params ["_unit", "_killer", "_instigator"];
		private _Debug = missionNamespace getVariable ["GOL_Kills_Debug", false];
		if (local _unit) then {
			if (_Debug) then {
				"[KILLS] EntityKilled Event: IsLocal" spawn OKS_fnc_LogDebug;
			};			
			if(!(_unit isKindOf "CAManBase")) exitWith {
				if(_Debug) then {
					format["[KILLS] EntityKilled Event Exited: Not CAManBase (%1).", typeOf _unit] spawn OKS_fnc_LogDebug;
				};
			};
			if (isNull _instigator) then { _instigator = (UAVControl (vehicle _killer)) select 0 };
			if (isNull _instigator) then { _instigator = _killer };

			// Determine sides and relationships
			private _PlayerSide 				 = missionNamespace getVariable ["GOL_PlayerSide", west];
			private _SideUnit 					 = (side (group _unit));
			private _SideKiller 				 = (side (group _killer));
			private _SideInstigator 			 = (side (group _instigator));
			private _KillerOrInstigatorIsPlayer  = (isPlayer _killer) || (isPlayer _instigator) && !(isPlayer _unit);
			private _isCombatant 				 = !(_unit getVariable ["GOL_NonCombatant", false]) && side (group _unit) != civilian;
			private _KillerAndUnitIsEnemy 		 = _SideUnit getFriend _SideKiller < 0.6;
			private _KillerAndUnitIsFriendly     = _SideUnit getFriend _SideKiller > 0.6; 
			private _InstigatorAndUnitIsEnemy    = _SideUnit getFriend _SideInstigator < 0.6;
			private _InstigatorAndUnitIsFriendly = _SideUnit getFriend _SideInstigator > 0.6;
			private _UnitIsCivilian 			 = _unit getVariable ["GOL_NonCombatant", false] || side (group _unit) == civilian;
			private _UnitIsCaptive				 = _unit getVariable ["GOL_IsCaptive", false];
			private _BuildingCollapse            = _unit isEqualTo _killer || _unit isEqualTo _instigator;
			private _BuildingCollapseEnemy       = _BuildingCollapse && _SideUnit getFriend _PlayerSide < 0.6;
			private _BuildingCollapseFriendly    = _BuildingCollapse && _SideUnit getFriend _PlayerSide > 0.6 && _isCombatant;
			private _BuildingCollapseCivilian    = _BuildingCollapse && _UnitIsCivilian && !_isCombatant;
			private _BuildingCollapseCaptive     = _BuildingCollapse && _UnitIsCaptive;
			private _UnitName 					 = name _unit;
			private _KillerName 				 = name _killer;
			private _InstigatorName 			 = name _instigator;
			
			// Fallback to typeOf if name is empty
			if (isNil "_UnitName" || {_UnitName isEqualTo ""}) then { 
				_UnitName = typeOf _unit;
			};

			if(_BuildingCollapse) then {
				_KillerName = "Building Collapse";
				_InstigatorName = "Building Collapse";
			};

			if (_Debug) then {
				format["[KILLS] EntityKilled Event: %1 killed by %2 (%3) - Instigator %4 (%5).", _UnitName, _KillerName, _killer, _InstigatorName, _instigator] spawn OKS_fnc_LogDebug;
			};

			// Update Score Method
			private _UpdateScore = {
				params ["_Unit","_UnitName","_KillerName","_InstigatorName","_Variable"];
				private _Debug = missionNamespace getVariable ["GOL_Kills_Debug", false];
				private _KillCount = missionNamespace getVariable [_Variable, 0];
				if (_unit getVariable ["GOL_ScoreAdded", false]) exitWith {
					if (_Debug) then {
						format["[KILLS] %1 Exit: already Processed %2.", _Variable, _UnitName] spawn OKS_fnc_LogDebug;
					};	
				};

				// Synchronized to all clients.
				_unit setVariable ["GOL_ScoreAdded", true, true];
				_KillCount = _KillCount + 1;
				missionNamespace setVariable [_Variable, _KillCount, true];

				if (_Debug) then {
					format["[KILLS] %1 killed by %2 (%3) | Updated (%4): %5.", _UnitName, _KillerName, _InstigatorName, _Variable, _KillCount] spawn OKS_fnc_LogDebug;
				};
			};

			// Only process if not already handled.
			if (_unit getVariable ["GOL_ScoreAdded", false]) exitWith {
				if (_Debug) then {
					format["[KILLS] EntityKilled Event Exited: Already Processed %1 killed by %2 (%3) - Instigator %4 (%5).", _UnitName, _KillerName, _killer, _InstigatorName, _instigator] spawn OKS_fnc_LogDebug;
				};			
			};
			if(_KillerOrInstigatorIsPlayer || _BuildingCollapse) then {
				if (_Debug) then {
					"[KILLS] EntityKilled Event: Player Kill or Collapse" spawn OKS_fnc_LogDebug;
				};	

				// Combatant Killed Logic
				if (_isCombatant) then {
					// Enemy Killed Logic
					if (_KillerAndUnitIsEnemy || _InstigatorAndUnitIsEnemy || _BuildingCollapseEnemy) exitWith {
						[_Unit,_UnitName,_KillerName,_InstigatorName,"GOL_EnemiesKilled"] call _UpdateScore;		
					};
					
					// Friendly fire check for AI
					if (_KillerAndUnitIsFriendly || _InstigatorAndUnitIsFriendly || _BuildingCollapseFriendly) exitWith {
						[_Unit,_UnitName,_KillerName,_InstigatorName,"GOL_FriendlyFireKills"] call _UpdateScore;
					};
				};

				// Civilian kill logic
				if (_UnitIsCivilian || _BuildingCollapseCivilian) exitWith {
					[_Unit,_UnitName,_KillerName,_InstigatorName,"GOL_CiviliansKilled"] call _UpdateScore;
					[10] call OKS_fnc_IncreaseMultiplier;
				};

				// Captive kill logic
				if (_UnitIsCaptive || _BuildingCollapseCaptive) exitWith {
					_unit setVariable ["GOL_CaptiveKilled", true, true];
					[_Unit,_UnitName,_KillerName,_InstigatorName,"GOL_CiviliansKilled"] call _UpdateScore;
					[15] call OKS_fnc_IncreaseMultiplier;
				};
				
				// No matching event
				if (_Debug) then {
					format ["[KILLS] Matching Events: %1 | Combatant: %2 | Enemy: %3 | Friendly: %4 | Non-Combatant: %5 | Captive: %6.",
						_UnitName,
						_isCombatant,
						_KillerAndUnitIsEnemy || _InstigatorAndUnitIsEnemy,
						_KillerAndUnitIsFriendly || _InstigatorAndUnitIsFriendly,
						_UnitIsCivilian,
						_UnitIsCaptive
					] spawn OKS_fnc_LogDebug;
				};
			} else {
				if (_Debug) then {
					format["[KILLS] Not Player: %1 killed by %2 (%3) - Instigator %4 (%5).", _UnitName, _KillerName, _Killer, _InstigatorName, _Instigator] spawn OKS_fnc_LogDebug;
				};
			}
        } else {
			if (_Debug) then {
				format["[KILLS] Not Local: %1 killed by %2 (%3) - Instigator %4 (%5).", _UnitName, _KillerName, _Killer, _InstigatorName, _Instigator] spawn OKS_fnc_LogDebug;
			};
		};
    }];
};
