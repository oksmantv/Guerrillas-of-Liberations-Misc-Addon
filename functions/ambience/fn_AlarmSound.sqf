/*
    OKS_fnc_AlarmSound

    Ported from legacy script: Scripts\OKS_Ambience\OKS_AlarmSound.sqf

    Params:
    0: Origin object (object)
    1: Audible distance (number)

    Example:
    [alarm_1, 1500] spawn OKS_fnc_AlarmSound;
*/

if (!isServer) exitWith { false };

params [
    ["_origin", objNull, [objNull]],
    ["_distance", 1500, [0]]
];

if (isNull _origin) exitWith { false };

while { alive _origin } do {
    playSound3D [
        "\OKS_GOL_Misc\Sounds\siren.ogg",
        _origin,
        false,
        getPosASL _origin,
        5,
        1,
        _distance
    ];
    sleep 180; // Match the 3-minute sound file duration
};

true
