// --- Forward declarations for VehicleSystemsDisplay panel templates ---
class DefaultVehicleSystemsDisplayManagerLeft
{
	class components;
};
class DefaultVehicleSystemsDisplayManagerRight
{
	class components;
};
class VehicleSystemsTemplateLeftDriver: DefaultVehicleSystemsDisplayManagerLeft
{
	class components;
};
class VehicleSystemsTemplateRightDriver: DefaultVehicleSystemsDisplayManagerRight
{
	class components;
};
class VehicleSystemsTemplateLeftGunner: DefaultVehicleSystemsDisplayManagerLeft
{
	class components;
};
class VehicleSystemsTemplateRightGunner: DefaultVehicleSystemsDisplayManagerRight
{
	class components;
};
class VehicleSystemsTemplateLeftCommander: DefaultVehicleSystemsDisplayManagerLeft
{
	class components;
};
class VehicleSystemsTemplateRightCommander: DefaultVehicleSystemsDisplayManagerRight
{
	class components;
};

class CfgVehicles {
    class Land;
    class LandVehicle: Land {
        class ACE_Actions {
            class ACE_MainActions {};
        };
    };
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

	class Man;
	class CAManBase: Man {
		class ACE_SelfActions {
			class ACE_Equipment {
				class Drones {
					displayName = "Drones";
					condition = "vehicle _player == _player";
					statement = "";
					exceptions[] = {};
					icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";

					class Deploy_Drone_AP {
						displayName = "Deploy Drone (AP)";
						condition = "('GOL_Packed_Drone_AP' in (itemsWithMagazines _player)) && vehicle _player == _player";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_Deploy_AP_Drone_Code;";
						icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
					};

					class Convert_Drone_AP_To_Throwable {
						displayName = "Convert Drone (AP) to Throwable";
						condition = "('GOL_Packed_Drone_AP' in (itemsWithMagazines _player)) && vehicle _player == _player";
						exceptions[] = {};
						statement = "[0.5, [_player], { [_this select 0,'AP'] call OKS_fnc_Convert_Packed_Drone_To_Throwable; }, {}, 'Converting...'] call ace_common_fnc_progressBar;";
						icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
					};

					class Deploy_Drone_AT {
						displayName = "Deploy Drone (AT)";
						condition = "('GOL_Packed_Drone_AT' in (itemsWithMagazines _player)) && vehicle _player == _player";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_Deploy_AT_Drone_Code;";
						icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
					};

					class Convert_Drone_AT_To_Throwable {
						displayName = "Convert Drone (AT) to Throwable";
						condition = "('GOL_Packed_Drone_AT' in (itemsWithMagazines _player)) && vehicle _player == _player";
						exceptions[] = {};
						statement = "[0.5, [_player], { [_this select 0,'AT'] call OKS_fnc_Convert_Packed_Drone_To_Throwable; }, {}, 'Converting...'] call ace_common_fnc_progressBar;";
						icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
					};

					class Deploy_Drone_Recon {
						displayName = "Deploy Drone (Recon)";
						condition = "('GOL_Packed_Drone_Recon' in (itemsWithMagazines _player)) && vehicle _player == _player";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_Deploy_Recon_Drone_Code;";
						icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
					};

					class Deploy_Drone_Supply {
						displayName = "Deploy Drone (Supply)";
						condition = "('GOL_Packed_Drone_Supply' in (itemsWithMagazines _player)) && vehicle _player == _player";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_Deploy_Supply_Drone_Code;";
						icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
					};
				};

				class Unpack_60mm_HE {
					displayName = "Unpack 60mm HE";
					condition = "('GOL_Packed_60mm_HE' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Unpack_60mm_HE_Code";
					icon = "\OKS_GOL_Misc\Data\UI\60mm_HE.paa";
				};
				
				class Unpack_60mm_HEAB {
					displayName = "Unpack 60mm HEAB";
					condition = "('GOL_Packed_60mm_HEAB' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Unpack_60mm_HEAB_Code";
					icon = "\OKS_GOL_Misc\Data\UI\60mm_HEAB.paa";
				};

				class Unpack_60mm_Smoke {
					displayName = "Unpack 60mm Smoke";
					condition = "('GOL_Packed_60mm_Smoke' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Unpack_60mm_Smoke_Code";
					icon = "\OKS_GOL_Misc\Data\UI\60mm_Smoke.paa";
				};

				class Unpack_60mm_Flare {
					displayName = "Unpack 60mm Flare";
					condition = "('GOL_Packed_60mm_Flare' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Unpack_60mm_Flare_Code";
					icon = "\OKS_GOL_Misc\Data\UI\60mm_Flare.paa";
				};

				class Deploy_Static_HMG {
					displayName = "Deploy Static HMG";
					condition = "('GOL_Packed_HMG' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Deploy_HMG_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_HMG_Packed.paa";
				};

				class Deploy_Static_GMG {
					displayName = "Deploy Static GMG";
					condition = "('GOL_Packed_GMG' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Deploy_GMG_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_GMG_Packed.paa";
				};

				class Deploy_Static_AT {
					displayName = "Deploy Static AT";
					condition = "('GOL_Packed_AT' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Deploy_AT_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_AT_Packed.paa";
				};

				class Deploy_Static_Mortar {
					displayName = "Deploy Static Mortar";
					condition = "('GOL_Packed_Mortar' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Deploy_Mortar_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_Mortar_Packed.paa";
				};

				class DroneJammer {
					displayName = "Drone Jammer";
					condition = "('OKS_DroneJammer' in (items _player))";
					statement = "";
					exceptions[] = {};
					icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\radio_ca.paa";

					class ActivateJammer {
						displayName = "Activate Jammer";
						condition = "!(_player getVariable ['OKS_JammerActive', false]) && ('OKS_DroneJammer' in (items _player)) && !((vehicle _player) getVariable ['OKS_VehicleJammerActive', false])";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_DroneJammer_Init;";
						icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\radio_ca.paa";
					};

					class DeactivateJammer {
						displayName = "Deactivate Jammer";
						condition = "(_player getVariable ['OKS_JammerActive', false])";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_DroneJammer_Cleanup;";
						icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\radio_ca.paa";
					};
				};

				class DroneDetector {
					displayName = "Drone Detector";
					condition = "('OKS_DroneDetector' in (items _player))";
					statement = "";
					exceptions[] = {};
					icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";

					class ActivateDetector {
						displayName = "Activate Detector";
						condition = "!(_player getVariable ['OKS_DetectorActive', false]) && ('OKS_DroneDetector' in (items _player))";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_DroneDetector_Init;";
						icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";
					};

					class DeactivateDetector {
						displayName = "Deactivate Detector";
						condition = "(_player getVariable ['OKS_DetectorActive', false])";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_DroneDetector_Cleanup;";
						icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";
					};
				};					
			};
		};
	};

	class ACE_medicalSupplyCrate;
	class B_CargoNet_01_ammo_F;
	class B_supplyCrate_F;	
	class Box_Syndicate_Ammo_F;
	class Box_Syndicate_Wps_F;
	class Box_Syndicate_WpsLaunch_F;
	class FlexibleTank_base_F;
	class Land_HelipadSquare_F;
	class Land_RepairDepot_01_green_F;
	class FlagPole_F;
	class ThingX;
	class ReammoBox_F: ThingX {
		class ACE_Actions
		{
			class ACE_MainActions {};
		};
	};			

	class GOL_Flag_Hellfish: FlagPole_F {
		displayName = "GOL Flag (Hellfish)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Objects";

		class EventHandlers {
			init = "(_this select 0) setFlagTexture '\OKS_GOL_Misc\data\images\hellfishflag.paa'";
		};
	};
	
	class GOL_Flag_PZG371: FlagPole_F {
		displayName = "Flag (Panzergrenadierbataillon 371)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Objects";

		class EventHandlers {
			init = "(_this select 0) setFlagTexture '\OKS_GOL_Misc\data\images\pzg371flag.paa'";
		};
	};

	class GOL_ResupplyStation_WEST: ReammoBox_F  {
		displayName = "GOL Resupply Station (WEST)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		model = "\A3\Structures_F_Heli\Ind\Cargo\Cargo10_military_green_F.p3d";
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};	
		class EventHandlers {
			init = "(_this select 0) allowDamage false; (_this select 0) enableSimulation false;";
		};				
		class ACE_Actions : ACE_Actions
		{
			class ACE_MainActions : ACE_MainActions
			{
				distance = 6;	
				class OKS_CreateResupply {
					displayName = "Create Resupply";
					exceptions[] = {};
					condition = "alive _target";
					statement = "";
					icon = "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
					class GOL_TeamResupply
					{
						displayName = "Team Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_TeamResupplybox_WEST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_SpecialistResupply
					{
						displayName = "Specialist Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SpecialistResupplybox_WEST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_SquadResupply
					{
						displayName = "Squad Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SquadResupplybox_WEST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_MobileServiceStation
					{
						displayName = "Mobile Service Station";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_MobileServiceStation', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\repair_ca.paa";
					};	
					class GOL_MedicResupply
					{
						displayName = "Medical Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_MedicalResupply_WEST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\heal_ca.paa";
					};										
					class GOL_SupportResupply
					{
						displayName = "Support Crate";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SupportBox_WEST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\Map\VehicleIcons\iconCrateAmmo_ca.paa";
					};
				};
			};
		};
	};
	
