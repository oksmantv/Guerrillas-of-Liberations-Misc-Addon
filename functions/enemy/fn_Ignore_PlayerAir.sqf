/*
	Enemy AI Ignore Player Air Targets

	Param 1: Group - The group to apply the ignore air target behavior to
	Param 2: Value - true/false, whether to ignore player air targets or not (default true)

	Example Usage: [_this, true] spawn OKS_fnc_Ignore_PlayerAir;
*/

params [
	["_group", grpNull, [grpNull]],
	["_value", true, [false]]
];
if(!_value) exitWith {
	_group setVariable ["GOL_IgnorePlayerAir_Active", false, true];
	private _playerAircraft = (allPlayers - entities "HeadlessClient_F") select {
		alive _x && { vehicle _x isKindOf "Air" }
	};
	{ 
		_group ignoreTarget [vehicle _x, false];
		diag_log format ["[Ignore Player Air Targets] Group %1 no longer ignoring player air target %2", _group, name _x];
	} forEach _playerAircraft;
	"[Ignore Player Air Targets] Value is false, un-ignoring all. Exiting script." spawn OKS_fnc_LogDebug;
};
if(_group getVariable ["GOL_IgnorePlayerAir_Active", false]) exitWith {
	"[Ignore Player Air Targets] Group is already running ignore air target behavior, exiting script." spawn OKS_fnc_LogDebug;
};
_group setVariable ["GOL_IgnorePlayerAir_Active", true, true];

private _disabled = "disabled";
private _enabled = "enabled";
private _dynamic = "dynamic";
private _ignoreAirSetup = ["GOL_Enemy_IgnorePlayerAir"] call CBA_settings_fnc_get;
		_ignoreAirSetup params ["_ignoreValue", "_ignoreDisplayName"];
private _ignoreAirMaxRange = ["GOL_Enemy_IgnorePlayerAir_MaxRange"] call CBA_settings_fnc_get;
private _ignoreAirMaxRangeVehicle = ["GOL_EnemyVehicle_IgnorePlayerAir_MaxRange"] call CBA_settings_fnc_get;
private _ignoreAirMaxRangeAAA = ["GOL_EnemyVehicle_IgnorePlayerAir_MaxRange_AAA"] call CBA_settings_fnc_get;
private _pollingTime = ["GOL_Enemy_IgnorePlayerAir_PollTime"] call CBA_settings_fnc_get;
private _ignoreDelay = ["GOL_Enemy_IgnorePlayerAir_IgnoreDelay"] call CBA_settings_fnc_get;

private _VehicleClassName = "";
if (vehicle leader _group != leader _group) then {
	_VehicleClassName = typeof (vehicle (leader _group));
} else {
	{
		private _veh = vehicle _x;
		if (_veh != _x) exitWith { _VehicleClassName = typeof _veh; };
	} forEach (units _group select { alive _x });
};
private _VehicleDisplayName = "Infantry";
private _isVehicle = false;
if(_VehicleClassName != "") then {
	_VehicleDisplayName = [configFile >> "CfgVehicles" >> _VehicleClassName] call BIS_fnc_displayName;
	_isVehicle = true;
};
private _playerSide = missionNameSpace getVariable ["GOL_Friendly_Side", (side group player)];

