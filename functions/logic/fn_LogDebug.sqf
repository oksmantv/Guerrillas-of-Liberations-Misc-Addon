

Params ["_DebugMessage"];

Private _Debug = missionNamespace getVariable ["GOL_Core_Debug",false];

if(_Debug) then {
	_ClientTag = [] spawn OKS_fnc_GetClientId;
	_DebugTag = format["[DEBUG-%1]",_ClientTag];
	_DebugLogMessage = format["%1 %2",_DebugTag,_DebugMessage];
	diag_log _DebugLogMessage;
	_DebugLogMessage remoteExec ["systemChat",0];
};