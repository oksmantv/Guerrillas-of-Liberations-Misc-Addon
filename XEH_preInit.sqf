// OKS GOL Misc - Convoy settings (CBA Settings)
// Place this file in the addon PBO and register via Extended_PreInit_EventHandlers in config.

private _cat = "OKS Convoy";

if (!isNil "CBA_fnc_addSetting") then {
    // AA / Air behavior tunables
    [
        "GOL_Convoy_PullOffMaxSlopeDeg",
        "SLIDER",
        ["AA: Pull-off max slope (deg)", "Maximum terrain slope allowed for AA pull-off positions."],
        _cat,
        [0,45,15,0],
        true,
        { missionNamespace setVariable ["GOL_Convoy_PullOffMaxSlopeDeg", _this, true]; }
    ] call CBA_fnc_addSetting;

    [
        "GOL_Convoy_MergeGapMin",
        "SLIDER",
        ["AA: Merge gap (m)", "Minimum distance to previous tail before AA accelerates to rejoin."],
        _cat,
        [20,200,80,0],
        true,
        { missionNamespace setVariable ["GOL_Convoy_MergeGapMin", _this, true]; }
    ] call CBA_fnc_addSetting;

    [
        "GOL_Convoy_MergeGapTimeout",
        "SLIDER",
        ["AA: Merge gap timeout (s)", "After this time, AA will merge even if the gap is smaller."],
        _cat,
        [0,120,30,0],
        true,
        { missionNamespace setVariable ["GOL_Convoy_MergeGapTimeout", _this, true]; }
    ] call CBA_fnc_addSetting;

    [
        "GOL_Convoy_SpeedRampStepKph",
        "SLIDER",
        ["AA: Speed ramp step (kph)", "Speed increase per interval during AA rejoin ramp."],
        _cat,
        [1,30,10,0],
        true,
        { missionNamespace setVariable ["GOL_Convoy_SpeedRampStepKph", _this, true]; }
    ] call CBA_fnc_addSetting;

    [
        "GOL_Convoy_SpeedRampInterval",
        "SLIDER",
        ["AA: Speed ramp interval (s)", "Time between speed steps during AA rejoin ramp."],
        _cat,
        [0.1,5,1,1],
        true,
        { missionNamespace setVariable ["GOL_Convoy_SpeedRampInterval", _this, true]; }
    ] call CBA_fnc_addSetting;

    // Formation / Herringbone spacing
    [
        "GOL_Convoy_HerringboneSpacingMin",
        "SLIDER",
        ["Herringbone: minimum road spacing (m)", "Minimum spacing along road centerline between herringbone slots."],
        _cat,
        [15,60,35,0],
        true,
        { missionNamespace setVariable ["GOL_Convoy_HerringboneSpacingMin", _this, true]; }
    ] call CBA_fnc_addSetting;

    // AA: minimum pull-off distance from nearest road
    [
        "GOL_Convoy_PullOffMinRoadDist",
        "SLIDER",
        ["AA: Pull-off minimum road distance (m)", "Minimum distance from road centerline for AA pull-off positions."],
        _cat,
        [0,100,20,0],
        true,
        { missionNamespace setVariable ["GOL_Convoy_PullOffMinRoadDist", _this, true]; }
    ] call CBA_fnc_addSetting;

    // Initialize missionNamespace variables to current values
    if (!isNil "CBA_fnc_getSetting") then {
        {
            private _id = _x;
            private _val = [_id] call CBA_fnc_getSetting;
            if (!isNil "_val") then { missionNamespace setVariable [_id, _val, true]; };
        } forEach [
            "GOL_Convoy_PullOffMaxSlopeDeg",
            "GOL_Convoy_MergeGapMin",
            "GOL_Convoy_MergeGapTimeout",
            "GOL_Convoy_SpeedRampStepKph",
            "GOL_Convoy_SpeedRampInterval",
            "GOL_Convoy_HerringboneSpacingMin"
        ];
    };
} else {
    diag_log "[OKS_CONVOY] CBA not detected; convoy settings not registered.";
};
