// Satellite / PiP camera overlay (RscTitles entry). Included into the single addon-wide class RscTitles in config.cpp.
class OKS_SatCamHUD {
	idd = 9510;
	duration = 1e+011;
	fadeIn = 0;
	fadeOut = 0;
	onLoad = "uiNamespace setVariable ['OKS_SatCamHUD_Display', _this select 0];";

	class controls {
		// Background panel (hidden when device frame is active)
		class BG: RscText {
			idc = 9510;
			x = "safezoneX + safezoneW - 0.62";
			y = "safezoneY + safezoneH - 0.47";
			w = 0.60;
			h = 0.45;
			colorBackground[] = {0, 0, 0, 0.55};
			text = "";
		};

		// PiP feed
		class Feed: RscPicture {
			idc = 9511;
			text = "";
			x = "safezoneX + safezoneW - 0.60";
			y = "safezoneY + safezoneH - 0.45";
			w = 0.57;
			h = 0.42;
			colorText[] = {1,1,1,1};
		};

		// Optics overlay (crosshair/reticle)
		class OpticsOverlay: RscPicture {
			idc = 9515;
			text = "";
			x = "safezoneX + safezoneW - 0.60";
			y = "safezoneY + safezoneH - 0.45";
			w = 0.57;
			h = 0.42;
			colorText[] = {0,1,0,0.8};
		};

		// Vignette overlay
		class Vignette: RscPicture {
			idc = 9516;
			text = "#(argb,8,8,3)color(0,0,0,0.2)";
			x = "safezoneX + safezoneW - 0.60";
			y = "safezoneY + safezoneH - 0.45";
			w = 0.57;
			h = 0.42;
			colorText[] = {0,0,0,0.4};
		};

		// Center crosshair
		class Crosshair: RscText {
			idc = 9517;
			x = "safezoneX + safezoneW - 0.315";
			y = "safezoneY + safezoneH - 0.235";
			w = 0.03;
			h = 0.03;
			text = "+";
			sizeEx = 0.05;
			colorText[] = {0,1,0,0.7};
			colorBackground[] = {0,0,0,0};
			shadow = 2;
		};

		class Label: RscText {
			idc = 9513;
			x = "safezoneX + safezoneW - 0.60";
			y = "safezoneY + safezoneH - 0.49";
			w = 0.50;
			h = 0.02;
			text = "CAM FEED";
			sizeEx = 0.03;
			colorText[] = {0,1,0,0.9};
			colorBackground[] = {0,0,0,0};
			shadow = 1;
		};

		class Hint: RscText {
			idc = 9514;
			x = "safezoneX + safezoneW - 0.28";
			y = "safezoneY + safezoneH - 0.04";
			w = 0.25;
			h = 0.02;
			text = "ESC to exit";
			sizeEx = 0.025;
			colorText[] = {1,1,1,0.75};
			colorBackground[] = {0,0,0,0};
			shadow = 1;
		};

		// cTab device frame overlay — drawn LAST so it renders on top of feed & UI
		class DeviceFrame: RscPicture {
			idc = 9518;
			text = "";
			x = 0;
			y = 0;
			w = 0;
			h = 0;
			colorText[] = {1,1,1,1};
		};
	};
};
