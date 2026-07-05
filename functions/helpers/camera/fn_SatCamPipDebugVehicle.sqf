/*
    OKS_fnc_SatCamPipDebugVehicle

    Displays all model selections (memory points) of a vehicle as 3D world-space labels
    for a set duration. Logs the full sorted list with model-space positions to RPT,
    and prints a ready-to-paste satCamProfiles.sqf snippet.

    Usage (client, in debug console or Eden):
      [vehicle player] call OKS_fnc_SatCamPipDebugVehicle;
      [vehicle player, 60] call OKS_fnc_SatCamPipDebugVehicle;

    Params:
      0: OBJECT  - vehicle to inspect (default: vehicle player)
      1: NUMBER  - duration in seconds to show 3D labels (default: 30)

    Returns: ARRAY - full selectionNames list

    Notes:
    - 3D labels render in world space (not HUD) — visible in any view.
    - Full sorted list (all selections + model-space positions) goes to RPT only.
    - The profile snippet in RPT is a starting point; replace <memPointName> with a name
      from the list, then adjust distance/bboxInset as needed.
    - Call again to restart. Previous PFH auto-cleans.
    - The bboxRearLow anchor subtracts vehicle ATL Z from the model-space coordinate;
      this can misplace the camera if the vehicle's model origin is not at ground level.
      Use a "mem" anchor with a real memory point to avoid this.
*/

if (!hasInterface) exitWith { [] };

params [
    ["_vehicle", objNull, [objNull]],
    ["_durationSec", 30, [0]]
];

if (isNull _vehicle) then { _vehicle = vehicle player; };
if (isNull _vehicle) exitWith {
    hint "[Rear Cam Debug] ERROR: vehicle is null.";
    []
};

private _className = toLower typeOf _vehicle;
private _allSels = selectionNames _vehicle;
private _bb = boundingBoxReal _vehicle;
private _bboxMin = _bb#0;
private _bboxMax = _bb#1;

// Stop any previous debug PFH
private _oldPfh = missionNamespace getVariable ["OKS_SatCamPip_DebugPFH", -1];
if (_oldPfh isNotEqualTo -1) then {
    [_oldPfh] call CBA_fnc_removePerFrameHandler;
    missionNamespace setVariable ["OKS_SatCamPip_DebugPFH", -1];
};

// Build filtered list for 3D labels (noise reduction — only "interesting" selections)
private _keywords = [
    "view", "optic", "driver", "gun", "pilot", "turret",
    "exhaust", "wheel", "memory", "cargo", "hatch", "door",
    "sight", "camera", "rear", "front", "top", "bottom",
    "commander", "gunner", "crew", "light", "lamp", "antenna"
];

private _filtered = [];
{
    private _name = _x;
    private _nameLower = toLower _name;
    // Skip names that start with a digit (raw geometry LOD artifacts)
    if !(_nameLower select [0, 1] in ["0","1","2","3","4","5","6","7","8","9"]) then {
        private _isKeyword = false;
        {
            if (_nameLower find _x > -1) exitWith { _isKeyword = true; };
        } forEach _keywords;
        // Keep if keyword matches, OR if name is very short (≤10 chars, likely a real memory point)
        if (_isKeyword || {count _name <= 10}) then {
            _filtered pushBackUnique _name;
        };
    };
} forEach _allSels;

_filtered sort true;

// ---- RPT output ----------------------------------------------------------------

diag_log "====================================================================";
diag_log format ["[OKS VehicleDebug] Vehicle class : %1", typeOf _vehicle];
diag_log format ["[OKS VehicleDebug] Lowercase key  : %1", _className];
diag_log format ["[OKS VehicleDebug] BBox min        : %1", _bboxMin];
diag_log format ["[OKS VehicleDebug] BBox max        : %1", _bboxMax];
diag_log format ["[OKS VehicleDebug] Total selections: %1  |  Filtered for labels: %2", count _allSels, count _filtered];
diag_log "--------------------------------------------------------------------";
diag_log "[OKS VehicleDebug] ALL SELECTIONS sorted (model-space position):";

private _allSorted = +_allSels;
_allSorted sort true;
{
    private _p = _vehicle selectionPosition _x;
    diag_log format ["[OKS VehicleDebug]   %1  =>  %2", _x, _p];
} forEach _allSorted;

diag_log "--------------------------------------------------------------------";
diag_log "[OKS VehicleDebug] PROFILE SNIPPET — paste into satCamProfiles.sqf:";
diag_log format ["[OKS VehicleDebug] _profiles set [""%1"", createHashMapFromArray [", _className];
diag_log          "[OKS VehicleDebug]     [""driverRear_anchor"", [""mem"", ""<memPointName>"", [0,0,0]]],";
diag_log          "[OKS VehicleDebug]     [""driverRear_distance"", 0.15],";
diag_log          "[OKS VehicleDebug]     [""driverRear_bboxInset"", 0.0],";
diag_log          "[OKS VehicleDebug]     [""driverRear_useGeomRear"", false]";
diag_log          "[OKS VehicleDebug] ]];";
diag_log "====================================================================";

// ---- Hint ----------------------------------------------------------------------

hint format [
    "[Rear Cam Debug]\n%1\nSelections: %2 total | %3 labelled\nBBox min: %4\nBBox max: %5\nFull list in RPT.\nNOTE: exit or use free cam to see labels - they are on the vehicle exterior.",
    typeOf _vehicle,
    count _allSels,
    count _filtered,
    _bboxMin,
    _bboxMax
];

// ---- 3D label PFH --------------------------------------------------------------

private _startT = diag_tickTime;
private _pfhId = [{
    params ["_args", "_pfhId"];
    _args params ["_vehicle", "_filtered", "_startT", "_durationSec"];

    if (isNull _vehicle || {(diag_tickTime - _startT) > _durationSec}) exitWith {
        [_pfhId] call CBA_fnc_removePerFrameHandler;
        missionNamespace setVariable ["OKS_SatCamPip_DebugPFH", -1];
        hint "";
    };

    private _vehFwd = vectorDir _vehicle;
    private _vehUp  = vectorUp _vehicle;
    private _vehRight = _vehFwd vectorCrossProduct _vehUp;
    private _vehASL = getPosASL _vehicle;

    {
        private _pModel = _vehicle selectionPosition _x;
        private _worldOffset = ((_vehRight vectorMultiply (_pModel#0)) vectorAdd
                                (_vehFwd    vectorMultiply (_pModel#1)) vectorAdd
                                (_vehUp     vectorMultiply (_pModel#2)));
        private _posASL = _vehASL vectorAdd _worldOffset;

        drawIcon3D [
            "#(argb,8,8,3)color(1,0.5,0,1)",
            [1, 1, 1, 0.9],
            _posASL,
            0.25, 0.25,
            0,
            _x,
            1,
            0.022,
            "PuristaMedium"
        ];
    } forEach _filtered;

}, 0, [_vehicle, _filtered, _startT, _durationSec]] call CBA_fnc_addPerFrameHandler;

missionNamespace setVariable ["OKS_SatCamPip_DebugPFH", _pfhId];

_allSels
