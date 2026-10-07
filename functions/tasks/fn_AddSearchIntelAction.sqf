params [
	["_intelPiece", objNull, [objNull]],
	["_actionTitle", "Search for Intel", [""]]
];

if (isNull _intelPiece) exitWith { false };

if (isServer && {!hasInterface}) exitWith {
	[_intelPiece, _actionTitle] remoteExecCall ["OKS_fnc_AddSearchIntelAction", 0, true];
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
	_actionTitle,
	"\a3\ui_f\data\igui\cfg\simpletasks\types\search_ca.paa",
	{
		params ["_target", "_player", "_params"];
		_player switchMove "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon";
		[
			1.366,
			[_target, _player],
			{
				private _tgt = (_this select 0) select 0;
				private _plyr = (_this select 0) select 1;
				[_tgt, _plyr] remoteExecCall ["OKS_fnc_ClaimIntel", 2];
			},
			{},	// no animation reset — action matches animation duration exactly
			"Searching for Intel",
			{
				private _tgt = (_this select 0) select 0;
				private _plyr = (_this select 0) select 1;
				alive _plyr && {_plyr distance _tgt < 6}
			}
		] call ace_common_fnc_progressBar;
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