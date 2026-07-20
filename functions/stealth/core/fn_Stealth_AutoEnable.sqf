/*
    Auto-enables stealth behavior for existing and newly spawned AI groups.
    Event-driven: uses CBA class init listener for newly created units.

    Usage:
    [] spawn OKS_fnc_Stealth_AutoEnable;
*/

if (!isServer) exitWith { false };
if (missionNamespace getVariable ["OKS_Stealth_AutoEnable_Started", false]) exitWith { true };
missionNamespace setVariable ["OKS_Stealth_AutoEnable_Started", true];

[] call OKS_fnc_Stealth_Init;

private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];
private _log = {
    params ["_message"];
    if (_debug) then {
        [format ["[Stealth.AutoEnable] %1", _message], false, false, true] spawn OKS_fnc_LogDebug;
    };
};

private _attachForGroup = {
    params ["_group"];

    if (isNull _group) exitWith {};
    if (side _group in [civilian, sideLogic, sideUnknown]) exitWith {};
    if ({ alive _x } count units _group == 0) exitWith {};
    if ({ isPlayer _x } count units _group > 0) exitWith {}; // Never apply to player groups
    if !(missionNamespace getVariable ["GOL_Stealth_Enabled", false]) exitWith {};

    private _patrolEnabled = missionNamespace getVariable ["GOL_Stealth_AutoEnablePatrols", false];
    private _staticEnabled = missionNamespace getVariable ["GOL_Stealth_AutoEnableStatics", false];
    if (!_patrolEnabled && !_staticEnabled) exitWith {};

    private _sideTag = switch (side _group) do {
        case west: { "BLUFOR" };
        case east: { "OPFOR" };
        case independent: { "INDEPENDENT" };
        default { "" };
    };

    if (_sideTag isEqualTo "") exitWith {};

    private _sideLanguage = missionNamespace getVariable [format ["GOL_Stealth_Language_%1", _sideTag], ""];
    if (_sideLanguage isEqualTo "") then {
        // Backward compatibility for missions with older profile-only settings.
        _sideLanguage = missionNamespace getVariable [format ["GOL_Stealth_ProfileRadio_%1", _sideTag], "RUSSIAN"];
    };

    if ((toUpper _sideLanguage) isEqualTo "NONE") exitWith {
        if (missionNamespace getVariable ["GOL_Stealth_Debug", false]) then {
            [format ["[Stealth.AutoEnable] Skipped group %1 because side %2 is set to NONE", _group, _sideTag], false, false, true] spawn OKS_fnc_LogDebug;
        };
    };

    private _isStaticGroup =
        (_group getVariable ["GOL_IsStatic", false]) ||
        (_group getVariable ["GOL_isStatic", false]) ||
        (_group getVariable ["OKS_Stealth_SentryPriority", false]);

    if (_patrolEnabled && !_isStaticGroup && { count waypoints _group > 0 }) then {
        if !(_group getVariable ["OKS_Stealth_AutoTalkAttached", false]) then {
            [_group] spawn OKS_fnc_Stealth_EnemyTalk;
            _group setVariable ["OKS_Stealth_AutoTalkAttached", true, true];
            if (missionNamespace getVariable ["GOL_Stealth_Debug", false]) then {
                [format ["[Stealth.AutoEnable] Patrol enabled for group %1", _group], false, false, true] spawn OKS_fnc_LogDebug;
            };
        };
    };

    if (_staticEnabled && _isStaticGroup) then {
        if !(_group getVariable ["OKS_Stealth_AutoSentryAttached", false]) then {
            _group setVariable ["OKS_Stealth_SentryPriority", true, true];
            [_group, side _group, 0.35, true, false, 500, 500] spawn OKS_fnc_Stealth_EnemySentry;
            _group setVariable ["OKS_Stealth_AutoSentryAttached", true, true];
            if (missionNamespace getVariable ["GOL_Stealth_Debug", false]) then {
                [format ["[Stealth.AutoEnable] Static sentry enabled for group %1", _group], false, false, true] spawn OKS_fnc_LogDebug;
            };
        };
    };
};

// One-time sweep to catch groups that already exist at mission start.
{
    [_x] call _attachForGroup;
} forEach allGroups;

missionNamespace setVariable ["OKS_Stealth_AutoEnable_AttachForGroup", _attachForGroup];

// Hook newly created AI units and evaluate their group once spawn scripts finish setup.
["CAManBase", "init", {
    params ["_unit"];

    if (!isServer) exitWith {};
    if (isNull _unit) exitWith {};
    if (isPlayer _unit) exitWith {};

    [_unit] spawn {
        params ["_unit"];
        // spawnHandler sleeps 0.45s per unit before setting GOL_IsStatic at the end of the loop.
        // Wait long enough to ensure the spawner has finished and set group variables.
        sleep 1.5;
        [group _unit] call (missionNamespace getVariable ["OKS_Stealth_AutoEnable_AttachForGroup", {}]);
    };
}, true, [], true] call CBA_fnc_addClassEventHandler;
["Event listener active for CAManBase init."] call _log;
true
