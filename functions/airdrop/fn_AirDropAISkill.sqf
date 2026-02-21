	
	Private ["_Temp","_Type","_Skill","_Index","_This","_SkillVariables","_HeliClass","_PilotClasses","_CrewClasses","_UnitTypes","_PilotSkill","_CrewSkill","_UnitSkill"];

	Params ["_Temp","_Type","_Side"];
	// Inline skill vars directly - avoids the full OKS_fnc_Hunt_Settings chain (getVariable + splitString) per unit
	_SkillVariables = ["aimingspeed","aimingaccuracy","aimingshake","spotdistance","spottime","commanding","general"];
	_Skill = [0.4, 0.35, 0.35, 0.5, 0.6, 0.8, 0.7];

	_Index = 0;
	for "_i" from 1 to (count _SkillVariables) do
	{
		_Temp setSkill [(_SkillVariables select _Index), (_Skill select _Index)];
		_Index = _Index +1;
	};