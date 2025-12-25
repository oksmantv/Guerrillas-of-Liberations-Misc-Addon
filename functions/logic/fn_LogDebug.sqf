
private _payload = _this;
private _debugMessage = "";
private _echoToChat = false;

if (_payload isEqualType []) then {
	_debugMessage = _payload param [0, ""];
	_echoToChat = _payload param [1, false];
} else {
	_debugMessage = _payload;
};

if !(_debugMessage isEqualType "") then {
	_debugMessage = str _debugMessage;
};

private _debugEnabled = missionNamespace getVariable ["GOL_Core_Debug", false];
if !(_debugEnabled) exitWith {};

private _clientTag = [] call OKS_fnc_GetClientId;
private _debugTag = format ["[%1]", _clientTag];

private _prefixParts = [];
if (is3DEN) then {
	_prefixParts pushBack "[3DEN]";
};
_prefixParts pushBack _debugTag;
private _prefix = _prefixParts joinString "";

private _debugLogMessage = format ["%1 %2", _prefix, _debugMessage];
diag_log _debugLogMessage;

if (_echoToChat) then {
	systemChat _debugLogMessage;
};

// In 3DEN, avoid remoteExec spam/errors.
if (is3DEN) exitWith {};

private _globalDebug = missionNamespace getVariable ["GOL_Global_Debug", false];
if (_globalDebug) then {
	_debugLogMessage remoteExec ["systemChat", 0];
};

private _serverDebug = missionNamespace getVariable ["GOL_Server_Debug", false];
if (_serverDebug) then {
	_debugLogMessage remoteExec ["systemChat", 2];
};