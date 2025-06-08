
class CfgVehicles {
    class Land;
    class LandVehicle: Land {
        class ACE_Actions {
            class ACE_MainActions {};
        };
    };
	class StaticWeapon : LandVehicle
	{
		class ACE_Actions {
			class ACE_MainActions {};
		};
	};
	class StaticMGWeapon : StaticWeapon
	{
		class ACE_Actions: ACE_Actions {
			class ACE_MainActions : ACE_MainActions {		
				class Pack_Static {
					displayName = "Pack Static HMG";
					condition = "alive _target && vehicle _player != _target && _player canAdd [(_target getVariable ['GOL_ItemPacked','GOL_Packed_HMG']), 1, true] && count crew _target == 0 && (typeOf _target) == (missionNamespace getVariable ['OKS_PackedHMGClass', 'RHS_M2StaticMG_USMC_D'])";
					exceptions[] = {};
					statement = "[_player,_target] call OKS_fnc_Packing_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_HMG_Packed.paa";
				};	
			};
		};
	};
	class StaticGrenadeLauncher : StaticWeapon
	{
		class ACE_Actions: ACE_Actions {
			class ACE_MainActions : ACE_MainActions {				
				class Pack_Static {
					displayName = "Pack Static GMG";
					condition = "alive _target && vehicle _player != _target && _player canAdd [(_target getVariable ['GOL_ItemPacked','GOL_Packed_GMG']), 1, true] && count crew _target == 0 && (typeOf _target) == (missionNamespace getVariable ['OKS_PackedGMGClass', 'RHS_MK19_TriPod_USMC_WD'])";
					exceptions[] = {};
					statement = "[_player,_target] call OKS_fnc_Packing_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_GMG_Packed.paa";
				};	
			};
		};
	};
	class StaticATWeapon : StaticWeapon
	{
		class ACE_Actions: ACE_Actions {
			class ACE_MainActions : ACE_MainActions {			
				class Pack_Static_AT {
					displayName = "Pack Static AT";
					condition = "alive _target && vehicle _player != _target && _player canAdd [(_target getVariable ['GOL_ItemPacked','GOL_Packed_AT']), 1, true] && count crew _target == 0 && (typeOf _target) == (missionNamespace getVariable ['OKS_PackedATClass', 'RHS_TOW_TriPod_USMC_D'])";
					exceptions[] = {};
					statement = "[_player,_target] call OKS_fnc_Packing_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_AT_Packed.paa";
				};	
			};
		};
	};

	class StaticMortar : StaticWeapon
	{
		class ACE_Actions: ACE_Actions {
			class ACE_MainActions : ACE_MainActions {			
				class Pack_Static_Mortar {
					displayName = "Pack Static Mortar";
					condition = "alive _target && vehicle _player != _target && _player canAdd [(_target getVariable ['GOL_ItemPacked','GOL_Packed_Mortar']), 1, true] && count crew _target == 0 && (typeOf _target) == (missionNamespace getVariable ['OKS_PackedMortarClass', 'B_G_Mortar_01_F'])";
					exceptions[] = {};
					statement = "[_player,_target] call OKS_fnc_Packing_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_Mortar_Packed.paa";
				};	
			};
		};
	};

    class Air;
    class Helicopter: Air {
        class ACE_Actions {
            class ACE_MainActions {};
        };
    };
    class Helicopter_Base_F: Helicopter {
        class ACE_Actions: ACE_Actions {
            class ACE_MainActions: ACE_MainActions {
				class Pack_Drone {
					displayName = "Pack Drone";
					condition = "alive _target && _player canAdd [(_target getVariable ['GOL_ItemPacked','GOL_PACKED_DRONE_AP']), 1, true] && (typeOf _target) in [(missionNamespace getVariable ['OKS_PackedDroneAPClass', 'B_UAFPV_RKG_AP']),(missionNamespace getVariable ['OKS_PackedDroneATClass', 'B_UAFPV_AT']),(missionNamespace getVariable ['OKS_PackedDroneReconClass', 'B_UAV_01_F']),(missionNamespace getVariable ['OKS_PackedDroneSupplyClass', 'B_UAV_06_F'])]";
					exceptions[] = {};
					statement = "[_player,_target] call OKS_fnc_Packing_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";	
				}
			};
        };
    };		

	class Man;
	class CAManBase: Man {
		class ACE_SelfActions {
			class ACE_Equipment {
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

				class Deploy_Drone_AP {
					displayName = "Deploy Drone (AP)";
					condition = "('GOL_Packed_Drone_AP' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Deploy_AP_Drone_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
				};

				class Deploy_Drone_AT {
					displayName = "Deploy Drone (AT)";
					condition = "('GOL_Packed_Drone_AT' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Deploy_AT_Drone_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
				};

