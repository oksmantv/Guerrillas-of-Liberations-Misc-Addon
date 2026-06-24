params [
	["_intelPiece", objNull, [objNull]]
];

if (isNull _intelPiece) exitWith { false };

if (isServer && {!hasInterface}) exitWith {
	[_intelPiece] remoteExecCall ["OKS_fnc_AddSearchIntelAction", 0, true];
	true
};

if (!hasInterface) exitWith { true };

if (
	isNil "ace_interact_menu_fnc_createAction"
	|| {isNil "ace_interact_menu_fnc_addActionToObject"}
) exitWith {
	false
};

if (_intelPiece getVariable ["GOL_IntelSearchActionAdded", false]) exitWith { true };

private _action = [
	"OKS_SearchIntel",
	"Search for Intel",
	"\a3\ui_f\data\igui\cfg\simpletasks\types\search_ca.paa",
	{
		params ["_target", "_player", "_params"];
		[_target, _player] remoteExecCall ["OKS_fnc_ClaimIntel", 2];
	},
	{
		params ["_target", "_player", "_params"];
		alive _player
		&& {isPlayer _player}
		&& {!(_target getVariable ["GOL_IntelClaimed", false])}
	}
] call ace_interact_menu_fnc_createAction;

[_intelPiece, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
_intelPiece setVariable ["GOL_IntelSearchActionAdded", true];

true