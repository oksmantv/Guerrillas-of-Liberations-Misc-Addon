			class Kimi_HMD_HAD_Common
			{
				topLeft = "HUD_top_left";
				topRight = "HUD_top_right";
				bottomLeft = "HUD_bottom_left";
				borderLeft = 0;
				borderRight = 0;
				borderTop = 0;
				borderBottom = 0;
				color[] = {0.212,0.769,0.204,0.2};
				enableParallax = 0;
				helmetMountedDisplay = 1;
				helmetPosition[] = {-0.04,0.04,0.1};
				helmetRight[] = {0.08,0,0};
				helmetDown[] = {0,-0.08,0};
				class Bones
				{
					class PlaneOrientation
					{
						type = "fixed";
						pos[] = {0.5,0.5};
					};
					class Limit0109
					{
						type = "limit";
						limits[] = {0.1,0.1,0.9,0.9};
					};
					class ForwardVec
					{
						type = "vector";
						source = "forward";
						pos0[] = {0,0};
						pos10[] = {0.216,0.216};
					};
					class ForwardVec_Center
					{
						type = "vector";
						source = "forward";
						pos0[] = {0.5,0.5};
						pos10[] = {"0.500 + 0.2165","0.500 + 0.2165"};
					};
					class ForwardVecPNVS
					{
						type = "vector";
						source = "forward";
						pos0[] = {0,0};
						pos10[] = {-0.055,-0.055};
					};
					class VspeedBone
					{
						type = "linear";
						source = "vspeed";
						sourceScale = 1.9685;
						min = -20;
						max = 20;
						minPos[] = {0.93,0.2};
						maxPos[] = {0.93,0.8};
					};
					class RadarAltitudeBone
					{
						type = "linear";
						source = "altitudeAGL";
						sourceOffset = -6;
						sourceScale = 3.28084;
						min = 0;
						max = 200;
						minPos[] = {0.965,0.2};
						maxPos[] = {0.965,0.8};
					};
					class WYPT_Tape_Bone
					{
						type = "vector";
						source = "wppoint";
						pos0[] = {0.5,0.128};
						pos10[] = {"0.500 + 0.037",0.128};
					};
					class Tape_Limit
					{
						type = "limit";
						limits[] = {0.2,0,0.8,1};
					};
					class Turret_Tape_Bone
					{
						type = "vector";
						source = "Turret";
						pos0[] = {0.5,0.128};
						pos10[] = {"0.500 + 0.037",0.128};
						projection = 1;
					};
					class GunnerAim
					{
						type = "vector";
						source = "turret";
						pos0[] = {0,-2};
						pos10[] = {0.00717,-0.01};
						projection = 0;
					};
					class Gunner_HAD_Limit
					{
						type = "limit";
						limits[] = {0.4,0.86,0.6,0.94};
					};
					class Slip_Ball_X
					{
						type = "vector";
						source = "velocity";
						pos0[] = {0.5,0.843};
						pos10[] = {0.515,0.843};
					};
					class GforceX_Slip
					{
						type = "linear";
						source = "gmeterX";
						sourceScale = 1;
						max = 0.15;
						min = -0.15;
						minPos[] = {"0.5+0.1","0.9-0.04-0.02"};
						maxPos[] = {"0.5-0.1","0.9-0.04-0.02"};
					};
					class WeaponAim: ForwardVec_Center
					{
						source = "weapon";
					};
					class TurretAimToView
					{
						type = "vector";
						source = "weapontoview";
						pos0[] = {0.5,0.5};
						pos10[] = {"0.500 + 0.2165","0.500 + 0.2165"};
					};
					class CCIP: ForwardVec_Center
					{
						source = "impactpoint";
					};
					class CCIP_2_VIEW: CCIP
					{
						source = "impactpointtoview";
					};
					class RocketAim: ForwardVec_Center
					{
						source = "weapon";
					};
					class Target: ForwardVec_Center
					{
						source = "target";
					};
					class Target2View: Target
					{
						source = "targetToView";
					};
					class WYPT_2_VIEW: ForwardVec_Center
					{
						source = "wppointtoview";
					};
					class Velocity: ForwardVec_Center
					{
						source = "velocityToView";
					};
					class HorizonBankRot
					{
						type = "rotational";
						source = "horizonBank";
						center[] = {0.5,0.5};
						min = -3.1416;
						max = 3.1416;
						minAngle = -180;
						maxAngle = 180;
						aspectRatio = 1;
					};
					class Speed_X_Hover_P
					{
						type = "vector";
						source = "velocity";
						pos0[] = {0,0};
						pos10[] = {0.02,0};
					};
					class Speed_X_Hover_N
					{
						type = "vector";
						source = "velocityToView";
						sourcescale = "1";
						pos0[] = {0,0};
						pos10[] = {0.02,0.02};
					};
					class Speed_Z_Hover
					{
						type = "linear";
						source = "speed";
						sourcescale = "1.94384";
						max = 20;
						min = -20;
						minPos[] = {0.5,0.25};
						maxPos[] = {0.5,0.75};
					};
					class Speed_X_Transition
					{
						type = "vector";
						source = "velocity";
						pos0[] = {0,0};
						pos10[] = {0.02,0};
					};
					class Speed_Z_Transition
					{
						type = "linear";
						source = "speed";
						sourcescale = "1.94384";
						max = 60;
						min = -60;
						minPos[] = {0.5,0.25};
						maxPos[] = {0.5,0.75};
					};
					class GforceX_Hover
					{
						type = "linear";
						source = "gmeterX";
						Sourcescale = 1;
						max = 7;
						min = -7;
						minPos[] = {0.25,0};
						maxPos[] = {-0.25,0};
					};
					class GforceZ_Hover
					{
						type = "linear";
						source = "gmeterZ";
						Sourcescale = 1;
						max = 7;
						min = -7;
						minPos[] = {0,-0.25};
						maxPos[] = {0,0.25};
					};
					class GforceX_Transition
					{
						type = "linear";
						source = "gmeterX";
						Sourcescale = 1;
						max = 7;
						min = -7;
						minPos[] = {0.1,0};
						maxPos[] = {-0.1,0};
					};
					class GforceZ_Transition
					{
						type = "linear";
						source = "gmeterZ";
						Sourcescale = 1;
						max = 7;
						min = -7;
						minPos[] = {0,-0.1};
						maxPos[] = {0,0.1};
					};
					class Level0_Transition
					{
						type = "horizon";
						pos0[] = {0.5,0.5};
						pos10[] = {0.65,0.65};
						angle = 0;
					};
					class Level0
					{
						type = "horizon";
						pos0[] = {0.5,0.5};
						pos10[] = {0.78,0.78};
						angle = 0;
					};
					class LevelP5: Level0
					{
						angle = 5;
					};
					class LevelM5: Level0
					{
						angle = -5;
					};
					class LevelP10: Level0
					{
						angle = 10;
					};
					class LevelM10: Level0
					{
						angle = -10;
					};
					class LevelP15: Level0
					{
						angle = 15;
					};
					class LevelM15: Level0
					{
						angle = -15;
					};
					class LevelP20: Level0
					{
						angle = 20;
					};
					class LevelM20: Level0
					{
						angle = -20;
					};
					class LevelP25: Level0
					{
						angle = 25;
					};
					class LevelM25: Level0
					{
						angle = -25;
					};
					class LevelP30: Level0
					{
						angle = 30;
					};
					class LevelM30: Level0
					{
						angle = -30;
					};
					class LevelP35: Level0
					{
						angle = 35;
					};
					class LevelM35: Level0
					{
						angle = -35;
					};
					class LevelP40: Level0
					{
						angle = 40;
					};
					class LevelM40: Level0
					{
						angle = -40;
					};
					class LevelP45: Level0
					{
						angle = 45;
					};
					class LevelM45: Level0
					{
						angle = -45;
					};
					class LevelP50: Level0
					{
						angle = 50;
					};
					class LevelM50: Level0
					{
						angle = -50;
					};
				};
				turret[] = {};
				class Draw
				{
					color[] = {"user3","user4","user5"};
					alpha = "user6";
					condition = "on*user0";
					class Laser_Toggle_On
					{
						type = "group";
						condition = "laseron";
						class Laser_On
						{
							type = "text";
							text = "LRFD ON";
							source = "static";
							align = "right";
							scale = 1;
							pos[] = {{0.61,0.83},1};
							right[] = {{0.65,0.83},1};
							down[] = {{0.61,0.87},1};
						};
					};
					class Static_HAD_BOX
					{
						clipTL[] = {0,1};
						clipBR[] = {1,0};
						type = "line";
						width = 2;
						points[] = {{{"0.5-0.1","0.9-0.04"},1},{{"0.5-0.1","0.9+0.04"},1},{{"0.5+0.1","0.9+0.04"},1},{{"0.5+0.1","0.9-0.04"},1},{{"0.5-0.1","0.9-0.04"},1},{},{{"0.5-0.1","0.9-0.04+0.02667"},1},{{"0.5-0.092","0.9-0.04+0.02667"},1},{},{{"0.5+0.1","0.9-0.04+0.02667"},1},{{"0.5+0.092","0.9-0.04+0.02667"},1},{},{{0.5,"0.9-0.040"},1},{{0.5,"0.9-0.032"},1},{},{{0.5,"0.9+0.040"},1},{{0.5,"0.9+0.032"},1}};
					};
					class Missile_limits
					{
						type = "group";
						condition = "missile";
						class Missile_lines
						{
							type = "line";
							width = 1;
							points[] = {{{"0.5-0.0167","0.9-0.04+0.00000"},1},{{"0.5-0.0167","0.9-0.04+0.00889"},1},{},{{"0.5-0.0167","0.9-0.04+0.00889*2"},1},{{"0.5-0.0167","0.9-0.04+0.00889*3"},1},{},{{"0.5-0.0167","0.9-0.04+0.00889*4"},1},{{"0.5-0.0167","0.9-0.04+0.00889*5"},1},{},{{"0.5-0.0167","0.9-0.04+0.00889*6"},1},{{"0.5-0.0167","0.9-0.04+0.00889*7"},1},{},{{"0.5-0.0167","0.9-0.04+0.00889*8"},1},{{"0.5-0.0167","0.9-0.04+0.00889*9"},1},{},{{"0.5+0.0167","0.9-0.04+0.00000"},1},{{"0.5+0.0167","0.9-0.04+0.00889"},1},{},{{"0.5+0.0167","0.9-0.04+0.00889*2"},1},{{"0.5+0.0167","0.9-0.04+0.00889*3"},1},{},{{"0.5+0.0167","0.9-0.04+0.00889*4"},1},{{"0.5+0.0167","0.9-0.04+0.00889*5"},1},{},{{"0.5+0.0167","0.9-0.04+0.00889*6"},1},{{"0.5+0.0167","0.9-0.04+0.00889*7"},1},{},{{"0.5+0.0167","0.9-0.04+0.00889*8"},1},{{"0.5+0.0167","0.9-0.04+0.00889*9"},1}};
						};
					};
					class Gun_limits
					{
						type = "group";
						condition = "mgun";
						class Missile_lines
						{
							type = "line";
							width = 1;
							points[] = {{{"0.5-0.0717","0.9-0.04+0.00000"},1},{{"0.5-0.0717","0.9-0.04+0.00889"},1},{},{{"0.5-0.0717","0.9-0.04+0.00889*2"},1},{{"0.5-0.0717","0.9-0.04+0.00889*3"},1},{},{{"0.5-0.0717","0.9-0.04+0.00889*4"},1},{{"0.5-0.0717","0.9-0.04+0.00889*5"},1},{},{{"0.5-0.0717","0.9-0.04+0.00889*6"},1},{{"0.5-0.0717","0.9-0.04+0.00889*7"},1},{},{{"0.5-0.0717","0.9-0.04+0.00889*8"},1},{{"0.5-0.0717","0.9-0.04+0.00889*9"},1},{},{{"0.5+0.0717","0.9-0.04+0.00000"},1},{{"0.5+0.0717","0.9-0.04+0.00889"},1},{},{{"0.5+0.0717","0.9-0.04+0.00889*2"},1},{{"0.5+0.0717","0.9-0.04+0.00889*3"},1},{},{{"0.5+0.0717","0.9-0.04+0.00889*4"},1},{{"0.5+0.0717","0.9-0.04+0.00889*5"},1},{},{{"0.5+0.0717","0.9-0.04+0.00889*6"},1},{{"0.5+0.0717","0.9-0.04+0.00889*7"},1},{},{{"0.5+0.0717","0.9-0.04+0.00889*8"},1},{{"0.5+0.0717","0.9-0.04+0.00889*9"},1}};
						};
					};
					class Gunner_Aim_Box
					{
						type = "line";
						width = 2;
						points[] = {{"GunnerAim",{0.485,0.892},1},{"GunnerAim",{0.485,0.908},1},{"GunnerAim",{0.515,0.908},1},{"GunnerAim",{0.515,0.892},1},{"GunnerAim",{0.485,0.892},1}};
					};
					class AGM_TOF
					{
						condition = "ATmissile*missilelocked";
						type = "group";
						class TOFtext
						{
							type = "text";
							align = "right";
							source = "static";
							text = "TOF=";
							scale = 1;
							pos[] = {{0.61,0.92},1};
							right[] = {{0.65,0.92},1};
							down[] = {{0.61,0.96},1};
						};
						class TOFnumber
						{
							type = "text";
							source = "targetDist";
							sourcescale = 0.0025;
							align = "right";
							scale = 1;
							pos[] = {{0.69,0.92},1};
							right[] = {{0.73,0.92},1};
							down[] = {{0.69,0.96},1};
						};
					};
					class Range_group
					{
						type = "group";
						condition = "targetDist";
						class RangeText
						{
							type = "text";
							source = "static";
							text = "R";
							align = "right";
							scale = 1;
							pos[] = {{0.3,0.86},1};
							right[] = {{0.34,0.86},1};
							down[] = {{0.3,0.9},1};
						};
						class RangeNumber
						{
							type = "text";
							source = "targetDist";
							sourceprecision = 2;
							sourceScale = 0.001;
							align = "left";
							scale = 1;
							pos[] = {{0.37,0.86},1};
							right[] = {{0.41,0.86},1};
							down[] = {{0.37,0.9},1};
						};
					};
					class ACQ_TADS_Source
					{
						type = "group";
						condition = "1-activeSensorsOn";
						class ACQ_TADS
						{
							type = "text";
							source = "static";
							text = "TADS";
							align = "right";
							scale = 1;
							pos[] = {{0.3,0.89},1};
							right[] = {{0.34,0.89},1};
							down[] = {{0.3,0.93},1};
						};
					};
					class ACQ_FCRG_Source
					{
						type = "group";
						condition = "activeSensorsOn-AAmissile";
						class ACQ_FCRG
						{
							type = "text";
							source = "static";
							text = "FCR/G";
							align = "right";
							scale = 1;
							pos[] = {{0.3,0.89},1};
							right[] = {{0.34,0.89},1};
							down[] = {{0.3,0.93},1};
						};
					};
					class ACQ_FCRA_Source
					{
						type = "group";
						condition = "(activeSensorsOn*AAmissile)";
						class ACQ_FCRA
						{
							type = "text";
							source = "static";
							text = "FCR/A";
							align = "right";
							scale = 1;
							pos[] = {{0.3,0.89},1};
							right[] = {{0.34,0.89},1};
							down[] = {{0.3,0.93},1};
						};
					};
				};
			};
