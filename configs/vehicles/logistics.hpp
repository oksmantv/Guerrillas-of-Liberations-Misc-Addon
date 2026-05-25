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

