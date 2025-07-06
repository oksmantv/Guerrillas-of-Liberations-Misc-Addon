// [this] call OKS_fnc_VehicleAppearance;

Params
[
	["_Vehicle", ObjNull, [ObjNull]]
];

if(hasInterface && !isServer) exitWith {};
Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
Private _AppearanceArray = [];
if(isNull _Vehicle) exitWith {
    if(_Debug) then {
        format ["Vehicle Appearance Script, Vehicle was null. Exiting.."] spawn OKS_fnc_LogDebug;
    };
};

Private _VehicleAppearanceAI = missionNamespace getVariable ["GOL_VehicleAppearanceAI",false];
if(_VehicleAppearanceAI) then {
	format["Changed Vehicle Appearance on %1", [configFile >> "CfgVehicles" >> typeOf _Vehicle] call BIS_fnc_displayName] spawn OKS_fnc_LogDebug;
};

if(["btr60", typeOf _Vehicle, false] call BIS_fnc_inString || ["btr70", typeOf _Vehicle, false] call BIS_fnc_inString || ["btr80", typeOf _Vehicle, false] call BIS_fnc_inString) then {
 	_AppearanceArray = [
		"crate_l1_unhide",floor(random 2),"crate_l2_unhide",floor(random 2),"crate_l3_unhide",floor(random 2),
		"crate_l4_unhide",floor(random 2),"crate_r1_unhide",floor(random 2),"crate_r2_unhide",floor(random 2),
		"crate_r3_unhide",floor(random 2),"crate_r4_unhide",floor(random 2),"water_1_unhide",floor(random 2),
		"water_2_unhide",floor(random 2),"wheel_1_unhide",floor(random 2),"wheel_2_unhide",floor(random 2)
	];
};

if(["t72", typeOf _Vehicle, false] call BIS_fnc_inString) then {
 	_AppearanceArray = [
		["hide_com_shield",floor(random 2),"hide_sideskirts",floor(random 2)]
	];
};

if(["Tracked_02_cannon_F", typeOf _Vehicle, false] call BIS_fnc_inString) then {
 	_AppearanceArray = [
		["showTracks",floor(random 2),"showCamonetHull",floor(random 2),"showBags",floor(random 2),"showSLATHull",floor(random 2)]
	];
};
if(["I_APC_tracked_03_cannon_F", typeOf _Vehicle, false] call BIS_fnc_inString) then {
 	_AppearanceArray = [
		["showBags",floor(random 2),"showBags2",floor(random 2),"showCamonetHull",floor(random 2),"showCamonetTurret",floor(random 2),"showTools",floor(random 2),"showSLATHull",floor(random 2),"showSLATTurret",floor(random 2)]
	];
};
if(["I_APC_wheeled_03_cannon_F", typeOf _Vehicle, false] call BIS_fnc_inString) then {
 	_AppearanceArray = [
		["showCamonetHull",floor(random 2),"showBags",floor(random 2),"showBags2",floor(random 2),"showTools",floor(random 2),"showSLATHull",floor(random 2)]
	];
};
if(["I_LT_", typeOf _Vehicle, false] call BIS_fnc_inString) then {
 	_AppearanceArray = [
		["showTools",floor(random 2),"showCamonetHull",floor(random 2),"showBags",floor(random 2),"showSLATHull",floor(random 2)]
	];
};

if(["BMP1", typeOf _Vehicle, false] call BIS_fnc_inString) then {
 	_AppearanceArray = [
		["crate_l1_unhide",floor(random 2),"crate_l2_unhide",floor(random 2),"crate_l3_unhide",floor(random 2),"crate_r1_unhide",floor(random 2),"crate_r2_unhide",floor(random 2),"crate_r3_unhide",floor(random 2),"wood_1_unhide",floor(random 2),"maljutka_hide_source",1]
	];
};
if(["bmp2", typeOf _Vehicle, false] call BIS_fnc_inString) then {
 	_AppearanceArray = [
		["konkurs_hide_source",1,"crate_l1_unhide",floor(random 2),"crate_l2_unhide",floor(random 2),"crate_l3_unhide",floor(random 2),"crate_r1_unhide",floor(random 2),"crate_r2_unhide",floor(random 2),"crate_r3_unhide",floor(random 2),"wood_1_unhide",floor(random 2)]
	];
};
if(["bmd1", typeOf _Vehicle, false] call BIS_fnc_inString) then {
 	_AppearanceArray = [
		["maljutka_hide_source",1,"crate_l1_unhide",floor(random 2),"crate_l2_unhide",floor(random 2),"crate_l3_unhide",floor(random 2),"crate_r1_unhide",floor(random 2),"crate_r2_unhide",floor(random 2),"crate_r3_unhide",floor(random 2),"wood_1_unhide",floor(random 2),"wood_2_unhide",floor(random 2),"antena2_hide",floor(random 2)]
	];
};
if(["bmd2", typeOf _Vehicle, false] call BIS_fnc_inString) then {
 	_AppearanceArray = [
		["9p135_hide_source",1,"crate_l1_unhide",floor(random 2),"crate_l2_unhide",floor(random 2),"crate_l3_unhide",floor(random 2),"crate_r1_unhide",floor(random 2),"crate_r2_unhide",floor(random 2),"crate_r3_unhide",floor(random 2),"wood_1_unhide",floor(random 2),"wood_2_unhide",floor(random 2),"antena2_hide",floor(random 2)]
	];
};
if(["MBT_02_cannon", typeOf _Vehicle, false] call BIS_fnc_inString) then {
 	_AppearanceArray = [
		["showCamonetHull",floor(random 2),"showCamonetTurret",floor(random 2),"showLog",floor(random 2)]
	];
};
if(["B_MBT_01_cannon", typeOf _Vehicle, false] call BIS_fnc_inString) then {
 	_AppearanceArray = [
		["showBags",floor(random 2),"showCamonetTurret",floor(random 2),"showCamonetHull",floor(random 2)]
	];
};

if(_Debug && _AppearanceArray isEqualTo []) then {
	format ["Vehicle Appearance Script, no appearance defined. Exiting.."] spawn OKS_fnc_LogDebug;
};
[_Vehicle, "", _AppearanceArray] call BIS_fnc_initVehicle;