// ============================================================
// GOL Helicopter Targeting Pod (TGP) Variants
//
// Ports the UH-80 Ghost Hawk TGP solution (originally by
// Ampersand) into GOL Misc under the GOL_ namespace.
//
// All aircraft gain a stabilised pilot camera with three FOV
// levels (WFOV 30° / MFOV 6° / NFOV 2°), Normal/NVG/Thermal
// vision modes, and an integrated laser designator.
//
// Primary:   UH-80 Ghost Hawk (Stub Wings) and (Plain)
// Secondary: AH-9 Pawnee, PO-30 Orca, WY-55 Hellcat
//
// NOTE: This file is included inside class CfgVehicles {} in
//       CfgVehicles.cpp. Do NOT wrap content in CfgVehicles.
// ============================================================

// --- Forward declarations (inheritance chains) ---
class Helicopter_Base_H;
class Heli_Transport_01_base_F : Helicopter_Base_H {
	class MFD;
};
class Heli_Transport_01_pylons_base_F : Heli_Transport_01_base_F {
	class MFD : MFD {
		class AirplaneHUD;
	};
};
class B_Heli_Transport_01_F;
class B_Heli_Light_01_dynamicLoadout_F;
class Heli_Light_02_base_F;
class Heli_Light_02_dynamicLoadout_base_F : Heli_Light_02_base_F {
	class MFD;
};
class O_Heli_Light_02_dynamicLoadout_F : Heli_Light_02_dynamicLoadout_base_F {
	class MFD : MFD {
		class AirplaneHUD;
	};
};
class Heli_Light_03_base_F;
class Heli_Light_03_dynamicLoadout_base_F : Heli_Light_03_base_F {
	class MFD;
};
class I_Heli_Light_03_dynamicLoadout_F : Heli_Light_03_dynamicLoadout_base_F {
	class MFD : MFD {
		class AirplaneHUD;
		class MFD_Pilot_10;
	};
};

// ============================================================
// UH-80 Ghost Hawk (Stub Wings) — Internal Base Class
// Holds all TGP configuration; the editor variant below
// derives from this and adds faction/crew/scope.
// ============================================================
class GOL_Heli_Transport_01_pylons_laser_base : Heli_Transport_01_pylons_base_F {
	author = "GOL";
	displayName = "UH-80 Ghost Hawk (Stub Wings, Laser)";
	laserScanner = 1;
	showAllTargets = 4;
	LODDriverOpticsIn = 1000;
	editorPreview = "\A3\EditorPreviews_F\Data\CfgVehicles\B_Heli_Transport_01_pylons_F.jpg";
	availableForSupportTypes[] = {"Drop", "Transport"};

