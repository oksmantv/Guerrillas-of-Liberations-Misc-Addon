
private _payload = _this;
private _debugMessage = "";
private _echoToChat = false;
private _silent = false;
private _force = false;

if (_payload isEqualType []) then {
	_debugMessage = _payload param [0, ""];
	_echoToChat = _payload param [1, false];
	_silent = _payload param [2, false];
	_force = _payload param [3, false];
} else {
	_debugMessage = _payload;
};

if !(_debugMessage isEqualType "") then {
	_debugMessage = str _debugMessage;
};

private _debugEnabled = missionNamespace getVariable ["GOL_Core_Debug", false];
if !(_debugEnabled || {_force}) exitWith {};

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

if (_silent) exitWith {};

private _chatMessage = _debugLogMessage;
_chatMessage = _chatMessage splitString "\r\n" joinString " ";

if (_echoToChat) then {
	systemChat _chatMessage;
};

// In 3DEN, avoid remoteExec spam/errors.
if (is3DEN) exitWith {};

private _globalDebug = missionNamespace getVariable ["GOL_Global_Debug", false];
if (_globalDebug) then {
	_chatMessage remoteExec ["systemChat", 0];
};

private _serverDebug = missionNamespace getVariable ["GOL_Server_Debug", false];
if (_serverDebug) then {
	_chatMessage remoteExec ["systemChat", 2];
};