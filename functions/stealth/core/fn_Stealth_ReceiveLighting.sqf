/*
    OKS_fnc_Stealth_ReceiveLighting

    Client-side callback to receive lighting data from server.
    Called by server after OKS_fnc_Stealth_GetLightingServer processes the request.

    Parameters:
        _lighting - Array - [sunLight, ambientLight, moonLight, dynamicLight]

    Returns: Nothing (stores result in missionNamespace)

    Usage:
        [_lighting] remoteExecCall ["OKS_fnc_Stealth_ReceiveLighting", _clientOwner];
*/

if (!hasInterface) exitWith {};

params [
    ["_lighting", [], [[]]]
];

if (_lighting isEqualTo []) exitWith {};

// Store lighting data for main stealth loop to consume
missionNamespace setVariable ["OKS_Stealth_ServerLighting", _lighting];
missionNamespace setVariable ["OKS_Stealth_ServerLightingTime", time];
