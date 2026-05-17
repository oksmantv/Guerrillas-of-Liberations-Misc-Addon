// File: fn_GetEthnicityFromFace.sqf
/*
    Reads the unit's current face and returns a readable ethnicity label.
    Face pool data is sourced from OKS_fnc_FaceSwap.

    [unit] call OKS_fnc_GetEthnicityFromFace;
    Returns: "African" | "Asian" | "Middle Eastern" | "Caucasian" | "Unknown"

    Face pool mapping:
        AfricanHead_*, TanoanHead_*, Barklem         -> "African"
        AsianHead_*                                  -> "Asian"
        PersianHead_*                                -> "Middle Eastern"
        WhiteHead_*, LivonianHead_*, GreekHead_*,
        RussianHead_*, Ioannou, Mavros, Sturrock     -> "Caucasian"
*/

params [
    ["_unit", objNull, [objNull]]
];

if (isNull _unit) exitWith { "Unknown" };

private _face = toLower (face _unit);
private _ethnicity = "Unknown";

// Exact named faces that don't follow a clear prefix pattern
{
    if (_face == (_x select 0)) exitWith {
        _ethnicity = _x select 1;
    };
} forEach [
    ["barklem",  "African"],
    ["ioannou",  "Caucasian"],
    ["mavros",   "Caucasian"],
    ["sturrock", "Caucasian"]
];

if (_ethnicity isEqualTo "Unknown") then {
    // Prefix-based detection — order matters (more specific first)
    {
        if ((_face find (_x select 0)) == 0) exitWith {
            _ethnicity = _x select 1;
        };
    } forEach [
        ["africanhead",  "African"],
        ["tanoanhead",   "African"],
        ["asianhead",    "Asian"],
        ["persianhead",  "Middle Eastern"],
        ["whitehead",    "Caucasian"],
        ["livonianhead", "Caucasian"],
        ["greekhead",    "Caucasian"],
        ["russianhead",  "Caucasian"]
    ];
};

_ethnicity
