// Drone Jammer HUD - Integrates with vanilla UI Layout system
class RscTitles {
	class OKS_JammerHUD {
		idd = 9500;
		duration = 1e+011;
		fadeIn = 0;
		fadeOut = 0;
		onLoad = "uiNamespace setVariable ['OKS_JammerHUD_Display', _this select 0];";
		
		class controls {
			class Background: RscPicture {
				idc = 95003;
				x = "safezoneX + safezoneW - 0.18";
				y = "safezoneY + safezoneH - 0.18";
				w = 0.12;
				h = 0.12;
				colorBackground[] = {0, 0, 0, 0.5};
				colorText[] = {0, 0, 0, 1};
			};
			
			class Icon: RscPicture {
				idc = 95001;
				text = "\OKS_GOL_Misc\data\UI\jammer_icon_ca.paa";
				x = "safezoneX + safezoneW - 0.175";
				y = "safezoneY + safezoneH - 0.175";
				w = 0.10;
				h = 0.10;
				colorText[] = {1, 1, 1, 0.7};
			};
			
			class Indicator: RscPicture {
				idc = 95002;
				x = "safezoneX + safezoneW - 0.095";
				y = "safezoneY + safezoneH - 0.095";
				w = 0.02;
				h = 0.02;
				colorBackground[] = {1, 1, 1, 0.7};
			};
			
			class CountText: RscText {
				idc = 95004;
				x = "safezoneX + safezoneW - 0.19";
				y = "safezoneY + safezoneH - 0.13";
				w = 0.035;
				h = 0.055;
				text = "";
				sizeEx = 0.075;
				colorText[] = {1, 1, 1, 1};
				colorBackground[] = {0, 0, 0, 0};
				style = 0; // ST_LEFT
				shadow = 2;
			};
		};
	};
};

// Register with vanilla UI Layout system
class CfgCustomUILayoutPositions {
	class OKS_JammerHUD {
		idd = 9500;
		title = "Drone Jammer Status";
		position[] = {
			safezonex + safezoneW - 0.18,
			safezonY + safezoneH - 0.18
		};
	};
};
