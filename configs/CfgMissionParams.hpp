// Default mission lobby parameters shared by GOL framework missions.
// Include this file inside `class Params` from Description.ext.

class Daytime
{
	title = "Mission Time";
	texts[] = { "Mission Defined", "Dawn", "Noon", "Afternoon", "Evening", "Night" };
	values[] = { -1, 5.6, 12, 16, 19, 23 };
	default = -1;
	function = "GW_fnc_paramDaytime";
};

class ShouldGiveMedicalToAsstGunner
{
	title = "Should Asst. Gunner have medical supplies?";
	texts[] = { "No", "Yes" };
	values[] = { 0, 1 };
	default = 1;
};

class ShouldGiveServiceStationToVehicle
{
	title = "Should non-MHQ vehicles have service station?";
	texts[] = { "Yes", "No" };
	values[] = { 1, 0 };
	default = 1;
};

class SpawnMultiplier
{
	title = "Spawn Multiplier";
	texts[] = { "100%", "90%", "80%", "70%", "60%", "50%", "40%", "30%", "20%", "10%" };
	values[] = { 100, 90, 80, 70, 60, 50, 40, 30, 20, 10 };
	default = 100;
};

class GOL_AISkillOverride
{
	title = "AI Skill Preset Override";
	texts[] = { "No Override", "Special Forces", "Commando", "Regulars", "Insurgents", "Farmer" };
	values[] = { -1, 0, 1, 2, 3, 4 };
	default = -1;
};