	class GOL_ResupplyStation_EAST: ReammoBox_F  {
		displayName = "GOL Resupply Station (EAST)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";    
		maximumLoad = 20000;
		model = "\A3\Structures_F_Heli\Ind\Cargo\Cargo10_military_green_F.p3d";
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};	
		class EventHandlers {
			init = "(_this select 0) allowDamage false; (_this select 0) enableSimulation false;";
		};						
		class ACE_Actions : ACE_Actions
		{
			class ACE_MainActions : ACE_MainActions
			{
				distance = 5;
				class OKS_CreateResupply {
					displayName = "Create Resupply";
					distance = 5;
					exceptions[] = {};
					condition = "alive _target";
					statement = "";
					icon = "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
					class GOL_TeamResupply
					{
						displayName = "Team Resupply";
						distance = 5;
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_TeamResupplybox_EAST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_SpecialistResupply
					{
						displayName = "Specialist Resupply";
						distance = 5;
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SpecialistResupplybox_EAST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_SquadResupply
					{
						displayName = "Squad Resupply";
						distance = 5;
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SquadResupplybox_EAST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_MobileServiceStation
					{
						displayName = "Mobile Service Station";
						distance = 5;
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_MobileServiceStation', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\repair_ca.paa";
					};	
					class GOL_MedicResupply
					{
						displayName = "Medical Resupply";
						distance = 5;
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_MedicalResupply_EAST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\heal_ca.paa";
					};											
					class GOL_SupportResupply
					{
						displayName = "Support Crate";
						distance = 5;
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SupportBox_EAST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\Map\VehicleIcons\iconCrateAmmo_ca.paa";
					};
				};
			};
		};
	};

	class GOL_ResupplyStation_GUER: ReammoBox_F  {
		displayName = "GOL Resupply Station (GUER)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";    
		maximumLoad = 20000;
		model = "\A3\Structures_F_Heli\Ind\Cargo\Cargo10_military_green_F.p3d";
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};	
		class EventHandlers {
			init = "(_this select 0) allowDamage false; (_this select 0) enableSimulation false;";
		};				
		class ACE_Actions : ACE_Actions
		{
			class ACE_MainActions : ACE_MainActions
			{
				distance = 5;	
				class OKS_CreateResupply {
					displayName = "Create Resupply";
					exceptions[] = {};
					condition = "alive _target";
					statement = "";
					icon = "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
					class GOL_TeamResupply
					{
						displayName = "Team Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_TeamResupplybox_GUER', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_SpecialistResupply
					{
						displayName = "Specialist Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SpecialistResupplybox_GUER', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_SquadResupply
					{
						displayName = "Squad Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SquadResupplybox_GUER', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_MobileServiceStation
					{
						displayName = "Mobile Service Station";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_MobileServiceStation', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\repair_ca.paa";
					};	
					class GOL_MedicResupply
					{
						displayName = "Medical Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_MedicalResupply_GUER', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\heal_ca.paa";
					};										
					class GOL_SupportResupply
					{
						displayName = "Support Crate";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SupportBox_GUER', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\Map\VehicleIcons\iconCrateAmmo_ca.paa";
					};
				};
			};
		};
	};

	class GOL_ResupplyStation_WEST_Small: ReammoBox_F  {
		displayName = "GOL Small Resupply Station (WEST)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		model = "\a3\Props_F_Decade\Objectives\RuggedTerminal_02_communications_F.p3d";
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};		
		class EventHandlers {
			init = "(_this select 0) allowDamage false; (_this select 0) enableSimulation false;";
		};					
		class ACE_Actions : ACE_Actions
		{
			class ACE_MainActions : ACE_MainActions
			{
				distance = 10;	
				position = "[0, 0, -1.5]";
				class OKS_CreateResupply {
					displayName = "Create Resupply";
					distance = 10;
					exceptions[] = {};
					condition = "alive _target";
					statement = "";
					icon = "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
					class GOL_TeamResupply
					{
						displayName = "Team Resupply";
						distance = 10;
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_TeamResupplybox_WEST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_SpecialistResupply
					{
						displayName = "Specialist Resupply";
						distance = 10;
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SpecialistResupplybox_WEST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_SquadResupply
					{
						displayName = "Squad Resupply";
						distance = 10;
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SquadResupplybox_WEST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_MobileServiceStation
					{
						displayName = "Mobile Service Station";
						distance = 10;
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_MobileServiceStation', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\repair_ca.paa";
					};	
					class GOL_MedicResupply
					{
						displayName = "Medical Resupply";
						distance = 10;
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_MedicalResupply_WEST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\heal_ca.paa";
					};										
					class GOL_SupportResupply
					{
						displayName = "Support Crate";
						distance = 10;
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SupportBox_WEST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\Map\VehicleIcons\iconCrateAmmo_ca.paa";
					};
				};
			};
		};
	};
	
	class GOL_ResupplyStation_EAST_Small: ReammoBox_F  {
		displayName = "GOL Small Resupply Station (EAST)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";    
		maximumLoad = 20000;
		model = "\a3\Props_F_Decade\Objectives\RuggedTerminal_02_communications_F.p3d";
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};
		class EventHandlers {
			init = "(_this select 0) allowDamage false; (_this select 0) enableSimulation false;";
		};			
		class ACE_Actions : ACE_Actions
		{
			class ACE_MainActions : ACE_MainActions
			{
				distance = 10;	
				position = "[0, 0, -1.5]";
				class OKS_CreateResupply {
					displayName = "Create Resupply";
					exceptions[] = {};
					condition = "alive _target";
					statement = "";
					icon = "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
					class GOL_TeamResupply
					{
						displayName = "Team Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_TeamResupplybox_EAST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_SpecialistResupply
					{
						displayName = "Specialist Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SpecialistResupplybox_EAST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_SquadResupply
					{
						displayName = "Squad Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SquadResupplybox_EAST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_MobileServiceStation
					{
						displayName = "Mobile Service Station";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_MobileServiceStation', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\repair_ca.paa";
					};	
					class GOL_MedicResupply
					{
						displayName = "Medical Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_MedicalResupply_EAST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\heal_ca.paa";
					};											
					class GOL_SupportResupply
					{
						displayName = "Support Crate";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SupportBox_EAST', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\Map\VehicleIcons\iconCrateAmmo_ca.paa";
					};
				};
			};
		};
	};

	class GOL_ResupplyStation_GUER_Small: ReammoBox_F  {
		displayName = "GOL Small Resupply Station (GUER)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";  
		maximumLoad = 20000;  
		model = "\a3\Props_F_Decade\Objectives\RuggedTerminal_02_communications_F.p3d";
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};
		class EventHandlers {
			init = "(_this select 0) allowDamage false; (_this select 0) enableSimulation false;";
		};			
		class ACE_Actions : ACE_Actions
		{
			class ACE_MainActions : ACE_MainActions
			{
				distance = 10;	
				position = "[0, 0, -1.5]";
				class OKS_CreateResupply {
					displayName = "Create Resupply";
					exceptions[] = {};
					condition = "alive _target";
					statement = "";
					icon = "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
					class GOL_TeamResupply
					{
						displayName = "Team Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_TeamResupplybox_GUER', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_SpecialistResupply
					{
						displayName = "Specialist Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SpecialistResupplybox_GUER', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_SquadResupply
					{
						displayName = "Squad Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SquadResupplybox_GUER', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_MobileServiceStation
					{
						displayName = "Mobile Service Station";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_MobileServiceStation', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\repair_ca.paa";
					};	
					class GOL_MedicResupply
					{
						displayName = "Medical Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_MedicalResupply_GUER', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\heal_ca.paa";
					};											
					class GOL_SupportResupply
					{
						displayName = "Support Crate";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SupportBox_GUER', _player] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\Map\VehicleIcons\iconCrateAmmo_ca.paa";
					};
				};
			};
		};
	};

	class GOL_Helipad: ReammoBox_F
	{
        displayName = "GOL Helipad";
		scope = 2;
    	scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";		
		model = "\A3\Structures_F\Mil\Helipads\HelipadSquare_F.p3d";
		class TransportMagazines {};
        class TransportWeapons {};
        class TransportItems {};
        class TransportBackpacks {};
		class EventHandlers {
			init = "(_this select 0) setVariable ['ace_rearm_isSupplyVehicle', true]";
		};
	};
	
    class GOL_MobileServiceStation: Box_Syndicate_Ammo_F
	{
        displayName = "Mobile Service Station";
		scope = 2;
    	scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
        ace_refuel_fuelCargo = 9999;
		ace_rearm_defaultSupply = 9999;
		maximumLoad = 20000;
		model = "\A3\Structures_F_Heli\Civ\Constructions\WeldingTrolley_01_F.p3d";
		class TransportMagazines {};
        class TransportWeapons {};
        class TransportItems {};
        class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'OKS_fnc_SetupMobileServiceStation'}; [(_this select 0)] spawn OKS_fnc_SetupMobileServiceStation; }";
		};
    };	

    class GOL_GearBox_WEST: B_CargoNet_01_ammo_F
	{
        displayName = "Gear Box (WEST)";
		scope = 2;
    	scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
        maximumLoad = 20000;
		class TransportMagazines {};
        class TransportWeapons {};
        class TransportItems {};
        class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [_this select 0, ['gearbox','west']] call GW_Gear_Fnc_Init; }";
		};
    };

    class GOL_GearBox_EAST: B_CargoNet_01_ammo_F
	{
        displayName = "Gear Box (EAST)";
		scope = 2;
    	scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		class TransportMagazines {};	
        class TransportWeapons {};
        class TransportItems {};
        class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [_this select 0, ['gearbox','east']] call GW_Gear_Fnc_Init; }";
		};
    };

	class GOL_GearBox_GUER: B_CargoNet_01_ammo_F
	{
        displayName = "Gear Box (GUER)";
		scope = 2;
    	scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		class TransportMagazines {};
        class TransportWeapons {};
        class TransportItems {};
        class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [_this select 0, ['gearbox','independent']] call GW_Gear_Fnc_Init; }";
		};
    };

