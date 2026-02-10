// TFAR Intercom compatibility patch
// Enables TFAR intercom on MRAP base classes that TFAR left disabled.
// Only effective when TFAR is loaded; the properties are harmlessly
// ignored otherwise.
//
// NOTE: MRAP_03_base_F is patched directly in CfgVehicles.cpp (already
//       forward-declared there for Fennek inheritance).
//
// Inheritance chain (vanilla):
//   MRAP_01_base_F -> Car_F -> Car -> LandVehicle
//   MRAP_02_base_F -> Car_F -> Car -> LandVehicle

class MRAP_01_base_F : Car_F {
    TFAR_hasIntercom = 1;
    class ACE_SelfActions {
        class TFAR_IntercomChannel {
            displayName = "Intercom Channel";
            condition = "true";
            statement = "";
            icon = "";
            class TFAR_IntercomChannel_disabled {
                displayName = "Disabled";
                condition = "[_target, _player, -1] call TFAR_fnc_canSetIntercomChannel";
                statement = "[_target, _player, -1] call TFAR_fnc_setIntercomChannel";
            };
            class TFAR_IntercomChannel_1 {
                displayName = "Channel 1";
                condition = "[_target, _player, 0] call TFAR_fnc_canSetIntercomChannel";
                statement = "[_target, _player, 0] call TFAR_fnc_setIntercomChannel";
            };
            class TFAR_IntercomChannel_2 {
                displayName = "Channel 2";
                condition = "[_target, _player, 1] call TFAR_fnc_canSetIntercomChannel";
                statement = "[_target, _player, 1] call TFAR_fnc_setIntercomChannel";
            };
        };
    };
};

class MRAP_02_base_F : Car_F {
    TFAR_hasIntercom = 1;
    class ACE_SelfActions {
        class TFAR_IntercomChannel {
            displayName = "Intercom Channel";
            condition = "true";
            statement = "";
            icon = "";
            class TFAR_IntercomChannel_disabled {
                displayName = "Disabled";
                condition = "[_target, _player, -1] call TFAR_fnc_canSetIntercomChannel";
                statement = "[_target, _player, -1] call TFAR_fnc_setIntercomChannel";
            };
            class TFAR_IntercomChannel_1 {
                displayName = "Channel 1";
                condition = "[_target, _player, 0] call TFAR_fnc_canSetIntercomChannel";
                statement = "[_target, _player, 0] call TFAR_fnc_setIntercomChannel";
            };
            class TFAR_IntercomChannel_2 {
                displayName = "Channel 2";
                condition = "[_target, _player, 1] call TFAR_fnc_canSetIntercomChannel";
                statement = "[_target, _player, 1] call TFAR_fnc_setIntercomChannel";
            };
        };
    };
};


