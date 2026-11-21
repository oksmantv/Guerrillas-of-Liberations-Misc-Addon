// BettIR_Attachments registration for the GOL OX3000 (root scope).
//
// BettIR tracks the mounted variant through the parser/composer below and offers
// Mode and Strength in the ACE self-interaction menu (BettIR > Primary).
// Mode cycling stays on the CBA rail key (MRT rings), so BettIR's mode keys are no-ops.
// Strength uses BettIR's own Stepper keys (default Ctrl + mouse wheel). BettIR ships
// those user actions as placeholders, so they are re-pointed below to a dispatcher
// that runs the mounted device's onStepperUp / onStepperDown handler.
// The power button follows the engine headlights toggle: no momentary/double-tap logic.

class BettIR_Config {
    class CompatibleAttachments {
        class GOL_OX3000 {
            macroClass = "GOL_OX3000";
            classParser = "OKS_fnc_OX3000_ParseClass";
            classComposer = "OKS_fnc_OX3000_ComposeClass";
            onActivate = "_this spawn BettIR_Attachments_fnc_defaultDeviceActivate";
            // Non-empty so a previous device's deactivate script is replaced.
            onDeactivate = "true";
            onToggleModePrimary = "";
            onToggleModeSecondary = "";
            onStepperUp = "[1] call OKS_fnc_OX3000_AdjustStrength";
            onStepperDown = "[-1] call OKS_fnc_OX3000_AdjustStrength";

            class Configurable {
                class Mode {
                    displayName = "Mode";
                    defaultValue = "DP";
                    class DP { displayName = "IR Laser + IR Illuminator"; };
                    class LS { displayName = "IR Laser"; };
                    class FL { displayName = "Flashlight"; };
                };
                class Power {
                    displayName = "Strength";
                    defaultValue = "P1";
                    class P1 { displayName = "20%"; };
                    class P2 { displayName = "40%"; };
                    class P3 { displayName = "60%"; };
                    class P4 { displayName = "80%"; };
                    class P5 { displayName = "100%"; };
                };
            };
        };

        class GOL_OX3000_DP_P1: GOL_OX3000 {};
        class GOL_OX3000_DP_P2: GOL_OX3000 {};
        class GOL_OX3000_DP_P3: GOL_OX3000 {};
        class GOL_OX3000_DP_P4: GOL_OX3000 {};
        class GOL_OX3000_DP_P5: GOL_OX3000 {};
        class GOL_OX3000_LS_P1: GOL_OX3000 {};
        class GOL_OX3000_LS_P2: GOL_OX3000 {};
        class GOL_OX3000_LS_P3: GOL_OX3000 {};
        class GOL_OX3000_LS_P4: GOL_OX3000 {};
        class GOL_OX3000_LS_P5: GOL_OX3000 {};
        class GOL_OX3000_FL_P1: GOL_OX3000 {};
        class GOL_OX3000_FL_P2: GOL_OX3000 {};
        class GOL_OX3000_FL_P3: GOL_OX3000 {};
        class GOL_OX3000_FL_P4: GOL_OX3000 {};
        class GOL_OX3000_FL_P5: GOL_OX3000 {};

        // Legacy classes (saved loadouts / missions).
        class GOL_OX3000_II: GOL_OX3000 {};
        class GOL_OX3000_IP: GOL_OX3000 {};
        class GOL_OX3000_FL_Low: GOL_OX3000 {};
        class GOL_OX3000_FL: GOL_OX3000 {};
        class GOL_OX3000_LR: GOL_OX3000 {};
        class GOL_OX3000_LR_II: GOL_OX3000 {};
        class GOL_OX3000_LR_IP: GOL_OX3000 {};
        class GOL_OX3000_LR_FL_Low: GOL_OX3000 {};
        class GOL_OX3000_LR_FL: GOL_OX3000 {};
    };
};

// Replace BettIR's "not implemented yet" stepper placeholders with a device dispatcher.
class CfgUserActions {
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
};
