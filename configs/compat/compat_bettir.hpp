// BettIR patches and GOL light controls (root scope).
//
// The GOL OX3000 is deliberately NOT registered in BettIR_Config, so BettIR
// Attachments never tracks, menus or re-maps it. BettIR's L-key hook is skipped for
// it via the canUnitUseLaserDevice patch (configs/CfgFunctions.cpp).
//   Power:    engine headlights toggle (L).
//   Mode:     CBA rail key (MRT rings).
//   Strength: BettIR Stepper keys (default Ctrl + mouse wheel), re-pointed below.
// BettIR NVG illuminator strength: Alt + mouse wheel (OKS_NVGIllum_Up/Down).

class CfgUserActions {
    // BettIR ships these as "not implemented" placeholders.
    class BettIR_WeaponAttachments_Stepper_1_Up {
        onActivate = "if (!is3DEN && {alive player}) then { [player, 0, 1] call OKS_fnc_BettIR_onStepper }";
    };
    class BettIR_WeaponAttachments_Stepper_1_Down {
        onActivate = "if (!is3DEN && {alive player}) then { [player, 0, -1] call OKS_fnc_BettIR_onStepper }";
    };
    class BettIR_WeaponAttachments_Stepper_2_Up {
        onActivate = "if (!is3DEN && {alive player}) then { [player, 1, 1] call OKS_fnc_BettIR_onStepper }";
    };
    class BettIR_WeaponAttachments_Stepper_2_Down {
        onActivate = "if (!is3DEN && {alive player}) then { [player, 1, -1] call OKS_fnc_BettIR_onStepper }";
    };

    class OKS_NVGIllum_Up {
        displayName = "NVG Illuminator Stronger";
        tooltip = "Raise the NVG IR illuminator strength (NVG down, illuminator on)";
        onActivate = "if (!is3DEN && {alive player}) then { [1] call OKS_fnc_NVGIllum_Adjust }";
        onDeactivate = "";
    };
    class OKS_NVGIllum_Down {
        displayName = "NVG Illuminator Weaker";
        tooltip = "Lower the NVG IR illuminator strength (NVG down, illuminator on)";
        onActivate = "if (!is3DEN && {alive player}) then { [-1] call OKS_fnc_NVGIllum_Adjust }";
        onDeactivate = "";
    };
};

class CfgDefaultKeysPresets {
    class Arma2 {
        class Mappings {
            OKS_NVGIllum_Up[] = {0x38120004};   // Alt + wheel up
            OKS_NVGIllum_Down[] = {0x38120005}; // Alt + wheel down
        };
    };
};

class UserActionGroups {
    class OKS_GOL_Lights {
        name = "GOL Lights";
        isAddon = 1;
        group[] = {"OKS_NVGIllum_Up", "OKS_NVGIllum_Down"};
    };
};
