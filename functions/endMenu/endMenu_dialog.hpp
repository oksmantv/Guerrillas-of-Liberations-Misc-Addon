#include "baseControls.hpp"

class MyEndMissionDialog {
    idd = 1234; // Unique dialog ID
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "uiNamespace setVariable ['MyEndMissionDialog', _this select 0]";

    class controlsBackground {
        class Background: RscText {
            idc = -1;
            x = 0.3 * safezoneW + safezoneX;
            y = 0.2 * safezoneH + safezoneY;
            w = 0.4 * safezoneW;
            h = 0.6 * safezoneH;
            colorBackground[] = {0,0,0,0.7};
        };
    };

    class controls {
        class Title: RscText {
            idc = -1;
            text = "End Mission Summary";
            x = 0.3 * safezoneW + safezoneX;
            y = 0.2 * safezoneH + safezoneY;
            w = 0.4 * safezoneW;
            h = 0.05 * safezoneH;
            colorBackground[] = {0,0,0,0.8};
            sizeEx = 1 * GUI_GRID_H;
        };

        class ScoreList: RscListbox {
            idc = 1500; // Reference this in your script
            x = 0.32 * safezoneW + safezoneX;
            y = 0.27 * safezoneH + safezoneY;
            w = 0.36 * safezoneW;
            h = 0.48 * safezoneH;
        };

        class CloseButton: RscButton {
            idc = -1;
            text = "Close";
            x = 0.5 * safezoneW + safezoneX;
            y = 0.76 * safezoneH + safezoneY;
            w = 0.18 * safezoneW;
            h = 0.06 * safezoneH;
            action = "closeDialog 0;";
        };
    };
};
