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
    if ({ isPlayer _x || { _x in playableUnits } || { _x in switchableUnits } } count units _group > 0) exitWith {}; // Never apply to human-playable groups
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

    // Every new group has one implicit waypoint. A patrol needs at least one
    // additional mission waypoint; otherwise static spawn-list groups are
    // incorrectly classified before spawnHandler sets GOL_IsStatic.
    if (_patrolEnabled && !_isStaticGroup && { count waypoints _group > 1 }) then {
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

            // Static groups may already have been transferred to a Headless Client.
            // `joinSilent` only changes group membership where the unit is local, so
            // claim server ownership before the sentry setup tries to isolate units.
            [_group] spawn {
                params ["_group"];

                if (isNull _group || {({ alive _x } count units _group) == 0}) exitWith {};

                _group setGroupOwner 2;

                private _deadline = diag_tickTime + 10;
                waitUntil {
                    sleep 0.1;
                    isNull _group ||
                    {units _group isEqualTo []} ||
                    {local (leader _group)} ||
                    {diag_tickTime >= _deadline}
                };

                if (isNull _group || {units _group isEqualTo []} || {!local (leader _group)}) exitWith {
                    if (missionNamespace getVariable ["GOL_Stealth_Debug", false]) then {
                        [format ["[Stealth.AutoEnable] Static group %1 did not become server-local", _group], false, false, true] spawn OKS_fnc_LogDebug;
                    };
                };

                {
                    [_x] spawn OKS_fnc_Stealth_EnemySentry_SetupUnit;
                } forEach units _group;
                _group setVariable ["OKS_Stealth_AutoSentryAttached", true, true];
            };
            if (missionNamespace getVariable ["GOL_Stealth_Debug", false]) then {
                [format ["[Stealth.AutoEnable] Claiming static group %1 for sentry setup", _group], false, false, true] spawn OKS_fnc_LogDebug;
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
    if (isPlayer _unit || { _unit in playableUnits } || { _unit in switchableUnits }) exitWith {};

    [_unit] spawn {
        params ["_unit"];
        // spawnHandler marks a group static only after all of its units have spawned.
        // A fixed delay misses larger static groups, so wait until the group has either
        // completed static setup or received waypoints; the timeout preserves support
        // for externally spawned groups that use neither.
        private _group = group _unit;
        private _deadline = diag_tickTime + 20;
        waitUntil {
            sleep 0.25;
            isNull _unit ||
            {isNull _group} ||
            {_group getVariable ["GOL_IsStatic", false]} ||
            {_group getVariable ["GOL_isStatic", false]} ||
            {_group getVariable ["OKS_Stealth_SentryPriority", false]} ||
            {count waypoints _group > 1} ||
            {diag_tickTime >= _deadline}
        };
        if (!isNull _unit && !isNull _group) then {
            [_group] call (missionNamespace getVariable ["OKS_Stealth_AutoEnable_AttachForGroup", {}]);
        };
    };
}, true, [], true] call CBA_fnc_addClassEventHandler;
["Event listener active for CAManBase init."] call _log;
true