	class SimpleObject {
		eden = 1;
		animate[] = {
			{"rotor_destructx", 0}, {"rotor_destructy", 0},
			{"mala_vrtule_destructy", 0}, {"mala_vrtule_destructz", 0},
			{"damagehide", 0}, {"hrotor", 0}, {"vrotor", 0},
			{"lever_pilot", 0}, {"lever_copilot", 0},
			{"rotorimpacthide", 0}, {"tailrotorimpacthide", 0},
			{"i_compass_pilot", 0}, {"i_compass_copilot", 0}, {"i_compass_middle", 0},
			{"display_on", 0}, {"radar_on", 0}, {"radar2_on", 0},
			{"i_altitude_100f", 7.14}, {"i_speed", 0}, {"i_speed_02", 0}, {"i_speed_03", 0},
			{"i_speed02", 0}, {"i_speed02_02", 0}, {"i_speed02_03", 0},
			{"i_vspeed", 0}, {"i_vspeed_02", 0}, {"i_vspeed_03", 0},
			{"i_vspeed02", 0}, {"i_vspeed02_02", 0}, {"i_vspeed02_03", 0},
			{"i_altitude02_100f", 7.14},
			{"dg_pitch", 0}, {"dg_bank", 0}, {"dg_pitch2", 0}, {"dg_bank2", 0},
			{"dg_vertspeed", 0}, {"dg_vertspeed2", 0},
			{"i_rpm", 0}, {"i_rpm02", 0}, {"i_rpm03", 0}, {"i_rpm04", 0},
			{"i_torque01", 0}, {"i_torque02", 0}, {"i_torque03", 0}, {"i_torque04", 0},
			{"i_torque01_base", 0}, {"i_torque02_base", 0}, {"i_torque03_base", 0}, {"i_torque04_base", 0},
			{"i_fuel", 1}, {"i_fuel_02", 1}, {"i_fuel_03", 1}, {"i_fuel_04", 1},
			{"radar", 92.47}, {"radar2", 92.47},
			{"positionlights", 0}, {"collisionlight_red_blinking", 0}, {"collisionlight_white_blinking", 0},
			{"wheel_rear_damper", 0}, {"wheel_left_damper", 0}, {"wheel_right_damper", 0},
			{"reargear", 0}, {"rearrightcover", 0}, {"rearleftcover", 0},
			{"rightgear", 0}, {"leftgear", 0}, {"rightgear_hide", 0}, {"leftgear_hide", 0},
			{"wheel_1_1", 0}, {"wheel_1_2", 0}, {"wheel_2_1", 0},
			{"door_l", 0}, {"door_back_l_lock", 0}, {"door_r", 0}, {"door_back_r_lock", 0},
			{"holdster", 1},
			{"stick_pilot_dive_01", 0}, {"stick_pilot_dive_02", 0}, {"stick_pilot_dive_03", 0},
			{"stick_pilot_dive_04", 0}, {"stick_pilot_dive_05", 0},
			{"stick_pilot_bank_01", 0}, {"stick_pilot_bank_02", 0}, {"stick_pilot_bank_03", 0},
			{"stick_pilot_bank_04", 0}, {"stick_pilot_bank_05", 0},
			{"stick_copilot_dive01", 0}, {"stick_copilot_dive02", 0}, {"stick_copilot_dive03", 0},
			{"stick_copilot_dive04", 0}, {"stick_copilot_dive05", 0},
			{"stick_copilot_bank01", 0}, {"stick_copilot_bank02", 0}, {"stick_copilot_bank03", 0},
			{"stick_copilot_bank04", 0}, {"stick_copilot_bank05", 0},
			{"mainturret", 1.57}, {"maingun", -0.26},
			{"mainturret2", -1.57}, {"maingun2", -0.26},
			{"minigun", 0.33}, {"minigun2", 0.33}
		};
		hide[] = {
			"clan", "zasleh", "zasleh_1",
			"light_l", "light_r",
			"tail rotor blur", "main rotor blur",
			"zadni svetlo", "podsvit pristroju", "poskozeni"
		};
		verticalOffset = 2.192;
		verticalOffsetWorld = 0.053;
		postinit = "[this, '', []] call bis_fnc_initVehicle";
	};

	class MFD : MFD {
		class AirplaneHUD : AirplaneHUD {};

