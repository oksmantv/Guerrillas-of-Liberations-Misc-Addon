diag_log "OKS_GOL_Misc: XEH_preInit_eden.sqf executed";

// Only relevant inside Eden Editor.
if !(is3DEN) exitWith { false };

// CBA Settings for Eden Editor Debug
[
    "OKS_3DEN_DEBUG",
    "CHECKBOX",
    ["3DEN Debug", "Enables extra [3DEN] notifications and verbose copy-to-clipboard logging for GOL SCRIPTS Eden helpers."],
    ["GOL Eden", "Debug"],
    true,
    1
] call cba_settings_fnc_init;

// CBA Settings for Eden Editor Task Tools
[
    "OKS_3DEN_INTEL_CLASS",
    "EDITBOX",
    ["Intel Object Class", "CfgVehicles classname used by the GOL SCRIPTS -> TASK -> Setup Intel helper. Default targets ACEX Intel Items document."],
    ["GOL Eden", "Tasks"],
    "acex_intelitems_document",
    1
] call cba_settings_fnc_init;

// Mirror the setting into uiNamespace so the Eden scripts can also be toggled per-editor-session.
// (Eden helpers check uiNamespace first, then fall back to missionNamespace.)
uiNamespace setVariable ["OKS_3DEN_DEBUG", missionNamespace getVariable ["OKS_3DEN_DEBUG", true]];

// Keybind: repeat last used GOL Eden clipboard action (3DEN only)
[
    "GOL Eden",
    "OKS_3DEN_RepeatLastAction",
    [
        "Repeat Last Eden Action",
        "Re-runs the last used GOL Eden clipboard-generator at the current mouse position. If the current selection fails validation, retries once using the previous context selection."
    ],
    // NOTE: Actual execution is handled by the 3DEN display KeyDown handler below.
    // Keeping this keybind registered makes it configurable in CBA Addon Options without double-triggering.
    {},
    {},
    [DIK_R, [true, true, false]],
    false
] call CBA_fnc_addKeybind;

// Eden (3DEN) keybind handling:
// CBA keybinds are not guaranteed to trigger while the Eden display (IDD 313) is active,
// and some keys (e.g. T) are captured by Eden by default. We therefore hook KeyDown on
// display 313 and match against the CBA-configured binding.
if (hasInterface) then {
    [] spawn {
        disableSerialization;
        waitUntil { !isNull (findDisplay 313) };

        private _disp = findDisplay 313;
        if (isNull _disp) exitWith {};

        private _prev = uiNamespace getVariable ["OKS_3DEN_RepeatLastAction_KD_EH", -1];
        if (_prev isEqualType 0 && { _prev >= 0 }) then {
            _disp displayRemoveEventHandler ["KeyDown", _prev];
        };

        private _eh = _disp displayAddEventHandler ["KeyDown", {
            params ["_display", "_dik", "_shift", "_ctrl", "_alt"];

            private _kb = ["GOL Eden", "OKS_3DEN_RepeatLastAction"] call CBA_fnc_getKeybind;
            if !(_kb isEqualType []) exitWith { false };
            if ((count _kb) <= 8) exitWith { false };

            private _keys = _kb select 8;
            if !(_keys isEqualType []) exitWith { false };

            private _match = false;
            {
                if (_x isEqualType [] && { (count _x) >= 2 }) then {
                    _x params ["_k", "_mods"];
                    if (_mods isEqualType [] && { (count _mods) == 3 }) then {
                        _mods params ["_s", "_c", "_a"];
                        if ((_dik == _k) && { _shift == _s } && { _ctrl == _c } && { _alt == _a }) exitWith {
                            _match = true;
                        };
                    };
                };
            } forEach _keys;

            if (_match) then {
                if (uiNamespace getVariable ["OKS_3DEN_DEBUG", false]) then {
                    diag_log "OKS_GOL_Misc: RepeatLastAction KeyDown matched (3DEN)";
                };
                [] spawn OKS_fnc_EdenRepeatLastAction;
                true
            } else {
                false
            };
        }];

        uiNamespace setVariable ["OKS_3DEN_RepeatLastAction_KD_EH", _eh];
        if (uiNamespace getVariable ["OKS_3DEN_DEBUG", false]) then {
            diag_log format ["OKS_GOL_Misc: 3DEN KeyDown handler installed for RepeatLastAction (eh=%1)", _eh];
        };
    };
};

// CBA Settings for Eden Editor Marker Tools
[
    "OKS_Eden_FlagMarker_BLUFOR",
    "EDITBOX",
    ["BLUFOR Flag Marker Type", "Marker type to use for BLUFOR (b_) flag markers when using 'Mark Organisation Strength with Flag'."],
    ["GOL Eden", "Markers"],
    "flag_nato",
    1
] call cba_settings_fnc_init;

[
    "OKS_Eden_FlagMarker_OPFOR",
    "EDITBOX",
    ["OPFOR Flag Marker Type", "Marker type to use for OPFOR (o_) flag markers when using 'Mark Organisation Strength with Flag'."],
    ["GOL Eden", "Markers"],
    "flag_csat",
    1
] call cba_settings_fnc_init;

[
    "OKS_Eden_FlagMarker_INDEP",
    "EDITBOX",
    ["Independent Flag Marker Type", "Marker type to use for Independent (i_) flag markers when using 'Mark Organisation Strength with Flag'."],
    ["GOL Eden", "Markers"],
    "flag_aaf",
    1
] call cba_settings_fnc_init;
