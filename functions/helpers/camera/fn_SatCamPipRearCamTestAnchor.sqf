/*
    OKS_fnc_SatCamPipRearCamTestAnchor

    Injects a runtime-only anchor override for the driver rear camera of a specific
    vehicle and immediately starts the rear camera from that point.
    Does NOT persist to satCamProfiles.sqf — it only affects the current session.

    Usage (client, in debug console or Eden):
      ["driveroptics", vehicle player] call OKS_fnc_SatCamPipRearCamTestAnchor;

    Params:
      0: STRING  - selection / memory point name to use as rear cam anchor
      1: OBJECT  - vehicle to test on (default: vehicle player)

    Returns: OBJECT - the started camera (from OKS_fnc_SatCamPipStartVehicleDriverReverse),
                      or objNull on failure.

    Notes:
    - The override is written into OKS_SatCamPip_VehicleProfiles at runtime.
      It will remain active until the profiles hashmap is reloaded (mission restart).
    - driverRear_useGeomRear is set to false when using a mem anchor to avoid the
      GEOM raycast pushing the camera away from the intended point.
    - Check RPT after calling: a ready-to-paste profile snippet is logged there.
    - To test a raw model-space position instead of a named point, use the "model" anchor
      type in satCamProfiles.sqf directly.

    Tip: run OKS_fnc_SatCamPipDebugVehicle first to see all available selection names.
*/

if (!hasInterface) exitWith { objNull };

params [
    ["_memPointName", "", [""]],
    ["_vehicle", objNull, [objNull]]
];

if (_memPointName isEqualTo "") exitWith {
    diag_log "[OKS TestAnchor] ERROR: No memory point name provided.";
    hint "[Rear Cam Test]\nERROR: No memory point name given.\nUsage: [""name"", vehicle] call OKS_fnc_SatCamPipRearCamTestAnchor";
    objNull
};

if (isNull _vehicle) then { _vehicle = vehicle player; };
if (isNull _vehicle) exitWith {
    diag_log "[OKS TestAnchor] ERROR: Vehicle is null.";
    objNull
};

// Check if player is the driver (required by the rear cam function)
if (player isNotEqualTo driver _vehicle) then {
    diag_log "[OKS TestAnchor] WARNING: Player is not the driver. The rear cam will exit immediately.";
    hint "[Rear Cam Test]\nWARNING: You must be the driver for the rear cam to work.";
};

// Verify the selection exists on this model
private _allSels = selectionNames _vehicle;
if !(_memPointName in _allSels) then {
    diag_log format ["[OKS TestAnchor] WARNING: '%1' not found in selectionNames of %2. Attempting anyway.", _memPointName, typeOf _vehicle];
    hint format ["[Rear Cam Test]\nWARNING: '%1' not in selectionNames!\nCheck RPT for full list (run SatCamPipDebugVehicle).\nAttempting anyway...", _memPointName];
} else {
    private _modelPos = _vehicle selectionPosition _memPointName;
    diag_log format ["[OKS TestAnchor] '%1' found at model pos: %2", _memPointName, _modelPos];
};

// ---- Inject runtime override ---------------------------------------------------

private _profiles = missionNamespace getVariable ["OKS_SatCamPip_VehicleProfiles", createHashMap];
private _className = toLower typeOf _vehicle;
private _existingProfile = +(_profiles getOrDefault [_className, createHashMap]);

_existingProfile set ["driverRear_anchor",      ["mem", _memPointName, [0,0,0]]];
_existingProfile set ["driverRear_useGeomRear",  false];

_profiles set [_className, _existingProfile];
missionNamespace setVariable ["OKS_SatCamPip_VehicleProfiles", _profiles];

// ---- Log snippet ---------------------------------------------------------------

diag_log "--------------------------------------------------------------------";
diag_log format ["[OKS TestAnchor] Testing anchor '%1' on %2 (%3)", _memPointName, typeOf _vehicle, _className];
diag_log "[OKS TestAnchor] PROFILE SNIPPET — paste into satCamProfiles.sqf if this works:";
diag_log format ["[OKS TestAnchor] _profiles set [""%1"", createHashMapFromArray [", _className];
diag_log format ["[OKS TestAnchor]     [""driverRear_anchor"", [""mem"", ""%1"", [0,0,0]]],", _memPointName];
diag_log          "[OKS TestAnchor]     [""driverRear_useGeomRear"", false]";
diag_log          "[OKS TestAnchor] ]];";
diag_log "--------------------------------------------------------------------";

// ---- Start rear cam ------------------------------------------------------------

[_vehicle] call OKS_fnc_SatCamPipStartVehicleDriverReverse