		// Helmet-mounted TGP reticle — shows camera direction as a circle
		class GOL_TGP_HMD {
			enableParallax = 0;
			topLeft = "HUD_top_left";
			topRight = "HUD_top_right";
			bottomLeft = "HUD_bottom_left";
			borderLeft = 0;
			borderRight = 0;
			borderTop = 0;
			borderBottom = 0;
			color[] = {1, 1, 1, 1};
			helmetMountedDisplay = 1;
			helmetPosition[] = {-0.0325, 0.0325, 0.1};
			helmetRight[] = {0.065, 0, 0};
			helmetDown[] = {0, -0.065, 0};
			class Pos10Vector {
				type = "vector";
				pos0[] = {0.5, 0.5};
				pos10[] = {1.225, 1.1};
			};
			class Bones {
				class TargetingPodDir {
					source = "pilotcameratoview";
					type = "vector";
					pos0[] = {0.5, 0.5};
					pos10[] = {0.774, 0.77};
				};
			};
			class Draw {
				// user3/4/5 = Kimi HMD color (R/G/B); ties the TGP reticle color to the
				// pilot's chosen Kimi display color.  alpha="on" avoids user3 conflict
				// (Kimi uses user3 as R-channel, not as an alpha/visibility toggle).
				alpha = "on";
				color[] = {"user3", "user4", "user5"};
				condition = "on";
				class TargetingPodGroup {
					class TargetingPodDir {
						type = "line";
						width = 3;
						points[] = {
							{"TargetingPodDir", 1, {0.0208056,  0.00407807}, 1},
							{"TargetingPodDir", 1, {0.0208056, -0.00407807}, 1}, {},
							{"TargetingPodDir", 1, {0.0176381, -0.0116134},  1},
							{"TargetingPodDir", 1, {0.0117854, -0.0173806},  1}, {},
							{"TargetingPodDir", 1, {0.00413849,-0.0205019},  1},
							{"TargetingPodDir", 1, {-0.00413849,-0.0205019}, 1}, {},
							{"TargetingPodDir", 1, {-0.0117854,-0.0173806},  1},
							{"TargetingPodDir", 1, {-0.0176381,-0.0116134},  1}, {},
							{"TargetingPodDir", 1, {-0.0208056,-0.00407807}, 1},
							{"TargetingPodDir", 1, {-0.0208056, 0.00407808}, 1}, {},
							{"TargetingPodDir", 1, {-0.0176381, 0.0116134},  1},
							{"TargetingPodDir", 1, {-0.0117854, 0.0173806},  1}, {},
							{"TargetingPodDir", 1, {-0.00413849,0.0205019},  1},
							{"TargetingPodDir", 1, { 0.00413849,0.0205019},  1}, {},
							{"TargetingPodDir", 1, {0.0117854,  0.0173806},  1},
							{"TargetingPodDir", 1, {0.0176381,  0.0116134},  1}, {},
							{"TargetingPodDir", 1, {0.0208056,  0.00407807}, 1},
							{"TargetingPodDir", 1, {0.0208056, -0.00407808}, 1}, {},
							{"TargetingPodDir", 1, {0.0176381, -0.0116134},  1},
							{"TargetingPodDir", 1, {0.0117854, -0.0173807},  1}, {},
							{"TargetingPodDir", 1, {0.00413849,-0.0205019},  1},
							{"TargetingPodDir", 1, {-0.0041385,-0.0205019},  1}, {},
							{"TargetingPodDir", 1, {-0.0117854,-0.0173806},  1},
							{"TargetingPodDir", 1, {-0.0176381,-0.0116134},  1}, {}
						};
					};
				};
			};
		};
	};

	memoryPointDriverOptics = "light_l";
	driverWeaponsInfoType = "RscOptics_CAS_01_TGP";
	magazines[] += {"Laserbatteries"};
	weapons[] += {"Laserdesignator_pilotCamera"};

	class pilotCamera {
		class OpticsIn {
			class Wide {
				opticsDisplayName = "WFOV";
				initAngleX = 0; minAngleX = 0; maxAngleX = 0;
				initAngleY = 0; minAngleY = 0; maxAngleY = 0;
				initFov = (30 / 120);
				minFov  = (30 / 120);
				maxFov  = (30 / 120);
				directionStabilized = 1;
				visionMode[] = {"Normal", "NVG", "Ti"};
				thermalMode[] = {0, 1};
				gunnerOpticsModel = "\A3\Drones_F\Weapons_F_Gamma\Reticle\UAV_Optics_Gunner_wide_F.p3d";
			};
			class Medium {
				opticsDisplayName = "MFOV";
				initAngleX = 0; minAngleX = 0; maxAngleX = 0;
				initAngleY = 0; minAngleY = 0; maxAngleY = 0;
				initFov = (6 / 120);
				minFov  = (6 / 120);
				maxFov  = (6 / 120);
				directionStabilized = 1;
				visionMode[] = {"Normal", "NVG", "Ti"};
				thermalMode[] = {0, 1};
				gunnerOpticsModel = "\A3\Drones_F\Weapons_F_Gamma\Reticle\UAV_Optics_Gunner_medium_F.p3d";
			};
			class Narrow {
				opticsDisplayName = "NFOV";
				initAngleX = 0; minAngleX = 0; maxAngleX = 0;
				initAngleY = 0; minAngleY = 0; maxAngleY = 0;
				initFov = (2 / 120);
				minFov  = (2 / 120);
				maxFov  = (2 / 120);
				directionStabilized = 1;
				visionMode[] = {"Normal", "NVG", "Ti"};
				thermalMode[] = {0, 1};
				gunnerOpticsModel = "\A3\Drones_F\Weapons_F_Gamma\Reticle\UAV_Optics_Gunner_narrow_F.p3d";
			};
		};
		minTurn = -360;
		maxTurn = 360;
		initTurn = 0;
		minElev = -90;
		maxElev = 60;
		initElev = 0;
		maxXRotSpeed = 1;
		maxYRotSpeed = 1;
		maxMouseXRotSpeed = 0.5;
		maxMouseYRotSpeed = 0.5;
		pilotOpticsShowCursor = 1;
		controllable = 1;
	};
};

