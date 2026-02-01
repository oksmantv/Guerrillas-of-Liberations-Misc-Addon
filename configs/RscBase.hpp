// Shared UI base classes for OKS/GOL HUDs.
// These avoid build-tool failures where vanilla RscText/RscPicture are not loaded during binarize.

class OKS_RscText {
	access = 0;
	type = 0;
	idc = -1;
	style = 0;
	linespacing = 1;
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	text = "";
	shadow = 1;
	font = "RobotoCondensed";
	sizeEx = 0.03;
	fixedWidth = 0;
	x = 0;
	y = 0;
	w = 0;
	h = 0;
};

class OKS_RscPicture: OKS_RscText {
	style = 48;
};