if (_ignoreValue isEqualTo _disabled) exitWith {
	_group setVariable ["GOL_IgnorePlayerAir_Active", false, true];
	"[Ignore Player Air Targets] Disabled via CBA Settings, exiting script." spawn OKS_fnc_LogDebug;
};
if (side _group == _playerSide) exitWith {
	_group setVariable ["GOL_IgnorePlayerAir_Active", false, true];
	"[Ignore Player Air Targets] Group is friendly, exiting script." spawn OKS_fnc_LogDebug;
};
if (side _group getFriend _playerSide > 0.6) exitWith {
	_group setVariable ["GOL_IgnorePlayerAir_Active", false, true];
	"[Ignore Player Air Targets] Group is friendly, exiting script." spawn OKS_fnc_LogDebug;
};
if (_VehicleClassName isKindOf "Static") exitWith {
	_group setVariable ["GOL_IgnorePlayerAir_Active", false, true];
	"[Ignore Player Air Targets] Group is using static weapon, exiting script." spawn OKS_fnc_LogDebug;
};
if ({ (vehicle _x) getVariable ["OKS_Convoy_Active", false] } count units _group > 0) exitWith {
	_group setVariable ["GOL_IgnorePlayerAir_Active", false, true];
	"[Ignore Player Air Targets] Group belongs to an active convoy with its own air targeting, exiting script." spawn OKS_fnc_LogDebug;
};
if ({_x in switchableUnits} count units _group > 0) exitWith {
	_group setVariable ["GOL_IgnorePlayerAir_Active", false, true];
	"[Ignore Player Air Targets] Group contains a playable slot, exiting script." spawn OKS_fnc_LogDebug;
};

format["[Ignore Player Air Targets] Enabled %3 on Group %1 (%2) ", _group, _VehicleDisplayName, _ignoreValue] spawn OKS_fnc_LogDebug;

