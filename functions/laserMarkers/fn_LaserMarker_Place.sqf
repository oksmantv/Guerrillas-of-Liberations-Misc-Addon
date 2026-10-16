/*
    OKS_fnc_LaserMarker_Place

    Client keybind action. Places a shared marker at the local aircraft camera
    aim point. The server performs final validation and creates the marker
    in the operator's side channel.
*/

if (!hasInterface) exitWith { false };
if !(missionNamespace getVariable ["GOL_LaserMarker_Enabled", false]) exitWith {
    systemChat "[Laser Marker] Enable Aircraft Aim Markers in Addon Options first.";
    false
};

private _aimData = call OKS_fnc_LaserMarker_GetLaserAim;
if (_aimData isEqualTo []) exitWith {
    systemChat "[Laser Marker] Enter an aircraft crew seat and aim its camera.";
    false
};

_aimData params ["", "_impactASL", "", "_vehicle"];
[player, _vehicle, _impactASL] remoteExecCall ["OKS_fnc_LaserMarker_Create", 2];
true
