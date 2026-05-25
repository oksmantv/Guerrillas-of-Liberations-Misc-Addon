	class StaticWeapon : LandVehicle
	{
		class ACE_Actions: ACE_Actions {
			class ACE_MainActions : ACE_MainActions {	
				class Pack_Static_HMG {
					displayName = "Pack Static HMG";
					condition = "alive _target && vehicle _player != _target && _player canAdd [(_target getVariable ['GOL_ItemPacked','GOL_Packed_HMG']), 1, true] && count crew _target == 0 && (typeOf _target) == (missionNamespace getVariable ['GOL_PackedHMGClass', 'RHS_M2StaticMG_USMC_D'])";
					exceptions[] = {};
					statement = "[_player,_target] call OKS_fnc_Packing_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_HMG_Packed.paa";
				};	
				class Pack_Static_GMG {
					displayName = "Pack Static GMG";
					condition = "alive _target && vehicle _player != _target && _player canAdd [(_target getVariable ['GOL_ItemPacked','GOL_Packed_GMG']), 1, true] && count crew _target == 0 && (typeOf _target) == (missionNamespace getVariable ['GOL_PackedGMGClass', 'RHS_MK19_TriPod_USMC_WD'])";
					exceptions[] = {};
					statement = "[_player,_target] call OKS_fnc_Packing_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_GMG_Packed.paa";
				};			
				class Pack_Static_AT {
					displayName = "Pack Static AT";
					condition = "alive _target && vehicle _player != _target && _player canAdd [(_target getVariable ['GOL_ItemPacked','GOL_Packed_AT']), 1, true] && count crew _target == 0 && (typeOf _target) == (missionNamespace getVariable ['GOL_PackedATClass', 'RHS_TOW_TriPod_USMC_D'])";
					exceptions[] = {};
					statement = "[_player,_target] call OKS_fnc_Packing_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_AT_Packed.paa";
				};	
				class Pack_Static_Mortar {
					displayName = "Pack Static Mortar";
					condition = "alive _target && vehicle _player != _target && _player canAdd [(_target getVariable ['GOL_ItemPacked','GOL_Packed_Mortar']), 1, true] && count crew _target == 0 && (typeOf _target) == (missionNamespace getVariable ['GOL_PackedMortarClass', 'B_G_Mortar_01_F'])";
					exceptions[] = {};
					statement = "[_player,_target] call OKS_fnc_Packing_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_Mortar_Packed.paa";
				};	
			};
		};
	};

    class Air;
    class Helicopter: Air {
		class ACE_SelfActions {
			class GOL_StaticLine {
				displayName = "Static Line";
				condition = "(_target getcargoindex _player != -1)";
				statement = "";
				icon = "\OKS_GOL_Misc\Data\UI\UI_StaticLine.paa";

				class GOL_HookTrue {
					displayName = "Hook Up";
					condition = "!(_player getVariable ['GOL_Hooked',false]) && (backpack _player) in ['rhsusf_eject_Parachute_backpack','B_Parachute']";
					statement = "[_target,_player, true] call OKS_fnc_StaticJump_Hook;";
					icon = "\OKS_GOL_Misc\Data\UI\UI_Hook.paa";
				};
				class GOL_HookFalse {
					displayName = "Unhook";
					condition = "(_player getVariable ['GOL_Hooked',false])";
					statement = "[_target,_player, false] call OKS_fnc_StaticJump_Hook;";
					icon = "\OKS_GOL_Misc\Data\UI\UI_Unhook.paa";
				};
			};
		};
    };
    class Helicopter_Base_F: Helicopter {
		class ACE_MainActions {
			class Pack_Drone {
				displayName = "Pack Drone";
				condition = "alive _target && _player canAdd [(_target getVariable ['GOL_ItemPacked','GOL_PACKED_DRONE_AP']), 1, true] && (typeOf _target) in [(missionNamespace getVariable ['GOL_PackedDroneAPClass', 'B_UAFPV_RKG_AP']),(missionNamespace getVariable ['GOL_PackedDroneATClass', 'B_UAFPV_AT']),(missionNamespace getVariable ['GOL_PackedDroneReconClass', 'B_UAV_01_F']),(missionNamespace getVariable ['GOL_PackedDroneSupplyClass', 'B_UAV_06_F'])]";
				exceptions[] = {};
				statement = "[_player,_target] call OKS_fnc_Packing_Code";
				icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";	
			};
		};
    };		

