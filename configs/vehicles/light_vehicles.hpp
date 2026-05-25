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
