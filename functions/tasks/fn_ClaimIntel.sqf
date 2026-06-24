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
	[_message] remoteExec ["systemChat", _caller];
	false
};

private _intelText = _intelPiece getVariable ["GOL_IntelSearchText", ""];
private _intelHeader = _intelPiece getVariable ["GOL_IntelSearchHeader", "Intel"];

if (_intelText isEqualTo "") exitWith {
	["This intel could not be recovered."] remoteExec ["systemChat", _caller];
	false
};

[_caller, "acex_intelitems_document", _intelText, _intelHeader] call ace_intelitems_fnc_addIntel;

_intelPiece setVariable ["GOL_IntelClaimed", true, true];
_intelPiece setVariable ["GOL_IntelClaimedBy", _caller, true];

private _sourceName = if (_intelPiece isKindOf "Man") then {
	name _intelPiece
} else {
	"the target"
};

[format ["You recovered intel from %1.", _sourceName]] remoteExec ["systemChat", _caller];
format ["[ClaimIntel] %1 recovered intel from %2", name _caller, _sourceName] spawn OKS_fnc_LogDebug;

true