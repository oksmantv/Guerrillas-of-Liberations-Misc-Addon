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

// --- Forward declarations for Sensor templates ---
class SensorTemplatePassiveRadar;
class SensorTemplateActiveRadar;
class SensorTemplateIR;
class SensorTemplateVisual;
class SensorTemplateLaser;
class SensorTemplateNV;
class SensorTemplateDataLink;

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
        class AnimationSources {
            class Missiles_revolving {
                source = "revolving";
                weapon = "gol_weapon_s750Launcher";
            };
            class HitLFWheel {
                source = "Hit";
                hitpoint = "HitLFWheel";
                raw = 1;
            };
            class HitLBWheel : HitLFWheel { hitpoint = "HitLBWheel"; };
            class HitRFWheel : HitLFWheel { hitpoint = "HitRFWheel"; };
            class HitRBWheel : HitLFWheel { hitpoint = "HitRBWheel"; };
            class HitTurret : HitLFWheel { hitpoint = "HitTurret"; };
            class HitGun    : HitLFWheel { hitpoint = "HitGun"; };
            class HitHull   : HitLFWheel { hitpoint = "HitHull"; };
        };
    };

	class I_E_SAM_System_03_F;
    class GOL_I_E_SAM_System_03_F : I_E_SAM_System_03_F {
	displayName = "MIM-104 Patriot (Disabled ACE Guidance)";
        class AnimationSources {
            class Missiles_revolving {
                source = "revolving";
                weapon = "gol_weapon_s750Launcher";
            };
            class HitLFWheel {
                source = "Hit";
                hitpoint = "HitLFWheel";
                raw = 1;
            };
            class HitLBWheel : HitLFWheel { hitpoint = "HitLBWheel"; };
            class HitRFWheel : HitLFWheel { hitpoint = "HitRFWheel"; };
            class HitRBWheel : HitLFWheel { hitpoint = "HitRBWheel"; };
            class HitTurret : HitLFWheel { hitpoint = "HitTurret"; };
            class HitGun    : HitLFWheel { hitpoint = "HitGun"; };
            class HitHull   : HitLFWheel { hitpoint = "HitHull"; };
        };
    };	

	class B_SAM_System_03_F;
    class GOL_B_SAM_System_03_F : B_SAM_System_03_F {
	displayName = "MIM-104 Patriot (Disabled ACE Guidance)";
        class AnimationSources {
            class Missiles_revolving {
                source = "revolving";
                weapon = "gol_weapon_s750Launcher";
            };
            class HitLFWheel {
                source = "Hit";
                hitpoint = "HitLFWheel";
                raw = 1;
            };
            class HitLBWheel : HitLFWheel { hitpoint = "HitLBWheel"; };
            class HitRFWheel : HitLFWheel { hitpoint = "HitRFWheel"; };
            class HitRBWheel : HitLFWheel { hitpoint = "HitRBWheel"; };
            class HitTurret : HitLFWheel { hitpoint = "HitTurret"; };
            class HitGun    : HitLFWheel { hitpoint = "HitGun"; };
            class HitHull   : HitLFWheel { hitpoint = "HitHull"; };
        };
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

    class OKS_Module_Mortars : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Mortar Fire Support";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleMortars";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Mortar fire support module. Sync to a trigger to delay activation. Sync to an OKS_Module_MortarTarget for designated target position. Sync a placed mortar/artillery vehicle to use it directly at runtime — its position is used as the firing position. If no vehicle is synced, one is spawned from the 'Vehicle Class' classname at the module position. NOTE: There is a ~10 second warmup after activation for manned mortars (AI gunner mounting).";
        };
        class Arguments {
            class Platform {
                displayName = "Platform";
                description = "Manned: uses a synced vehicle or spawns from 'Vehicle Class' with an AI gunner. OffMap: virtual strike, no physical mortar.";
                typeName = "STRING";
                defaultValue = "manned";
                class values {
                    class Manned  { name = "Manned";  value = "manned"; };
                    class OffMap   { name = "Off-Map"; value = "offmap"; };
                };
            };
            class FallbackVehicle {
                displayName = "Vehicle Class";
                description = "Fallback classname used when no vehicle is synced (Manned only). If a vehicle is synced to this module, it is used directly and this field is ignored. Examples: O_Mortar_01_F, B_Mortar_01_F, rhs_2b14_82mm_msv, RHS_M252_USMC_WD";
                typeName = "STRING";
                defaultValue = "O_Mortar_01_F";
            };
            class Side {
                displayName = "Side";
                description = "Side the mortar crew belongs to.";
                typeName = "STRING";
                defaultValue = "east";
                class values {
                    class East        { name = "EAST";        value = "east"; };
                    class West        { name = "WEST";        value = "west"; };
                    class Independent { name = "INDEPENDENT"; value = "independent"; };
                };
            };
            class FiringMode {
                displayName = "Firing Mode";
                description = "Sporadic: random inaccurate. Precise: slow accurate. Barrage: fast salvo. Guided: walks onto target. Screen: line pattern. Random: picks one each cycle.";
                typeName = "STRING";
                defaultValue = "precise";
                class values {
                    class Precise  { name = "Precise";  value = "precise"; };
                    class Barrage  { name = "Barrage";  value = "barrage"; };
                    class Sporadic { name = "Sporadic"; value = "sporadic"; };
                    class Guided   { name = "Guided";   value = "guided"; };
                    class Screen   { name = "Screen";   value = "screen"; };
                    class Random   { name = "Random";   value = "random"; };
                };
            };
            class RoundType {
                displayName = "Round Type";
                description = "Ammunition type defined in Mortar_Settings.";
                typeName = "STRING";
                defaultValue = "light";
                class values {
                    class Light  { name = "Light";  value = "light"; };
                    class Medium { name = "Medium"; value = "medium"; };
                    class Heavy  { name = "Heavy";  value = "heavy"; };
                    class Smoke  { name = "Smoke";  value = "smoke"; };
                    class Flare  { name = "Flare";  value = "flare"; };
                };
            };
            class Targeting {
                displayName = "Targeting";
                description = "Auto: mortar picks its own targets. Designated: sync an OKS_Module_MortarTarget to set the target position. Falls back to module position if no target synced.";
                typeName = "STRING";
                defaultValue = "designated";
                class values {
                    class Designated { name = "Designated"; value = "designated"; };
                    class Auto       { name = "Auto";       value = "auto"; };
                };
            };
            class Inaccuracy {
                displayName = "Inaccuracy";
                description = "Round scatter in meters.";
                typeName = "NUMBER";
                defaultValue = 50;
            };
            class MinRange {
                displayName = "Min Range";
                description = "Minimum engagement range (Auto targeting only).";
                typeName = "NUMBER";
                defaultValue = 150;
            };
            class MaxRange {
                displayName = "Max Range";
                description = "Maximum engagement range (Auto targeting only).";
                typeName = "NUMBER";
                defaultValue = 400;
            };
            class Ammo {
                displayName = "Ammo";
                description = "Total rounds available.";
                typeName = "NUMBER";
                defaultValue = 20;
            };
            class RoundInterval {
                displayName = "Round Interval";
                description = "Seconds between rounds. -1 uses mode default.";
                typeName = "NUMBER";
                defaultValue = -1;
            };
            class RoundCount {
                displayName = "Round Count";
                description = "Forced rounds per burst. -1 uses mode default.";
                typeName = "NUMBER";
                defaultValue = -1;
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before firing. Use to stagger multiple modules on the same trigger.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    class OKS_Module_MortarTarget : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Mortar Target";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "";
        functionPriority = 0;
        isGlobal = 0;
        isTriggerActivated = 0;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Designates a target position for Mortar Fire Support. Synchronize this module to an OKS_Module_Mortars to set where rounds land. Drag to move the impact point.";
        };
    };

    // ==================== Radar ====================
    class OKS_Module_Radar : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Radar Share";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleRadar";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Radar share module. Sync a crewed radar vehicle to use it — the vehicle MUST have crew (the script does not create crew). If no vehicle is synced, one is spawned from 'Vehicle Class' at the module position (unmanned — add crew in Eden or it will not function). Nearby AAA vehicles matching the classnames list will receive target data from the radar.";
        };
        class Arguments {
            class FallbackVehicle {
                displayName = "Vehicle Class";
                description = "Radar classname used when no vehicle is synced. Synced vehicles take priority. The radar MUST have crew to function. Examples: O_Radar_System_02_F, B_Radar_System_01_F";
                typeName = "STRING";
                defaultValue = "O_Radar_System_02_F";
            };
            class AAAClassnames {
                displayName = "AAA Classnames";
                description = "Comma-separated vehicle classnames of AAA assets the radar will assist. The radar shares target data with nearby vehicles of these types.";
                typeName = "STRING";
                defaultValue = "rhsgref_ins_zsu234";
            };
            class ShareDistance {
                displayName = "Share Distance";
                description = "Range in meters within which AAA assets receive radar data.";
                typeName = "NUMBER";
                defaultValue = 2000;
            };
            class MaxRangeAAA {
                displayName = "Max Range AAA";
                description = "Maximum engagement range for AAA assets.";
                typeName = "NUMBER";
                defaultValue = 2500;
            };
            class MinimumAltitude {
                displayName = "Minimum Altitude";
                description = "Minimum altitude (meters) a target must be at to be considered.";
                typeName = "NUMBER";
                defaultValue = 100;
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before starting. Use to stagger multiple modules on the same trigger.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    // ==================== ArtyFire ====================
    class OKS_Module_ArtyFire : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Artillery Fire (Ambience)";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleArtyFire";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Ambient artillery fire module. Sync an artillery vehicle to use it directly, or one is spawned from 'Vehicle Class'. Sync an OKS_Module_ArtyTarget to set the impact position. The artillery will fire cyclically: 'Rounds' per salvo, 'Reload Time' between rounds, 'Rearm Time' between salvos.";
        };
        class Arguments {
            class Side {
                displayName = "Side";
                description = "Side the artillery crew belongs to.";
                typeName = "STRING";
                defaultValue = "east";
                class values {
                    class East        { name = "EAST";        value = "east"; };
                    class West        { name = "WEST";        value = "west"; };
                    class Independent { name = "INDEPENDENT"; value = "independent"; };
                };
            };
            class FallbackVehicle {
                displayName = "Vehicle Class";
                description = "Artillery classname used when no vehicle is synced. Synced vehicles take priority. Examples: rhs_2s1_tv, RHS_M119_WD";
                typeName = "STRING";
                defaultValue = "rhs_2s1_tv";
            };
            class Rounds {
                displayName = "Rounds";
                description = "Number of rounds fired per salvo.";
                typeName = "NUMBER";
                defaultValue = 7;
            };
            class RearmTime {
                displayName = "Rearm Time";
                description = "Seconds between salvos (cooldown).";
                typeName = "NUMBER";
                defaultValue = 300;
            };
            class ReloadTime {
                displayName = "Reload Time";
                description = "Seconds between individual rounds within a salvo.";
                typeName = "NUMBER";
                defaultValue = 30;
            };
            class FullCrew {
                displayName = "Full Crew";
                description = "Spawn commander crew in addition to gunner (if artillery has commander seat with weapon).";
                typeName = "STRING";
                defaultValue = "no";
                class values {
                    class No  { name = "No";  value = "no"; };
                    class Yes { name = "Yes"; value = "yes"; };
                };
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before firing. Use to stagger multiple modules on the same trigger.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    class OKS_Module_ArtyTarget : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Artillery Target";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "";
        functionPriority = 0;
        isGlobal = 0;
        isTriggerActivated = 0;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Designates a target position. Sync to an OKS_Module_ArtyFire or OKS_Module_ArtySuppression. For Suppression, sync multiple of these to define the firing sequence. Drag to move the impact point.";
        };
    };

    // ==================== Artillery Suppression ====================
    class OKS_Module_ArtySuppression : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Artillery Suppression";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleArtySuppression";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Artillery suppression module. Sync an artillery vehicle to use it directly, or one is spawned from 'Vehicle Class'. Sync multiple OKS_Module_ArtyTarget modules to define target positions — the artillery fires at each in sequence. Crew is auto-created if the vehicle has none.";
        };
        class Arguments {
            class Side {
                displayName = "Side";
                description = "Side the artillery crew belongs to.";
                typeName = "STRING";
                defaultValue = "east";
                class values {
                    class East        { name = "EAST";        value = "east"; };
                    class West        { name = "WEST";        value = "west"; };
                    class Independent { name = "INDEPENDENT"; value = "independent"; };
                };
            };
            class FallbackVehicle {
                displayName = "Vehicle Class";
                description = "Artillery classname used when no vehicle is synced. Synced vehicles take priority. Examples: rhs_2s1_tv, RHS_M119_WD";
                typeName = "STRING";
                defaultValue = "rhs_2s1_tv";
            };
            class RoundsPerTarget {
                displayName = "Rounds Per Target";
                description = "Number of rounds fired at each target position.";
                typeName = "NUMBER";
                defaultValue = 3;
            };
            class TimeBetweenRounds {
                displayName = "Time Between Rounds";
                description = "Seconds between individual rounds.";
                typeName = "NUMBER";
                defaultValue = 5;
            };
            class UnlimitedAmmo {
                displayName = "Unlimited Ammo";
                description = "Refill ammo after each salvo.";
                typeName = "STRING";
                defaultValue = "yes";
                class values {
                    class Yes { name = "Yes"; value = "yes"; };
                    class No  { name = "No";  value = "no"; };
                };
            };
            class ShouldLoop {
                displayName = "Loop";
                description = "Continuously loop through all targets until the artillery is destroyed.";
                typeName = "STRING";
                defaultValue = "yes";
                class values {
                    class Yes { name = "Yes"; value = "yes"; };
                    class No  { name = "No";  value = "no"; };
                };
            };
            class LoopDelay {
                displayName = "Loop Delay";
                description = "Seconds to wait between loops (only when Loop is enabled).";
                typeName = "NUMBER";
                defaultValue = 120;
            };
            class ShouldMark {
                displayName = "Mark Targets";
                description = "Drop red smoke (day) or flare (night) on target before firing.";
                typeName = "STRING";
                defaultValue = "yes";
                class values {
                    class Yes { name = "Yes"; value = "yes"; };
                    class No  { name = "No";  value = "no"; };
                };
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before firing. Use to stagger multiple modules on the same trigger.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    // ==================== LAMBS SpawnGroup ====================
    class OKS_Module_LambsSpawnGroup : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "LAMBS Spawn Group";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleLambsSpawnGroup";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Spawns a LAMBS AI group at the module position. Infantry mode: spawns a foot patrol. Vehicle mode: sync pre-placed vehicles to use their classnames (vehicles are deleted at runtime, fresh ones spawned by the script). If no vehicles are synced, uses the 'Vehicle Class' fallback.";
        };
        class Arguments {
            class Mode {
                displayName = "Mode";
                description = "Infantry: spawns foot soldiers. Vehicle: spawns a vehicle with cargo (sync vehicles for classnames or use fallback).";
                typeName = "STRING";
                defaultValue = "infantry";
                class values {
                    class Infantry { name = "Infantry"; value = "infantry"; };
                    class Vehicle  { name = "Vehicle";  value = "vehicle"; };
                };
            };
            class LambsType {
                displayName = "LAMBS Type";
                description = "AI behaviour type from LAMBS danger.";
                typeName = "STRING";
                defaultValue = "rush";
                class values {
                    class Rush        { name = "Rush";         value = "rush"; };
                    class Hunt        { name = "Hunt";         value = "hunt"; };
                    class Creep       { name = "Creep";        value = "creep"; };
                    class Attack      { name = "Attack";       value = "attack"; };
                    class AmbushAttack { name = "Ambush Attack"; value = "ambushattack"; };
                    class AmbushRush  { name = "Ambush Rush";  value = "ambushrush"; };
                    class AmbushHunt  { name = "Ambush Hunt";  value = "ambushhunt"; };
                    class AmbushCQB   { name = "Ambush CQB";   value = "ambushcqb"; };
                };
            };
            class Side {
                displayName = "Side";
                description = "Side the spawned units belong to.";
                typeName = "STRING";
                defaultValue = "east";
                class values {
                    class East        { name = "EAST";        value = "east"; };
                    class West        { name = "WEST";        value = "west"; };
                    class Independent { name = "INDEPENDENT"; value = "independent"; };
                };
            };
            class UnitCount {
                displayName = "Unit Count";
                description = "Number of infantry to spawn (Infantry mode only).";
                typeName = "NUMBER";
                defaultValue = 6;
            };
            class FallbackVehicle {
                displayName = "Vehicle Class";
                description = "Vehicle classname used when no vehicle is synced (Vehicle mode only). Sync placed vehicles for their classnames instead. Examples: O_MRAP_02_hmg_F, O_APC_Wheeled_02_rcws_v2_F";
                typeName = "STRING";
                defaultValue = "O_MRAP_02_hmg_F";
            };
            class CargoCount {
                displayName = "Cargo Count";
                description = "Number of infantry in vehicle cargo (Vehicle mode only).";
                typeName = "NUMBER";
                defaultValue = 2;
            };
            class Range {
                displayName = "Range";
                description = "Tracking range for LAMBS AI and ambush trigger radius.";
                typeName = "NUMBER";
                defaultValue = 1500;
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before spawning. Use to stagger multiple modules on the same trigger.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    // ==================== Convoy ====================
    class OKS_Module_Convoy : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Convoy Spawn";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleConvoy";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Spawns a convoy at the module position. Sync to OKS_Module_ConvoyWaypoint modules to define the route: Main → WP1 → WP2 → ... → End. Each waypoint syncs to the next. The last waypoint must have Type=End. Sync pre-placed vehicles to use their classnames (vehicles are deleted at runtime). If no vehicles are synced, uses the 'Vehicle Classnames' field.";
        };
        class Arguments {
            class Side {
                displayName = "Side";
                description = "Side the convoy units belong to.";
                typeName = "STRING";
                defaultValue = "east";
                class values {
                    class East        { name = "EAST";        value = "east"; };
                    class West        { name = "WEST";        value = "west"; };
                    class Independent { name = "INDEPENDENT"; value = "independent"; };
                };
            };
            class VehicleCount {
                displayName = "Vehicle Count";
                description = "Number of vehicles in the convoy (when using classnames field, not synced vehicles).";
                typeName = "NUMBER";
                defaultValue = 4;
            };
            class VehicleClassnames {
                displayName = "Vehicle Classnames";
                description = "Comma-separated vehicle classnames. Synced vehicles override this field. Examples: O_MRAP_02_F, O_Truck_03_covered_F";
                typeName = "STRING";
                defaultValue = "O_MRAP_02_F";
            };
            class SpeedKph {
                displayName = "Speed (km/h)";
                description = "Convoy travel speed in km/h.";
                typeName = "NUMBER";
                defaultValue = 35;
            };
            class Dispersion {
                displayName = "Dispersion";
                description = "Spacing in meters between convoy vehicles while driving.";
                typeName = "NUMBER";
                defaultValue = 50;
            };
            class ParkingDispersion {
                displayName = "Parking Dispersion";
                description = "Spacing in meters between parked vehicles at the end waypoint.";
                typeName = "NUMBER";
                defaultValue = 30;
            };
            class SpawnCargo {
                displayName = "Spawn Cargo";
                description = "Spawn infantry in vehicle cargo.";
                typeName = "STRING";
                defaultValue = "yes";
                class values {
                    class Yes { name = "Yes"; value = "yes"; };
                    class No  { name = "No";  value = "no"; };
                };
            };
            class CargoCount {
                displayName = "Cargo Count";
                description = "Maximum infantry per vehicle cargo.";
                typeName = "NUMBER";
                defaultValue = 6;
            };
            class ForcedCareless {
                displayName = "Forced Careless";
                description = "Force the convoy to careless behaviour (no reaction to threats).";
                typeName = "STRING";
                defaultValue = "no";
                class values {
                    class No  { name = "No";  value = "no"; };
                    class Yes { name = "Yes"; value = "yes"; };
                };
            };
            class DeleteAtFinalWP {
                displayName = "Delete at Final WP";
                description = "Delete convoy vehicles and crew when they reach the end waypoint.";
                typeName = "STRING";
                defaultValue = "no";
                class values {
                    class No  { name = "No";  value = "no"; };
                    class Yes { name = "Yes"; value = "yes"; };
                };
            };
            class DismountBehaviour {
                displayName = "Dismount Behaviour";
                description = "AI behaviour after dismounting at the end waypoint.";
                typeName = "STRING";
                defaultValue = "rush";
                class values {
                    class Rush    { name = "Rush";    value = "rush"; };
                    class Defend  { name = "Defend";  value = "defend"; };
                    class Patrol  { name = "Patrol";  value = "patrol"; };
                    class Assault { name = "Assault"; value = "assault"; };
                    class Hunt    { name = "Hunt";    value = "hunt"; };
                };
            };
            class ParkingMode {
                displayName = "Parking Mode";
                description = "How vehicles park at the end waypoint. Alternate: herringbone left/right. Successive: fill both sides. ConvoyStop: stop in-line on road. Offroad: single-file off-road.";
                typeName = "STRING";
                defaultValue = "alternate";
                class values {
                    class Alternate  { name = "Alternate (Herringbone)"; value = "alternate"; };
                    class Successive { name = "Successive";             value = "successive"; };
                    class ConvoyStop { name = "Convoy Stop";            value = "convoystop"; };
                    class Offroad    { name = "Offroad";                value = "offroad"; };
                };
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before spawning. Use to stagger multiple modules on the same trigger.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    class OKS_Module_ConvoyWaypoint : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Convoy Waypoint";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "";
        functionPriority = 0;
        isGlobal = 0;
        isTriggerActivated = 0;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Defines a waypoint or end position for a Convoy. Sync from the main OKS_Module_Convoy (or previous waypoint) to this module, then from this module to the next. The last module in the chain must have Type set to End.";
        };
        class Arguments {
            class WaypointType {
                displayName = "Type";
                description = "Waypoint: intermediate travel point (can have multiple). End: final destination where vehicles park and troops dismount (exactly one).";
                typeName = "STRING";
                defaultValue = "waypoint";
                class values {
                    class Waypoint { name = "Waypoint"; value = "waypoint"; };
                    class End      { name = "End";      value = "end"; };
                };
            };
        };
    };

    // ==================== Ambient AAA ====================
    class OKS_Module_AmbientAAA : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Ambient AAA";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleAmbientAAA";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Ambient anti-aircraft fire. Sync a static weapon or vehicle to use as the AAA platform. If no vehicle is synced, one is spawned from 'Vehicle Class'. Crew is auto-created if the vehicle has no gunner.";
        };
        class Arguments {
            class Side {
                displayName = "Side";
                description = "Side the AAA crew belongs to.";
                typeName = "STRING";
                defaultValue = "east";
                class values {
                    class East        { name = "EAST";        value = "east"; };
                    class West        { name = "WEST";        value = "west"; };
                    class Independent { name = "INDEPENDENT"; value = "independent"; };
                };
            };
            class FallbackVehicle {
                displayName = "Vehicle Class";
                description = "AAA vehicle classname used when no vehicle is synced. Synced vehicles take priority. Examples: RHS_Ural_Zu23_MSV_01, rhsgref_ins_zsu234";
                typeName = "STRING";
                defaultValue = "RHS_Ural_Zu23_MSV_01";
            };
            class IsHMG {
                displayName = "Is HMG";
                description = "Set to Yes if the AAA platform is an HMG (heavy machine gun). Affects lead calculation for moving targets — HMG rounds are slower and need more lead.";
                typeName = "STRING";
                defaultValue = "no";
                class values {
                    class No  { name = "No";  value = "no"; };
                    class Yes { name = "Yes"; value = "yes"; };
                };
            };
            class Range {
                displayName = "Range";
                description = "Maximum engagement range in meters. Targets beyond this distance are ignored.";
                typeName = "NUMBER";
                defaultValue = 1500;
            };
            class Radar {
                displayName = "Radar";
                description = "Enable radar-assisted targeting. When on, nearby radar vehicles share target information with this AAA platform, improving detection.";
                typeName = "STRING";
                defaultValue = "yes";
                class values {
                    class Yes { name = "Yes"; value = "yes"; };
                    class No  { name = "No";  value = "no"; };
                };
            };
            class RateOfFire {
                displayName = "Rate of Fire (burst sizes)";
                description = "Comma-separated list of burst sizes. Each burst randomly picks one value from this list. Example: '3,4,5,6' means each burst fires 3 to 6 rounds at random.";
                typeName = "STRING";
                defaultValue = "3,4,5,6";
            };
            class TimeBetweenShots {
                displayName = "Time Between Shots";
                description = "Override seconds between individual shots in a burst. Set to 0 to use the weapon's natural reload time.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before the AAA starts operating.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    // ==================== Hunt Base ====================
    class OKS_Module_HuntBase : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Hunt Base";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleHuntBase";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 1;
        canSetAreaShape = 1;
        class AttributeValues {
            size3[] = {3000, 3000, -1};
            isRectangle = 0;
        };
        class ModuleDescription {
            description = "Reactive hunt base. When enemy players are detected in the module's zone, the base spawns infantry or vehicles to hunt them. Requires two synced objects: a destructible base object (building/vehicle — destroying it stops spawns) and an OKS_Module_SpawnPoint (defines where units spawn and which direction they face). The module's adjustable area defines the trigger zone. If 'Vehicle Classnames' is set, vehicles are spawned instead of infantry.";
        };
        class Arguments {
            class Side {
                displayName = "Side";
                description = "Side the spawned units belong to.";
                typeName = "STRING";
                defaultValue = "east";
                class values {
                    class East        { name = "EAST";        value = "east"; };
                    class West        { name = "WEST";        value = "west"; };
                    class Independent { name = "INDEPENDENT"; value = "independent"; };
                };
            };
            class Soldiers {
                displayName = "Infantry Count";
                description = "Number of infantry per wave (used when Vehicle Classnames is empty).";
                typeName = "NUMBER";
                defaultValue = 6;
            };
            class VehicleClassnames {
                displayName = "Vehicle Classnames";
                description = "Comma-separated vehicle classnames. If set, vehicles are spawned instead of infantry. One is randomly selected per wave. Leave blank for infantry. Examples: CUP_O_BTR40_MG_TKM, CUP_O_Ural_ZU23_TKM";
                typeName = "STRING";
                defaultValue = "";
            };
            class Waves {
                displayName = "Waves";
                description = "Total number of spawn waves before the base runs out.";
                typeName = "NUMBER";
                defaultValue = 5;
            };
            class RespawnDelay {
                displayName = "Respawn Delay";
                description = "Seconds between waves.";
                typeName = "NUMBER";
                defaultValue = 900;
            };
            class RefreshRate {
                displayName = "Refresh Rate";
                description = "Seconds between player-detection checks in the hunt zone. Lower = faster response but slightly higher performance cost.";
                typeName = "NUMBER";
                defaultValue = 120;
            };
            class DeployFlare {
                displayName = "Deploy Flare (Night)";
                description = "Launch a red flare above the base when spawning at night.";
                typeName = "STRING";
                defaultValue = "yes";
                class values {
                    class Yes { name = "Yes"; value = "yes"; };
                    class No  { name = "No";  value = "no"; };
                };
            };
            class WaypointBehaviour {
                displayName = "Waypoint Behaviour";
                description = "AI behaviour for spawned groups. Auto = AWARE for infantry, SAFE for vehicles.";
                typeName = "STRING";
                defaultValue = "";
                class values {
                    class Auto    { name = "Auto";    value = ""; };
                    class Safe    { name = "SAFE";    value = "SAFE"; };
                    class Aware   { name = "AWARE";   value = "AWARE"; };
                    class Combat  { name = "COMBAT";  value = "COMBAT"; };
                    class Stealth { name = "STEALTH"; value = "STEALTH"; };
                };
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before the base starts listening for players.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    // ==================== Air Base ====================
    class OKS_Module_AirBase : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Air Base";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleAirBase";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 1;
        canSetAreaShape = 1;
        class AttributeValues {
            size3[] = {5000, 5000, -1};
            isRectangle = 0;
        };
        class ModuleDescription {
            description = "Helicopter reinforcement base. When enemy players are detected in the module's zone, a helicopter is dispatched to insert troops near the players. Requires two synced objects: a destructible base object (destroying it stops spawns) and an OKS_Module_SpawnPoint (helicopter spawn position). The module's adjustable area defines the reinforcement zone. Supports multiple comma-separated helicopter classnames for random selection.";
        };
        class Arguments {
            class Side {
                displayName = "Side";
                description = "Side the helicopter and inserted troops belong to.";
                typeName = "STRING";
                defaultValue = "east";
                class values {
                    class East        { name = "EAST";        value = "east"; };
                    class West        { name = "WEST";        value = "west"; };
                    class Independent { name = "INDEPENDENT"; value = "independent"; };
                };
            };
            class HelicopterClass {
                displayName = "Helicopter Class";
                description = "Helicopter classname(s). Comma-separated for random selection per wave. Examples: O_Heli_Light_02_unarmed_F, RHS_Mi8mt_vvsc";
                typeName = "STRING";
                defaultValue = "O_Heli_Light_02_unarmed_F";
            };
            class InsertType {
                displayName = "Insert Type";
                description = "How troops are delivered. Unload: helicopter lands. Fastrope: troops fast-rope down. Paradrop: troops parachute. UnloadThenPatrol / ParadropThenPatrol: same but helicopter stays to patrol. Random: picks randomly per wave.";
                typeName = "STRING";
                defaultValue = "unload";
                class values {
                    class Unload            { name = "Unload";              value = "unload"; };
                    class Fastrope          { name = "Fastrope";            value = "fastrope"; };
                    class Paradrop          { name = "Paradrop";            value = "paradrop"; };
                    class UnloadThenPatrol  { name = "Unload then Patrol";  value = "unloadthenpatrol"; };
                    class ParadropThenPatrol { name = "Paradrop then Patrol"; value = "paradropthenpatrol"; };
                    class Random            { name = "Random";              value = "random"; };
                };
            };
            class NumGroups {
                displayName = "Number of Groups";
                description = "Split inserted troops into this many groups/teams.";
                typeName = "NUMBER";
                defaultValue = 2;
            };
            class CargoPercent {
                displayName = "Cargo Fill (%)";
                description = "Percentage of the helicopter's cargo seats to fill with troops (0-100). 100 = all seats, 50 = half.";
                typeName = "NUMBER";
                defaultValue = 100;
            };
            class RespawnTimer {
                displayName = "Respawn Timer";
                description = "Cooldown in seconds between helicopter waves.";
                typeName = "NUMBER";
                defaultValue = 900;
            };
            class RandomDistanceLZ {
                displayName = "LZ Distance";
                description = "How far (in meters) from the target player the landing zone / drop zone is placed.";
                typeName = "NUMBER";
                defaultValue = 200;
            };
            class RefreshRate {
                displayName = "Refresh Rate";
                description = "Seconds between player-detection checks in the reinforcement zone.";
                typeName = "NUMBER";
                defaultValue = 90;
            };
            class RespawnCount {
                displayName = "Wave Count";
                description = "Total number of helicopter waves before the base runs out.";
                typeName = "NUMBER";
                defaultValue = 5;
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before the air base starts listening for players.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    // ==================== SpawnPoint (companion) ====================
    class OKS_Module_SpawnPoint : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "Spawn Point";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "";
        functionPriority = 0;
        isGlobal = 0;
        isTriggerActivated = 0;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Defines a spawn position and direction for a parent module. Sync to an OKS_Module_HuntBase or OKS_Module_AirBase. Units/vehicles spawn at this module's position facing its direction. Rotate the module in Eden to set the spawn facing.";
        };
        class Arguments {};
    };

    // ==================== SAM (Networked) ====================
    class OKS_Module_SAM : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "SAM Launcher (Networked)";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleSAM";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Networked SAM launcher. Sync a SAM vehicle and a radar to use them directly. If no SAM is synced, one is spawned from 'Vehicle Class'. A radar must be synced or placed within 200m. The global network limits in-flight missiles per target across all SAM launchers.";
        };
        class Arguments {
            class FallbackVehicle {
                displayName = "Vehicle Class";
                description = "SAM launcher classname used when no vehicle is synced. Synced vehicles take priority. Examples: GOL_O_SAM_System_04_F, GOL_B_SAM_System_03_F";
                typeName = "STRING";
                defaultValue = "GOL_O_SAM_System_04_F";
            };
            class RateOfFire {
                displayName = "Rate of Fire";
                description = "Base delay (seconds) between shots. Actual delay is randomised up to 2x this value.";
                typeName = "NUMBER";
                defaultValue = 20;
            };
            class Ammo {
                displayName = "Ammo (Magazine Size)";
                description = "Number of missiles per magazine before a full reload cycle.";
                typeName = "NUMBER";
                defaultValue = 4;
            };
            class ReloadRate {
                displayName = "Reload Rate";
                description = "Seconds per reload step (4 steps total) when the magazine is empty.";
                typeName = "NUMBER";
                defaultValue = 20;
            };
            class MinimumAltitude {
                displayName = "Minimum Altitude";
                description = "Minimum altitude (meters) a target must be at to be engaged.";
                typeName = "NUMBER";
                defaultValue = 100;
            };
            class MaxRange {
                displayName = "Max Range";
                description = "Maximum engagement range in meters.";
                typeName = "NUMBER";
                defaultValue = 3000;
            };
            class MaxMissilesPerTarget {
                displayName = "Max Missiles Per Target";
                description = "Network-wide limit of in-flight missiles allowed per single air target. Prevents all launchers from dumping on one aircraft.";
                typeName = "NUMBER";
                defaultValue = 2;
                class values {
                    class V1 { name = "1"; value = 1; };
                    class V2 { name = "2"; value = 2; default = 1; };
                    class V3 { name = "3"; value = 3; };
                    class V4 { name = "4"; value = 4; };
                };
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before starting. Use to stagger multiple modules on the same trigger.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
    };

    // ==================== SHORAD (Networked) ====================
    class OKS_Module_SHORAD : Module_F {
        scope = 2;
        scopeCurator = 0;
        displayName = "SHORAD (Networked)";
        icon = "\a3\Modules_F\data\iconModule_ca.paa";
        category = "GOL_Modules";
        function = "OKS_fnc_ModuleSHORAD";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        curatorCanAttach = 0;
        canSetArea = 0;
        class ModuleDescription {
            description = "Networked SHORAD. Sync a vehicle (Tigris, Cheetah, etc.) to rate-limit its missile fire. Native missile weapons are replaced with the unified GOL SHORAD IR launcher. Cannons are unaffected. The global network limits in-flight missiles per target across all SAM and SHORAD launchers.";
        };
        class Arguments {
            class FallbackVehicle {
                displayName = "Vehicle Class";
                description = "SHORAD vehicle classname used when no vehicle is synced. Examples: O_APC_Tracked_02_AA_F (Tigris), B_APC_Tracked_01_AA_F (Cheetah), I_APC_tracked_03_AA_F (Cheetah IND)";
                typeName = "STRING";
                defaultValue = "O_APC_Tracked_02_AA_F";
            };
            class MissileType {
                displayName = "Missile Type";
                description = "IR missile variant. Light = high flare susceptibility, Medium = balanced, Heavy = low flare susceptibility.";
                typeName = "STRING";
                defaultValue = "medium";
                class values {
                    class Light { name = "Light (High Flare Susceptibility)"; value = "light"; };
                    class Medium { name = "Medium (Balanced)"; value = "medium"; default = 1; };
                    class Heavy { name = "Heavy (Low Flare Susceptibility)"; value = "heavy"; };
                };
            };
            class Ammo {
                displayName = "Missiles Per Turret";
                description = "Number of missiles each turret gets before a full reload cycle. Each turret tracks ammo independently.";
                typeName = "NUMBER";
                defaultValue = 4;
            };
            class ReloadTime {
                displayName = "Reload Time";
                description = "Base delay (seconds) between missile shots. Actual delay is randomised up to 1.5x this value. Full reload after all missiles spent = 4x this value.";
                typeName = "NUMBER";
                defaultValue = 10;
            };
            class Delay {
                displayName = "Activation Delay";
                description = "Seconds to wait after activation before starting. Use to stagger multiple modules on the same trigger.";
                typeName = "NUMBER";
                defaultValue = 0;
            };
        };
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

	// --- JAS-39 Gripen E (Unlimited Pilot Camera) ---
	class Plane_Base_F;
	class Plane_Fighter_04_Base_F: Plane_Base_F
	{
		class EventHandlers;
		class pilotCamera;
		class Components;
	};
	class I_Plane_Fighter_04_F: Plane_Fighter_04_Base_F {};

	class GOL_I_Plane_Fighter_04_F: I_Plane_Fighter_04_F
	{
		scope = 2;
		scopeCurator = 2;
		author = "GOL";
		displayName = "JAS-39E Gripen";

		AWS_ECM_STAT = 69;

		class ABSystem
		{
			AfterburnerEnabled = 1;
			ABSwitchName = "";
			throttle_name = "";
			ab_start_script = "\OKS_GOL_Misc\functions\vehicles\jets\fn_AWSNoop.sqf";
			ab_end_script = "\OKS_GOL_Misc\functions\vehicles\jets\fn_AWSNoop.sqf";
			maxspeed = 1400;
			fuelconsume_ratio = 0.002;
		};

		class EventHandlers: EventHandlers
		{
			class GOL_AWS
			{
				init = "[_this select 0, true, false, false] call OKS_fnc_JetAWSInit;";
			};
		};

		hiddenSelectionsTextures[] = {
			"a3\air_f_jets\plane_fighter_04\data\Fighter_04_fuselage_01_green_co.paa",
			"a3\air_f_jets\plane_fighter_04\data\Fighter_04_fuselage_02_green_co.paa",
			"",
			"a3\air_f_jets\plane_fighter_04\data\Numbers\Fighter_04_number_04_ca.paa",
			"a3\air_f_jets\plane_fighter_04\data\Numbers\Fighter_04_number_04_ca.paa",
			"a3\air_f_jets\plane_fighter_04\data\Numbers\Fighter_04_number_08_ca.paa"
		};

		class TextureSources
		{
			class DigitalCamoGreen
			{
				displayName = "Digital Green";
				author = "Bohemia Interactive";
				textures[] = {
					"a3\air_f_jets\plane_fighter_04\data\Fighter_04_fuselage_01_green_co.paa",
					"a3\air_f_jets\plane_fighter_04\data\Fighter_04_fuselage_02_green_co.paa",
					"",
					"a3\air_f_jets\plane_fighter_04\data\Numbers\Fighter_04_number_04_ca.paa",
					"a3\air_f_jets\plane_fighter_04\data\Numbers\Fighter_04_number_04_ca.paa",
					"a3\air_f_jets\plane_fighter_04\data\Numbers\Fighter_04_number_08_ca.paa"
				};
				factions[] = {"IND_F"};
			};
			class DigitalCamoGrey
			{
				displayName = "Digital Grey";
				author = "Bohemia Interactive";
				textures[] = {
					"a3\air_f_jets\plane_fighter_04\data\Fighter_04_fuselage_01_gray_co.paa",
					"a3\air_f_jets\plane_fighter_04\data\Fighter_04_fuselage_02_gray_co.paa",
					"",
					"a3\air_f_jets\plane_fighter_04\data\Numbers\Fighter_04_number_04_ca.paa",
					"a3\air_f_jets\plane_fighter_04\data\Numbers\Fighter_04_number_04_ca.paa",
					"a3\air_f_jets\plane_fighter_04\data\Numbers\Fighter_04_number_08_ca.paa"
				};
				factions[] = {"IND_F"};
			};
			class CamoGrey
			{
				displayName = "Grey";
				author = "Bohemia Interactive";
				textures[] = {
					"a3\air_f_jets\plane_fighter_04\data\Fighter_04_fuselage_01_co.paa",
					"a3\air_f_jets\plane_fighter_04\data\Fighter_04_fuselage_02_co.paa",
					"",
					"a3\air_f_jets\plane_fighter_04\data\Numbers\Fighter_04_number_04_ca.paa",
					"a3\air_f_jets\plane_fighter_04\data\Numbers\Fighter_04_number_04_ca.paa",
					"a3\air_f_jets\plane_fighter_04\data\Numbers\Fighter_04_number_08_ca.paa"
				};
				factions[] = {"IND_F"};
			};
		};

		textureList[] = {
			"DigitalCamoGreen", 1,
			"DigitalCamoGrey", 1,
			"CamoGrey", 1
		};

		class pilotCamera: pilotCamera
		{
			minTurn = -360;
			maxTurn = 360;
			initTurn = 0;
			minElev = -90;
			maxElev = 90;
			initElev = 5;
		};

		class Components: Components
		{
			class SensorsManagerComponent
			{
				class Components
				{
					class IRSensorComponent: SensorTemplateIR
					{
						class AirTarget
						{
							minRange = 500;
							maxRange = 5000;
							objectDistanceLimitCoef = -1;
							viewDistanceLimitCoef = 1;
						};
						class GroundTarget
						{
							minRange = 500;
							maxRange = 4000;
							objectDistanceLimitCoef = 1;
							viewDistanceLimitCoef = 1;
						};
						angleRangeHorizontal = 360;
						angleRangeVertical = 180;
						aimDown = 0;
					};
					class VisualSensorComponent: SensorTemplateVisual
					{
						class AirTarget
						{
							minRange = 500;
							maxRange = 5000;
							objectDistanceLimitCoef = -1;
							viewDistanceLimitCoef = 1;
						};
						class GroundTarget
						{
							minRange = 500;
							maxRange = 4000;
							objectDistanceLimitCoef = 1;
							viewDistanceLimitCoef = 1;
						};
						angleRangeHorizontal = 360;
						angleRangeVertical = 180;
						aimDown = 0;
					};
					class ActiveRadarSensorComponent: SensorTemplateActiveRadar
					{
						class AirTarget
						{
							minRange = 500;
							maxRange = 16000;
							objectDistanceLimitCoef = -1;
							viewDistanceLimitCoef = -1;
						};
						class GroundTarget
						{
							minRange = 500;
							maxRange = 12000;
							objectDistanceLimitCoef = -1;
							viewDistanceLimitCoef = -1;
						};
						angleRangeHorizontal = 360;
						angleRangeVertical = 180;
						groundNoiseDistanceCoef = -1;
						maxGroundNoiseDistance = -1;
						minSpeedThreshold = 0;
						maxSpeedThreshold = 0;
						aimDown = 0;
					};
					class PassiveRadarSensorComponent: SensorTemplatePassiveRadar{};
					class LaserSensorComponent: SensorTemplateLaser
					{
						angleRangeHorizontal = 360;
						angleRangeVertical = 180;
						aimDown = 0;
					};
					class NVSensorComponent: SensorTemplateNV
					{
						angleRangeHorizontal = 360;
						angleRangeVertical = 180;
						aimDown = 0;
					};
					class DataLinkSensorComponent: SensorTemplateDataLink{};
				};
			};
		};
	};

	// --- F/A-181 Black Wasp III (Unlimited Pilot Camera) ---
	class Plane_Fighter_01_Base_F: Plane_Base_F
	{
		class EventHandlers;
		class pilotCamera;
		class Components;
	};
	class B_Plane_Fighter_01_F: Plane_Fighter_01_Base_F {};
	class B_Plane_Fighter_01_Stealth_F: Plane_Fighter_01_Base_F {};

	class GOL_B_Plane_Fighter_01_Stealth_F: B_Plane_Fighter_01_Stealth_F
	{
		scope = 2;
		scopeCurator = 2;
		author = "GOL";
		displayName = "F/A-181 Black Wasp III (Stealth)";

		AWS_ECM_STAT = 88;

		class ABSystem
		{
			AfterburnerEnabled = 1;
			ABSwitchName = "";
			throttle_name = "";
			ab_start_script = "\OKS_GOL_Misc\functions\vehicles\jets\fn_AWSNoop.sqf";
			ab_end_script = "\OKS_GOL_Misc\functions\vehicles\jets\fn_AWSNoop.sqf";
			maxspeed = 1500;
			fuelconsume_ratio = 0.002;
		};

		class EventHandlers: EventHandlers
		{
			class GOL_AWS
			{
				init = "[_this select 0, true, false, false] call OKS_fnc_JetAWSInit;";
			};
		};

		// FA-18 flight model
		maxSpeed = 1900;
		acceleration = 300;
		landingSpeed = 200;
		thrustCoef[] = {0.2, 0.5, 1, 1.3, 1.5, 1.7, 1.7, 1.4, 1.4, 1.3, 1.1, 1.1, 1, 1, 1, 1};
		envelope[] = {0, 0.8, 2.9, 5, 7.8, 9.3, 9.5, 9.8, 8.2, 5.6, 3.2, 2.6, 2.1, 1.7, 1.4, 1.35, 1.3, 1.15, 0};
		altFullForce = 15000;
		altNoForce = 18000;
		aileronSensitivity = 0.7;
		elevatorSensitivity = 0.85;
		aileronCoef[] = {0, 0.8, 0.9, 1, 1.1, 1.2, 1.2, 1.3, 1.3, 1.3, 1.4, 1.4, 1.4};
		elevatorCoef[] = {0, 0.8, 0.9, 1, 1.1, 1.2, 1.2, 1.3, 1.3, 1.3, 1.4, 1.4, 1.4};
		draconicForceXCoef = 6;
		draconicForceYCoef = 8.5;
		draconicForceZCoef = 8.5;
		draconicTorqueXCoef = 2.5;
		draconicTorqueYCoef = 2.5;
		wheelSteeringSensitivity = 2.6;
		flapsFrictionCoef = 0.32;
		angleOfIndicence = 0.05235987;

		class pilotCamera: pilotCamera
		{
			minTurn = -360;
			maxTurn = 360;
			initTurn = 0;
			minElev = -90;
			maxElev = 90;
			initElev = 25;
		};

		class Components: Components
		{
			class SensorsManagerComponent
			{
				class Components
				{
					class IRSensorComponent: SensorTemplateIR
					{
						class AirTarget
						{
							minRange = 500;
							maxRange = 5000;
							objectDistanceLimitCoef = -1;
							viewDistanceLimitCoef = 1;
						};
						class GroundTarget
						{
							minRange = 500;
							maxRange = 4000;
							objectDistanceLimitCoef = 1;
							viewDistanceLimitCoef = 1;
						};
						angleRangeHorizontal = 360;
						angleRangeVertical = 180;
						aimDown = 0;
					};
					class VisualSensorComponent: SensorTemplateVisual
					{
						class AirTarget
						{
							minRange = 500;
							maxRange = 5000;
							objectDistanceLimitCoef = -1;
							viewDistanceLimitCoef = 1;
						};
						class GroundTarget
						{
							minRange = 500;
							maxRange = 4000;
							objectDistanceLimitCoef = 1;
							viewDistanceLimitCoef = 1;
						};
						angleRangeHorizontal = 360;
						angleRangeVertical = 180;
						aimDown = 0;
					};
					class ActiveRadarSensorComponent: SensorTemplateActiveRadar
					{
						class AirTarget
						{
							minRange = 500;
							maxRange = 16000;
							objectDistanceLimitCoef = -1;
							viewDistanceLimitCoef = -1;
						};
						class GroundTarget
						{
							minRange = 500;
							maxRange = 12000;
							objectDistanceLimitCoef = -1;
							viewDistanceLimitCoef = -1;
						};
						angleRangeHorizontal = 360;
						angleRangeVertical = 180;
						groundNoiseDistanceCoef = -1;
						maxGroundNoiseDistance = -1;
						minSpeedThreshold = 0;
						maxSpeedThreshold = 0;
						aimDown = 0;
					};
					class PassiveRadarSensorComponent: SensorTemplatePassiveRadar{};
					class LaserSensorComponent: SensorTemplateLaser
					{
						angleRangeHorizontal = 360;
						angleRangeVertical = 180;
						aimDown = 0;
					};
					class NVSensorComponent: SensorTemplateNV
					{
						angleRangeHorizontal = 360;
						angleRangeVertical = 180;
						aimDown = 0;
					};
					class DataLinkSensorComponent: SensorTemplateDataLink{};
				};
			};
		};
	};

	class GOL_B_Plane_Fighter_01_F: B_Plane_Fighter_01_F
	{
		scope = 2;
		scopeCurator = 2;
		author = "GOL";
		displayName = "F/A-181 Black Wasp III";

		AWS_ECM_STAT = 75;

		class ABSystem
		{
			AfterburnerEnabled = 1;
			ABSwitchName = "";
			throttle_name = "";
			ab_start_script = "\OKS_GOL_Misc\functions\vehicles\jets\fn_AWSNoop.sqf";
			ab_end_script = "\OKS_GOL_Misc\functions\vehicles\jets\fn_AWSNoop.sqf";
			maxspeed = 1500;
			fuelconsume_ratio = 0.002;
		};

		class EventHandlers: EventHandlers
		{
			class GOL_AWS
			{
				init = "[_this select 0, true, false, false] call OKS_fnc_JetAWSInit;";
			};
		};

		// FA-18 flight model
		maxSpeed = 1900;
		acceleration = 300;
		landingSpeed = 200;
		thrustCoef[] = {0.2, 0.5, 1, 1.3, 1.5, 1.7, 1.7, 1.4, 1.4, 1.3, 1.1, 1.1, 1, 1, 1, 1};
		envelope[] = {0, 0.8, 2.9, 5, 7.8, 9.3, 9.5, 9.8, 8.2, 5.6, 3.2, 2.6, 2.1, 1.7, 1.4, 1.35, 1.3, 1.15, 0};
		altFullForce = 15000;
		altNoForce = 18000;
		aileronSensitivity = 0.7;
		elevatorSensitivity = 0.85;
		aileronCoef[] = {0, 0.8, 0.9, 1, 1.1, 1.2, 1.2, 1.3, 1.3, 1.3, 1.4, 1.4, 1.4};
		elevatorCoef[] = {0, 0.8, 0.9, 1, 1.1, 1.2, 1.2, 1.3, 1.3, 1.3, 1.4, 1.4, 1.4};
		draconicForceXCoef = 6;
		draconicForceYCoef = 8.5;
		draconicForceZCoef = 8.5;
		draconicTorqueXCoef = 2.5;
		draconicTorqueYCoef = 2.5;
		wheelSteeringSensitivity = 2.6;
		flapsFrictionCoef = 0.32;
		angleOfIndicence = 0.05235987;

		class pilotCamera: pilotCamera
		{
			minTurn = -360;
			maxTurn = 360;
			initTurn = 0;
			minElev = -90;
			maxElev = 90;
			initElev = 25;
		};

		class Components: Components
		{
			class SensorsManagerComponent
			{
				class Components
				{
					class IRSensorComponent: SensorTemplateIR
					{
						class AirTarget
						{
							minRange = 500;
							maxRange = 5000;
							objectDistanceLimitCoef = -1;
							viewDistanceLimitCoef = 1;
						};
						class GroundTarget
						{
							minRange = 500;
							maxRange = 4000;
							objectDistanceLimitCoef = 1;
							viewDistanceLimitCoef = 1;
						};
						angleRangeHorizontal = 360;
						angleRangeVertical = 180;
						aimDown = 0;
					};
					class VisualSensorComponent: SensorTemplateVisual
					{
						class AirTarget
						{
							minRange = 500;
							maxRange = 5000;
							objectDistanceLimitCoef = -1;
							viewDistanceLimitCoef = 1;
						};
						class GroundTarget
						{
							minRange = 500;
							maxRange = 4000;
							objectDistanceLimitCoef = 1;
							viewDistanceLimitCoef = 1;
						};
						angleRangeHorizontal = 360;
						angleRangeVertical = 180;
						aimDown = 0;
					};
					class ActiveRadarSensorComponent: SensorTemplateActiveRadar
					{
						class AirTarget
						{
							minRange = 500;
							maxRange = 16000;
							objectDistanceLimitCoef = -1;
							viewDistanceLimitCoef = -1;
						};
						class GroundTarget
						{
							minRange = 500;
							maxRange = 12000;
							objectDistanceLimitCoef = -1;
							viewDistanceLimitCoef = -1;
						};
						angleRangeHorizontal = 360;
						angleRangeVertical = 180;
						groundNoiseDistanceCoef = -1;
						maxGroundNoiseDistance = -1;
						minSpeedThreshold = 0;
						maxSpeedThreshold = 0;
						aimDown = 0;
					};
					class PassiveRadarSensorComponent: SensorTemplatePassiveRadar{};
					class LaserSensorComponent: SensorTemplateLaser
					{
						angleRangeHorizontal = 360;
						angleRangeVertical = 180;
						aimDown = 0;
					};
					class NVSensorComponent: SensorTemplateNV
					{
						angleRangeHorizontal = 360;
						angleRangeVertical = 180;
						aimDown = 0;
					};
					class DataLinkSensorComponent: SensorTemplateDataLink{};
				};
			};
		};
	};

	// --- A-10E Thunderbolt III (Unlimited Pilot Camera) ---
	class Plane_CAS_01_base_F: Plane_Base_F
	{
		class EventHandlers;
		class PilotCamera;
	};
	class Plane_CAS_01_dynamicLoadout_base_F: Plane_CAS_01_base_F {};
	class B_Plane_CAS_01_dynamicLoadout_F: Plane_CAS_01_dynamicLoadout_base_F {};

	class GOL_B_Plane_CAS_01_dynamicLoadout_F: B_Plane_CAS_01_dynamicLoadout_F
	{
		scope = 2;
		scopeCurator = 2;
		author = "GOL";
		displayName = "A-10E Thunderbolt III";

		AWS_ECM_STAT = 50;

		class EventHandlers: EventHandlers
		{
			class GOL_AWS
			{
				init = "[_this select 0, false, false, false] call OKS_fnc_JetAWSInit;";
			};
		};

		// FIR A-10 flight model
		maxSpeed = 706;
		aileronSensitivity = 0.75;
		elevatorSensitivity = 1.4;
		rudderInfluence = 0.01;
		aileronControlsSensitivityCoef = 3;
		elevatorControlsSensitivity = 2;
		elevatorControlsSensitivityCoef = 4;
		rudderControlsSensitivityCoef = 4;
		elevatorCoef[] = {0.6, 0.9, 0.8, 0.7, 0.7, 0.6, 0.5};
		aileronCoef[] = {0.6, 1, 0.95, 0.9, 0.85, 0.8, 0.75};
		rudderCoef[] = {0.6, 1, 1, 0.9, 0.8, 0.7, 0.6};
		flapsFrictionCoef = 0.5;
		angleOfIndicence = 0.0523599;
		draconicForceXCoef = 7.4;
		draconicForceYCoef = 3;
		draconicForceZCoef = 0.1;
		draconicTorqueXCoef = 1.2;
		draconicTorqueYCoef = 3;
		envelope[] = {0.1, 0.1, 0.9, 2.8, 3.5, 3.7, 3.8, 3.8, 3.6, 3.3, 2.7};
		thrustCoef[] = {0.9, 0.8, 0.9, 1.3, 1.2, 1.2, 1.1, 1, 0.9, 0.2, 0.1, 0, 0};
		wheelSteeringSensitivity = 3;
		altFullForce = 13700;
		altNoForce = 15000;

		class PilotCamera: PilotCamera
		{
			minTurn = -360;
			maxTurn = 360;
			initTurn = 0;
			minElev = -90;
			maxElev = 90;
			initElev = 5;
		};
	};

	// --- To-201M Shikra (Unlimited Pilot Camera) ---
	class Plane_Fighter_02_Base_F: Plane_Base_F
	{
		class EventHandlers;
		class pilotCamera;
	};
	class O_Plane_Fighter_02_F: Plane_Fighter_02_Base_F {};

	class GOL_O_Plane_Fighter_02_F: O_Plane_Fighter_02_F
	{
		scope = 2;
		scopeCurator = 2;
		author = "GOL";
		displayName = "To-201M Shikra";

		AWS_ECM_STAT = 75;

		class ABSystem
		{
			AfterburnerEnabled = 1;
			ABSwitchName = "";
			throttle_name = "";
			ab_start_script = "\OKS_GOL_Misc\functions\vehicles\jets\fn_AWSNoop.sqf";
			ab_end_script = "\OKS_GOL_Misc\functions\vehicles\jets\fn_AWSNoop.sqf";
			maxspeed = 1600;
			fuelconsume_ratio = 0.002;
		};

		class EventHandlers: EventHandlers
		{
			class GOL_AWS
			{
				init = "[_this select 0, true, false, false] call OKS_fnc_JetAWSInit;";
			};
		};

		class pilotCamera: pilotCamera
		{
			minTurn = -360;
			maxTurn = 360;
			initTurn = 0;
			minElev = -90;
			maxElev = 90;
			initElev = 15;
		};
	};

	// --- Yak-131 (Unlimited Pilot Camera) ---
	class Plane_CAS_02_base_F: Plane_Base_F
	{
		class EventHandlers;
		class PilotCamera;
	};
	class Plane_CAS_02_dynamicLoadout_base_F: Plane_CAS_02_base_F {};
	class O_Plane_CAS_02_dynamicLoadout_F: Plane_CAS_02_dynamicLoadout_base_F {};

	class GOL_O_Plane_CAS_02_dynamicLoadout_F: O_Plane_CAS_02_dynamicLoadout_F
	{
		scope = 2;
		scopeCurator = 2;
		author = "GOL";
		displayName = "Yak-131";

		AWS_ECM_STAT = 56;

		class EventHandlers: EventHandlers
		{
			class GOL_AWS
			{
				init = "[_this select 0, false, false, false] call OKS_fnc_JetAWSInit;";
			};
		};

		class PilotCamera: PilotCamera
		{
			minTurn = -360;
			maxTurn = 360;
			initTurn = 0;
			minElev = -90;
			maxElev = 90;
			initElev = 15;
		};
	};

	// --- L-160 ALCA (Unlimited Pilot Camera) ---
	class Plane_Fighter_03_base_F: Plane_Base_F
	{
		class EventHandlers;
		class pilotCamera;
	};
	class Plane_Fighter_03_dynamicLoadout_base_F: Plane_Fighter_03_base_F {};
	class I_Plane_Fighter_03_dynamicLoadout_F: Plane_Fighter_03_dynamicLoadout_base_F {};

	class GOL_I_Plane_Fighter_03_dynamicLoadout_F: I_Plane_Fighter_03_dynamicLoadout_F
	{
		scope = 2;
		scopeCurator = 2;
		author = "GOL";
		displayName = "L-160 ALCA";

		AWS_ECM_STAT = 63;

		class EventHandlers: EventHandlers
		{
			class GOL_AWS
			{
				init = "[_this select 0, false, false, false] call OKS_fnc_JetAWSInit;";
			};
		};

		weapons[] = {
			"Laserdesignator_pilotCamera",
			"CMFlareLauncher"
		};
		magazines[] = {
			"Laserbatteries",
			"120Rnd_CMFlare_Chaff_Magazine"
		};

		class pilotCamera: pilotCamera
		{
			minTurn = -360;
			maxTurn = 360;
			initTurn = 0;
			minElev = -90;
			maxElev = 90;
			initElev = 5;
		};
	};

	// TFAR Intercom patch (enables intercom on MRAPs)
	#include "compat\compat_tfar_intercom.hpp"

};
