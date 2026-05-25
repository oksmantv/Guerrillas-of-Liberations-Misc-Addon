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