	class GOL_SupportBox_WEST: Box_Syndicate_WpsLaunch_F
	{
        displayName = "Support Box (WEST)";
		scope = 2;
    	scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		class TransportMagazines {};
        class TransportWeapons {};
        class TransportItems {};
        class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [_this select 0, ['support_box','west']] call GW_Gear_Fnc_Init; }";
		};
    };

	class GOL_SupportBox_EAST: Box_Syndicate_WpsLaunch_F
	{
        displayName = "Support Box (EAST)";
		scope = 2;
    	scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		class TransportMagazines {};
        class TransportWeapons {};
        class TransportItems {};
        class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [_this select 0, ['support_box','east']] call GW_Gear_Fnc_Init; }";
		};
    };

	class GOL_SupportBox_GUER: Box_Syndicate_WpsLaunch_F
	{
        displayName = "Support Box (GUER)";
		scope = 2;
    	scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		class TransportMagazines {};
        class TransportWeapons {};
        class TransportItems {};
        class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [_this select 0, ['support_box','independent']] call GW_Gear_Fnc_Init; }";
		};
    };

    class GOL_MedicalResupply_WEST: ACE_medicalSupplyCrate
	{
        displayName = "Medical Resupply Crate (WEST)";
		scope = 2;
    	scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		model = "\z\ace\addons\medical_treatment\data\ace_medcrate.p3d";
		class TransportMagazines {};
        class TransportWeapons {};
        class TransportItems {};
        class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [(_this select 0), ['med_box','west']] call GW_Gear_Fnc_Init}";
		};
    };
	
    class GOL_MedicalResupply_EAST: ACE_medicalSupplyCrate
	{
        displayName = "Medical Resupply Crate (EAST)";
		scope = 2;
    	scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		model = "\z\ace\addons\medical_treatment\data\ace_medcrate.p3d";
		class TransportMagazines {};
        class TransportWeapons {};
        class TransportItems {};
        class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [(_this select 0), ['med_box','east']] call GW_Gear_Fnc_Init}";
		};
    };
	
	class GOL_MedicalResupply_GUER: ACE_medicalSupplyCrate
	{
        displayName = "Medical Resupply Crate (GUER)";
		scope = 2;
    	scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		model = "\z\ace\addons\medical_treatment\data\ace_medcrate.p3d";
		maximumLoad = 20000;
		class TransportMagazines {};
        class TransportWeapons {};
        class TransportItems {};
        class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [(_this select 0), ['med_box','independent']] call GW_Gear_Fnc_Init}";
		};
    };

	// WEST Crates
	class GOL_TeamResupplybox_WEST: Box_Syndicate_Ammo_F
	{
		displayName = "Team Resupply Crate (WEST)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [(_this select 0), ['tiny_box','west']] call GW_Gear_Fnc_Init }";
		};
	};

	class GOL_SpecialistResupplybox_WEST: Box_Syndicate_Wps_F
	{
		displayName = "Specialist Resupply Crate (WEST)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [(_this select 0), ['tiny_box_special','west']] call GW_Gear_Fnc_Init }";
		};
	};

	class GOL_SquadResupplybox_WEST: B_supplyCrate_F
	{
		displayName = "Squad Resupply Crate (WEST)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [(_this select 0), ['small_box','west']] call GW_Gear_Fnc_Init }";
		};
	};

	// EAST Crates
	class GOL_TeamResupplybox_EAST: Box_Syndicate_Ammo_F
	{
		displayName = "Team Resupply Crate (EAST)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [(_this select 0), ['tiny_box','east']] call GW_Gear_Fnc_Init }";
		};
	};

	class GOL_SpecialistResupplybox_EAST: Box_Syndicate_Wps_F
	{
		displayName = "Specialist Resupply Crate (EAST)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [(_this select 0), ['tiny_box_special','east']] call GW_Gear_Fnc_Init }";
		};
	};

	class GOL_SquadResupplybox_EAST: B_supplyCrate_F
	{
		displayName = "Squad Resupply Crate (EAST)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [(_this select 0), ['small_box','east']] call GW_Gear_Fnc_Init }";
		};
	};

	// GUER Crates
	class GOL_TeamResupplybox_GUER: Box_Syndicate_Ammo_F
	{
		displayName = "Team Resupply Crate (GUER)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [(_this select 0), ['tiny_box','independent']] call GW_Gear_Fnc_Init }";
		};
	};

	class GOL_SpecialistResupplybox_GUER: Box_Syndicate_Wps_F
	{
		displayName = "Specialist Resupply Crate (GUER)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [(_this select 0), ['tiny_box_special','independent']] call GW_Gear_Fnc_Init }";
		};
	};

	class GOL_SquadResupplybox_GUER: B_supplyCrate_F
	{
		displayName = "Squad Resupply Crate (GUER)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		maximumLoad = 20000;
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [(_this select 0), ['small_box','independent']] call GW_Gear_Fnc_Init }";
		};
	};

	class O_SAM_System_04_F;
    class GOL_O_SAM_System_04_F : O_SAM_System_04_F {
	displayName = "S-400 (Disabled ACE Guidance)";
        weapons[] = {"gol_weapon_s750Launcher"}; // Replace default weapon
        magazines[] = {"gol_magazine_Missile_s750_x4"}; // Replace default magazine
    };

	class I_E_SAM_System_03_F;
    class GOL_I_E_SAM_System_03_F : I_E_SAM_System_03_F {
	displayName = "MIM-104 Patriot (Disabled ACE Guidance)";
        weapons[] = {"gol_weapon_s750Launcher"}; // Replace default weapon
        magazines[] = {"gol_magazine_Missile_s750_x4"}; // Replace default magazine
    };	

	class B_SAM_System_03_F;
    class GOL_B_SAM_System_03_F : B_SAM_System_03_F {
	displayName = "MIM-104 Patriot (Disabled ACE Guidance)";
        weapons[] = {"gol_weapon_s750Launcher"}; // Replace default weapon
        magazines[] = {"gol_magazine_Missile_s750_x4"}; // Replace default magazine
    };	

	class Module_F;
    class OKS_Module_MechanizedSetup : Module_F {
        scope = 2;
        scopeCurator = 2;
        displayName = "Mechanized Setup";
        category = "GOL_Modules";
        function = "OKS_fnc_SetupMechanized"; // Your function
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 1;
    };
    class OKS_Module_HelicopterSetup : Module_F {
        scope = 2;
        scopeCurator = 2;
        displayName = "Helicopter Setup";
        category = "GOL_Modules";
        function = "OKS_fnc_SetupHelicopter"; // Your function
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 1;
    };
    class OKS_Module_MHQ : Module_F {
        scope = 2;
        scopeCurator = 2;
        displayName = "MHQ Setup";
        category = "GOL_Modules";
        function = "OKS_fnc_SetupMHQ"; // Your function
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 1;
    };	
    class OKS_Module_ApplyUnitGear : Module_F {
        scope = 2;
        scopeCurator = 2;
        displayName = "OKS Apply Unit Gear";
        category = "GOL_Modules";
        function = "OKS_fnc_ApplyUnitGear"; // Your function
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 1;
    };

	class Land_ClutterCutter_small_F;
	class GOL_FastRope_DZ : Land_ClutterCutter_small_F {
		displayName = "AI Fast Rope DZ";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Objects";
	};

	class Plane: Air {
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

	class Car;
	class Car_F : Car {
		class ACE_SelfActions;
	};
	class MRAP_03_base_F : Car_F {
		TFAR_hasIntercom = 1;
		class ACE_SelfActions : ACE_SelfActions {
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
	class I_MRAP_03_F;
	class Fennek_wd: I_MRAP_03_F
	{
		crew = "B_soldier_F";
		displayName = "Fennek";
		forceInGarage = 1;
		faction = "BLU_F_WD";
		textureList[] = {"Blu",1};
		class TextureSources
		{
			class Blu_Arid
			{
				displayName = "Arid";
				author = "Phantom hawk";
				textures[] = {"A3\soft_f_beta\MRAP_03\Data\mrap_03_ext_co.paa","A3\Data_F\Vehicles\Turret_CO.paa"};
				factions[] = {"BLU_F_A","BLU_F_WD","BLU_F_D"};
			};
			class Blu_Woodland
			{
				displayName = "Woodland";
				author = "Phantom hawk";
				textures[] = {"\OKS_GOL_Misc\data\textures\Fennek_ext_wd.paa","\OKS_GOL_Misc\data\textures\Turret_wd.paa"};
				factions[] = {"BLU_F_A","BLU_F_WD","BLU_F_D"};
			};
			class Blu_Desert
			{
				displayName = "Desert";
				author = "Phantom hawk";
				textures[] = {"\OKS_GOL_Misc\data\textures\Fennek_ext_d.paa","\OKS_GOL_Misc\data\textures\Turret_d.paa"};
				factions[] = {"BLU_F_A","BLU_F_WD","BLU_F_D"};
			};
		};
		hiddenSelectionsTextures[] = {"\OKS_GOL_Misc\data\textures\Fennek_ext_wd.paa","\OKS_GOL_Misc\data\textures\Turret_wd.paa"};
		side = 1;
		class TransportMagazines
		{
			class _xx_30Rnd_65x39_caseless_mag
			{
				magazine = "30Rnd_65x39_caseless_mag";
				count = 16;
			};
			class _xx_100Rnd_65x39_caseless_mag
			{
				magazine = "100Rnd_65x39_caseless_mag";
				count = 6;
			};
			class _xx_HandGrenade
			{
				magazine = "HandGrenade";
				count = 10;
			};
			class _xx_1Rnd_HE_Grenade_shell
			{
				magazine = "1Rnd_HE_Grenade_shell";
				count = 10;
			};
			class _xx_1Rnd_Smoke_Grenade_shell
			{
				magazine = "1Rnd_Smoke_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeGreen_Grenade_shell
			{
				magazine = "1Rnd_SmokeGreen_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeOrange_Grenade_shell
			{
				magazine = "1Rnd_SmokeOrange_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeBlue_Grenade_shell
			{
				magazine = "1Rnd_SmokeBlue_Grenade_shell";
				count = 4;
			};
			class _xx_16Rnd_9x21_Mag
			{
				magazine = "16Rnd_9x21_Mag";
				count = 12;
			};
			class _xx_SmokeShell
			{
				magazine = "SmokeShell";
				count = 4;
			};
			class _xx_SmokeShellGreen
			{
				magazine = "SmokeShellGreen";
				count = 4;
			};
			class _xx_SmokeShellOrange
			{
				magazine = "SmokeShellOrange";
				count = 4;
			};
			class _xx_SmokeShellBlue
			{
				magazine = "SmokeShellBlue";
				count = 4;
			};
			class _xx_NLAW_F
			{
				magazine = "NLAW_F";
				count = 2;
			};
		};
		class TransportItems
		{
			class _xx_FirstAidKit
			{
				name = "FirstAidKit";
				count = 10;
			};
		};
		class TransportWeapons
		{
			class _xx_arifle_MX_F
			{
				weapon = "arifle_MX_F";
				count = 2;
			};
		};
	};
	class Fennek_d: I_MRAP_03_F
	{
		crew = "B_soldier_F";
		displayName = "Fennek";
		forceInGarage = 1;
		faction = "BLU_F_D";
		textureList[] = {"Blu",1};
		class TextureSources
		{
			class Blu_Arid
			{
				displayName = "Arid";
				author = "Phantom hawk";
				textures[] = {"A3\soft_f_beta\MRAP_03\Data\mrap_03_ext_co.paa","A3\Data_F\Vehicles\Turret_CO.paa"};
				factions[] = {"BLU_F_A","BLU_F_WD","BLU_F_D"};
			};
			class Blu_Woodland
			{
				displayName = "Woodland";
				author = "Phantom hawk";
				textures[] = {"\OKS_GOL_Misc\data\textures\Fennek_ext_wd.paa","\OKS_GOL_Misc\data\textures\Turret_wd.paa"};
				factions[] = {"BLU_F_A","BLU_F_WD","BLU_F_D"};
			};
			class Blu_Desert
			{
				displayName = "Desert";
				author = "Phantom hawk";
				textures[] = {"\OKS_GOL_Misc\data\textures\Fennek_ext_d.paa","\OKS_GOL_Misc\data\textures\Turret_d.paa"};
				factions[] = {"BLU_F_A","BLU_F_WD","BLU_F_D"};
			};
		};
		hiddenSelectionsTextures[] = {"\OKS_GOL_Misc\data\textures\Fennek_ext_d.paa","\OKS_GOL_Misc\data\textures\Turret_d.paa"};
		side = 1;
	};
	class Fennek_e: I_MRAP_03_F
	{
		crew = "B_soldier_F";
		displayName = "Fennek";
		forceInGarage = 1;
		faction = "BLU_F_A";
		textureList[] = {"Blu",1};
		class TextureSources
		{
			class Blu_Arid
			{
				displayName = "Arid";
				author = "Phantom hawk";
				textures[] = {"A3\soft_f_beta\MRAP_03\Data\mrap_03_ext_co.paa","A3\Data_F\Vehicles\Turret_CO.paa"};
				factions[] = {"BLU_F_A","BLU_F_WD","BLU_F_D"};
			};
			class Blu_Woodland
			{
				displayName = "Woodland";
				author = "Phantom hawk";
				textures[] = {"\OKS_GOL_Misc\data\textures\Fennek_ext_wd.paa","\OKS_GOL_Misc\data\textures\Turret_wd.paa"};
				factions[] = {"BLU_F_A","BLU_F_WD","BLU_F_D"};
			};
			class Blu_Desert
			{
				displayName = "Desert";
				author = "Phantom hawk";
				textures[] = {"\OKS_GOL_Misc\data\textures\Fennek_ext_d.paa","\OKS_GOL_Misc\data\textures\Turret_d.paa"};
				factions[] = {"BLU_F_A","BLU_F_WD","BLU_F_D"};
			};
		};
		hiddenSelectionsTextures[] = {"A3\soft_f_beta\MRAP_03\Data\mrap_03_ext_co.paa","A3\Data_F\Vehicles\Turret_CO.paa"};
		side = 1;
	};
	class MRAP_03_hmg_base_F;
	class I_MRAP_03_hmg_F;
	class Fennek_hmg_Base: I_MRAP_03_hmg_F
	{
		class EventHandlers;
		scope = 0;
		textureList[] = {"Blu",1};
		class TextureSources
		{
			class Blu_Arid
			{
				displayName = "Arid";
				author = "Phantom hawk";
				textures[] = {"A3\soft_f_beta\MRAP_03\Data\mrap_03_ext_co.paa","A3\Data_F\Vehicles\Turret_CO.paa"};
				factions[] = {"BLU_F_A","BLU_F_WD","BLU_F_D"};
			};
			class Blu_Woodland
			{
				displayName = "Woodland";
				author = "Phantom hawk";
				textures[] = {"\OKS_GOL_Misc\data\textures\Fennek_ext_wd.paa","\OKS_GOL_Misc\data\textures\Turret_wd.paa"};
				factions[] = {"BLU_F_A","BLU_F_WD","BLU_F_D"};
			};
			class Blu_Desert
			{
				displayName = "Desert";
				author = "Phantom hawk";
				textures[] = {"\OKS_GOL_Misc\data\textures\Fennek_ext_d.paa","\OKS_GOL_Misc\data\textures\Turret_d.paa"};
				factions[] = {"BLU_F_A","BLU_F_WD","BLU_F_D"};
			};
		};
	};
	class Fennek_hmg_wd: Fennek_hmg_Base
	{
		crew = "B_soldier_F";
		displayName = "Fennek HMG";
		scope = 2;
		forceInGarage = 1;
		faction = "BLU_F_WD";
		side = 1;
		vehicleClass = "Cars";
		typicalCargo[] = {"B_soldier_F"};
		class EventHandlers: EventHandlers
		{
			init = "(_this select 0) execVM ""\Fennek\scripts\ATGM.sqf""";
		};
		hiddenSelectionsTextures[] = {"\OKS_GOL_Misc\data\textures\Fennek_ext_wd.paa","\OKS_GOL_Misc\data\textures\Turret_wd.paa"};
		class TransportMagazines
		{
			class _xx_30Rnd_65x39_caseless_mag
			{
				magazine = "30Rnd_65x39_caseless_mag";
				count = 16;
			};
			class _xx_100Rnd_65x39_caseless_mag
			{
				magazine = "100Rnd_65x39_caseless_mag";
				count = 6;
			};
			class _xx_HandGrenade
			{
				magazine = "HandGrenade";
				count = 10;
			};
			class _xx_1Rnd_HE_Grenade_shell
			{
				magazine = "1Rnd_HE_Grenade_shell";
				count = 10;
			};
			class _xx_1Rnd_Smoke_Grenade_shell
			{
				magazine = "1Rnd_Smoke_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeGreen_Grenade_shell
			{
				magazine = "1Rnd_SmokeGreen_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeOrange_Grenade_shell
			{
				magazine = "1Rnd_SmokeOrange_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeBlue_Grenade_shell
			{
				magazine = "1Rnd_SmokeBlue_Grenade_shell";
				count = 4;
			};
			class _xx_16Rnd_9x21_Mag
			{
				magazine = "16Rnd_9x21_Mag";
				count = 12;
			};
			class _xx_SmokeShell
			{
				magazine = "SmokeShell";
				count = 4;
			};
			class _xx_SmokeShellGreen
			{
				magazine = "SmokeShellGreen";
				count = 4;
			};
			class _xx_SmokeShellOrange
			{
				magazine = "SmokeShellOrange";
				count = 4;
			};
			class _xx_SmokeShellBlue
			{
				magazine = "SmokeShellBlue";
				count = 4;
			};
			class _xx_NLAW_F
			{
				magazine = "NLAW_F";
				count = 2;
			};
		};
		class TransportItems
		{
			class _xx_FirstAidKit
			{
				name = "FirstAidKit";
				count = 10;
			};
		};
		class TransportWeapons
		{
			class _xx_arifle_MX_F
			{
				weapon = "arifle_MX_F";
				count = 2;
			};
		};
	};
	class Fennek_hmg_d: Fennek_hmg_Base
	{
		crew = "B_soldier_F";
		displayName = "Fennek HMG";
		scope = 2;
		forceInGarage = 1;
		faction = "BLU_F_D";
		side = 1;
		vehicleClass = "Cars";
		typicalCargo[] = {"B_soldier_F"};
		class EventHandlers: EventHandlers
		{
			init = "(_this select 0) execVM ""\Fennek\scripts\ATGM.sqf""";
		};
		hiddenSelectionsTextures[] = {"\OKS_GOL_Misc\data\textures\Fennek_ext_d.paa","\OKS_GOL_Misc\data\textures\Turret_d.paa"};
		class TransportMagazines
		{
			class _xx_30Rnd_65x39_caseless_mag
			{
				magazine = "30Rnd_65x39_caseless_mag";
				count = 16;
			};
			class _xx_100Rnd_65x39_caseless_mag
			{
				magazine = "100Rnd_65x39_caseless_mag";
				count = 6;
			};
			class _xx_HandGrenade
			{
				magazine = "HandGrenade";
				count = 10;
			};
			class _xx_1Rnd_HE_Grenade_shell
			{
				magazine = "1Rnd_HE_Grenade_shell";
				count = 10;
			};
			class _xx_1Rnd_Smoke_Grenade_shell
			{
				magazine = "1Rnd_Smoke_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeGreen_Grenade_shell
			{
				magazine = "1Rnd_SmokeGreen_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeOrange_Grenade_shell
			{
				magazine = "1Rnd_SmokeOrange_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeBlue_Grenade_shell
			{
				magazine = "1Rnd_SmokeBlue_Grenade_shell";
				count = 4;
			};
			class _xx_16Rnd_9x21_Mag
			{
				magazine = "16Rnd_9x21_Mag";
				count = 12;
			};
			class _xx_SmokeShell
			{
				magazine = "SmokeShell";
				count = 4;
			};
			class _xx_SmokeShellGreen
			{
				magazine = "SmokeShellGreen";
				count = 4;
			};
			class _xx_SmokeShellOrange
			{
				magazine = "SmokeShellOrange";
				count = 4;
			};
			class _xx_SmokeShellBlue
			{
				magazine = "SmokeShellBlue";
				count = 4;
			};
			class _xx_NLAW_F
			{
				magazine = "NLAW_F";
				count = 2;
			};
		};
		class TransportItems
		{
			class _xx_FirstAidKit
			{
				name = "FirstAidKit";
				count = 10;
			};
		};
		class TransportWeapons
		{
			class _xx_arifle_MX_F
			{
				weapon = "arifle_MX_F";
				count = 2;
			};
		};
	};
	class Fennek_hmg_e: Fennek_hmg_Base
	{
		crew = "B_soldier_F";
		displayName = "Fennek HMG";
		scope = 2;
		forceInGarage = 1;
		faction = "BLU_F_A";
		side = 1;
		vehicleClass = "Cars";
		typicalCargo[] = {"B_soldier_F"};
		class EventHandlers: EventHandlers
		{
			init = "(_this select 0) execVM ""\Fennek\scripts\ATGM.sqf""";
		};
		hiddenSelectionsTextures[] = {"A3\soft_f_beta\MRAP_03\Data\mrap_03_ext_co.paa","A3\Data_F\Vehicles\Turret_CO.paa"};
		class TransportMagazines
		{
			class _xx_30Rnd_65x39_caseless_mag
			{
				magazine = "30Rnd_65x39_caseless_mag";
				count = 16;
			};
			class _xx_100Rnd_65x39_caseless_mag
			{
				magazine = "100Rnd_65x39_caseless_mag";
				count = 6;
			};
			class _xx_HandGrenade
			{
				magazine = "HandGrenade";
				count = 10;
			};
			class _xx_1Rnd_HE_Grenade_shell
			{
				magazine = "1Rnd_HE_Grenade_shell";
				count = 10;
			};
			class _xx_1Rnd_Smoke_Grenade_shell
			{
				magazine = "1Rnd_Smoke_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeGreen_Grenade_shell
			{
				magazine = "1Rnd_SmokeGreen_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeOrange_Grenade_shell
			{
				magazine = "1Rnd_SmokeOrange_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeBlue_Grenade_shell
			{
				magazine = "1Rnd_SmokeBlue_Grenade_shell";
				count = 4;
			};
			class _xx_16Rnd_9x21_Mag
			{
				magazine = "16Rnd_9x21_Mag";
				count = 12;
			};
			class _xx_SmokeShell
			{
				magazine = "SmokeShell";
				count = 4;
			};
			class _xx_SmokeShellGreen
			{
				magazine = "SmokeShellGreen";
				count = 4;
			};
			class _xx_SmokeShellOrange
			{
				magazine = "SmokeShellOrange";
				count = 4;
			};
			class _xx_SmokeShellBlue
			{
				magazine = "SmokeShellBlue";
				count = 4;
			};
			class _xx_NLAW_F
			{
				magazine = "NLAW_F";
				count = 2;
			};
		};
		class TransportItems
		{
			class _xx_FirstAidKit
			{
				name = "FirstAidKit";
				count = 10;
			};
		};
		class TransportWeapons
		{
			class _xx_arifle_MX_F
			{
				weapon = "arifle_MX_F";
				count = 2;
			};
		};
	};
	class MRAP_03_gmg_base_F;
	class I_MRAP_03_gmg_F;
	class Fennek_gmg_Base: I_MRAP_03_gmg_F
	{
		class EventHandlers;
		scope = 0;
		textureList[] = {"Blu",1};
		class TextureSources
		{
			class Blu_Arid
			{
				displayName = "Arid";
				author = "Phantom hawk";
				textures[] = {"A3\soft_f_beta\MRAP_03\Data\mrap_03_ext_co.paa","A3\Data_F\Vehicles\Turret_CO.paa"};
				factions[] = {"BLU_F_A","BLU_F_WD","BLU_F_D"};
			};
			class Blu_Woodland
			{
				displayName = "Woodland";
				author = "Phantom hawk";
				textures[] = {"\OKS_GOL_Misc\data\textures\Fennek_ext_wd.paa","\OKS_GOL_Misc\data\textures\Turret_wd.paa"};
				factions[] = {"BLU_F_A","BLU_F_WD","BLU_F_D"};
			};
			class Blu_Desert
			{
				displayName = "Desert";
				author = "Phantom hawk";
				textures[] = {"\OKS_GOL_Misc\data\textures\Fennek_ext_d.paa","\OKS_GOL_Misc\data\textures\Turret_d.paa"};
				factions[] = {"BLU_F_A","BLU_F_WD","BLU_F_D"};
			};
		};
	};
	class Fennek_gmg_wd: Fennek_gmg_Base
	{
		crew = "B_soldier_F";
		displayName = "Fennek GMG";
		scope = 2;
		forceInGarage = 1;
		faction = "BLU_F_WD";
		side = 1;
		vehicleClass = "Cars";
		typicalCargo[] = {"B_soldier_F"};
		class EventHandlers: EventHandlers
		{
			init = "(_this select 0) execVM ""\Fennek\scripts\ATGM.sqf""";
		};
		hiddenSelectionsTextures[] = {"\OKS_GOL_Misc\data\textures\Fennek_ext_wd.paa","\OKS_GOL_Misc\data\textures\Turret_wd.paa"};
		class TransportMagazines
		{
			class _xx_30Rnd_65x39_caseless_mag
			{
				magazine = "30Rnd_65x39_caseless_mag";
				count = 16;
			};
			class _xx_100Rnd_65x39_caseless_mag
			{
				magazine = "100Rnd_65x39_caseless_mag";
				count = 6;
			};
			class _xx_HandGrenade
			{
				magazine = "HandGrenade";
				count = 10;
			};
			class _xx_1Rnd_HE_Grenade_shell
			{
				magazine = "1Rnd_HE_Grenade_shell";
				count = 10;
			};
			class _xx_1Rnd_Smoke_Grenade_shell
			{
				magazine = "1Rnd_Smoke_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeGreen_Grenade_shell
			{
				magazine = "1Rnd_SmokeGreen_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeOrange_Grenade_shell
			{
				magazine = "1Rnd_SmokeOrange_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeBlue_Grenade_shell
			{
				magazine = "1Rnd_SmokeBlue_Grenade_shell";
				count = 4;
			};
			class _xx_16Rnd_9x21_Mag
			{
				magazine = "16Rnd_9x21_Mag";
				count = 12;
			};
			class _xx_SmokeShell
			{
				magazine = "SmokeShell";
				count = 4;
			};
			class _xx_SmokeShellGreen
			{
				magazine = "SmokeShellGreen";
				count = 4;
			};
			class _xx_SmokeShellOrange
			{
				magazine = "SmokeShellOrange";
				count = 4;
			};
			class _xx_SmokeShellBlue
			{
				magazine = "SmokeShellBlue";
				count = 4;
			};
			class _xx_NLAW_F
			{
				magazine = "NLAW_F";
				count = 2;
			};
		};
		class TransportItems
		{
			class _xx_FirstAidKit
			{
				name = "FirstAidKit";
				count = 10;
			};
		};
		class TransportWeapons
		{
			class _xx_arifle_MX_F
			{
				weapon = "arifle_MX_F";
				count = 2;
			};
		};
	};
	class Fennek_gmg_d: Fennek_gmg_Base
	{
		crew = "B_soldier_F";
		displayName = "Fennek GMG";
		scope = 2;
		forceInGarage = 1;
		faction = "BLU_F_D";
		side = 1;
		vehicleClass = "Cars";
		typicalCargo[] = {"B_soldier_F"};
		class EventHandlers: EventHandlers
		{
			init = "(_this select 0) execVM ""\Fennek\scripts\ATGM.sqf""";
		};
		hiddenSelectionsTextures[] = {"\OKS_GOL_Misc\data\textures\Fennek_ext_d.paa","\OKS_GOL_Misc\data\textures\Turret_d.paa"};
		class TransportMagazines
		{
			class _xx_30Rnd_65x39_caseless_mag
			{
				magazine = "30Rnd_65x39_caseless_mag";
				count = 16;
			};
			class _xx_100Rnd_65x39_caseless_mag
			{
				magazine = "100Rnd_65x39_caseless_mag";
				count = 6;
			};
			class _xx_HandGrenade
			{
				magazine = "HandGrenade";
				count = 10;
			};
			class _xx_1Rnd_HE_Grenade_shell
			{
				magazine = "1Rnd_HE_Grenade_shell";
				count = 10;
			};
			class _xx_1Rnd_Smoke_Grenade_shell
			{
				magazine = "1Rnd_Smoke_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeGreen_Grenade_shell
			{
				magazine = "1Rnd_SmokeGreen_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeOrange_Grenade_shell
			{
				magazine = "1Rnd_SmokeOrange_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeBlue_Grenade_shell
			{
				magazine = "1Rnd_SmokeBlue_Grenade_shell";
				count = 4;
			};
			class _xx_16Rnd_9x21_Mag
			{
				magazine = "16Rnd_9x21_Mag";
				count = 12;
			};
			class _xx_SmokeShell
			{
				magazine = "SmokeShell";
				count = 4;
			};
			class _xx_SmokeShellGreen
			{
				magazine = "SmokeShellGreen";
				count = 4;
			};
			class _xx_SmokeShellOrange
			{
				magazine = "SmokeShellOrange";
				count = 4;
			};
			class _xx_SmokeShellBlue
			{
				magazine = "SmokeShellBlue";
				count = 4;
			};
			class _xx_NLAW_F
			{
				magazine = "NLAW_F";
				count = 2;
			};
		};
		class TransportItems
		{
			class _xx_FirstAidKit
			{
				name = "FirstAidKit";
				count = 10;
			};
		};
		class TransportWeapons
		{
			class _xx_arifle_MX_F
			{
				weapon = "arifle_MX_F";
				count = 2;
			};
		};
	};
	class Fennek_gmg_e: Fennek_gmg_Base
	{
		crew = "B_soldier_F";
		displayName = "Fennek GMG";
		scope = 2;
		forceInGarage = 1;
		faction = "BLU_F_A";
		side = 1;
		vehicleClass = "Cars";
		typicalCargo[] = {"B_soldier_F"};
		class EventHandlers: EventHandlers
		{
			init = "(_this select 0) execVM ""\Fennek\scripts\ATGM.sqf""";
		};
		hiddenSelectionsTextures[] = {"A3\soft_f_beta\MRAP_03\Data\mrap_03_ext_co.paa","A3\Data_F\Vehicles\Turret_CO.paa"};
		class TransportMagazines
		{
			class _xx_30Rnd_65x39_caseless_mag
			{
				magazine = "30Rnd_65x39_caseless_mag";
				count = 16;
			};
			class _xx_100Rnd_65x39_caseless_mag
			{
				magazine = "100Rnd_65x39_caseless_mag";
				count = 6;
			};
			class _xx_HandGrenade
			{
				magazine = "HandGrenade";
				count = 10;
			};
			class _xx_1Rnd_HE_Grenade_shell
			{
				magazine = "1Rnd_HE_Grenade_shell";
				count = 10;
			};
			class _xx_1Rnd_Smoke_Grenade_shell
			{
				magazine = "1Rnd_Smoke_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeGreen_Grenade_shell
			{
				magazine = "1Rnd_SmokeGreen_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeOrange_Grenade_shell
			{
				magazine = "1Rnd_SmokeOrange_Grenade_shell";
				count = 4;
			};
			class _xx_1Rnd_SmokeBlue_Grenade_shell
			{
				magazine = "1Rnd_SmokeBlue_Grenade_shell";
				count = 4;
			};
			class _xx_16Rnd_9x21_Mag
			{
				magazine = "16Rnd_9x21_Mag";
				count = 12;
			};
			class _xx_SmokeShell
			{
				magazine = "SmokeShell";
				count = 4;
			};
			class _xx_SmokeShellGreen
			{
				magazine = "SmokeShellGreen";
				count = 4;
			};
			class _xx_SmokeShellOrange
			{
				magazine = "SmokeShellOrange";
				count = 4;
			};
			class _xx_SmokeShellBlue
			{
				magazine = "SmokeShellBlue";
				count = 4;
			};
			class _xx_NLAW_F
			{
				magazine = "NLAW_F";
				count = 2;
			};
		};
		class TransportItems
		{
			class _xx_FirstAidKit
			{
				name = "FirstAidKit";
				count = 10;
			};
		};
		class TransportWeapons
		{
			class _xx_arifle_MX_F
			{
				weapon = "arifle_MX_F";
				count = 2;
			};
		};
	};

	// ==========================================
	// GOL BMP-2DM — Vanilla optics & laser designator
	// Base: rhs_bmp2d_msv (RHS AFRF)
	// Standalone turret definitions (no turret inheritance)
	// ==========================================
	class rhs_bmp2d_msv;
	class GOL_BMP2DM: rhs_bmp2d_msv
	{
		scope = 2;
		scopeCurator = 2;
		author = "OksmanTV";
		displayName = "BMP-2DM";
		faction = "rhs_faction_msv";

		// --- Armor upgrade (75% increase over RHS stock 300) ---
		armor = 450;

		// --- Built-in info panels (GPS, crew list, vehicle info) ---
		enableGPS = 1;
		driverCanSee = 31;

		// --- Texture selections & camo presets ---
		hiddenSelections[] = {"camo1","camo2","camo3","camo4","camo5","camo6","n1","n2","n3","i1","i2","i3","i4","i5"};
		hiddenSelectionsTextures[] = {
			"rhsafrf\addons\rhs_bmp\textures\bmp_1_co.paa",
			"rhsafrf\addons\rhs_bmp\textures\bmp_2_co.paa",
			"rhsafrf\addons\rhs_bmp\textures\bmp_3_co.paa",
			"rhsafrf\addons\rhs_bmp\textures\bmp_4_co.paa",
			"rhsafrf\addons\rhs_bmp\textures\bmp_5_co.paa",
			"rhsafrf\addons\rhs_bmp\textures\bmp_6_co.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa"
		};

		class TextureSources
		{
			class MSV
			{
				displayName = "MSV (Default)";
				author = "RHS AFRF";
				factions[] = {"rhs_faction_msv"};
				textures[] = {
					"rhsafrf\addons\rhs_bmp\textures\bmp_1_co.paa",
					"rhsafrf\addons\rhs_bmp\textures\bmp_2_co.paa",
					"rhsafrf\addons\rhs_bmp\textures\bmp_3_co.paa",
					"rhsafrf\addons\rhs_bmp\textures\bmp_4_co.paa",
					"rhsafrf\addons\rhs_bmp\textures\bmp_5_co.paa",
					"rhsafrf\addons\rhs_bmp\textures\bmp_6_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa"
				};
			};
			class CSAT
			{
				displayName = "CSAT";
				author = "UK3CB";
				factions[] = {};
				textures[] = {
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\csat_s_bmp_1_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\csat_s_bmp_2_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\csat_s_bmp_3_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\csat_s_bmp_4_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\csat_s_bmp_5_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\csat_s_bmp_6_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa"
				};
			};
			class AAF
			{
				displayName = "AAF";
				author = "UK3CB";
				factions[] = {};
				textures[] = {
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\aaf_bmp_1_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\aaf_bmp_2_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\aaf_bmp_3_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\aaf_bmp_4_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\aaf_bmp_5_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\aaf_bmp_6_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa"
				};
			};
			class CHDKZ
			{
				displayName = "CHDKZ";
				author = "UK3CB";
				factions[] = {};
				textures[] = {
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\chdkz_bmp_1_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\chdkz_bmp_2_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\chdkz_bmp_3_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\chdkz_bmp_4_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\chdkz_bmp_5_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\chdkz_bmp_6_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa"
				};
			};
			class TKA
			{
				displayName = "TKA";
				author = "UK3CB";
				factions[] = {};
				textures[] = {
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\tka_bmp_1_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\tka_bmp_2_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\tka_bmp_3_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\tka_bmp_4_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\tka_bmp_5_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\tka_bmp_6_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa"
				};
			};
			class CDF
			{
				displayName = "CDF";
				author = "RHS GREF";
				factions[] = {"rhsgref_faction_cdf_ground"};
				textures[] = {
					"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_1_cdf_co.paa",
					"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_2_cdf_co.paa",
					"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_3_cdf_co.paa",
					"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_4_cdf_co.paa",
					"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_5_cdf_co.paa",
					"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_6_cdf_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa"
				};
			};
			class GAF
			{
				displayName = "GAF (Grozovian)";
				author = "UK3CB";
				factions[] = {};
				textures[] = {
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\gaf_bmp_1_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\gaf_bmp_2_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\gaf_bmp_3_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\gaf_bmp_4_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\gaf_bmp_5_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\gaf_bmp_6_co.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
					"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa"
				};
			};
		};

		// ACE self-actions for ATGM deploy/stow are added via script
		// (see XEH_postInit_Global.sqf) to avoid wiping parent ACE actions.
		// Ghost weapon removal (rhs_weap_9k11) also handled in XEH_postInit_Global.sqf
		// to avoid wiping parent RHS EventHandlers (PhysX init, etc.).

		// --- Driver camera-style view (replaces RHS 2D periscope) ---
		driverForceOptics = 1;
		driverOpticsModel = "\A3\drones_f\Weapons_F_Gamma\Reticle\UGV_01_Optics_Driver_F.p3d";
		driverOpticsColor[] = {1,1,1,1};
		driverOpticsEffect[] = {};

		class DriverOpticsIn
		{
			class OpticView
			{
				initAngleX = 0;
				minAngleX = -30;
				maxAngleX = 30;
				initAngleY = 0;
				minAngleY = -30;
				maxAngleY = 30;
				initFov = 0.7;
				minFov = 0.25;
				maxFov = 1.1;
				visionMode[] = {"Normal","NVG"};
				opticsModel = "\A3\drones_f\Weapons_F_Gamma\Reticle\UGV_01_Optics_Driver_F.p3d";
				gunnerOpticsEffect[] = {};
			};
		};

		// --- Driver info panels (Ctrl+Left/Right) ---
		// Driver sees: Gunner camera + Commander camera
		class Components
		{
			class VehicleSystemsDisplayManagerComponentLeft: VehicleSystemsTemplateLeftDriver
			{
				class Components: components
				{
					class VehiclePrimaryGunnerDisplay
					{
						componentType = "TransportFeedDisplayComponent";
						source = "PrimaryGunner";
					};
					class VehicleCommanderDisplay
					{
						componentType = "TransportFeedDisplayComponent";
						source = "Commander";
					};
				};
			};
			class VehicleSystemsDisplayManagerComponentRight: VehicleSystemsTemplateRightDriver
			{
				class Components: components
				{
					class VehiclePrimaryGunnerDisplay
					{
						componentType = "TransportFeedDisplayComponent";
						source = "PrimaryGunner";
					};
					class VehicleCommanderDisplay
					{
						componentType = "TransportFeedDisplayComponent";
						source = "Commander";
					};
				};
			};
		};

		class Turrets
		{
			class MainTurret
			{
				// --- Turret identity ---
				gunnerName = "Gunner";
				gunnerType = "";
				proxyType = "CPGunner";
				proxyIndex = 1;
				primaryGunner = 1;
				primaryObserver = 0;
				commanding = 1;
				hasGunner = 1;
				dontCreateAI = 0;
				isPersonTurret = 0;
				isCopilot = 0;
				startEngine = 0;
				canEject = 1;
				primary = 1;
				playerPosition = 0;

				// --- Animation sources ---
				body = "RHS_BMP1_MainTurret";
				gun = "RHS_BMP1_MainGun";
				animationSourceBody = "MainTurret";
				animationSourceGun = "MainGun";
				animationSourceHatch = "HatchGunner";
				animationSourceCamElev = "camElev";
				selectionFireAnim = "zasleh_1";

				// --- Memory points ---
				memoryPointGun = "machinegun";
				memoryPointGunnerOptics = "view_bpk42";
				memoryPointGunnerOutOptics = "view_bpk42";
				memoryPointsGetInGunner = "pos gunner";
				memoryPointsGetInGunnerDir = "pos gunner dir";
				memoryPointsGetInGunnerPrecise = "";
				gunBeg = "Gun_start";
				gunEnd = "Gun_end";
				missileBeg = "spice rakety";
				missileEnd = "konec rakety";

				// --- Actions ---
				gunnerAction = "rhs_bmp2_gunner";
				gunnerInAction = "rhs_bmp2_gunnerin";
				personTurretAction = "RHS_passenger_inside_6";
				gunnerGetInAction = "GetInHigh";
				gunnerGetOutAction = "GetOutHigh";
				gunnerDoor = "hatchG";
				preciseGetInOut = 0;

				// --- Weapons (GOL wrappers enable vanilla FCS auto-range) ---
				// HE/AP split into separate single-muzzle weapons (weapon-switch to toggle ammo type)
				weapons[] = {"GOL_weap_2a42_HE","GOL_weap_2a42_AP","GOL_weap_pkt","rhs_weap_9m113","rhs_weap_902a"};
				magazines[] = {"rhs_mag_3uof8_340","rhs_mag_3uof8_340","rhs_mag_3uof8_340","rhs_mag_3ubr8_160","rhs_mag_3ubr8_160","rhs_mag_3ubr8_160","rhs_mag_9m113M","rhs_mag_9m113M","rhs_mag_9m113M","rhs_mag_9m113M","rhs_mag_762x54mm_2000","rhs_mag_3d17_6"};

				// --- Turret movement ---
				minElev = -5;
				maxElev = 74;
				initElev = 0;
				minTurn = -360;
				maxTurn = 360;
				initTurn = 0;
				minOutElev = -45;
				maxOutElev = 45;
				initOutElev = 0;
				minOutTurn = -60;
				maxOutTurn = 60;
				initOutTurn = 0;
				minCamElev = -90;
				maxCamElev = 90;
				initCamElev = 0;
				maxhorizontalrotspeed = 0.61;
				maxverticalrotspeed = 0.104;
				stabilizedInAxes = 3;

				// --- Optics behavior ---
				gunnerForceoptics = 1;
				gunnerOutForceOptics = 0;
				LodOpticsIn = 0;
				LodOpticsOut = 0;
				nightVision = 1;
				forceNVG = 0;
				showHMD = 0;
				canUseScanners = 0;
				allowTabLock = 0;
				discreteDistance[] = {100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,2600,2700,2800,2900,3000};
				discreteDistanceInitIndex = 2;

				// --- Vanilla HUD (Badger-style) ---
				turretInfoType = "RscOptics_APC_Wheeled_01_gunner";
				gunnerOpticsModel = "\A3\weapons_f\reticle\Optics_Gunner_02_F";
				gunnerOutOpticsModel = "";
				gunnerOpticsEffect[] = {};
				gunnerOutOpticsEffect[] = {};
				gunnerOpticsColor[] = {0,0,0,1};
				gunnerOpticsShowCursor = 0;
				gunnerOutOpticsColor[] = {0,0,0,1};
				gunnerOutOpticsShowCursor = 0;

				// --- Vanilla-style multi-zoom optics ---
				class OpticsIn
				{
					class Wide
					{
						opticsDisplayName = "W";
						initAngleX = 0;
						minAngleX = -30;
						maxAngleX = 30;
						initAngleY = 0;
						minAngleY = -100;
						maxAngleY = 100;
						initFov = 0.6;
						minFov = 0.6;
						maxFov = 0.6;
						visionMode[] = {"Normal","NVG","Ti"};
						thermalMode[] = {0,1};
						gunnerOpticsModel = "\A3\Weapons_F\Reticle\Optics_Gunner_APC_01_w_F.p3d";
						gunnerOpticsEffect[] = {};
					};
					class Medium: Wide
					{
						opticsDisplayName = "M";
						initFov = 0.175;
						minFov = 0.175;
						maxFov = 0.175;
						gunnerOpticsModel = "\A3\Weapons_F\Reticle\Optics_Gunner_APC_01_m_F.p3d";
					};
					class Narrow: Wide
					{
						opticsDisplayName = "N";
						initFov = 0.0583;
						minFov = 0.0583;
						maxFov = 0.0583;
						gunnerOpticsModel = "\A3\Weapons_F\Reticle\Optics_Gunner_APC_01_n_F.p3d";
					};
					class VNarrow: Wide
					{
						opticsDisplayName = "VN";
						initFov = 0.0292;
						minFov = 0.0292;
						maxFov = 0.0292;
						gunnerOpticsModel = "\A3\Weapons_F\Reticle\Optics_Gunner_APC_01_n_F.p3d";
					};
					class UNarrow: Wide
					{
						opticsDisplayName = "UN";
						initFov = 0.0146;
						minFov = 0.0146;
						maxFov = 0.0146;
						gunnerOpticsModel = "\A3\Weapons_F\Reticle\Optics_Gunner_APC_01_n_F.p3d";
					};
				};

				class OpticsOut
				{
					class Optics1
					{
						opticsDisplayName = "OUT";
						initAngleX = 0;
						minAngleX = -30;
						maxAngleX = 30;
						initAngleY = 0;
						minAngleY = -100;
						maxAngleY = 100;
						initFov = 0.7;
						minFov = 0.25;
						maxFov = 1.1;
						visionMode[] = {"Normal","NVG"};
						gunnerOpticsModel = "";
						gunnerOpticsEffect[] = {};
					};
				};

				// --- Gunner visibility ---
				forcehidegunner = 0;
				viewGunnerInExternal = 1;
				castGunnerShadow = 0;
				viewGunnerShadow = 1;
				viewGunnerShadowDiff = 1;
				viewGunnerShadowAmb = 1;
				ejectDeadGunner = 0;
				hideWeaponsGunner = 1;
				canHideGunner = -1;
				outGunnerMayFire = 0;
				inGunnerMayFire = 1;
				gunnerFireAlsoInInternalCamera = 1;
				gunnerOutFireAlsoInInternalCamera = 1;
				gunnerUsesPilotView = 0;
				lockWhenDriverOut = 1;
				lockWhenVehicleSpeed = -1;
				turretFollowFreeLook = 0;
				showAllTargets = 0;
				showCrewAim = 0;
				disableSoundAttenuation = 0;
				slingLoadOperator = 0;
				allowLauncherIn = 0;
				allowLauncherOut = 0;

				// --- Misc ---
				gunnerCompartments = "Compartment1";
				LODTurnedIn = -1;
				LODTurnedOut = -1;
				armorLights = 0.1;
				aggregateReflectors[] = {};
				soundServo[] = {"\rhsafrf\addons\rhs_bmp\sounds\turret1.wss",4,1,10};
				soundElevation[] = {"",0.00316228,1};
				gunnerLeftHandAnimName = "";
				gunnerRightHandAnimName = "";
				gunnerLeftLegAnimName = "";
				gunnerRightLegAnimName = "";
				turretCanSee = 31;

				class Reflectors {};

				// --- ACE FCS ---
				ace_fcs_Enabled = 0;
				ace_fcs_MinDistance = 200;
				ace_fcs_MaxDistance = 5500;
				ace_fcs_DistanceInterval = 5;

				// --- Gunner info panels (Ctrl+Left/Right) ---
				// Gunner sees: Driver camera + Commander camera
				class Components
				{
					class VehicleSystemsDisplayManagerComponentLeft: VehicleSystemsTemplateLeftGunner
					{
						class Components: components
						{
							class VehicleDriverDisplay
							{
								componentType = "TransportFeedDisplayComponent";
								source = "Driver";
							};
							class VehicleCommanderDisplay
							{
								componentType = "TransportFeedDisplayComponent";
								source = "Commander";
							};
						};
					};
					class VehicleSystemsDisplayManagerComponentRight: VehicleSystemsTemplateRightGunner
					{
						class Components: components
						{
							class VehicleDriverDisplay
							{
								componentType = "TransportFeedDisplayComponent";
								source = "Driver";
							};
							class VehicleCommanderDisplay
							{
								componentType = "TransportFeedDisplayComponent";
								source = "Commander";
							};
						};
					};
				};

				// --- Commander sub-turret (standalone) ---
				class Turrets
				{
					class CommanderOptics
					{
						// --- Identity ---
						gunnerName = "Commander";
						gunnerType = "";
						proxyType = "CPCommander";
						proxyIndex = 1;
						primaryGunner = 0;
						primaryObserver = 1;
						hasCommander = 1;
						hasGunner = 1;
						dontCreateAI = 1;
						commanding = 2;
						isPersonTurret = 0;
						isCopilot = 0;
						startEngine = 0;
						canEject = 1;
						primary = 1;
						playerPosition = 0;

						// --- Animation sources ---
						body = "RHS_BMP1_com_coppula_BMP2";
						gun = "RHS_BMP1_OU3_BMP2";
						animationSourceBody = "obsturret";
						animationSourceGun = "obsGun";
						animationSourceHatch = "HatchCommander_BMP2";
						animationSourceCamElev = "camElev";
						selectionFireAnim = "";

						// --- Memory points ---
						memoryPointGun = "gun_muzzle";
						memoryPointGunnerOptics = "ou3_bmp2";
						memoryPointGunnerOutOptics = "commander_out_view";
						memoryPointsGetInGunner = "pos commander";
						memoryPointsGetInGunnerDir = "pos commander dir";
						memoryPointsGetInGunnerPrecise = "";
						gunBeg = "Mgun_end";
						gunEnd = "Mgun_start";
						missileBeg = "spice rakety";
						missileEnd = "konec rakety";

						// --- Actions ---
						gunnerAction = "RHS_passenger_inside_6";
						gunnerInAction = "rhs_bmp2_commanderIn";
						personTurretAction = "RHS_passenger_inside_6";
						gunnerGetInAction = "GetInHigh";
						gunnerGetOutAction = "GetOutHigh";
						gunnerDoor = "hatchC";
						preciseGetInOut = 0;

						// --- Weapons (commander has laser designator) ---
						weapons[] = {"Laserdesignator_mounted"};
						magazines[] = {"Laserbatteries"};

						// --- Turret movement ---
						minElev = -4;
						maxElev = 60;
						initElev = 0;
						minTurn = -135;
						maxTurn = 135;
						initTurn = 0;
						minOutElev = -4;
						maxOutElev = 20;
						initOutElev = 0;
						minOutTurn = -60;
						maxOutTurn = 60;
						initOutTurn = 0;
						minCamElev = -90;
						maxCamElev = 90;
						initCamElev = 0;
						maxHorizontalRotSpeed = 1.2;
						maxVerticalRotSpeed = 1.2;
						stabilizedInAxes = 3;

						// --- Optics behavior ---
						gunnerForceoptics = 1;
						gunnerOutForceOptics = 0;
						LodOpticsIn = 0;
						LodOpticsOut = 0;
						forceNVG = 0;
						showHMD = 0;
						canUseScanners = 0;
						allowTabLock = 0;

						// --- Vanilla HUD (Badger-style commander) ---
						turretInfoType = "RscOptics_MBT_01_commander";
						gunnerOpticsModel = "\A3\weapons_f\reticle\Optics_Commander_02_F";
						gunnerOutOpticsModel = "";
						gunnerOpticsEffect[] = {};
						gunnerOutOpticsEffect[] = {};
						gunnerOpticsColor[] = {0,0,0,1};
						gunnerOpticsShowCursor = 0;
						gunnerOutOpticsColor[] = {0,0,0,1};
						gunnerOutOpticsShowCursor = 0;

						// --- Vanilla-style multi-zoom commander optics ---
						class OpticsIn
						{
							class Wide
							{
								opticsDisplayName = "W";
								initAngleX = 0;
								minAngleX = -30;
								maxAngleX = 30;
								initAngleY = 0;
								minAngleY = -100;
								maxAngleY = 100;
								initFov = 0.6;
								minFov = 0.6;
								maxFov = 0.6;
								visionMode[] = {"Normal","NVG","Ti"};
								thermalMode[] = {0,1};
								gunnerOpticsModel = "\A3\Weapons_F\Reticle\Optics_Commander_01_w_F.p3d";
								gunnerOpticsEffect[] = {};
							};
							class Medium: Wide
							{
								opticsDisplayName = "M";
								initFov = 0.175;
								minFov = 0.175;
								maxFov = 0.175;
								gunnerOpticsModel = "\A3\Weapons_F\Reticle\Optics_Commander_01_m_F.p3d";
							};
							class Narrow: Wide
							{
								opticsDisplayName = "N";
								initFov = 0.0583;
								minFov = 0.0583;
								maxFov = 0.0583;
								gunnerOpticsModel = "\A3\Weapons_F\Reticle\Optics_Commander_01_n_F.p3d";
							};
							class VNarrow: Wide
							{
								opticsDisplayName = "VN";
								initFov = 0.0292;
								minFov = 0.0292;
								maxFov = 0.0292;
								gunnerOpticsModel = "\A3\Weapons_F\Reticle\Optics_Commander_01_n_F.p3d";
							};
							class UNarrow: Wide
							{
								opticsDisplayName = "UN";
								initFov = 0.0146;
								minFov = 0.0146;
								maxFov = 0.0146;
								gunnerOpticsModel = "\A3\Weapons_F\Reticle\Optics_Commander_01_n_F.p3d";
							};
						};

						class OpticsOut
						{
							class Optics1
							{
								opticsDisplayName = "OUT";
								initAngleX = 0;
								minAngleX = -30;
								maxAngleX = 30;
								initAngleY = 0;
								minAngleY = -100;
								maxAngleY = 100;
								initFov = 0.7;
								minFov = 0.25;
								maxFov = 1.1;
								visionMode[] = {"Normal","NVG"};
								gunnerOpticsModel = "";
								gunnerOpticsEffect[] = {};
							};
						};

						// --- Commander visibility ---
						viewGunnerInExternal = 1;
						castGunnerShadow = 0;
						viewGunnerShadow = 1;
						viewGunnerShadowDiff = 1;
						viewGunnerShadowAmb = 1;
						ejectDeadGunner = 0;
						hideWeaponsGunner = 1;
						canHideGunner = -1;
						forceHideGunner = 0;
						outGunnerMayFire = 0;
						inGunnerMayFire = 1;
						gunnerFireAlsoInInternalCamera = 1;
						gunnerOutFireAlsoInInternalCamera = 1;
						gunnerUsesPilotView = 0;
						lockWhenDriverOut = 0;
						lockWhenVehicleSpeed = -1;
						turretFollowFreeLook = 0;
						showAllTargets = 0;
						showCrewAim = 0;
						disableSoundAttenuation = 0;
						slingLoadOperator = 0;
						allowLauncherIn = 0;
						allowLauncherOut = 0;

						// --- Misc ---
						gunnerCompartments = "Compartment1";
						LODTurnedIn = -1;
						LODTurnedOut = -1;
						armorLights = 0.4;
						aggregateReflectors[] = {};
						soundServo[] = {};
						soundElevation[] = {"",0.00316228,1};
						gunnerLeftHandAnimName = "";
						gunnerRightHandAnimName = "";
						gunnerLeftLegAnimName = "";
						gunnerRightLegAnimName = "";
						turretCanSee = 31;

						class Reflectors {};
						class Turrets {};

						// --- ACE FCS ---
						ace_fcs_Enabled = 0;
						ace_fcs_MinDistance = 200;
						ace_fcs_MaxDistance = 5500;
						ace_fcs_DistanceInterval = 5;

						// --- Commander info panels (Ctrl+Left/Right) ---
						// Commander sees: Driver camera + Gunner camera
						class Components
						{
							class VehicleSystemsDisplayManagerComponentLeft: VehicleSystemsTemplateLeftCommander
							{
								class Components: components
								{
									class VehicleDriverDisplay
									{
										componentType = "TransportFeedDisplayComponent";
										source = "Driver";
									};
									class VehiclePrimaryGunnerDisplay
									{
										componentType = "TransportFeedDisplayComponent";
										source = "PrimaryGunner";
									};
								};
							};
							class VehicleSystemsDisplayManagerComponentRight: VehicleSystemsTemplateRightCommander
							{
								class Components: components
								{
									class VehicleDriverDisplay
									{
										componentType = "TransportFeedDisplayComponent";
										source = "Driver";
									};
									class VehiclePrimaryGunnerDisplay
									{
										componentType = "TransportFeedDisplayComponent";
										source = "PrimaryGunner";
									};
								};
							};
						};
					};
				};
			};
		};
	};

	// --- GOL BMP-2DM CDF variant ---
	class GOL_BMP2DM_CDF: GOL_BMP2DM
	{
		displayName = "BMP-2DM (CDF)";
		faction = "rhsgref_faction_cdf_ground";
		side = 2;
		hiddenSelectionsTextures[] = {
			"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_1_cdf_co.paa",
			"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_2_cdf_co.paa",
			"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_3_cdf_co.paa",
			"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_4_cdf_co.paa",
			"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_5_cdf_co.paa",
			"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_6_cdf_co.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa"
		};
	};

	// --- GOL BMP-2DM GAF variant ---
	class GOL_BMP2DM_GAF: GOL_BMP2DM
	{
		displayName = "BMP-2DM (GAF)";
		faction = "UK3CB_GAF_B";
		side = 1;
		hiddenSelectionsTextures[] = {
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\gaf_bmp_1_co.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\gaf_bmp_2_co.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\gaf_bmp_3_co.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\gaf_bmp_4_co.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\gaf_bmp_5_co.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\apc\UK3CB_Factions_Vehicles_BMP\data\gaf_bmp_6_co.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa",
			"\UK3CB_Factions\addons\UK3CB_Factions_Vehicles\UK3CB_Factions_Vehicles_common\decal\no_ca.paa"
		};
	};

	// TFAR Intercom patch (enables intercom on MRAPs)
	#include "compat\compat_tfar_intercom.hpp"
};
