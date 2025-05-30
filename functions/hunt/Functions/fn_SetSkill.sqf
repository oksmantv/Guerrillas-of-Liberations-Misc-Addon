//	[Group, ["SkillVariables"], [Skill]] Spawn OKS_fnc_SetSkill;
//	
//	This handles setting the skill of the AI group
//	
//	Returns: Nothing.
//	
//	Made by NeKo-ArroW

Params ["_Grp","_SkillVariables","_Skill"];

{
	_x remoteExec ["GW_SetDifficulty_fnc_setSkill",0]
} forEach (Units _Grp);