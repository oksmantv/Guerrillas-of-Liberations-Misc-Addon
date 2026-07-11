/*
    OKS_fnc_Stealth_GetLightingServer

    Server-side function to get lighting values without NVG influence.
    On dedicated servers, getLightingAt always uses NVG-off state, excluding IR-only lights.

    Called by clients via remoteExecCall to get accurate lighting for stealth calculations.

    Parameters:
        _unit - Object - The unit at whose position to measure lighting
        _clientOwner - Number - Client owner ID to send result back to

    Returns: Nothing (sends result via remoteExecCall)

    Usage:
        [player, clientOwner] remoteExecCall ["OKS_fnc_Stealth_GetLightingServer", 2];
*/

if (!isServer) exitWith {};

params [
    ["_unit", objNull, [objNull]],
    ["_clientOwner", 0, [0]]
];

if (isNull _unit || _clientOwner == 0) exitWith {};

private _lighting = getLightingAt _unit;

// Send result back to requesting client
[_lighting] remoteExecCall ["OKS_fnc_Stealth_ReceiveLighting", _clientOwner];
