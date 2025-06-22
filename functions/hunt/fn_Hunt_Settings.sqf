//	[side] Call OKS_fnc_Hunt_Settings;
//
//	Settings for NEKY_Hunt.
//
//	Returns: [Settings]
//
//	Made by NeKo-ArroW

// General Settings
Params [
    ["_Side",east,[sideUnknown]]
];
private ["_Leaders","_Units","_HeliClass", "_PilotClasses", "_CrewClasses"];

_MinDistance = missionNamespace getVariable ["GOL_Hunt_MinDistance", 100];
_UpdateFreq = missionNamespace getVariable ["GOL_UpdateFreq", 60];
_MaxCargoSeats = missionNamespace getVariable ["GOL_MaxCargoSeats", 6];
_ForceRespawnMultiplier = 150;

// Skill settings (add these to CBA if you want them configurable)
_SkillVariables = ["aimingspeed","aimingaccuracy","aimingshake","spotdistance","spottime","commanding","general"];
_Skill = [0.4, 0.35, 0.35, 0.5, 0.6, 0.8, 0.7];

// Side specific settings
switch (_Side) do {
    case BLUFOR: {
		_HeliClass = "B_Heli_Transport_01_F"; // Default Heli class - Ghosthawk Armed
		_PilotClasses = ["B_Pilot_F"]; // Class names for pilots
		_CrewClasses = ["B_Pilot_F"]; // Class names for crew
        _Leaders = (missionNamespace getVariable ["GOL_Leaders_BLUFOR", "B_Soldier_TL_F,B_Soldier_TL_F"]) splitString ",";
        _Units = (missionNamespace getVariable ["GOL_Units_BLUFOR", "B_Soldier_LAT_F,B_Soldier_GL_F,B_medic_F,B_Soldier_AR_F,B_Soldier_A_F"]) splitString ",";
    };
    case OPFOR: {
		_HeliClass = "O_Heli_light_03_unarmed_F"; // Default Heli class - Orca Unarmed
		_PilotClasses = ["O_Pilot_F"]; // Class names for pilots
		_CrewClasses = ["O_Pilot_F"]; // Class names for crew	
        _Leaders = (missionNamespace getVariable ["GOL_Leaders_OPFOR", "O_Soldier_TL_F,O_Soldier_TL_F"]) splitString ",";
        _Units = (missionNamespace getVariable ["GOL_Units_OPFOR", "O_Soldier_LAT_F,O_Soldier_GL_F,O_medic_F,O_Soldier_AR_F,O_Soldier_A_F"]) splitString ",";
    };
    case INDEPENDENT: {
		_HeliClass = "I_Heli_light_03_unarmed_F"; // Default Heli class - Hellcat Unarmed
		_PilotClasses = ["I_Pilot_F"]; // Class names for pilots
		_CrewClasses = ["I_Pilot_F"]; // Class names for crew
        _Leaders = (missionNamespace getVariable ["GOL_Leaders_INDEPENDENT", "I_Soldier_TL_F,I_Soldier_TL_F"]) splitString ",";
        _Units = (missionNamespace getVariable ["GOL_Units_INDEPENDENT", "I_Soldier_LAT_F,I_Soldier_GL_F,I_medic_F,I_Soldier_AR_F,I_Soldier_A_F"]) splitString ",";
    };
    default {
        _Leaders = [];
        _Units = [];
		_HeliClass = ""; // Default Heli class - Hellcat Unarmed
		_PilotClasses = [""]; // Class names for pilots
		_CrewClasses = [""]; // Class names for crew		
    };
};

private _forceMultiplier = missionNamespace getVariable ["GOL_ForceMultiplier", 1];
[_MinDistance, _UpdateFreq, _SkillVariables, _Skill, _Leaders, _Units, (_MaxCargoSeats * _forceMultiplier), _HeliClass, _PilotClasses, _CrewClasses, _ForceRespawnMultiplier]