// ============================================================
// UH-80 Ghost Hawk (Stub Wings, Laser) — Editor Variant
// ============================================================
class GOL_Heli_Transport_01_pylons_laser : GOL_Heli_Transport_01_pylons_laser_base {
	scope = 2;
	scopeCurator = 2;
	displayName = "UH-80 Ghost Hawk (Stub Wings, Laser)";
	_generalMacro = "GOL_Heli_Transport_01_pylons_laser";
	forceInGarage = 1;
	side = 1;
	faction = "BLU_F";
	crew = "B_Helipilot_F";
	typicalCargo[] = {"B_Helipilot_F"};
};

// ============================================================
// UH-80 Ghost Hawk (Plain, Laser)
// Uses the nose optic point (light_l_end) instead of the
// stub-wing light point.
// ============================================================
class GOL_Heli_Transport_01_laser : B_Heli_Transport_01_F {
	scope = 2;
	scopeCurator = 2;
	author = "GOL";
	displayName = "UH-80 Ghost Hawk (Laser)";
	_generalMacro = "GOL_Heli_Transport_01_laser";
	forceInGarage = 1;

	memoryPointDriverOptics = "light_l_end";
	driverWeaponsInfoType = "RscOptics_CAS_01_TGP";
	magazines[] += {"Laserbatteries"};
	weapons[] += {"Laserdesignator_pilotCamera"};

	class pilotCamera {
		class OpticsIn {
			class Wide {
				opticsDisplayName = "WFOV";
				initAngleX = 0; minAngleX = 0; maxAngleX = 0;
				initAngleY = 0; minAngleY = 0; maxAngleY = 0;
				initFov = (30 / 120);
				minFov  = (30 / 120);
				maxFov  = (30 / 120);
				directionStabilized = 1;
				visionMode[] = {"Normal", "NVG", "Ti"};
				thermalMode[] = {0, 1};
				gunnerOpticsModel = "\A3\Drones_F\Weapons_F_Gamma\Reticle\UAV_Optics_Gunner_wide_F.p3d";
			};
			class Medium {
				opticsDisplayName = "MFOV";
				initAngleX = 0; minAngleX = 0; maxAngleX = 0;
				initAngleY = 0; minAngleY = 0; maxAngleY = 0;
				initFov = (6 / 120);
				minFov  = (6 / 120);
				maxFov  = (6 / 120);
				directionStabilized = 1;
				visionMode[] = {"Normal", "NVG", "Ti"};
				thermalMode[] = {0, 1};
				gunnerOpticsModel = "\A3\Drones_F\Weapons_F_Gamma\Reticle\UAV_Optics_Gunner_medium_F.p3d";
			};
			class Narrow {
				opticsDisplayName = "NFOV";
				initAngleX = 0; minAngleX = 0; maxAngleX = 0;
				initAngleY = 0; minAngleY = 0; maxAngleY = 0;
				initFov = (2 / 120);
				minFov  = (2 / 120);
				maxFov  = (2 / 120);
				directionStabilized = 1;
				visionMode[] = {"Normal", "NVG", "Ti"};
				thermalMode[] = {0, 1};
				gunnerOpticsModel = "\A3\Drones_F\Weapons_F_Gamma\Reticle\UAV_Optics_Gunner_narrow_F.p3d";
			};
		};
		minTurn = -360;
		maxTurn = 360;
		initTurn = 0;
		minElev = -90;
		maxElev = 60;
		initElev = 0;
		maxXRotSpeed = 1;
		maxYRotSpeed = 1;
		maxMouseXRotSpeed = 0.5;
		maxMouseYRotSpeed = 0.5;
		pilotOpticsShowCursor = 1;
		controllable = 1;
	};
};

