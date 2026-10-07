params [
	["_intelPiece", objNull, [objNull]],
	["_caller", objNull, [objNull]]
];

if (!isServer) exitWith {
	[_intelPiece, _caller] remoteExecCall ["OKS_fnc_ClaimIntel", 2];
	true
};

if (isNull _intelPiece || {isNull _caller} || {!isPlayer _caller}) exitWith { false };

if (_intelPiece getVariable ["GOL_IntelClaimed", false]) exitWith {
	private _claimedBy = _intelPiece getVariable ["GOL_IntelClaimedBy", objNull];
	private _message = if (!isNull _claimedBy && {_claimedBy isEqualTo _caller}) then {
		"You already recovered this intel."
	} else {
		format ["This intel has already been recovered by %1.", if (!isNull _claimedBy) then {name _claimedBy} else {"another player"}]
	};
	format ["[ClaimIntel] Already claimed — telling %1: %2", name _caller, _message] spawn OKS_fnc_LogDebug;
	[[format ["<br/><br/><br/><br/><br/><br/><br/><br/><t size='1.44' color='#FF8800' align='center'>%1</t>", _message], "PLAIN", 0.3, true, true]] remoteExec ["cutText", _caller];
	[_caller] spawn { params ["_c"]; sleep 2; [1] remoteExec ["cutFadeOut", _c]; };
	false
};

private _intelText = _intelPiece getVariable ["GOL_IntelSearchText", ""];
private _intelHeader = _intelPiece getVariable ["GOL_IntelSearchHeader", "Intel"];

format ["[ClaimIntel] piece=%1, caller=%2, textLen=%3, header='%4'", typeOf _intelPiece, name _caller, count _intelText, _intelHeader] spawn OKS_fnc_LogDebug;

if (_intelText isEqualTo "") exitWith {
	// Empty intel text means this is a decoy object — tell the player they found nothing
	// and consume the action so it cannot be triggered again.
	_intelPiece setVariable ["GOL_IntelClaimed", true, true];
	format ["[ClaimIntel] Decoy triggered by %1 on %2", name _caller, typeOf _intelPiece] spawn OKS_fnc_LogDebug;
	[["<br/><br/><br/><br/><br/><br/><br/><br/><t size='1.44' color='#AAAAAA' align='center'>You searched but found no useful intel.</t>", "PLAIN", 0.3, true, true]] remoteExec ["cutText", _caller];
	[_caller] spawn { params ["_c"]; sleep 2; [1] remoteExec ["cutFadeOut", _c]; };
	false
};

format ["[ClaimIntel] Calling addIntel for %1, header='%2'", name _caller, _intelHeader] spawn OKS_fnc_LogDebug;
[_caller, "acex_intelitems_document", _intelText, _intelHeader] call ace_intelitems_fnc_addIntel;

_intelPiece setVariable ["GOL_IntelClaimed", true, true];
_intelPiece setVariable ["GOL_IntelClaimedBy", _caller, true];

private _sourceName = if (_intelPiece isKindOf "Man") then {
	name _intelPiece
} else {
	private _dispName = getText (configFile >> "CfgVehicles" >> typeOf _intelPiece >> "displayName");
	if (_dispName isEqualTo "") then { typeOf _intelPiece } else { _dispName }
};

[[format ["<br/><br/><br/><br/><br/><br/><br/><br/><t size='1.76' color='#FFD700' align='center'>You recovered intel from %1.</t>", _sourceName], "PLAIN", 0.3, true, true]] remoteExec ["cutText", _caller];
[_caller] spawn { params ["_c"]; sleep 2; [1] remoteExec ["cutFadeOut", _c]; };
format ["[ClaimIntel] %1 recovered intel from %2", name _caller, _sourceName] spawn OKS_fnc_LogDebug;

true