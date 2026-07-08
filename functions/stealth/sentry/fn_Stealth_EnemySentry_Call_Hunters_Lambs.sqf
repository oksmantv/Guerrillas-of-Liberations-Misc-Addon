/*
	[_Group,500,_Unit] call OKS_fnc_Stealth_EnemySentry_Call_Hunters_Lambs;
*/

params ["_Group", "_HuntRange"];

if (!(_Group getVariable ["LAMBS_HUNTING", false]) && !(_Group getVariable ["GOL_IsStatic", false])) then {
	[_Group] call OKS_fnc_Stealth_SendDetectionFlare;
	_Group setVariable ["LAMBS_HUNTING", true, true];
	[_Group, _HuntRange, 15, [], getPos (leader _Group), true, false, false] remoteExec ["lambs_wp_fnc_taskHunt", 0];
	sleep 10;
	_Group setBehaviour "AWARE";
	_Group setSpeedMode "NORMAL";
	{
		[_X, "FSM"] remoteExec ["disableAI", 0];
		[_X, false] remoteExec ["enableAttack", 0];
	} forEach units _Group;
};