				class Deploy_Drone_Recon {
					displayName = "Deploy Drone (Recon)";
					condition = "('GOL_Packed_Drone_Recon' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Deploy_Recon_Drone_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
				};

				class Deploy_Drone_Supply {
					displayName = "Deploy Drone (Supply)";
					condition = "('GOL_Packed_Drone_Supply' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Deploy_Supply_Drone_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
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
			};
		};
	};

	class Land_RepairDepot_01_green_F;
	class ACE_medicalSupplyCrate;
	class FlexibleTank_base_F;
	class Box_Syndicate_Ammo_F;
	class Box_Syndicate_Wps_F;
	class B_CargoNet_01_ammo_F;
	class B_supplyCrate_F;	
	class Land_HelipadSquare_F;
	class ReammoBox_F {
		class ACE_Actions
		{
			class ACE_MainActions {};
		};
	};	

	class GOL_ResupplyStation_WEST: ReammoBox_F  {
		displayName = "GOL Resupply Station (WEST)";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";    
		model = "\a3\Structures_F_Tank\Military\RepairDepot\RepairDepot_01_green_F.p3d";
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};			
		class ACE_Actions : ACE_Actions
		{
			class ACE_MainActions : ACE_MainActions
			{
				class OKS_CreateResupply {
					displayName = "Create Resupply";
					exceptions[] = {};
					condition = "alive _target";
					statement = "";
					icon = "\A3\ui_f\data\igui\cfg\actions\unloadVehicle_ca.paa";
					class GOL_TeamResupply
					{
						displayName = "Team Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_TeamResupplybox_WEST'] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_SpecialistResupply
					{
						displayName = "Specialist Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SpecialistResupplybox_WEST'] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_SquadResupply
					{
						displayName = "Squad Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SquadResupplybox_WEST'] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_MobileServiceStation
					{
						displayName = "Mobile Service Station";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_MobileServiceStation'] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\repair_ca.paa";
					};	
					class GOL_MedicResupply
					{
						displayName = "Medical Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_MedicalResupply_WEST'] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\simpleTasks\heal_ca.paa";
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
		model = "\a3\Structures_F_Tank\Military\RepairDepot\RepairDepot_01_green_F.p3d";
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};			
		class ACE_Actions : ACE_Actions
		{
			class ACE_MainActions : ACE_MainActions
			{
				class OKS_CreateResupply {
					displayName = "Create Resupply";
					exceptions[] = {};
					condition = "alive _target";
					statement = "";
					icon = "\A3\ui_f\data\igui\cfg\actions\unloadVehicle_ca.paa";
					class GOL_TeamResupply
					{
						displayName = "Team Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_TeamResupplybox_EAST'] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_SpecialistResupply
					{
						displayName = "Specialist Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SpecialistResupplybox_EAST'] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_SquadResupply
					{
						displayName = "Squad Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_SquadResupplybox_EAST'] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\reload_ca.paa";
					};
					class GOL_MobileServiceStation
					{
						displayName = "Mobile Service Station";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_MobileServiceStation'] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\actions\repair_ca.paa";
					};	
					class GOL_MedicResupply
					{
						displayName = "Medical Resupply";
						exceptions[] = {};
						condition = "alive _target";
						statement = "[_target, 'GOL_MedicalResupply_EAST'] call OKS_fnc_spawnCrate;";
						icon = "\A3\ui_f\data\igui\cfg\simpleTasks\heal_ca.paa";
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
	
    class GOL_MobileServiceStation: FlexibleTank_base_F
	{
        displayName = "Mobile Service Station";
		scope = 2;
    	scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
		ace_refuel_fuelCargo = 9999;
		model = "\A3\Supplies_F_Heli\Fuel\FlexibleTank_01_F.p3d";
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
		class TransportMagazines {};
        class TransportWeapons {};
        class TransportItems {};
        class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [_this select 0, ['gearbox','east']] call GW_Gear_Fnc_Init; }";
		};
    };

    class GOL_MedicalResupply_WEST: ACE_medicalSupplyCrate
	{
        displayName = "Medical Resupply Crate (WEST)";
		scope = 2;
    	scopeCurator = 2;
		editorCategory = "GOL_GuerrillasOfLiberation";
		editorSubcategory = "GOL_Resupply";
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
		model = "\z\ace\addons\medical_treatment\data\ace_medcrate.p3d";
		class TransportMagazines {};
        class TransportWeapons {};
        class TransportItems {};
        class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [(_this select 0), ['med_box','east']] call GW_Gear_Fnc_Init}";
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
		class TransportMagazines {};
		class TransportWeapons {};
		class TransportItems {};
		class TransportBackpacks {};
		class EventHandlers {
			init = "_this spawn { waitUntil {sleep 1; !isNil 'GW_Gear_Fnc_Init'}; [(_this select 0), ['small_box','east']] call GW_Gear_Fnc_Init }";
		};
	};
};