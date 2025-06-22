//	Settings for heli crew and units and also skill setting for heli crew and units.
//
//	Made By NeKo-ArroW
// [] call OKS_fnc_AirDrop_Settings;
// General Settings

_Rendevouz = missionNamespace getVariable ["GOL_Airdrop_Rendevouz", false];
_ChuteHeight = missionNamespace getVariable ["GOL_Airdrop_ChuteHeight", 100];
_WPDistance = missionNamespace getVariable ["GOL_Airdrop_WPDistance", 150];
_Settings = [_Side] call OKS_fnc_Hunt_Settings;
_Settings Params ["_MinDistance","_UpdateFreqSettings","_SkillVariables","_Skill","_AirDropLeaders","_AirDropUnits","_MaxCargoSeats","_HeliClass", "_PilotClasses", "_CrewClasses"];
_EgressPos = [0,0,0];
_UnitClasses = _AirDropLeaders + _AirDropUnits;
_UnitTypes = _UnitClasses;
_SkillVariables = ["aimingspeed","aimingaccuracy","aimingshake","spotdistance","spottime","commanding","general"];
_Skill = [0.4, 0.35, 0.35, 0.5, 0.6, 0.8, 0.7];

