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

	// Helicopter Targeting Pod variants (UH-80, AH-9, PO-30, WY-55)