// ============================================================
// AH-9 Pawnee (Laser)  — NATO Light Attack
// memoryPointDriverOptics = "light_pos"
// ============================================================
class GOL_Heli_Light_01_dynamicLoadout_laser : B_Heli_Light_01_dynamicLoadout_F {
	scope = 2;
	scopeCurator = 2;
	author = "GOL";
	displayName = "AH-9 Pawnee (Laser)";
	_generalMacro = "GOL_Heli_Light_01_dynamicLoadout_laser";
	forceInGarage = 1;

	memoryPointDriverOptics = "light_pos";
	driverWeaponsInfoType = "RscOptics_CAS_01_TGP";
	magazines[] += {"Laserbatteries"};
	weapons[] += {"Laserdesignator_pilotCamera"};

	class pilotCamera {
		class OpticsIn {
			class Wide {
				opticsDisplayName = "WFOV";
				initAngleX = 0; minAngleX = 0; maxAngleX = 0;
				initAngleY = 0; minAngleY = 0; maxAngleY = 0;
				initFov = (30 / 120);
				minFov  = (30 / 120);
				maxFov  = (30 / 120);
				directionStabilized = 1;
				visionMode[] = {"Normal", "NVG", "Ti"};
				thermalMode[] = {0, 1};
				gunnerOpticsModel = "\A3\Drones_F\Weapons_F_Gamma\Reticle\UAV_Optics_Gunner_wide_F.p3d";
			};
			class Medium {
				opticsDisplayName = "MFOV";
				initAngleX = 0; minAngleX = 0; maxAngleX = 0;
				initAngleY = 0; minAngleY = 0; maxAngleY = 0;
				initFov = (6 / 120);
				minFov  = (6 / 120);
				maxFov  = (6 / 120);
				directionStabilized = 1;
				visionMode[] = {"Normal", "NVG", "Ti"};
				thermalMode[] = {0, 1};
				gunnerOpticsModel = "\A3\Drones_F\Weapons_F_Gamma\Reticle\UAV_Optics_Gunner_medium_F.p3d";
			};
			class Narrow {
				opticsDisplayName = "NFOV";
				initAngleX = 0; minAngleX = 0; maxAngleX = 0;
				initAngleY = 0; minAngleY = 0; maxAngleY = 0;
				initFov = (2 / 120);
				minFov  = (2 / 120);
				maxFov  = (2 / 120);
				directionStabilized = 1;
				visionMode[] = {"Normal", "NVG", "Ti"};
				thermalMode[] = {0, 1};
				gunnerOpticsModel = "\A3\Drones_F\Weapons_F_Gamma\Reticle\UAV_Optics_Gunner_narrow_F.p3d";
			};
		};
		minTurn = -360;
		maxTurn = 360;
		initTurn = 0;
		minElev = -90;
		maxElev = 60;
		initElev = 0;
		maxXRotSpeed = 1;
		maxYRotSpeed = 1;
		maxMouseXRotSpeed = 0.5;
		maxMouseYRotSpeed = 0.5;
		pilotOpticsShowCursor = 1;
		controllable = 1;
	};
};

// ============================================================
// PO-30 Orca (Laser)  — OPFOR Light Attack
// memoryPointDriverOptics = "light_r_pos"
// Includes TGP HMD reticle in MFD.
// ============================================================
class GOL_Heli_Light_02_dynamicLoadout_laser : O_Heli_Light_02_dynamicLoadout_F {
	scope = 2;
	scopeCurator = 2;
	author = "GOL";
	displayName = "PO-30 Orca (Laser)";
	_generalMacro = "GOL_Heli_Light_02_dynamicLoadout_laser";
	forceInGarage = 1;

	memoryPointDriverOptics = "light_r_pos";
	driverWeaponsInfoType = "RscOptics_CAS_01_TGP";
	magazines[] += {"Laserbatteries"};
	weapons[] += {"Laserdesignator_pilotCamera"};

