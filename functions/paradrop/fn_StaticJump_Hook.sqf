params ["_aircraft","_player","_value"];
_Debug = missionNamespace getVariable ["GOL_Paradrop_Debug",false];

_player setVariable ["GOL_Hooked",_value,true];
if(_Debug) then {
	format["[StaticLine] Static Jump Code - Hook for %1 set to %2", _player, _value] spawn OKS_fnc_LogDebug;
};

if(_value == true) then {
	[_aircraft, _player] spawn OKS_fnc_StaticJump_Action;
	if(_Debug) then {
		format["[StaticLine] Static Jump Code - Jump Action on %1 for %2 was added.", _aircraft, _player] spawn OKS_fnc_LogDebug;
	};
};

if(_value == false) then {
	_aircraft removeAction (_player getVariable ["GOL_StaticJumpAction",-1]);
	if(_Debug) then {
		format["[StaticLine] Static Jump Code - Jump Action on %1 for %2 was removed.", _aircraft, _player] spawn OKS_fnc_LogDebug;
	};
};