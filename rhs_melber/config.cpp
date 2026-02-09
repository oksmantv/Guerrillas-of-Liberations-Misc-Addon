////////////////////////////////////////////////////////////////////
//DeRap: config.bin
//Produced from mikero's Dos Tools Dll version 9.10
//https://mikero.bytex.digital/Downloads
//'now' is Wed Jun 12 23:43:10 2024 : 'file' last modified on Fri Apr 08 22:25:14 2022
////////////////////////////////////////////////////////////////////

#define _ARMA_

class CfgPatches
{
	class GOL_melber
	{
		units[] = {"GOL_MELB_AH6M"};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"rhsusf_main","rhsusf_melb","rhsusf_c_melb","rhsusf_c_airweapons","rhsusf_c_heavyweapons","MELB_UI","Kimi_UI"};
		magazines[] = {};
	};
};
class SensorTemplatePassiveRadar;
class SensorTemplateAntiRadiation;
class SensorTemplateActiveRadar;
class SensorTemplateIR;
class SensorTemplateVisual;
class SensorTemplateMan;
class SensorTemplateLaser;
class SensorTemplateNV;
class SensorTemplateDataLink;
class DefaultVehicleSystemsDisplayManagerLeft
{
	class components;
};
class DefaultVehicleSystemsDisplayManagerRight
{
	class components;
};
class VehicleSystemsTemplateLeftPilot: DefaultVehicleSystemsDisplayManagerLeft
{
	class components;
};
class VehicleSystemsTemplateRightPilot: DefaultVehicleSystemsDisplayManagerRight
{
	class components;
};
class Mode_SemiAuto;
class Mode_Burst;
class Mode_FullAuto;
class RHS_Effects_Helicopter_Hull_Destruction;
class cfgAmmo
{
	class Bulletbase;
	class B_127x99_SLAP;
	class GOL_ammo_127x99_SLAP: B_127x99_SLAP
	{
		hit = 15;
		indirectHit = 5;
		indirectHitRange = 1;
		caliber = 2.80992;
		class CamShakeFire
		{
			power = 1;
			duration = 0.2;
			frequency = 20;
			distance = 8;
		};
		class CamShakePlayerFire
		{
			power = 1;
			duration = 0.1;
			frequency = 20;
			distance = 1;
		};
	};
};
class cfgMagazines
{
	class CA_Magazine;
	class 5000Rnd_762x51_Belt;
	class GOL_FakeMagazine_MELB: 5000Rnd_762x51_Belt
	{
		count = 0;
		displaynameshort = "-";
		displayName = "-";
		descriptionShort = "-";
		tracersEvery = 0;
		weight = 0;
	};
};
class cfgWeapons
{
	class MGun;
	class Laserdesignator_mounted;
	class GOL_Laserdesignator_MELB: Laserdesignator_mounted
	{
		displayName = "Laser Designator";
		cursor = "EmptyCursor";
		cursorAim = "EmptyCursor";
		nameSound = "laserdesignator";
		minRange = 1;
		minRangeProbab = 0.01;
		midRange = 2;
		midRangeProbab = 0.01;
		maxRange = 3;
		maxRangeProbab = 0.01;
	};
};