	class MFD : MFD {
		class AirplaneHUD : AirplaneHUD {};
		class GOL_TGP_HMD {
			enableParallax = 0;
			topLeft = "HUD_top_left";
			topRight = "HUD_top_right";
			bottomLeft = "HUD_bottom_left";
			borderLeft = 0;
			borderRight = 0;
			borderTop = 0;
			borderBottom = 0;
			color[] = {1, 1, 1, 1};
			helmetMountedDisplay = 1;
			helmetPosition[] = {-0.0325, 0.0325, 0.1};
			helmetRight[] = {0.065, 0, 0};
			helmetDown[] = {0, -0.065, 0};
			class Pos10Vector {
				type = "vector";
				pos0[] = {0.5, 0.5};
				pos10[] = {1.225, 1.1};
			};
			class Bones {
				class TargetingPodDir {
					source = "pilotcameratoview";
					type = "vector";
					pos0[] = {0.5, 0.5};
					pos10[] = {0.774, 0.77};
				};
			};
			class Draw {
				alpha = "user3";
				color[] = {"user0", "user1", "user2"};
				condition = "on";
				class TargetingPodGroup {
					class TargetingPodDir {
						type = "line";
						width = 3;
						points[] = {
							{"TargetingPodDir", 1, {0.0208056,  0.00407807}, 1},
							{"TargetingPodDir", 1, {0.0208056, -0.00407807}, 1}, {},
							{"TargetingPodDir", 1, {0.0176381, -0.0116134},  1},
							{"TargetingPodDir", 1, {0.0117854, -0.0173806},  1}, {},
							{"TargetingPodDir", 1, {0.00413849,-0.0205019},  1},
							{"TargetingPodDir", 1, {-0.00413849,-0.0205019}, 1}, {},
							{"TargetingPodDir", 1, {-0.0117854,-0.0173806},  1},
							{"TargetingPodDir", 1, {-0.0176381,-0.0116134},  1}, {},
							{"TargetingPodDir", 1, {-0.0208056,-0.00407807}, 1},
							{"TargetingPodDir", 1, {-0.0208056, 0.00407808}, 1}, {},
							{"TargetingPodDir", 1, {-0.0176381, 0.0116134},  1},
							{"TargetingPodDir", 1, {-0.0117854, 0.0173806},  1}, {},
							{"TargetingPodDir", 1, {-0.00413849,0.0205019},  1},
							{"TargetingPodDir", 1, { 0.00413849,0.0205019},  1}, {},
							{"TargetingPodDir", 1, {0.0117854,  0.0173806},  1},
							{"TargetingPodDir", 1, {0.0176381,  0.0116134},  1}, {},
							{"TargetingPodDir", 1, {0.0208056,  0.00407807}, 1},
							{"TargetingPodDir", 1, {0.0208056, -0.00407808}, 1}, {},
							{"TargetingPodDir", 1, {0.0176381, -0.0116134},  1},
							{"TargetingPodDir", 1, {0.0117854, -0.0173807},  1}, {},
							{"TargetingPodDir", 1, {0.00413849,-0.0205019},  1},
							{"TargetingPodDir", 1, {-0.0041385,-0.0205019},  1}, {},
							{"TargetingPodDir", 1, {-0.0117854,-0.0173806},  1},
							{"TargetingPodDir", 1, {-0.0176381,-0.0116134},  1}, {}
						};
					};
				};
			};
		};
	};

