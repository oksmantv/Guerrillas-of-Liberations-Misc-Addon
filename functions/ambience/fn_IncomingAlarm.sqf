/*
    fn_IncomingAlarm.sqf

    Example:
    [Speaker_1, "dynamic", 400, 0, 2, []] spawn OKS_fnc_IncomingAlarm;
*/

if (!isServer) exitWith {};

Params [
    "_Speaker",
    ["_Type","dynamic",[""]],
    ["_Range",500, [0]],
    ["_LoopCount",2,[0]],
    ["_OffsetAltitude", 0, [0]],
    ["_AmmoTypes", [], [[]]]
];

_SpeakerPosition = getPosATL _Speaker;
_SpeakerPosition set [2, (_SpeakerPosition select 2) + _OffsetAltitude];

_Light = "UK3CB_BAF_Sh_60mm_AMOS";	// Class name of light mortar round.																				String
_Medium = "Sh_82mm_AMOS";			// Class name of medium mortar round.																				String
_Heavy = "Sh_155mm_AMOS";	        // Class name of heavy mortar round.																				String
_PossibleRounds = [_Light, _Medium, _Heavy];
_PossibleRounds append _AmmoTypes;

switch (toLower _Type) do {
    case "dynamic": {
        while {alive _Speaker} do {
            waitUntil {
                sleep 0.1;
                private _nearbyProjectiles = nearestObjects [_SpeakerPosition, _PossibleRounds, _Range];
                count _nearbyProjectiles > 0
            };
            playSound3D ["\OKS_GOL_Misc\sounds\IncomingAlarm.wav", _Speaker, false, _SpeakerPosition, 5, 1, _Range];
            sleep 7.05;
            playSound3D ["\OKS_GOL_Misc\sounds\IncomingAlarm.wav", _Speaker, false, _SpeakerPosition, 5, 1, _Range];
            sleep 7;
        };
    };
    case "loop": {
        for "_i" from 1 to _LoopCount do {
            playSound3D ["\OKS_GOL_Misc\sounds\IncomingAlarm.wav", _Speaker, false, _SpeakerPosition, 5, 1, _Range];
            sleep 7.05;
        };
    };
    default {
        "[INCOMING ALARM] Unknown type passed to fn_IncomingAlarm.sqf" spawn OKS_fnc_logError;
    };
};

