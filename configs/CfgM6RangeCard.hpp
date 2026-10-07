// M6 Mortar Range Card display.
// Top-level class (outside RscTitles) — opened via (findDisplay 46) createDisplay "OKS_M6RangeCard".
// Draggable via title bar. Right-click or X to close.
// IDC 9602 = image (referenced by fn_M6RangeCardStep).

class OKS_M6RangeCard {
	idd = 9600;
	enableSimulation = 1;
	movingEnable = 1;
	fadeIn = 0;
	fadeOut = 0;
	duration = 1e+011;
	onLoad = "_this call OKS_fnc_M6RangeCardOnLoad;";

	class controls {

		// Header background — covers full width; moving=1 makes the centre gap draggable
		class TitleBarBg: RscText {
			idc = 9610;
			moving = 1;
			text = "";
			colorBackground[] = {0.18, 0.14, 0.09, 0.95};
			x = "safezoneX + safezoneW * 0.832";
			y = "safezoneY + safezoneH * 0.040";
			w = "safezoneW * 0.163";
			h = "safezoneH * 0.034";
		};

		// < prev — small button on far left
		class PrevButton: RscButton {
			idc = 9604;
			text = "<";
			action = "[-1] call OKS_fnc_M6RangeCardStep;";
			font = "EtelkaMonospacePro";
			sizeEx = "0.016 * safezoneH";
			colorText[] = {0.95, 0.92, 0.85, 1.0};
			colorBackground[] = {0, 0, 0, 0};
			colorBackgroundActive[] = {0.30, 0.24, 0.15, 1.0};
			colorFocused[] = {0.30, 0.24, 0.15, 1.0};
			x = "safezoneX + safezoneW * 0.832";
			y = "safezoneY + safezoneH * 0.040";
			w = "safezoneW * 0.020";
			h = "safezoneH * 0.034";
		};

		// > next — small button, right side (leaves centre as drag area)
		class NextButton: RscButton {
			idc = 9605;
			text = ">";
			action = "[1] call OKS_fnc_M6RangeCardStep;";
			font = "EtelkaMonospacePro";
			sizeEx = "0.016 * safezoneH";
			colorText[] = {0.95, 0.92, 0.85, 1.0};
			colorBackground[] = {0, 0, 0, 0};
			colorBackgroundActive[] = {0.30, 0.24, 0.15, 1.0};
			colorFocused[] = {0.30, 0.24, 0.15, 1.0};
			x = "safezoneX + safezoneW * 0.953";
			y = "safezoneY + safezoneH * 0.040";
			w = "safezoneW * 0.020";
			h = "safezoneH * 0.034";
		};

		// X close — small button on far right
		class TitleClose: RscButton {
			idc = 9612;
			text = "X";
			action = "(findDisplay 9600) closeDisplay 0;";
			font = "EtelkaMonospacePro";
			sizeEx = "0.016 * safezoneH";
			colorText[] = {0.95, 0.92, 0.85, 1.0};
			colorBackground[] = {0, 0, 0, 0};
			colorBackgroundActive[] = {0.65, 0.12, 0.12, 1.0};
			colorFocused[] = {0.50, 0.10, 0.10, 1.0};
			x = "safezoneX + safezoneW * 0.975";
			y = "safezoneY + safezoneH * 0.040";
			w = "safezoneW * 0.020";
			h = "safezoneH * 0.034";
		};

		// Range table image — 256x1024 PAA (4:1), h = w * 4 in safezoneW units
		class RangeTableImage: RscPicture {
			idc = 9602;
			style = 2096;
			text = "\UK3CB_BAF_Weapons\addons\UK3CB_BAF_Weapons_Static\data\M6_charge0_ca.paa";
			x = "safezoneX + safezoneW * 0.832";
			y = "safezoneY + safezoneH * 0.074";
			w = "safezoneW * 0.163";
			h = "safezoneW * 0.652";
		};
	};
};