	class pilotCamera {
		class OpticsIn {
			class Wide {
				opticsDisplayName = "WFOV";
				initAngleX = 0; minAngleX = 0; maxAngleX = 0;
				initAngleY = 0; minAngleY = 0; maxAngleY = 0;
				initFov = (30 / 120);
				minFov  = (30 / 120);
				maxFov  = (30 / 120);
				directionStabilized = 1;
				visionMode[] = {"Normal", "NVG", "Ti"};
				thermalMode[] = {0, 1};
				gunnerOpticsModel = "\A3\Drones_F\Weapons_F_Gamma\Reticle\UAV_Optics_Gunner_wide_F.p3d";
			};
			class Medium {
				opticsDisplayName = "MFOV";
				initAngleX = 0; minAngleX = 0; maxAngleX = 0;
				initAngleY = 0; minAngleY = 0; maxAngleY = 0;
				initFov = (6 / 120);
				minFov  = (6 / 120);
				maxFov  = (6 / 120);
				directionStabilized = 1;
				visionMode[] = {"Normal", "NVG", "Ti"};
				thermalMode[] = {0, 1};
				gunnerOpticsModel = "\A3\Drones_F\Weapons_F_Gamma\Reticle\UAV_Optics_Gunner_medium_F.p3d";
			};
			class Narrow {
				opticsDisplayName = "NFOV";
				initAngleX = 0; minAngleX = 0; maxAngleX = 0;
				initAngleY = 0; minAngleY = 0; maxAngleY = 0;
				initFov = (2 / 120);
				minFov  = (2 / 120);
				maxFov  = (2 / 120);
				directionStabilized = 1;
				visionMode[] = {"Normal", "NVG", "Ti"};
				thermalMode[] = {0, 1};
				gunnerOpticsModel = "\A3\Drones_F\Weapons_F_Gamma\Reticle\UAV_Optics_Gunner_narrow_F.p3d";
			};
		};
		minTurn = -360;
		maxTurn = 360;
		initTurn = 0;
		minElev = -90;
		maxElev = 60;
		initElev = 0;
		maxXRotSpeed = 1;
		maxYRotSpeed = 1;
		maxMouseXRotSpeed = 0.5;
		maxMouseYRotSpeed = 0.5;
		pilotOpticsShowCursor = 1;
		controllable = 1;
	};
};

// ============================================================
// WY-55 Hellcat (Laser)  — INDFOR Light Attack
// memoryPointDriverOptics = "laserstart"
// Includes TGP HMD reticle in MFD.
// ============================================================
class GOL_Heli_Light_03_dynamicLoadout_laser : I_Heli_Light_03_dynamicLoadout_F {
	scope = 2;
	scopeCurator = 2;
	author = "GOL";
	displayName = "WY-55 Hellcat (Laser)";
	_generalMacro = "GOL_Heli_Light_03_dynamicLoadout_laser";
	forceInGarage = 1;

	memoryPointDriverOptics = "laserstart";
	driverWeaponsInfoType = "RscOptics_CAS_01_TGP";
	magazines[] += {"Laserbatteries"};
	weapons[] += {"Laserdesignator_pilotCamera"};

