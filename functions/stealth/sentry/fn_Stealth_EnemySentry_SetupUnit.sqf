/*
	[_Unit] call OKS_fnc_Stealth_EnemySentry_SetupUnit;
*/

params ["_Unit"];

if (count units group _Unit > 1) then {
	private _SingleGroup = createGroup (side _Unit);
	[_Unit] joinSilent _SingleGroup;
};
group _Unit setVariable ["GOL_IsStatic", true, true];
group _Unit setVariable ["acex_headless_blacklist", true, true];
[group _Unit, 70] spawn OKS_fnc_Stealth_EnemyTalk;
_Unit setVariable ["GOL_IsSentry", true, true];
_Unit setVariable ["ace_captives_issurrendering", true, true];
_Unit setCombatMode "GREEN";

if (count waypoints _Unit <= 1) then {
	_Unit disableAI "PATH";
};

if (toLower (unitPos _Unit) isEqualTo "auto" && count waypoints _Unit <= 1) then {
	_Unit setUnitPos selectRandom ["UP", "UP", "UP", "UP", "UP", "MIDDLE"];
};
_Unit setSkill ["commanding", 0];
_Unit setSkill ["spotTime", 0];
_Unit disableAI "AUTOCOMBAT";

_Unit spawn {
	waitUntil { sleep 0.25; !([_this] call ace_common_fnc_isAwake) };
	_this setDamage 1;
};
_Unit spawn {
	sleep 30;
	private _nearEntities = (_this nearEntities ["Man", 5]) select {
		side _X == side _this &&
		!isPlayer _X &&
		_X getVariable ["GOL_IsSentry", false] &&
		_X != _this
	};
	if (count _nearEntities > 0) then {
		private _nearestSentry = selectRandom _nearEntities;
		_this setDir (_this getDir _nearestSentry);
		_this doWatch (getPos _nearestSentry);
	};
};

_Unit addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];

	private _target = selectRandom ((_unit targets [true]) select {
		isPlayer _X &&
		!((vehicle _X) isKindOf "AIR") &&
		!((_X getVariable ["GOL_SelectedRole", [""]] select 0) in ["p", "jetp"])
	});
	private _knowsAbout = _unit knowsAbout _target;
	private _nearbyUnits = (_unit nearEntities ["Man", 300]) select { _X getVariable ["GOL_IsSentry", false] };
	{
		_X reveal [_target, _knowsAbout];
	} forEach _nearbyUnits;
	_unit removeEventHandler [_thisEvent, _thisEventHandler];
}];

_Unit addEventHandler ["Suppressed", {
	params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];

	if (typeName _distance == "SCALAR") then {
		if (_distance < 10 && isPlayer _instigator) then {
			_unit reveal [_shooter, 2.5];
			_unit setBehaviour "COMBAT";
			_unit removeEventHandler [_thisEvent, _thisEventHandler];
		};
	};
}];