[_group,_value,_ignoreValue,_VehicleDisplayName,_ignoreAirMaxRange,_ignoreAirMaxRangeVehicle,_ignoreAirMaxRangeAAA,_pollingTime,_ignoreDelay,_enabled,_dynamic,_isVehicle] spawn { 
	
	params ["_group","_value","_ignoreValue","_VehicleDisplayName","_ignoreAirMaxRange","_ignoreAirMaxRangeVehicle","_ignoreAirMaxRangeAAA","_pollingTime","_ignoreDelay","_enabled","_dynamic","_isVehicle"];
	private _lastInRangeTimes = createHashMap;
	while {
		{ alive _x } count units _group > 0
		&& { _ignoreValue isEqualTo _enabled || _ignoreValue isEqualTo _dynamic }
		&& (_group getVariable ["GOL_IgnorePlayerAir_Active", false])
	} do {
		private _playerAircraft = (allPlayers - entities "HeadlessClient_F") select {
			alive _x && { vehicle _x isKindOf "Air" }
		};

		if(!(_group getVariable ["GOL_IgnorePlayerAir_Active", false])) exitWith {
			"[Ignore Player Air Targets] Group Variable is no longer active, exiting script." spawn OKS_fnc_LogDebug;
		};

		// Re-check vehicle mount status every poll - any group member (not just the leader)
		// may mount/dismount a vehicle after this loop started, so this cannot be detected
		// only once before spawning, and cannot rely on the leader alone.
		private _VehicleClassName = "";
		if (vehicle leader _group != leader _group) then {
			_VehicleClassName = typeof (vehicle (leader _group));
		} else {
			{
				private _veh = vehicle _x;
				if (_veh != _x) exitWith { _VehicleClassName = typeof _veh; };
			} forEach (units _group select { alive _x });
		};
		if (_VehicleClassName != "") then {
			_VehicleDisplayName = [configFile >> "CfgVehicles" >> _VehicleClassName] call BIS_fnc_displayName;
			_isVehicle = true;
		} else {
			_VehicleDisplayName = "Infantry";
			_isVehicle = false;
		};

		// Static weapons can also be manned mid-loop (a group that started as infantry may
		// pick up a static gun after this script is already running), so this must be
		// re-checked every poll too, not just once before spawning. Statics have their own
		// targeting behavior, same reasoning as the AA-vehicle exit below.
		if (_VehicleClassName isKindOf "Static") exitWith {
			{ _group ignoreTarget [vehicle _x, false]; } forEach _playerAircraft;
			_group setVariable ["GOL_IgnorePlayerAir_Active", false, true];
			format ["[Ignore Player Air Targets] Group %1 (%2) is now using a static weapon, un-ignoring all player air targets and exiting - static weapons use their own targeting logic.", _group, _VehicleClassName] spawn OKS_fnc_LogDebug;
		};

		// Re-check AA status every poll - a group can mount/dismount an AA vehicle, or a soldier
		// can pick up/drop AA launcher gear, at any time. Checked on BOTH mounted vehicles AND
		// dismounted infantry - `vehicle _x` already equals `_x` itself when dismounted, so
		// `magazines (vehicle _x)` naturally scans a dismounted soldier's own carried magazines
		// (backpack/vest/launcher) with no separate infantry-only branch needed. In "enabled"
		// mode (no range awareness) AA-capable units still fully bypass this script and keep
		// their own targeting/radar logic, same as statics. In "dynamic" mode though, they get
		// their own dedicated max-range (_ignoreAirMaxRangeAAA) instead of being excluded.
		//
		// NOTE: ammo-attribute heuristics (simulation/airLock/groundLock) and weapon-attribute
		// heuristics (canLock/lockableTargetTypes/radarType) were all tried and abandoned - none
		// of them reliably separate real AA weapons from regular cannons or wire-guided AT
		// missiles in this modset. E.g. RHS's Malyutka ATGM (rhs_ammo_9m14m, a manually-guided
		// AT missile) has airLock=1/groundLock=0/canLock=2, identical in shape to real AA
		// missiles like Stinger/Titan_AA - so those flags cannot tell them apart. The only
		// signal that has held up across every real sample tested (RHS, UK3CB, vanilla; cannons
		// AND missiles) is the ammo classname itself: both mod packs and vanilla consistently
		// brand true AA ammo with an explicit "AA" token (RHS_ammo_23mm_AA, uk3cb_23mm_AA_green,
		// B_35mm_AA_Tracer_Green, M_Titan_AA), while AT/regular ammo never has it (rhs_ammo_9m14m,
		// rhs_ammo_3uof8, rhs_ammo_3ubr11, rhs_B_762x54_Ball). Some genuine AA missiles (e.g.
		// Stinger's ace_missile_manpad_stinger, Tunguska's 9M311M1) don't carry the "AA" token
		// either, but every such vehicle tested also carries an "AA"-tagged autocannon round
		// alongside it, so the vehicle is still correctly flagged overall. Since this rule no
		// longer depends on `simulation`/`airLock` at all, the earlier RPG/AT false-positive risk
		// that originally forced infantry to be excluded from this check no longer applies -
		// RPG/AT ammo classnames never carry an "aa" token.
		private _isAAVehicle = false;
		{
			private _veh = vehicle _x;
			if (_isAAVehicle) exitWith {};
			{
				private _ammoClass = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
				if (_ammoClass != "" && { "aa" in (toLower _ammoClass splitString "_") }) exitWith { _isAAVehicle = true; };
			} forEach (magazines _veh);
		} forEach (units _group select { alive _x });

		// Only fully exclude AA-equipped groups in "enabled" mode (no range logic to give them
		// instead). In "dynamic" mode they fall through to the range-check branch below, using
		// their own dedicated AAA max range.
		if (_isAAVehicle && _ignoreValue != _dynamic) exitWith {
			{ _group ignoreTarget [vehicle _x, false]; } forEach _playerAircraft;
			_group setVariable ["GOL_IgnorePlayerAir_Active", false, true];
			format ["[Ignore Player Air Targets] Group %1 (%2) is mounted in an AA vehicle, un-ignoring all player air targets and exiting - AA vehicles use their own targeting logic.", _group, _VehicleDisplayName] spawn OKS_fnc_LogDebug;
		};

		diag_log format ["[Ignore Player Air Targets] Group %1 (%4) checking for player air targets. Found %2 player aircraft. Polling Time: %3", _group, count _playerAircraft, _pollingTime, _VehicleDisplayName];
		if (_ignoreValue == _enabled) then {
			// Dynamic Air Targeting Disabled
			{
				if (_value) then {
					_group ignoreTarget [vehicle _x, true];
					if(missionNamespace getVariable ["GOL_Enemy_IgnorePlayerAir_DetailedDebug", false]) then {
						diag_log format ["[Ignore Player Air Targets] Group %1 (%3) ignoring player air target %2", _group, name _x, _VehicleDisplayName]; 
					};				
				} else {
					_group ignoreTarget [vehicle _x, false];
					if(missionNamespace getVariable ["GOL_Enemy_IgnorePlayerAir_DetailedDebug", false]) then {
						diag_log format ["[Ignore Player Air Targets] Group %1 (%3) no longer ignoring player air target %2", _group, name _x, _VehicleDisplayName];
					};
				};
			} forEach _playerAircraft;
		};

		if (_ignoreValue == _dynamic) then {
			// Dynamic Air Targeting Enabled - Max Range in effect.
			// In range  -> allowed to engage (ignoreTarget false)
			// Out of range -> ignored, but only after being out of range for at least
			// _ignoreDelay seconds. This gives fast/low aircraft that get missed between
			// polls a fair engagement window instead of being re-ignored immediately.
			// Priority: AAA range > Vehicle range > Infantry range. AA-equipped groups only
			// reach this branch in dynamic mode (see _isAAVehicle exit above).
			private _SelectedRange = if (_isAAVehicle) then { _ignoreAirMaxRangeAAA } else { if (_isVehicle) then { _ignoreAirMaxRangeVehicle } else { _ignoreAirMaxRange } };
			private _RangeTypeLabel = if (_isAAVehicle) then { "AAA" } else { if (_isVehicle) then { "Vehicle" } else { "Infantry" } };
			private _groupUnits = units _group select { alive _x };
			{
				private _aircraft = _x;
				private _netId = netId _aircraft;
				// Range is measured from whichever group member is nearest to the aircraft,
				// not just the leader - a spread out group can have members much closer.
				private _currentRange = round (selectMin (_groupUnits apply { _x distance2d _aircraft }));
				if (_currentRange < _SelectedRange) then {
					_lastInRangeTimes set [_netId, time];
					_group ignoreTarget [vehicle _aircraft, false];
					if(missionNamespace getVariable ["GOL_Enemy_IgnorePlayerAir_DetailedDebug", false]) then {
						systemChat format["[Ignore Player Air Targets] Group %1 (%3) no longer ignoring player air target %2 - Range %4/%5 (%6 range)", _group, name _aircraft, _VehicleDisplayName, _currentRange, _SelectedRange, _RangeTypeLabel];
					};
					diag_log format ["[Ignore Player Air Targets] Group %1 (%3) no longer ignoring player air target %2 - Range %4/%5 (%6 range)", _group, name _aircraft, _VehicleDisplayName, _currentRange, _SelectedRange, _RangeTypeLabel];
				} else {
					private _lastInRangeTime = _lastInRangeTimes getOrDefault [_netId, -1];
					if (_lastInRangeTime < 0 || { (time - _lastInRangeTime) > _ignoreDelay }) then {
						_lastInRangeTimes deleteAt _netId;
						_group ignoreTarget [vehicle _aircraft, true];
						if(missionNamespace getVariable ["GOL_Enemy_IgnorePlayerAir_DetailedDebug", false]) then {
							systemChat format["[Ignore Player Air Targets] Group %1 (%3) ignoring player air target %2 - Range %4/%5 (%6 range)", _group, name _aircraft, _VehicleDisplayName, _currentRange, _SelectedRange, _RangeTypeLabel]; 					
						};
						diag_log format ["[Ignore Player Air Targets] Group %1 (%3) ignoring player air target %2 - Range %4/%5 (%6 range)", _group, name _aircraft, _VehicleDisplayName, _currentRange, _SelectedRange, _RangeTypeLabel]; 
					} else {
						if(missionNamespace getVariable ["GOL_Enemy_IgnorePlayerAir_DetailedDebug", false]) then {
							diag_log format ["[Ignore Player Air Targets] Group %1 (%3) grace period for player air target %2 - Range %4/%5 (%6 range), %7s left", _group, name _aircraft, _VehicleDisplayName, _currentRange, _SelectedRange, _RangeTypeLabel, (_ignoreDelay - (time - _lastInRangeTime))];
						};
					};
				};
			} forEach _playerAircraft;
		};

		sleep _pollingTime;
	};
};

_value;