class CfgVehicles
{
	class Helicopter;
	class Helicopter_Base_F: Helicopter
	{
		class Turrets;
		class HitPoints;
	};
	class Helicopter_Base_H: Helicopter_Base_F
	{
		class EventHandlers;
		class Turrets: Turrets
		{
			class CopilotTurret;
		};
		class HitPoints: HitPoints
		{
			class HitHull;
			class HitFuel;
			class HitEngine;
			class HitAvionics;
			class HitVRotor;
			class HitHRotor;
			class HitGlass1;
			class HitGlass2;
			class HitGlass3;
			class HitGlass4;
			class HitGlass5;
			class HitGlass6;
		};
		class CargoTurret;
		class AnimationSources;
		class ViewOptics;
		class RotorLibHelicopterProperties;
		class Components;
	};
	class GOL_MELB_base: Helicopter_Base_H
	{
		author = "$STR_RHSUSF_AUTHOR_FULL";
		dlc = "RHS_USAF";
		scope = 0;
		side = 1;
		faction = "rhs_faction_socom";
		crew = "rhsusf_army_ucp_helipilot";
		model = "rhsusf\addons\rhsusf_melb\MELB.p3d";
		picture = "rhsusf\addons\rhsusf_melb\Data\ui\melb_h_6m_ca.paa";
		icon = "rhsusf\addons\rhsusf_melb\Data\ui\map_melb_h_6m_ca.paa";
		mapSize = 11;
		destrType = "DestructWreck";
		accuracy = 0.5;
		unitInfoType = "RscUnitInfoAir_NoRadar_MELB";
		unitInfoTypeRTD = "RHSUSF_RscUnitInfoAirRTDFullDigital_MELB";
		nameSound = "veh_helicopter";
		driverAction = "MELB_Pilot";
		driverInAction = "MELB_Pilot";
		getInAction = "ChopperLight_L_In_H";
		getOutAction = "GetOutLow";
		memoryPointsGetInDriver = "pos pilot";
		memoryPointsGetInDriverDir = "pos pilot dir";
		memoryPointsGetInDriverPrecise = "pos pilot";
		memoryPointsGetInCargo[] = {"pos cargo"};
		memoryPointsGetInCargoDir[] = {"pos cargo dir"};
		memoryPointsGetInCargoPrecise[] = {"pos cargo"};
		usePreciseGetInAction = 1;
		getInRadius = 1.5;
		cargoCompartments[] = {"compartment3"};
		cargoGetInAction[] = {"GetInLow"};
		cargoGetOutAction[] = {"GetOutLow"};
		cargoAction[] = {"passenger_flatground_generic04"};
		preciseGetInOut = 0;
		castCargoShadow = 1;
		getInProxyOrder[] = {9,1,2,3,4,5,6,7,8,10};
		extCameraPosition[] = {0,0.75,-10};
		driverCanSee = 31;
		transportSoldier = 6;
		hideWeaponsDriver = 1;
		hideWeaponsGunner = 1;
		hideWeaponsCargo = 1;
		threat[] = {0,0,0};
		radarType = 0;
		irTarget = 1;
		irTargetSize = 0.7;
		visualTarget = 1;
		visualTargetSize = 0.8;
		radarTarget = 1;
		radarTargetSize = 0.8;
		receiveRemoteTargets = 1;
		reportRemoteTargets = 1;
		reportOwnPosition = 1;
		LockDetectionSystem = "2 +4 + 8 + 16";
		incomingMissileDetectionSystem = 16;
		weapons[] = {"rhs_weap_laserDesignator_AI","rhsusf_weap_LWIRCM"};
		magazines[] = {"rhs_laserfcsmag","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM"};
		hiddenSelections[] = {"camo1","d_SN"};
		hiddenSelectionsTextures[] = {"rhsusf\addons\rhsusf_melb\data\melb_ext_co.paa","rhsusf\addons\rhsusf_melb\data\decals\SN\blank_ca.paa"};
		class MFD{};
		class ViewOptics: ViewOptics
		{
			initAngleX = 0;
			minAngleX = -30;
			maxAngleX = 30;
			initAngleY = 0;
			minAngleY = -86;
			maxAngleY = 86;
			minFov = 0.25;
			maxFov = 1.25;
			initFov = 0.75;
		};
		memorypointcm[] = {"flare_launcher1"};
		memorypointcmdir[] = {"flare_launcher1_dir"};
		driveOnComponent[] = {"Skids"};
		fuelCapacity = 236;
		fuelConsumptionRate = 0.06;
		maxFordingDepth = 0.65;
		mainBladeRadius = 4.32;
		tailBladeRadius = 0.77;
		class RotorLibHelicopterProperties: RotorLibHelicopterProperties
		{
			RTDconfig = "rhsusf\addons\rhsusf_c_melb\RTD_MELB.xml";
			autoHoverCorrection[] = {0.28,2.88,0};
			defaultCollective = 0.5;
			throttleOffToIdle = 8;
			throttleIdleToOff = 6;
			throttleIdleToFull = 12;
			throttleFullToIdle = 6;
			maxTorque = 1200;
			stressDamagePerSec = 0.0033333332;
			maxHorizontalStabilizerLeftStress = 10000;
			maxHorizontalStabilizerRightStress = 10000;
			maxVerticalStabilizerStress = 10000;
			horizontalWingsAngleCollMin = 0;
			horizontalWingsAngleCollMax = 0;
			maxMainRotorStress = 45000;
			maxTailRotorStress = 20200;
			retreatBladeStallWarningSpeed = 77.222;
			rtd_center = "rtd_center";
		};
		startDuration = 10;
		washDownStrength = "0.7f";
		maxSpeed = 200;
		slingLoadMemoryPoint = "slingLoad0";
		slingLoadMaxCargoMass = 900;
		liftForceCoef = 1;
		cyclicAsideForceCoef = 1.65;
		cyclicForwardForceCoef = 0.4;
		backrotorforcecoef = 0.9;
		bodyFrictionCoef = 0.3;
		sensitivity = 2.5;
		maximumLoad = 1000;
		cost = 4000000;
		memoryPointSupply = "memsupply";
		supplyradius = 4;
		occludeSoundsWhenIn = 0.762341;
		obstructSoundsWhenIn = 0.616228;
		attenuationEffectType = "OpenHeliAttenuation";
		soundGeneralCollision1[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_default_int_1",1,1,100};
		soundGeneralCollision2[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_default_int_2",1,1,100};
		soundGeneralCollision3[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_default_int_3",1,1,100};
		soundCrashes[] = {"soundGeneralCollision1",0.33,"soundGeneralCollision2",0.33,"soundGeneralCollision3",0.33};
		soundLandCrashes[] = {"emptySound",0};
		soundBuildingCrash[] = {"soundGeneralCollision1",1,"soundGeneralCollision2",1,"soundGeneralCollision3",1};
		soundArmorCrash[] = {"soundGeneralCollision1",1,"soundGeneralCollision2",1,"soundGeneralCollision3",1};
		soundWoodCrash[] = {"soundGeneralCollision1",1,"soundGeneralCollision2",1,"soundGeneralCollision3",1};
		soundBushCollision1[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_bush_int_1",1,1,100};
		soundBushCollision2[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_bush_int_2",1,1,100};
		soundBushCollision3[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_bush_int_3",1,1,100};
		soundBushCrash[] = {"soundBushCollision1",0.33,"soundBushCollision2",0.33,"soundBushCollision3",0.33};
		soundWaterCollision1[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_water_ext_1",1,1,100};
		soundWaterCollision2[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_coll_water_ext_2",1,1,100};
		soundWaterCrashes[] = {"soundWaterCollision1",0.5,"soundWaterCollision2",0.5};
		soundGetIn[] = {"A3\Sounds_F\vehicles\air\noises\heli_get_in2",0.56234133,1};
		soundGetOut[] = {"A3\Sounds_F\vehicles\air\noises\heli_get_out2",0.7943282,1,20};
		soundDammage[] = {"A3\Sounds_F\vehicles\crashes\helis\Heli_crash_default_ext_1",3.1622777,1};
		soundEngineOnInt[] = {"rhsusf\addons\rhsusf_melb\Sound\Int_Start",0.4,1};
		soundEngineOnExt[] = {"rhsusf\addons\rhsusf_melb\Sound\Ext_Start",0.7943282,1,600};
		soundEngineOffInt[] = {"rhsusf\addons\rhsusf_melb\Sound\Int_Off",0.4,1};
		soundEngineOffExt[] = {"rhsusf\addons\rhsusf_melb\Sound\Ext_Off",0.7943282,1,600};
		soundLocked[] = {"\A3\Sounds_F\weapons\Rockets\opfor_lock_1",1,1};
		soundIncommingMissile[] = {"\A3\Sounds_F\weapons\Rockets\opfor_lock_2",0.7,1};
		rotorDamageInt[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_rotor_int_open_1",1,1};
		rotorDamageOut[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_rotor_ext_1",2.5118864,1,150};
		rotorDamage[] = {"rotorDamageInt","rotorDamageOut"};
		tailDamageInt[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_tail",1,1};
		tailDamageOut[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_tail",1,1,300};
		tailDamage[] = {"tailDamageInt","tailDamageOut"};
		landingSoundInt0[] = {"A3\Sounds_F\vehicles\air\noises\landing_skids_int1_open",1,1,100};
		landingSoundInt1[] = {"A3\Sounds_F\vehicles\air\noises\landing_skids_int1_open",1,1,100};
		landingSoundInt[] = {"landingSoundInt0",0.5,"landingSoundInt1",0.5};
		landingSoundOut0[] = {"A3\Sounds_F\vehicles\air\noises\landing_skids_ext1",1.7782794,1,100};
		landingSoundOut1[] = {"A3\Sounds_F\vehicles\air\noises\landing_skids_ext1",1.7782794,1,100};
		landingSoundOut[] = {"landingSoundOut0",0.5,"landingSoundOut1",0.5};
		slingCargoAttach0[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineDownEndINT",1,1};
		slingCargoAttach1[] = {"A3\Sounds_F\vehicles\air\noises\SL_1hookLock",1,1,80};
		slingCargoAttach[] = {"slingCargoAttach0","slingCargoAttach1"};
		slingCargoDetach0[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineUpEndINT",1,1};
		slingCargoDetach1[] = {"A3\Sounds_F\vehicles\air\noises\SL_1hookUnlock",1,1,80};
		slingCargoDetach[] = {"slingCargoDetach0","slingCargoDetach1"};
		slingCargoDetachAir0[] = {"A3\Sounds_F\vehicles\air\noises\SL_unhook_air_int",1,1};
		slingCargoDetachAir1[] = {"A3\Sounds_F\vehicles\air\noises\SL_unhook_air_ext",1,1,80};
		slingCargoDetachAir[] = {"slingCargoDetach0","slingCargoDetach1"};
		slingCargoRopeBreak0[] = {"A3\Sounds_F\vehicles\air\noises\SL_rope_break_int",1,1};
		slingCargoRopeBreak1[] = {"A3\Sounds_F\vehicles\air\noises\SL_rope_break_ext",1,1,80};
		slingCargoRopeBreak[] = {"slingCargoDetach0","slingCargoDetach1"};
		class Sounds
		{
			class EngineExt
			{
				sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Ext_Idle",1.2889254,1,400};
				frequency = "rotorSpeed*(1+rotorThrust/6)*0.9";
				volume = "camPos*((rotorSpeed-0.72)*4)";
			};
			class RotorExt
			{
				sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Ext_Low",1.2589254,1,500};
				frequency = "1.3*(rotorSpeed factor [0.3, 0.7]) * (rotorSpeed factor [0.3, 1]) * (1 - rotorThrust/6)";
				volume = "camPos*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)";
			};
			class RotorSwist
			{
				sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Close",1.2,1,600};
				frequency = "rotorSpeed*(1+rotorThrust/6)*0.9";
				volume = "camPos * (gmeterZ factor[1.5, 2.5]) + (gmeterZ factor[0.5, -0.5]) * (rotorThrust factor [0.7, 0.9])";
			};
			class EngineInt
			{
				sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Int_Idle",1,1};
				frequency = "rotorSpeed*(1+rotorThrust/6)*0.9";
				volume = "(1-camPos)*((rotorSpeed-0.75)*4)";
			};
			class RotorInt
			{
				sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Int_Low",0.501187,1};
				frequency = "1*(rotorSpeed factor [0.3, 0.7]) * (rotorSpeed factor [0.3, 1]) * (1 - rotorThrust/6)";
				volume = "(1-camPos)*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)*0.9";
			};
			class RotorBench
			{
				sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Ext_Low",1.2589254,1,500};
				frequency = "1.3*(rotorSpeed factor [0.3, 0.7]) * (rotorSpeed factor [0.3, 1]) * (1 - rotorThrust/6)";
				volume = "(playerPos factor [3.9, 4]) * (1 - camPos) * (rotorSpeed factor [0.3, 1]) * (1 + rotorThrust) * 0.4";
				cone[] = {1.6,3.14,1.6,0.95};
			};
			class EngineBench
			{
				sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Ext_Idle",1.2818383,1};
				frequency = "rotorSpeed*(1+rotorThrust/6)*0.9";
				volume = "(playerPos factor [3.9, 4]) * (1 - camPos) * (0 max (rotorSpeed-0.4))";
			};
			class WindBench
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\wind_open_out",0.56234133,1,50};
				frequency = 1;
				volume = "4 * (playerPos factor [3.9, 4]) * (1 - camPos) * ((speed factor[0, 30]) + (speed factor[0, -30]))";
			};
			class TransmissionDamageExt_phase1
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_ext_1",1,1,150};
				frequency = "0.66 + rotorSpeed / 3";
				volume = "camPos * (transmissionDamage factor [0.3, 0.35]) * (transmissionDamage factor [0.5, 0.45]) * (rotorSpeed factor [0.2, 0.5])";
			};
			class TransmissionDamageExt_phase2
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_ext_2",1,1,150};
				frequency = "0.66 + rotorSpeed / 3";
				volume = "camPos * (transmissionDamage factor [0.45, 0.5]) * (rotorSpeed factor [0.2, 0.5])";
			};
			class TransmissionDamageInt_phase1
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_int_1",1,1,150};
				frequency = "0.66 + rotorSpeed / 3";
				volume = "(1 - camPos) * (transmissionDamage factor [0.3, 0.35]) * (transmissionDamage factor [0.5, 0.45]) * (rotorSpeed factor [0.2, 0.5])";
			};
			class TransmissionDamageInt_phase2
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_int_2",1,1,150};
				frequency = "0.66 + rotorSpeed / 3";
				volume = "(1 - camPos) * (transmissionDamage factor [0.45, 0.5]) * (rotorSpeed factor [0.2, 0.5])";
			};
			class RotorNoiseExt
			{
				sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Rotor_Fast",1.2818383,1,200};
				frequency = 1.5;
				volume = "(camPos*(rotorSpeed factor [0.6, 0.85]))";
				cone[] = {1.6,3.14,2,0.95};
			};
			class FarDistance
			{
				sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Distance",2.0918384,1.1,1100};
				frequency = "rotorSpeed";
				volume = "2 * camPos * (0 max (rotorSpeed-0.4))";
			};
			class FarDistanceRotor
			{
				sound[] = {"rhsusf\addons\rhsusf_melb\Sound\tail_rotor",2.0918384,1,1000};
				frequency = "rotorSpeed";
				volume = "2 * camPos * (0 max (rotorSpeed-0.4))";
			};
			class damageAlarmInt
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_alarm_bluefor",0.31622776,1};
				frequency = 1;
				volume = "engineOn * (1 - camPos) * ( 1 - ((transmissionDamage factor [0.61, 0.60]) * (motorDamage factor [0.61, 0.60]) * (rotorDamage factor [0.51, 0.50]))) * (rotorSpeed factor [0.0, 0.001])";
			};
			class damageAlarmExt
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_alarm_bluefor",0.2238721,1,20};
				frequency = 1;
				volume = "engineOn * camPos * ( 1 - ((transmissionDamage factor [0.61, 0.60]) * (motorDamage factor [0.61, 0.60]) * (rotorDamage factor [0.51, 0.50]))) * (rotorSpeed factor [0, 0.001])";
			};
			class rotorLowAlarmInt
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_alarm_rotor_low",0.31622776,1};
				frequency = 1;
				volume = "engineOn * (1 - camPos) * (rotorSpeed factor [0.9, 0.8999]) * (rotorSpeed factor [-0.5, 1]) * (speed factor [3, 3.01])";
			};
			class rotorLowAlarmExt
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_alarm_rotor_low",0.2238721,1,20};
				frequency = 1;
				volume = "engineOn * camPos * (rotorSpeed factor [0.9, 0.8999]) * (rotorSpeed factor [-0.5, 1]) * (speed factor [3, 3.01])";
			};
			class scrubLandInt
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\scrubLandInt_open",1,1,100};
				frequency = 1;
				volume = "2 * (1-camPos) * (scrubLand factor[0.02, 0.05])";
			};
			class scrubLandExt
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\scrubLandExt",1,1,100};
				frequency = 1;
				volume = "camPos * (scrubLand factor[0.02, 0.05])";
			};
			class scrubBuildingInt
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\scrubBuildingInt",1,1,100};
				frequency = 1;
				volume = "2 * (1 - camPos) * (scrubBuilding factor[0.02, 0.05])";
			};
			class scrubBuildingExt
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\scrubBuildingExt",1,1,100};
				frequency = 1;
				volume = "camPos * (scrubBuilding factor[0.02, 0.05])";
			};
			class scrubTreeInt
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\scrubTreeExt",1,1,100};
				frequency = 1;
				volume = "(1 - camPos) * ((scrubTree) factor [0, 0.01])";
			};
			class scrubTreeExt
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\scrubTreeExt",1,1,100};
				frequency = 1;
				volume = "camPos * ((scrubTree) factor [0, 0.01])";
			};
			class RainExt
			{
				sound[] = {"A3\Sounds_F\vehicles\noises\rain1_ext",1,1,100};
				frequency = 1;
				volume = "camPos * (rain - rotorSpeed/2) * 2";
			};
			class RainInt
			{
				sound[] = {"A3\Sounds_F\vehicles\noises\rain1_int_open",1,1,100};
				frequency = 1;
				volume = "(1-camPos)*(rain - rotorSpeed/2)*2";
			};
			class SlingLoadDownExt
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineDownEXT",1,1,500};
				frequency = 1;
				volume = "camPos*(slingLoadActive factor [0,-1])";
			};
			class SlingLoadUpExt
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineUpEXT",1,1,500};
				frequency = 1;
				volume = "camPos*(slingLoadActive factor [0,1])";
			};
			class SlingLoadDownInt
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineDownINT",1,1,500};
				frequency = 1;
				volume = "(1-camPos)*(slingLoadActive factor [0,-1])";
			};
			class SlingLoadUpInt
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineUpINT",1,1,500};
				frequency = 1;
				volume = "(1-camPos)*(slingLoadActive factor [0,1])";
			};
			class WindInt
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\wind_open_int",1,1,50};
				frequency = 1;
				volume = "(1-camPos)*(speed factor[5, 50])*(speed factor[5, 50])";
			};
			class WindLateralMovementInt
			{
				sound[] = {"A3\Sounds_F\vehicles\air\noises\wind_lateral_open_int",1,1,50};
				frequency = 1;
				volume = "(1-camPos)*lateralMovement*((speed factor [5,40]) + (speed factor [-5,-40]))";
			};
			class GStress
			{
				sound[] = {"A3\Sounds_F\vehicles\noises\vehicle_stress2b",0.11622776,1,50};
				frequency = 1;
				volume = "engineOn * (1-camPos) * ((gmeterZ factor[1.5, 2.5]) + (gmeterZ factor[0.5, -0.5]))";
			};
		};
		class SoundsExt
		{
			class SoundEvents{};
			class Sounds
			{
				class EngineExt
				{
					sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Ext_Idle",1.2889254,1,400};
					frequency = "1.3*rotorSpeed";
					volume = "2 * camPos * (0 max (rotorSpeed-0.4))";
				};
				class RotorExt
				{
					sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Ext_Low",1.2589254,1,500};
					frequency = "1.3*(rotorSpeed factor [0.3, 0.7]) * (rotorSpeed factor [0.3, 1]) * (1 - rotorThrust/6)";
					volume = "camPos * (rotorSpeed factor [0.3, 1]) * (1 + rotorThrust)";
				};
				class RotorSwist
				{
					sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Close",1.2,1,600};
					frequency = "1.3*rotorspeed";
					volume = "camPos * (gmeterZ factor[1.5, 2.5]) + (gmeterZ factor[0.5, -0.5]) * (rotorThrust factor [0.7, 0.9])";
				};
				class EngineInt
				{
					sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Int_Idle",1,1};
					frequency = "rotorSpeed";
					volume = "(1-camPos)*2*(0 max (rotorSpeed-0.4))";
				};
				class RotorInt
				{
					sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Int_Low",1.2818383,1};
					frequency = "(rotorSpeed factor [0.3, 0.7]) * (rotorSpeed factor [0.3, 1]) * (1 - rotorThrust/6)";
					volume = "(1 - camPos) * (rotorSpeed factor [0.3, 0.7]) * (1 + rotorThrust) * 0.7";
				};
				class RotorBench
				{
					sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Ext_Low",1.2589254,1,500};
					frequency = "1.3*(rotorSpeed factor [0.3, 0.7]) * (rotorSpeed factor [0.3, 1]) * (1 - rotorThrust/6)";
					volume = "(playerPos factor [3.9, 4]) * (1 - camPos) * (rotorSpeed factor [0.3, 1]) * (1 + rotorThrust) * 0.4";
					cone[] = {1.6,3.14,1.6,0.95};
				};
				class EngineBench
				{
					sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Ext_Idle",1.2818383,1};
					frequency = "1.3*rotorSpeed";
					volume = "(playerPos factor [3.9, 4]) * (1 - camPos) * (0 max (rotorSpeed-0.4))";
				};
				class WindBench
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\wind_open_out",0.56234133,1,50};
					frequency = 1;
					volume = "4 * (playerPos factor [3.9, 4]) * (1 - camPos) * ((speed factor[0, 30]) + (speed factor[0, -30]))";
				};
				class TransmissionDamageExt_phase1
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_ext_1",1,1,150};
					frequency = "0.66 + rotorSpeed / 3";
					volume = "camPos * (transmissionDamage factor [0.3, 0.35]) * (transmissionDamage factor [0.5, 0.45]) * (rotorSpeed factor [0.2, 0.5])";
				};
				class TransmissionDamageExt_phase2
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_ext_2",1,1,150};
					frequency = "0.66 + rotorSpeed / 3";
					volume = "camPos * (transmissionDamage factor [0.45, 0.5]) * (rotorSpeed factor [0.2, 0.5])";
				};
				class TransmissionDamageInt_phase1
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_int_1",1,1,150};
					frequency = "0.66 + rotorSpeed / 3";
					volume = "(1 - camPos) * (transmissionDamage factor [0.3, 0.35]) * (transmissionDamage factor [0.5, 0.45]) * (rotorSpeed factor [0.2, 0.5])";
				};
				class TransmissionDamageInt_phase2
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_damage_transmission_int_2",1,1,150};
					frequency = "0.66 + rotorSpeed / 3";
					volume = "(1 - camPos) * (transmissionDamage factor [0.45, 0.5]) * (rotorSpeed factor [0.2, 0.5])";
				};
				class RotorNoiseExt
				{
					sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Rotor_Fast",1.2818383,1,200};
					frequency = 1;
					volume = "(camPos*(rotorSpeed factor [0.6, 0.85]))";
					cone[] = {1.6,3.14,2,0.95};
				};
				class FarDistance
				{
					sound[] = {"rhsusf\addons\rhsusf_melb\Sound\Distance",2.0918384,1.1,1100};
					frequency = "rotorSpeed";
					volume = "2 * camPos * (0 max (rotorSpeed-0.4))";
				};
				class FarDistanceRotor
				{
					sound[] = {"rhsusf\addons\rhsusf_melb\Sound\tail_rotor",2.0918384,1,1000};
					frequency = "rotorSpeed";
					volume = "2 * camPos * (0 max (rotorSpeed-0.4))";
				};
				class damageAlarmInt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_alarm_bluefor",0.31622776,1};
					frequency = 1;
					volume = "engineOn * (1 - camPos) * ( 1 - ((transmissionDamage factor [0.61, 0.60]) * (motorDamage factor [0.61, 0.60]) * (rotorDamage factor [0.51, 0.50]))) * (rotorSpeed factor [0.0, 0.001])";
				};
				class damageAlarmExt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_alarm_bluefor",0.2238721,1,20};
					frequency = 1;
					volume = "engineOn * camPos * ( 1 - ((transmissionDamage factor [0.61, 0.60]) * (motorDamage factor [0.61, 0.60]) * (rotorDamage factor [0.51, 0.50]))) * (rotorSpeed factor [0, 0.001])";
				};
				class rotorLowAlarmInt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_alarm_rotor_low",0.31622776,1};
					frequency = 1;
					volume = "engineOn * (1 - camPos) * (rotorSpeed factor [0.9, 0.8999]) * (rotorSpeed factor [-0.5, 1]) * (speed factor [3, 3.01])";
				};
				class rotorLowAlarmExt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\heli_alarm_rotor_low",0.2238721,1,20};
					frequency = 1;
					volume = "engineOn * camPos * (rotorSpeed factor [0.9, 0.8999]) * (rotorSpeed factor [-0.5, 1]) * (speed factor [3, 3.01])";
				};
				class scrubLandInt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\scrubLandInt_open",1,1,100};
					frequency = 1;
					volume = "2 * (1-camPos) * (scrubLand factor[0.02, 0.05])";
				};
				class scrubLandExt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\scrubLandExt",1,1,100};
					frequency = 1;
					volume = "camPos * (scrubLand factor[0.02, 0.05])";
				};
				class scrubBuildingInt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\scrubBuildingInt",1,1,100};
					frequency = 1;
					volume = "2 * (1 - camPos) * (scrubBuilding factor[0.02, 0.05])";
				};
				class scrubBuildingExt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\scrubBuildingExt",1,1,100};
					frequency = 1;
					volume = "camPos * (scrubBuilding factor[0.02, 0.05])";
				};
				class scrubTreeInt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\scrubTreeExt",1,1,100};
					frequency = 1;
					volume = "(1 - camPos) * ((scrubTree) factor [0, 0.01])";
				};
				class scrubTreeExt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\scrubTreeExt",1,1,100};
					frequency = 1;
					volume = "camPos * ((scrubTree) factor [0, 0.01])";
				};
				class RainExt
				{
					sound[] = {"A3\Sounds_F\vehicles\noises\rain1_ext",1,1,100};
					frequency = 1;
					volume = "camPos * (rain - rotorSpeed/2) * 2";
				};
				class RainInt
				{
					sound[] = {"A3\Sounds_F\vehicles\noises\rain1_int_open",1,1,100};
					frequency = 1;
					volume = "(1-camPos)*(rain - rotorSpeed/2)*2";
				};
				class SlingLoadDownExt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineDownEXT",1,1,500};
					frequency = 1;
					volume = "camPos*(slingLoadActive factor [0,-1])";
				};
				class SlingLoadUpExt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineUpEXT",1,1,500};
					frequency = 1;
					volume = "camPos*(slingLoadActive factor [0,1])";
				};
				class SlingLoadDownInt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineDownINT",1,1,500};
					frequency = 1;
					volume = "(1-camPos)*(slingLoadActive factor [0,-1])";
				};
				class SlingLoadUpInt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\SL_engineUpINT",1,1,500};
					frequency = 1;
					volume = "(1-camPos)*(slingLoadActive factor [0,1])";
				};
				class WindInt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\wind_open_int",1.1220185,1,50};
					frequency = 1;
					volume = "(1-camPos)*(speed factor[5, 50])*(speed factor[5, 50])";
				};
				class WindLateralMovementInt
				{
					sound[] = {"A3\Sounds_F\vehicles\air\noises\wind_lateral_open_int",1.9952624,1,50};
					frequency = 1;
					volume = "(1-camPos)*lateralMovement*((speed factor [5,40]) + (speed factor [-5,-40]))";
				};
				class GStress
				{
					sound[] = {"A3\Sounds_F\vehicles\noises\vehicle_stress2b",0.11622776,1,50};
					frequency = 1;
					volume = "engineOn * (1-camPos) * ((gmeterZ factor[1.5, 2.5]) + (gmeterZ factor[0.5, -0.5]))";
				};
			};
		};
		class CargoTurret;
		class pilotCamera
		{
			class OpticsIn
			{
				class Wide
				{
					opticsDisplayName = "W";
					initAngleX = 0;
					minAngleX = 0;
					maxAngleX = 0;
					initAngleY = 0;
					minAngleY = 0;
					maxAngleY = 0;
					initFov = 0.7;
					minFov = 0.03;
					maxFov = 1.2;
					visionMode[] = {"Normal","NVG","Ti"};
					thermalMode[] = {0,1};
					gunnerOpticsModel = "\A3\Weapons_F_Beta\Reticle\Heli_Attack_01_Optics_Gunner_wide_F.p3d";
				};
				showMiniMapInOptics = 0;
				showUAVViewpInOptics = 0;
				showSlingLoadManagerInOptics = 1;
			};
			gunBeg = "commanderview";
			gunEnd = "laserstart";
			memoryPointGun = "commanderview";
			discretedistance[] = {100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,2600,2700,2800,2900,3000};
			discretedistanceinitindex = 3;
			weapons[] = {"rhs_weap_laserDesignator_AI","rhs_weap_fcs_ah64"};
			magazines[] = {"rhs_laserfcsmag","rhs_LaserMag_ai"};
			minTurn = -90;
			maxTurn = 90;
			initTurn = 0;
			minElev = -35;
			maxElev = 90;
			initElev = 0;
			maxXRotSpeed = 0.5;
			maxYRotSpeed = 0.5;
			pilotOpticsShowCursor = 1;
			controllable = 1;
		};
		memoryPointGunnerOptics = "commanderview";
		memoryPointDriverOptics = "commanderview";
		gunBeg = "commanderview";
		gunEnd = "laserstart";
		memoryPointGun = "commanderview";
		body = "obsTurret";
		gun = "obsGun";
		animationSourceBody = "obsTurret";
		animationSourceGun = "obsGun";
		turretInfoType = "Rsc_MELB_Turret_UnitInfo";
		usepip = 1;
		canUseScanners = 1;
		class Exhausts
		{
			class Exhaust01
			{
				position = "exhaust1";
				direction = "exhaust1_dir";
				effect = "ExhaustEffectHeli";
			};
		};
		class Library
		{
			libTextDesc = "Syko's Little Birds";
		};
		armor = 35;
		armorStructural = 20;
		epeImpulseDamageCoef = 20;
		damageResistance = 0.01039;
		crewCrashProtection = 0.2;
		hullDamageCauseExplosion = 1;
		hullExplosionDelay[] = {10,20};
		class HitPoints: HitPoints
		{
			class HitFuel: HitFuel
			{
				armor = -130;
				armorComponent = "fuel_hit";
				name = "fuel_hit";
				visual = "-";
				radius = 0.125;
				minimalhit = -0.04;
				explosionShielding = 0.5;
				passThrough = 0;
			};
			class HitHull: HitHull
			{
				depends = "HitEngine";
				simulation = "RHS_Hull_Helicopter";
				armor = -120;
				minimalHit = -0.15;
				radius = 0.02;
				name = "hull_hit";
				armorComponent = "hull_hit";
				visual = "zbytek";
				passThrough = 1;
				class DestructionEffects: RHS_Effects_Helicopter_Hull_Destruction{};
			};
			class HitEngine: HitEngine
			{
				armorComponent = "engine_hit";
				name = "engine_hit";
				armor = -120;
				visual = "-";
				radius = 0.15;
				explosionShielding = 0.85;
				minimalhit = -0.05;
				passThrough = 0.3;
			};
			class HitAvionics: HitAvionics
			{
				name = "avionics_hit";
				armor = 2;
				visual = "-";
				radius = 0.05;
				explosionShielding = 0.5;
			};
			class HitVRotor: HitVRotor
			{
				visual = "tail rotor static";
				armor = 1;
				radius = 0.05;
				explosionShielding = 0.8;
			};
			class HitHRotor: HitHRotor
			{
				visual = "main rotor static";
				armor = 3;
				radius = 0.2;
				explosionShielding = 0.5;
			};
			class HitGlass1: HitGlass1
			{
				armor = 2;
				radius = 0.15;
				explosionShielding = 2;
			};
			class HitGlass2: HitGlass2
			{
				armor = 2;
				radius = 0.15;
				explosionShielding = 2;
			};
			class HitGlass3: HitGlass3
			{
				armor = 2;
				radius = 0.15;
				explosionShielding = 2;
			};
			class HitGlass4: HitGlass4
			{
				armor = 2;
				radius = 0.15;
				explosionShielding = 2;
			};
			class HitPylon1
			{
				armor = -30;
				name = "hit_pylon_1";
				passThrough = 0;
				minimalHit = -0.1;
				explosionShielding = 0.1;
				radius = 0.7;
				visual = "-";
				class DestructionEffects
				{
					ammoExplosionEffect = "";
					effectRadius = 1;
					ignoreFuel = 1;
					class RHS_Pylon_Flash
					{
						simulation = "particles";
						type = "RHS_ERA_Flash";
						position = "fx_pylon_1";
						intensity = 0.5;
						interval = 1;
						lifeTime = 0.006;
					};
					class RHS_Pylon_Sound
					{
						simulation = "sound";
						type = "RHS_ERA_Explosion_Sound";
						position = "fx_pylon_1";
						intensity = 1;
						interval = 1;
						lifeTime = 1;
					};
					class RHS_Pylon_Smoke
					{
						simulation = "particles";
						type = "RHS_ERA_Smoke";
						position = "fx_pylon_1";
						intensity = 0.1;
						interval = 1;
						lifeTime = 0.04;
					};
					class RHS_Pylon_Shard
					{
						simulation = "particles";
						type = "RHS_ERA_Shard";
						position = "fx_pylon_1";
						intensity = 1;
						interval = 1;
						lifeTime = 0.03;
					};
				};
			};
			class HitPylon2
			{
				armor = -30;
				name = "hit_pylon_2";
				passThrough = 0;
				minimalHit = -0.1;
				explosionShielding = 0.1;
				radius = 0.7;
				visual = "-";
				class DestructionEffects
				{
					ammoExplosionEffect = "";
					effectRadius = 1;
					ignoreFuel = 1;
					class RHS_Pylon_Flash
					{
						simulation = "particles";
						type = "RHS_ERA_Flash";
						position = "fx_pylon_2";
						intensity = 0.5;
						interval = 1;
						lifeTime = 0.006;
					};
					class RHS_Pylon_Sound
					{
						simulation = "sound";
						type = "RHS_ERA_Explosion_Sound";
						position = "fx_pylon_2";
						intensity = 1;
						interval = 1;
						lifeTime = 1;
					};
					class RHS_Pylon_Smoke
					{
						simulation = "particles";
						type = "RHS_ERA_Smoke";
						position = "fx_pylon_2";
						intensity = 0.1;
						interval = 1;
						lifeTime = 0.04;
					};
					class RHS_Pylon_Shard
					{
						simulation = "particles";
						type = "RHS_ERA_Shard";
						position = "fx_pylon_2";
						intensity = 1;
						interval = 1;
						lifeTime = 0.03;
					};
				};
			};
			class HitPylon3
			{
				armor = -30;
				name = "hit_pylon_3";
				passThrough = 0;
				minimalHit = -0.1;
				explosionShielding = 0.1;
				radius = 0.7;
				visual = "-";
				class DestructionEffects
				{
					ammoExplosionEffect = "";
					effectRadius = 1;
					ignoreFuel = 1;
					class RHS_Pylon_Flash
					{
						simulation = "particles";
						type = "RHS_ERA_Flash";
						position = "fx_pylon_3";
						intensity = 0.5;
						interval = 1;
						lifeTime = 0.006;
					};
					class RHS_Pylon_Sound
					{
						simulation = "sound";
						type = "RHS_ERA_Explosion_Sound";
						position = "fx_pylon_3";
						intensity = 1;
						interval = 1;
						lifeTime = 1;
					};
					class RHS_Pylon_Smoke
					{
						simulation = "particles";
						type = "RHS_ERA_Smoke";
						position = "fx_pylon_3";
						intensity = 0.1;
						interval = 1;
						lifeTime = 0.04;
					};
					class RHS_Pylon_Shard
					{
						simulation = "particles";
						type = "RHS_ERA_Shard";
						position = "fx_pylon_3";
						intensity = 1;
						interval = 1;
						lifeTime = 0.03;
					};
				};
			};
			class HitPylon4
			{
				armor = -30;
				name = "hit_pylon_4";
				passThrough = 0;
				minimalHit = -0.1;
				explosionShielding = 0.1;
				radius = 0.7;
				visual = "-";
				class DestructionEffects
				{
					ammoExplosionEffect = "";
					effectRadius = 1;
					ignoreFuel = 1;
					class RHS_Pylon_Flash
					{
						simulation = "particles";
						type = "RHS_ERA_Flash";
						position = "fx_pylon_4";
						intensity = 0.5;
						interval = 1;
						lifeTime = 0.006;
					};
					class RHS_Pylon_Sound
					{
						simulation = "sound";
						type = "RHS_ERA_Explosion_Sound";
						position = "fx_pylon_4";
						intensity = 1;
						interval = 1;
						lifeTime = 1;
					};
					class RHS_Pylon_Smoke
					{
						simulation = "particles";
						type = "RHS_ERA_Smoke";
						position = "fx_pylon_4";
						intensity = 0.1;
						interval = 1;
						lifeTime = 0.04;
					};
					class RHS_Pylon_Shard
					{
						simulation = "particles";
						type = "RHS_ERA_Shard";
						position = "fx_pylon_4";
						intensity = 1;
						interval = 1;
						lifeTime = 0.03;
					};
				};
			};
		};
		class Damage
		{
			tex[] = {};
			mat[] = {"rhsusf\addons\rhsusf_melb\data\melb_ext.rvmat","rhsusf\addons\rhsusf_melb\data\melb_ext_damage.rvmat","rhsusf\addons\rhsusf_melb\data\melb_ext_destruct.rvmat","rhsusf\addons\rhsusf_melb\data\melb_glass.rvmat","rhsusf\addons\rhsusf_melb\data\melb_glass_damage.rvmat","rhsusf\addons\rhsusf_melb\data\melb_glass_destruct.rvmat","rhsusf\addons\rhsusf_melb\data\melb_glass_in.rvmat","rhsusf\addons\rhsusf_melb\data\melb_glass_damage.rvmat","rhsusf\addons\rhsusf_melb\data\melb_glass_destruct.rvmat"};
		};
		class AnimationSources: AnimationSources
		{
			class AddBenches
			{
				source = "user";
				animPeriod = 1e-06;
				initPhase = 0;
			};
			class Addgunrack
			{
				source = "user";
				animPeriod = 1e-07;
				initPhase = 0;
			};
			class Addcrosshair
			{
				source = "user";
				animPeriod = 1e-06;
				initPhase = 0;
			};
			class Addfueltank
			{
				source = "user";
				animPeriod = 1e-06;
				initPhase = 0;
			};
			class AddBobhead
			{
				source = "user";
				animPeriod = 1e-06;
				initPhase = 0;
				displayName = "Bobblehead";
			};
			class hide_NoFear
			{
				source = "user";
				animPeriod = 1e-05;
				initPhase = 0;
				displayName = "No Fear Decal";
			};
			class hide_SGDM: hide_NoFear
			{
				displayName = "Six Guns Decal";
			};
			class hide_SN_nose: hide_NoFear
			{
				displayName = "Tail Number on nose";
			};
			class hide_clan: hide_NoFear
			{
				displayName = "Squad XML";
			};
			class HitGlass1
			{
				source = "Hit";
				hitpoint = "HitGlass1";
				raw = 1;
			};
			class HitGlass2: HitGlass1
			{
				hitpoint = "HitGlass2";
			};
			class HitGlass3: HitGlass1
			{
				hitpoint = "HitGlass3";
			};
			class HitGlass4: HitGlass1
			{
				hitpoint = "HitGlass4";
			};
			class HitGlass5: HitGlass1
			{
				hitpoint = "HitGlass5";
			};
			class HitGlass6: HitGlass1
			{
				hitpoint = "HitGlass6";
			};
			class MFD_Pilot
			{
				source = "user";
				animPeriod = 1;
				initPhase = 0;
			};
			class MFD_CoPilot: MFD_Pilot{};
			class pilotpip
			{
				source = "user";
				animperiod = 0.001;
				initPhase = 0;
			};
			class copilotpip: pilotpip{};
			class hit_pylon_1_source
			{
				source = "Hit";
				hitpoint = "HitPylon1";
			};
			class hit_pylon_2_source
			{
				source = "Hit";
				hitpoint = "HitPylon2";
			};
			class hit_pylon_3_source
			{
				source = "Hit";
				hitpoint = "HitPylon3";
			};
			class hit_pylon_4_source
			{
				source = "Hit";
				hitpoint = "HitPylon4";
			};
		};
		class UserActions
		{
			class MFD_Toggle
			{
				displayName = "Toggle Monitor";
				onlyforplayer = 1;
				position = "doplnovani";
				radius = 2;
				shortcut = "LandGearUp";
				condition = "((call rhsusf_fnc_findPlayer)==driver this) or ((call rhsusf_fnc_findPlayer)==gunner this) ";
				statement = "call RHS_MELB_fnc_MFD_toggle";
				showWindow = 0;
			};
			class SAFEMODE
			{
				displayName = "<t color='#00FF7F'>MASTERSAFE</t>";
				condition = "(call rhsusf_fnc_findPlayer) in this";
				statement = "(call rhsusf_fnc_findPlayer) action ['SwitchWeapon', this, (call rhsusf_fnc_findPlayer), 0];";
				position = "";
				radius = 10;
				priority = 10.5;
				onlyforplayer = 1;
				showWindow = 0;
				shortcut = "user13";
				hideOnUse = 1;
			};
		};
		class Attributes
		{
			class GOL_MELB_TailNumber
			{
				displayName = "Define Tail Number";
				tooltip = "Select tail number specific to this helicopter.";
				property = "GOL_MELB_TailNumber";
				control = "Combo";
				expression = "if(_value != 'NoChange')then{ [_this,'d_SN',_value] call RHS_MELB_fnc_tailNumber}";
				defaultValue = 0;
				typeName = "STRING";
				class values
				{
					class NoChange
					{
						name = "Default defined";
						value = "NoChange";
					};
					class blank_ca
					{
						name = "Empty";
						value = "blank_ca";
					};
					class MELB_SN_25385_ca
					{
						name = "25385";
						value = "MELB_SN_25385_ca";
					};
					class MELB_SN_25381_ca
					{
						name = "25381";
						value = "MELB_SN_25381_ca";
					};
					class MELB_SN_25378_ca
					{
						name = "25378";
						value = "MELB_SN_25378_ca";
					};
					class MELB_SN_25376_ca
					{
						name = "25376";
						value = "MELB_SN_25376_ca";
					};
					class MELB_SN_25374_ca
					{
						name = "25374";
						value = "MELB_SN_25374_ca";
					};
					class MELB_SN_25372_ca
					{
						name = "25372";
						value = "MELB_SN_25372_ca";
					};
					class MELB_SN_25366_ca
					{
						name = "25366";
						value = "MELB_SN_25366_ca";
					};
					class MELB_SN_25363_ca
					{
						name = "25363";
						value = "MELB_SN_25363_ca";
					};
					class MELB_SN_25361_ca
					{
						name = "25361";
						value = "MELB_SN_25361_ca";
					};
					class MELB_SN_25358_ca
					{
						name = "25358";
						value = "MELB_SN_25358_ca";
					};
					class MELB_SN_25355_ca
					{
						name = "25355";
						value = "MELB_SN_25355_ca";
					};
					class MELB_SN_25350_ca
					{
						name = "25350";
						value = "MELB_SN_25350_ca";
					};
					class MELB_SN_25349_ca
					{
						name = "25349";
						value = "MELB_SN_25349_ca";
					};
					class MELB_SN_25348_ca
					{
						name = "25348";
						value = "MELB_SN_25348_ca";
					};
					class MELB_SN_25346_ca
					{
						name = "25346";
						value = "MELB_SN_25346_ca";
					};
					class MELB_SN_24683_ca
					{
						name = "24683";
						value = "MELB_SN_24683_ca";
					};
					class MELB_SN_23654_ca
					{
						name = "23654";
						value = "MELB_SN_23654_ca";
					};
					class MELB_SN_23653_ca
					{
						name = "23653";
						value = "MELB_SN_23653_ca";
					};
					class MELB_SN_23652_ca
					{
						name = "23652";
						value = "MELB_SN_23652_ca";
					};
					class MELB_SN_23649_ca
					{
						name = "23649";
						value = "MELB_SN_23649_ca";
					};
					class MELB_SN_23636_ca
					{
						name = "23636";
						value = "MELB_SN_23636_ca";
					};
					class MELB_SN_23635_ca
					{
						name = "23635";
						value = "MELB_SN_23635_ca";
					};
					class MELB_SN_23632_ca
					{
						name = "23632";
						value = "MELB_SN_23632_ca";
					};
					class MELB_SN_23631_ca
					{
						name = "23631";
						value = "MELB_SN_23631_ca";
					};
				};
			};
			class GOL_MELB_NoFear
			{
				displayName = "No Fear";
				property = "MELB_NoFear";
				control = "CheckboxNumber";
				expression = "_this animate ['hide_NoFear',_value,true]";
				defaultValue = 0;
			};
			class GOL_MELB_SGDM: GOL_MELB_NoFear
			{
				displayName = "Six Guns";
				property = "MELB_SGDM";
				expression = "_this animate ['hide_SGDM',_value,true]";
			};
			class GOL_MELB_SN_Nose: GOL_MELB_NoFear
			{
				displayName = "Tail Number";
				property = "MELB_SN_Nose";
				expression = "_this animate ['hide_SN_nose',_value,true]";
			};
			class GOL_MELB_clan: GOL_MELB_NoFear
			{
				displayName = "Squad XML";
				property = "MELB_clan";
				expression = "_this animate ['hide_clan',_value,true]";
			};
			class GOL_MELB_ToggleBoy: GOL_MELB_NoFear
			{
				displayName = "Bobblehead";
				property = "MELB_ToggleBoy";
				expression = "_this animate ['AddBobhead',_value,true]";
			};
		};
		class Reflectors
		{
			class Light
			{
				color[] = {7000,7500,10000,1};
				ambient[] = {95,95,100,0};
				intensity = 50;
				size = 1;
				innerAngle = 10;
				outerAngle = 60;
				coneFadeCoef = 7;
				position = "Light_pos";
				direction = "Light_dir";
				hitpoint = "Light_hitpoint";
				selection = "Light";
				useFlare = 1;
				flareSize = 6;
				flareMaxDistance = 250;
				dayLight = 0;
				class Attenuation
				{
					start = 1;
					constant = 0;
					linear = 0;
					quadratic = 4;
				};
			};
		};
		class NVGMarkers
		{
			class IR_Position
			{
				color[] = {0.1,0.1,0.1};
				ambient[] = {0.01,0.01,0.01};
				brightness = 0.15;
				name = "IR_Position";
				drawLight = 1;
				drawLightSize = 0.01;
				drawLightCenterSize = 0.005;
				activeLight = 0;
				blinking = 0;
				dayLight = 0;
				onlyInNvg = 1;
				useFlare = 0;
			};
		};
		class Turrets: Turrets
		{
			class CopilotTurret: CopilotTurret
			{
				gunnerCompartments = "Compartment1";
				body = "obsTurret";
				gun = "obsGun";
				animationSourceBody = "obsTurret";
				animationSourceGun = "obsGun";
				turretInfoType = "Rsc_MELB_Turret_UnitInfo";
				stabilizedInAxes = 3;
				memoryPointGunnerOptics = "commanderview";
				maxXRotSpeed = 0.5;
				maxYRotSpeed = 0.5;
				minElev = -180;
				maxElev = 180;
				initElev = 0;
				minTurn = -180;
				maxTurn = 180;
				initTurn = 0;
				minFov = 0.25;
				maxFov = 0.9;
				initFov = 0.75;
				lodTurnedOut = 1100;
				lodTurned = 1100;
				memoryPointsGetInGunner = "pos gunner";
				memoryPointsGetInGunnerDir = "pos gunner dir";
				memoryPointsGetInGunnerPrecise = "pos gunner";
				gunBeg = "commanderview";
				gunEnd = "laserstart";
				memoryPointGun = "commanderview";
				discretedistance[] = {100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,2600,2700,2800,2900,3000};
				discretedistanceinitindex = 3;
				weapons[] = {"rhs_weap_laserDesignator_AI","rhs_weap_fcs_ah64"};
				magazines[] = {"rhs_laserfcsmag","rhs_LaserMag_ai"};
				soundServo[] = {"",0.01,1,30};
				inGunnerMayFire = 1;
				outGunnerMayFire = 1;
				primaryGunner = 1;
				gunnerAction = "MELB_Copilot";
				gunnerInAction = "MELB_Copilot";
				usePreciseGetInAction = 1;
				precisegetinout = 0;
				gunnerGetInAction = "Chopperlight_R_In_H";
				gunnergetOutAction = "GetOutLow";
				gunnerOpticsModel = "";
				TurretCanSee = "1+2+4+8";
				showAllTargets = 1;
				gunnerHasFlares = 1;
				usepip = 1;
				canUseScanners = 1;
				allowTabLock = 0;
				class ViewGunner
				{
					minAngleX = -65;
					maxAngleX = 85;
					initAngleX = 0;
					minAngleY = -150;
					maxAngleY = 150;
					initAngleY = 0;
					minFov = 0.25;
					maxFov = 0.9;
					initFov = 0.75;
				};
				class OpticsIn
				{
					class Wide
					{
						opticsDisplayName = "W";
						initAngleX = 0;
						minAngleX = 0;
						maxAngleX = 0;
						initAngleY = 0;
						minAngleY = 0;
						maxAngleY = 0;
						initFov = 0.7;
						minFov = 0.03;
						maxFov = 1.2;
						visionMode[] = {"Normal","NVG","Ti"};
						thermalMode[] = {0,1};
						directionStabilized = 1;
						gunnerOpticsModel = "\A3\Weapons_F_Beta\Reticle\Heli_Attack_01_Optics_Gunner_wide_F.p3d";
						opticsPPEffects[] = {"OpticsCHAbera3","OpticsBlur3"};
						gunnerOpticsEffect[] = {"TankCommanderOptics2"};
					};
				};
				class Components
				{
					class VehicleSystemsDisplayManagerComponentLeft: VehicleSystemsTemplateLeftPilot{};
					class VehicleSystemsDisplayManagerComponentRight: VehicleSystemsTemplateRightPilot{};
				};
				class Hitpoints{};
			};
		};
		class EventHandlers: EventHandlers
		{
			class GOL_MELB_EH
			{
				handleDamage = "_this call RHS_MELB_fnc_fallDamage";
				postInit = "_this call rhs_fnc_reapplyTextures";
			};
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
							maxRange = 4000;
							objectDistanceLimitCoef = -1;
							viewDistanceLimitCoef = 1;
						};
						class GroundTarget
						{
							minRange = 500;
							maxRange = 3000;
							objectDistanceLimitCoef = 1;
							viewDistanceLimitCoef = 1;
						};
						maxTrackableSpeed = 75;
						angleRangeHorizontal = 240;
						angleRangeVertical = 110;
						animDirection = "commanderview";
					};
					class VisualSensorComponent: SensorTemplateVisual
					{
						class AirTarget
						{
							minRange = 500;
							maxRange = 4000;
							objectDistanceLimitCoef = -1;
							viewDistanceLimitCoef = 1;
						};
						class GroundTarget
						{
							minRange = 500;
							maxRange = 3000;
							objectDistanceLimitCoef = 1;
							viewDistanceLimitCoef = 1;
						};
						maxTrackableSpeed = 75;
						angleRangeHorizontal = 240;
						angleRangeVertical = 110;
						aimDown = 1;
						animDirection = "commanderview";
					};
					class ActiveRadarSensorComponent: SensorTemplateActiveRadar
					{
						class AirTarget
						{
							minRange = 7000;
							maxRange = 7000;
							objectDistanceLimitCoef = -1;
							viewDistanceLimitCoef = -1;
						};
						class GroundTarget
						{
							minRange = 4000;
							maxRange = 4000;
							objectDistanceLimitCoef = -1;
							viewDistanceLimitCoef = -1;
						};
						angleRangeHorizontal = 240;
						angleRangeVertical = 110;
						groundNoiseDistanceCoef = -1;
						maxGroundNoiseDistance = -1;
						minSpeedThreshold = 0;
						maxSpeedThreshold = 0;
						aimDown = 35;
					};
					class DataLinkSensorComponent: SensorTemplateDataLink{};
					class PassiveRadarSensorComponent: SensorTemplatePassiveRadar{};
					class LaserSensorComponent: SensorTemplateLaser
					{
						angleRangeHorizontal = 360;
						angleRangeVertical = 120;
						aimDown = 30;
					};
					class NVSensorComponent: SensorTemplateNV
					{
						angleRangeHorizontal = 360;
						angleRangeVertical = 120;
						aimDown = 30;
					};
				};
			};
			class VehicleSystemsDisplayManagerComponentLeft: VehicleSystemsTemplateLeftPilot{};
			class VehicleSystemsDisplayManagerComponentRight: VehicleSystemsTemplateRightPilot{};
		};
	};
	class GOL_MELB_AH6M: GOL_MELB_base
	{
		editorPreview = "rhsusf\addons\rhsusf_editorPreviews\data\rhs_MELB_AH6M.paa";
		scope = 2;
		forceInGarage = 1;
		author = "$STR_RHSUSF_AUTHOR_FULL";
		dlc = "RHS_USAF";
		picture = "rhsusf\addons\rhsusf_melb\Data\ui\melb_ah_6m_ca.paa";
		icon = "rhsusf\addons\rhsusf_melb\Data\ui\map_melb_ah_6m_l_ca.paa";
		displayName = "AH-6M Little Bird (GOL)";

		// GOL-only Kimi HMD support
		#include "compat\kimi_useractions.hpp"
		#include "compat\kimi_melb_mfd.hpp"

		slingLoadMaxCargoMass = 0;
		fuelCapacity = 436;
		fuelConsumptionRate = 0.08;
		transportSoldier = 1;
		cargoProxyIndexes[] = {10};
		hideWeaponsCargo = 0;
		ejectDeadCargo = 1;
		cargoGetInAction[] = {"MELB_L_Rack_in"};
		cargoAction[] = {"MELB_L_Rack"};
		memoryPointsGetInCargo[] = {"pos rack"};
		memoryPointsGetInCargoDir[] = {"pos rack dir"};
		memoryPointsGetInCargoPrecise[] = {"pos rack"};
		usePreciseGetInAction = 1;
		availableForSupportTypes[] = {"CAS_Heli"};
		weapons[] = {"Laserdesignator_mounted","rhs_weap_MASTERSAFE","rhsusf_weap_LWIRCM"};
		magazines[] = {"Laserbatteries","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM","rhsusf_mag_LWIRCM"};
		threat[] = {0.6,0.4,0.1};
		cost = 1000000;
		class Turrets: Turrets
		{
			class CopilotTurret: CopilotTurret{};
		};
		class AnimationSources: AnimationSources
		{
			class Addcrosshair
			{
				source = "user";
				animPeriod = 1;
				initPhase = 1;
			};
			class Addgunrack
			{
				source = "user";
				animPeriod = 1;
				initPhase = 1;
			};
			class Addfueltank
			{
				source = "user";
				animPeriod = 1;
				initPhase = 1;
			};
			class ExtLongL
			{
				source = "user";
				animPeriod = 1e-05;
				initPhase = 1;
			};
			class ExtLongR
			{
				source = "user";
				animPeriod = 1e-05;
				initPhase = 1;
			};
		};
		class Attributes: Attributes
		{
			class GOL_MELB_TailNumber: GOL_MELB_TailNumber{};
			class GOL_MELB_SGDM: GOL_MELB_SGDM{};
			class GOL_MELB_SN_Nose: GOL_MELB_SN_Nose{};
			class GOL_MELB_clan: GOL_MELB_clan{};
			class GOL_MELB_ToggleBoy: GOL_MELB_ToggleBoy{};
		};
		class Components: Components
		{
			class TransportPylonsComponent
			{
				UIPicture = "\rhsusf\addons\rhsusf_melb\data\loadouts\RHS_AH6M_EDEN_CA.paa";
				class pylons
				{
					class pylon1
					{
						hardpoints[] = {"RHS_HP_MELB","RHS_HP_MELB_L", "RHS_HP_FFAR_USMC"};
						priority = 2;
						attachment = "rhs_mag_M151_7";
						maxweight = 1200;
						UIposition[] = {0.625,0.2};
						bay = -1;
						turret[] = {};
						hitpoint = "HitPylon1";
					};
					class pylon2: pylon1
					{
						hardpoints[] = {"RHS_HP_MELB_M134","RHS_HP_MELB", "RHS_HP_FFAR_USMC"};
						UIposition[] = {0.562,0.3};
						priority = 1;
						attachment = "rhs_mag_m134_pylon_3000";
						turret[] = {};
						hitpoint = "HitPylon2";
					};
					class pylon3: pylon2
					{
						UIposition[] = {0.103,0.3};
						mirroredMissilePos = 2;
						ace_pylons_mirroredMissilePos = 2;
						attachment = "rhs_mag_m134_pylon_3000";
						turret[] = {};
						hitpoint = "HitPylon3";
					};
					class pylon4: pylon1
					{
						hardpoints[] = {"RHS_HP_MELB","RHS_HP_MELB_R", "RHS_HP_FFAR_USMC"};
						UIposition[] = {0.04,0.2};
						mirroredMissilePos = 1;
						ace_pylons_mirroredMissilePos = 1;
						turret[] = {};
						hitpoint = "HitPylon4";
					};
				};
				class Presets
				{
					class Light
					{
						attachment[] = {"rhs_mag_M151_7","rhs_mag_m134_pylon_3000","rhs_mag_m134_pylon_3000","rhs_mag_M151_7"};
						displayname = "Light";
					};
					class Medium
					{
						attachment[] = {"rhsusf_mag_gau19_melb_left","","","rhs_mag_M151_19"};
						displayname = "Medium";
					};
					class Heavy
					{
						attachment[] = {"rhsusf_mag_gau19_melb_left","","","rhs_mag_AGM114K_2"};
						displayname = "Heavy";
					};
				};
			};
		};
	};
};
class cfgMods
{
	author = "Vasquez - Edited by GOL";
	timepacked = "1649438714";
};
