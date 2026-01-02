/*
	[launcher, allowedWeapons] call OKS_fnc_ScudIntercept_RegisterLauncher;

	Installs a server-side Fired EH on the launcher that:
	- Calls CMC intercept (if present) to spawn an interceptable proxy target attached to the projectile
	- Creates/updates the OKS intercept task

	allowedWeapons:
	- [] means "any weapon" (not recommended)
	- otherwise only those weapon classnames will trigger
*/

if (!isServer) exitWith {false};

params [
	["_launcher", objNull, [objNull]],
	["_allowedWeapons", [], [[]]]
];

if (isNull _launcher) exitWith {false};

private _oldEhId = _launcher getVariable ["OKS_ScudIntercept_firedEH", -1];
if (_oldEhId != -1) then {
	_launcher removeEventHandler ["Fired", _oldEhId];
};

private _ehId = _launcher addEventHandler ["Fired", {
	params ["_veh", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

	if (!isServer) exitWith {};
	private _dbg = missionNamespace getVariable ["GOL_ScudIntercept_Debug", true];
	private _logDebug = {
		params ["_msg"]; 
		if !(missionNamespace getVariable ["GOL_ScudIntercept_Debug", true]) exitWith {};
		if (isNil "OKS_fnc_LogDebug") exitWith {};
		private _chat = missionNamespace getVariable ["GOL_ScudIntercept_DebugChat", false];
		[format ["[SCUDINT] %1", _msg], _chat, !_chat, true] call OKS_fnc_LogDebug;
	};

	_veh setVariable ["OKS_ScudIntercept_lastFiredStamp", diag_tickTime, true];
	_veh setVariable ["OKS_ScudIntercept_lastFiredWeapon", _weapon, true];
	_veh setVariable ["OKS_ScudIntercept_lastFiredAmmo", _ammo, true];
	_veh setVariable ["OKS_ScudIntercept_lastFiredProjectile", _projectile, true];
	private _allowed = _veh getVariable ["OKS_ScudIntercept_allowedWeapons", []];
	if (!(_allowed isEqualTo []) && { !(_weapon in _allowed) }) exitWith {};

	if (_dbg) then {
		[format ["Fired EH | veh=%1 type=%2 weapon=%3 ammo=%4 mag=%5 proj=%6 netId=%7 local=%8", _veh, typeOf _veh, _weapon, _ammo, _magazine, _projectile, netId _projectile, local _projectile]] call _logDebug;
	};

	// Make projectile interceptable (if CMC intercept is loaded)
	private _useCmc = missionNamespace getVariable ["GOL_ScudIntercept_UseCMCIntercept", true];
	if (_useCmc && {!isNil "cmc_intercept_fnc_onFired"}) then {
		[_veh, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile, _gunner] call cmc_intercept_fnc_onFired;
		if (_dbg) then {
			[format ["CMC intercept invoked | proj=%1 attachedNow=%2", _projectile, count (attachedObjects _projectile)]] call _logDebug;
		};
	};

	// Debug: confirm proxy attachment shortly after fired (server)
	if (_dbg) then {
		[_projectile] spawn {
			params ["_projectile"]; 
			sleep 0.15;
			if (isNull _projectile) exitWith {};
			private _attached = attachedObjects _projectile;
			private _types = _attached apply { typeOf _x };
			if !(isNil "OKS_fnc_LogDebug") then {
				private _chat = missionNamespace getVariable ["GOL_ScudIntercept_DebugChat", false];
				[format ["[SCUDINT] PostFired attach check | proj=%1 attached=%2 types=%3", _projectile, count _attached, _types], _chat, !_chat, true] call OKS_fnc_LogDebug;
			};
		};
	};

	// Create/attach/update the intercept task
	if (!isNil "OKS_fnc_ScudIntercept_OnFired") then {
		[_veh, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile, _gunner] call OKS_fnc_ScudIntercept_OnFired;
	};
}];

_launcher setVariable ["OKS_ScudIntercept_firedEH", _ehId];
_launcher setVariable ["OKS_ScudIntercept_allowedWeapons", _allowedWeapons, true];

true;
