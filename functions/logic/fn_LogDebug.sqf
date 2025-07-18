

Params ["_DebugMessage"];

Private _Debug = missionNamespace getVariable ["GOL_Core_Debug",false];

if(_Debug) then {
	_ClientTag = [] call OKS_fnc_GetClientId;
	_DebugTag = format["[DEBUG-%1]",_ClientTag];
	_DebugLogMessage = format["%1 %2",_DebugTag,_DebugMessage];
	diag_log _DebugLogMessage;
	Private _GlobalDebug = missionNamespace getVariable ["GOL_Global_Debug",false];
	if(_GlobalDebug) then {
		_DebugLogMessage remoteExec ["systemChat",0];
	} else {
		_DebugLogMessage remoteExec ["systemChat",2];
	};
};