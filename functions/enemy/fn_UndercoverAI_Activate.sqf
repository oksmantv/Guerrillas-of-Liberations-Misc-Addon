/*
    Undercover AI Function

    [thisTrigger, east] spawn OKS_fnc_UndercoverAI_Activate;
*/
params [
    "_Trigger",
    ["_EnemySide",east,[sideUnknown]],
    ["_ChanceForArms", (missionNamespace getVariable ["GOL_UndercoverAI_ChanceForArms",0.5]), [0]]
];

_Debug = missionNamespace getVariable ["GOL_UndercoverAI_Debug", false];
if(_Debug) then {
    format ["[UndercoverAI] Activating Trigger: %1", _Trigger] spawn OKS_fnc_LogDebug;
};

{
    if (_X getVariable ["GOL_UndercoverAI", false]) then {
        [_X,_EnemySide,_ChanceForArms] spawn {
            Params ["_X", "_EnemySide","_ChanceForArms"];
            Private ["_NewEnemyGroup"];

            // Make AI crouch
            _X setUnitPos "MIDDLE";
            doStop _X; // Stop any current actions
            sleep 2;

            // Play pickup animation (use a suitable animation, e.g., "AinvPknlMstpSnonWnonDnon_medic0")
            _X playMove "AinvPknlMstpSnonWnonDnon_medic0";
            sleep 2.8; // Wait for animation to play

            _random = random 1;
            if(_random > _ChanceForArms) then {
                _NewEnemyGroup = createGroup _EnemySide;
                [_X] joinSilent _NewEnemyGroup;

                _NewEnemyGroup setCombatMode "RED";
                _NewEnemyGroup setBehaviour "AWARE";
                _X setCombatMode "RED";
                _X setBehaviour "AWARE";
                _StoredWeapon = _X getVariable ["GOL_UndercoverAI_Weapon", ""];
                _X addWeapon _StoredWeapon;
                _X addMagazine "MiniGrenade";
                _X selectWeapon _StoredWeapon;
            };

            if (_X checkAIFeature "PATH") then {
                [_NewEnemyGroup, 400, 15, [], [], true, false, false] remoteExec ["lambs_wp_fnc_taskHunt", 0];
            };
        };
        sleep 1 + (random 2);
    };
} forEach list _Trigger;