	class MFD : MFD {
		class AirplaneHUD : AirplaneHUD {};
		class MFD_Pilot_10 : MFD_Pilot_10 {};
		class GOL_TGP_HMD {
			enableParallax = 0;
			topLeft = "HUD_top_left";
			topRight = "HUD_top_right";
			bottomLeft = "HUD_bottom_left";
			borderLeft = 0;
			borderRight = 0;
			borderTop = 0;
			borderBottom = 0;
			color[] = {1, 1, 1, 1};
			helmetMountedDisplay = 1;
			helmetPosition[] = {-0.0325, 0.0325, 0.1};
			helmetRight[] = {0.065, 0, 0};
			helmetDown[] = {0, -0.065, 0};
			class Pos10Vector {
				type = "vector";
				pos0[] = {0.5, 0.5};
				pos10[] = {1.225, 1.1};
			};
			class Bones {
				class TargetingPodDir {
					source = "pilotcameratoview";
					type = "vector";
					pos0[] = {0.5, 0.5};
					pos10[] = {0.774, 0.77};
				};
			};
			class Draw {
				alpha = "user3";
				color[] = {"user0", "user1", "user2"};
				condition = "on";
				class TargetingPodGroup {
					class TargetingPodDir {
						type = "line";
						width = 3;
						points[] = {
							{"TargetingPodDir", 1, {0.0208056,  0.00407807}, 1},
							{"TargetingPodDir", 1, {0.0208056, -0.00407807}, 1}, {},
							{"TargetingPodDir", 1, {0.0176381, -0.0116134},  1},
							{"TargetingPodDir", 1, {0.0117854, -0.0173806},  1}, {},
							{"TargetingPodDir", 1, {0.00413849,-0.0205019},  1},
							{"TargetingPodDir", 1, {-0.00413849,-0.0205019}, 1}, {},
							{"TargetingPodDir", 1, {-0.0117854,-0.0173806},  1},
							{"TargetingPodDir", 1, {-0.0176381,-0.0116134},  1}, {},
							{"TargetingPodDir", 1, {-0.0208056,-0.00407807}, 1},
							{"TargetingPodDir", 1, {-0.0208056, 0.00407808}, 1}, {},
							{"TargetingPodDir", 1, {-0.0176381, 0.0116134},  1},
							{"TargetingPodDir", 1, {-0.0117854, 0.0173806},  1}, {},
							{"TargetingPodDir", 1, {-0.00413849,0.0205019},  1},
							{"TargetingPodDir", 1, { 0.00413849,0.0205019},  1}, {},
							{"TargetingPodDir", 1, {0.0117854,  0.0173806},  1},
							{"TargetingPodDir", 1, {0.0176381,  0.0116134},  1}, {},
							{"TargetingPodDir", 1, {0.0208056,  0.00407807}, 1},
							{"TargetingPodDir", 1, {0.0208056, -0.00407808}, 1}, {},
							{"TargetingPodDir", 1, {0.0176381, -0.0116134},  1},
							{"TargetingPodDir", 1, {0.0117854, -0.0173807},  1}, {},
							{"TargetingPodDir", 1, {0.00413849,-0.0205019},  1},
							{"TargetingPodDir", 1, {-0.0041385,-0.0205019},  1}, {},
							{"TargetingPodDir", 1, {-0.0117854,-0.0173806},  1},
							{"TargetingPodDir", 1, {-0.0176381,-0.0116134},  1}, {}
						};
					};
				};
			};
		};
	};

	class pilotCamera {
		class OpticsIn {
			class Wide {
				opticsDisplayName = "WFOV";
				initAngleX = 0; minAngleX = 0; maxAngleX = 0;
				initAngleY = 0; minAngleY = 0; maxAngleY = 0;
				initFov = (30 / 120);
				minFov  = (30 / 120);
				maxFov  = (30 / 120);
				directionStabilized = 1;
				visionMode[] = {"Normal", "NVG", "Ti"};
				thermalMode[] = {0, 1};
				gunnerOpticsModel = "\A3\Drones_F\Weapons_F_Gamma\Reticle\UAV_Optics_Gunner_wide_F.p3d";
			};
			class Medium {
				opticsDisplayName = "MFOV";
				initAngleX = 0; minAngleX = 0; maxAngleX = 0;
				initAngleY = 0; minAngleY = 0; maxAngleY = 0;
				initFov = (6 / 120);
				minFov  = (6 / 120);
				maxFov  = (6 / 120);
				directionStabilized = 1;
				visionMode[] = {"Normal", "NVG", "Ti"};
				thermalMode[] = {0, 1};
				gunnerOpticsModel = "\A3\Drones_F\Weapons_F_Gamma\Reticle\UAV_Optics_Gunner_medium_F.p3d";
			};
			class Narrow {
				opticsDisplayName = "NFOV";
				initAngleX = 0; minAngleX = 0; maxAngleX = 0;
				initAngleY = 0; minAngleY = 0; maxAngleY = 0;
				initFov = (2 / 120);
				minFov  = (2 / 120);
				maxFov  = (2 / 120);
				directionStabilized = 1;
				visionMode[] = {"Normal", "NVG", "Ti"};
				thermalMode[] = {0, 1};
				gunnerOpticsModel = "\A3\Drones_F\Weapons_F_Gamma\Reticle\UAV_Optics_Gunner_narrow_F.p3d";
			};
		};
		minTurn = -360;
		maxTurn = 360;
		initTurn = 0;
		minElev = -90;
		maxElev = 60;
		initElev = 0;
		maxXRotSpeed = 1;
		maxYRotSpeed = 1;
		maxMouseXRotSpeed = 0.5;
		maxMouseYRotSpeed = 0.5;
		pilotOpticsShowCursor = 1;
		controllable = 1;
	};
};
