	
	Private ["_Temp","_Type","_Skill","_Index","_This","_SkillVariables","_HeliClass","_PilotClasses","_CrewClasses","_UnitTypes","_PilotSkill","_CrewSkill","_UnitSkill"];

	Params ["_Temp","_Type","_Side"];
	#include "fn_AirDrop_Settings.sqf"

	call Compile Format ["_Skill = _%1Skill",_Type];
	_Index = 0;
	for "_i" from 1 to (count _SkillVariables) do
	{
		_Temp setSkill [(_SkillVariables select _Index), (_Skill select _Index)];
		_Index = _Index +1;
	};