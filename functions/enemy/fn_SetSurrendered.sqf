/*
    [_this, 0.4, 50, true, true] spawn OKS_fnc_SetSurrendered;
    [_unit, _chance, _ChanceWeaponAim _distance, _DistanceWeaponAim, _byShot, _byFlashbang] spawn OKS_fnc_SetSurrendered;
*/
params ["_Unit", "_Chance", "_ChanceWeaponAim", "_Distance", "_DistanceWeaponAim" ,"_SurrenderByShot", "_SurrenderByFlashbang", "_NearFriendliesDistance"];
private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];

if(hasInterface && !isServer) exitWith {};

_random = random 1;
if(_surrenderDebug) then {
    format ["SetSurrender Random %1%% value",round(_random * 100)] spawn OKS_fnc_LogDebug;
};
if(_random < 0.8 && {_X distance _Unit < 10} count AllPlayers == 0 && _X checkAIFeature "PATH") then {
    if(_surrenderDebug) then {
        format ["SetSurrender Unit set to flee."] spawn OKS_fnc_LogDebug;
    };
    _CivilianGroup = createGroup CIVILIAN;
    [_Unit] join _CivilianGroup;
    _RandomPosition = _Unit getPos [500,(random 360)];
    _FleeWaypoint = _CivilianGroup addWaypoint [_RandomPosition,0];
    _FleeWaypoint setWaypointType "MOVE";
    _FleeWaypoint setWaypointBehaviour "AWARE";
    _FleeWaypoint setWaypointCombatMode "BLUE";
    _FleeWaypoint setWaypointStatements ["true", "this setUnitPos 'DOWN'; this disableAI 'PATH';"];

    waitUntil {sleep 1; !isNil "lambs_wp_fnc_taskAssault"};
    [_Unit, _RandomPosition, true] remoteExec ["lambs_wp_fnc_taskAssault",0];

    _CivilianGroup setVariable ["lambs_danger_disableAI",true,true];
    _Unit setVariable ["lambs_danger_disableAI", true,true];   
} else {
    [_unit, true] call ACE_captives_fnc_setSurrendered;
    if(_surrenderDebug) then {
        format ["SetSurrender Unit set to surrender."] spawn OKS_fnc_LogDebug;
    };
};