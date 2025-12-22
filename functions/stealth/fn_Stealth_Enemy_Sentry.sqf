/*
	Function: OKS_fnc_Stealth_Enemy_Sentry
	
	Description:
	Creates a sentry/guard unit that detects players and triggers hunt responses.
	When player is detected, sentry alerts nearby units and can call reinforcements.
	Includes radio requirement mechanics and LAMBS AI integration.
	
	Parameter(s):
	0: OBJECT or ARRAY - Unit to convert to sentry, or position to spawn sentry at
	1: side - side of the sentry unit (default: east)
	2: NUMBER - Chance for radio equipment (0-1, default: 0.25)
	3: BOOL - Requires radio to call hunt (default: true)
	4: BOOL - Should set nearby groups to hunt (default: false)
	5: NUMBER - Range to find hunter groups (default: 500)
	6: NUMBER - Hunt tracking range (default: 500)
	7: STRING (Optional) - Variable name to set to true when player detected
	
	Returns:
	Nothing
	
	Example:
	[this, east, 0.3, true, true, 1000, 500] spawn OKS_fnc_Stealth_Enemy_Sentry;
	[getPos this, independent, 0.5, false, true, 800, 600, "Hunt_1"] spawn OKS_fnc_Stealth_Enemy_Sentry;
*/

if (!isServer) exitWith {};

params [
	["_Unit", objNull, [objNull, []]],
	["_Side", east, [sideUnknown]],
	["_ChanceForRadioEquipment", 0.25, [0]],
	["_RequiresRadioToCallHunt", true, [true]],
	["_ShouldSetNearbyToHunt", false, [true]],
	["_NearbyHunterRange", 500, [0]],
	["_HuntRange", 500, [0]],
	["_Variable", nil, [""]]
];

private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];

if (_debug) then {
	format ["[STEALTH] Sentry function called for %1 (group: %2)", _Unit, if (_Unit isEqualType objNull) then {
		groupId group _Unit
	} else {
		"position array"
	}] spawn OKS_fnc_LogDebug;
};

// if _Unit is an object (not a position array), check if sentry already applied
if (_Unit isEqualType objNull && !isNull _Unit) then {
	if (_Unit getVariable ["OKS_Sentry_Applied", false]) exitWith {
		if (_debug) then {
			format ["[STEALTH] Sentry already applied to %1 (group: %2), exiting", _Unit, groupId group _Unit] spawn OKS_fnc_LogDebug;
		};
	};
	if (_debug) then {
		format ["[STEALTH] Setting OKS_Sentry_Applied flag on %1 (group: %2)", _Unit, groupId group _Unit] spawn OKS_fnc_LogDebug;
	};
	_Unit setVariable ["OKS_Sentry_Applied", true, true];
};

if (_debug) then {
	format ["[STEALTH] Sentry initialized: %1 (Side: %2, group: %3)", _Unit, _Side, if (_Unit isEqualType objNull) then {
		groupId group _Unit
	} else {
		"new unit"
	}] spawn OKS_fnc_LogDebug;
};

private ["_Units", "_Dice", "_Leaders", "_NearFriendlies", "_RadioNearby"];

switch (_Side) do {
	case blufor: {
		_Leaders = ["B_Soldier_SL_F"];
		_Units = [
			"B_Soldier_A_F", "B_Soldier_AR_F", "B_Soldier_AR_F",
			"B_medic_F", "B_medic_F", "B_Soldier_GL_F",
			"B_HeavyGunner_F", "B_soldier_M_F",
			"B_Soldier_F", "B_Soldier_F", "B_Soldier_F", "B_Soldier_LAT_F"
		];
	};
	case opfor: {
		_Leaders = ["O_Soldier_SL_F"];
		_Units = [
			"O_Soldier_A_F", "O_Soldier_AR_F", "O_Soldier_AR_F",
			"O_medic_F", "O_medic_F", "O_Soldier_GL_F",
			"O_HeavyGunner_F", "O_soldier_M_F",
			"O_Soldier_F", "O_Soldier_F", "O_Soldier_F", "O_Soldier_LAT_F"
		];
	};
	case independent: {
		_Leaders = ["I_Soldier_SL_F"];
		_Units = [
			"I_Soldier_A_F", "I_Soldier_AR_F", "I_Soldier_AR_F",
			"I_medic_F", "I_medic_F", "I_Soldier_GL_F",
			"I_HeavyGunner_F", "I_soldier_M_F",
			"I_Soldier_F", "I_Soldier_F", "I_Soldier_F", "I_Soldier_LAT_F"
		];
	};
	default {
		_Units = "";
	};
};

// Handle different input types for _Unit parameter
if (typeName _Unit isEqualTo "ARRAY") then {
	_Pos = _Unit;
	_UnitClass = selectRandom _Units;
	_Group = createGroup _Side;

	_Dice = random 1;
	if (_Dice < _ChanceForRadioEquipment && _RequiresRadioToCallHunt) then {
		_Unit = _Group createUnit [selectRandom _Leaders, _Pos, [], 0, "CAN_COLLIDE"];
		_Unit setVariable ["GOL_HasRadio", true, true];
	} else {
		_Unit = _Group createUnit [_UnitClass, _Pos, [], 0, "CAN_COLLIDE"];
	};
	_Unit setRank "PRIVATE";
	_Unit setDir (random 360);
} else {
	if (_Unit isKindOf "Man") then {
		// Mark unit as processed BEFORE moving to new group to prevent event handler re-triggering
		if (_debug) then {
			format ["[STEALTH] Setting OKS_Stealth_Applied on %1 before group split (current group: %2)", _Unit, groupId group _Unit] spawn OKS_fnc_LogDebug;
		};
		_Unit setVariable ["OKS_Stealth_Applied", true, true];

		if (count units group _Unit > 1) then {
			private _oldGroup = groupId group _Unit;
			_SingleGroup = createGroup (side _Unit);
			[_Unit] joinSilent _SingleGroup;
			if (_debug) then {
				format ["[STEALTH] Split %1 from group %2 to new group %3", _Unit, _oldGroup, groupId _SingleGroup] spawn OKS_fnc_LogDebug;
			};
		};
		if (typeOf _Unit in _Leaders) then {
			_Unit setVariable ["GOL_HasRadio", true, true];
		};
	} else {
		_Pos = getPosATL _Unit;
		_PosObject = _Unit;
		_UnitClass = selectRandom _Units;
		_Group = createGroup _Side;

		_Dice = random 1;
		if (_Dice < _ChanceForRadioEquipment && _RequiresRadioToCallHunt) then {
			_Unit = _Group createUnit [selectRandom _Leaders, _Pos, [], 0, "CAN_COLLIDE"];
			_Unit setVariable ["GOL_HasRadio", true, true];
		} else {
			_Unit = _Group createUnit [_UnitClass, _Pos, [], 0, "CAN_COLLIDE"];
		};
		_Unit setRank "PRIVATE";
		_Unit setDir (getDir _PosObject);
		_Unit setFormDir (getDir _PosObject);
		_Unit doWatch (_Unit getPos [15, (getDir _Unit)]);
		_Unit lookAt (_Unit getPos [15, (getDir _Unit)]);

		deleteVehicle _PosObject;
	}
};

group _Unit setVariable ["GOL_IsStatic", true, true];
group _Unit setVariable ["acex_headless_blacklist", true, true];

if (count waypoints _Unit <= 1) then {
	_Unit disableAI "PATH";
};
_Unit setUnitPos selectRandom ["UP", "MIDDLE"];
_Unit setSkill ["spotDistance", 0.5];
_Unit setSkill ["spotTime", 0.5];
_Unit setSkill ["general", 0.4];

// Remove weapon lights/lasers from sentries
_Unit enableGunLights "forceOff";
{
	private _weapon = _x;
	private _attachments = _Unit weaponAccessories _weapon;
	if (count _attachments > 0) then {
		private _pointer = _attachments select 1; // Index 1 is pointer/light slot
		if (_pointer != "") then {
			_Unit removePrimaryWeaponItem _pointer;
		};
	};
} forEach weapons _Unit;

// Enable ambient talking for sentry if not already applied
if (!(group _Unit getVariable ["OKS_Talk_Applied", false])) then {
	if (_debug) then {
		format ["[STEALTH] Spawning talk for sentry %1 (group: %2)", _Unit, groupId group _Unit] spawn OKS_fnc_LogDebug;
	};
	_LoopDelay = (missionNamespace getVariable ["GOL_OKS_Talk_LoopDelay", 5]) * 2;
	[group _Unit, nil, nil, nil, _LoopDelay] spawn OKS_fnc_Stealth_Enemy_Talk;
	group _Unit setVariable ["OKS_Talk_Applied", true, true];
} else {
	if (_debug) then {
		format ["[STEALTH] Talk already applied to group %1 for sentry %2", groupId group _Unit, _Unit] spawn OKS_fnc_LogDebug;
	};
};

waitUntil {
	sleep 2;
	{
		_Unit knowsAbout _x > 3.99
	} count allPlayers > 0
};
diag_log "OKS Stealth: Sentry detected player";

// Determine sound based on nationality setting
_Nationality = missionNamespace getVariable ["GOL_OKS_Enemy_Nationality", "russian"];
_SoundFolder = "";

switch (_Nationality) do {
	case "russian": {
		_SoundFolder = "russian";
	};
	case "arabic": {
		_SoundFolder = "arabic";
	};
	case "vietnamese": {
		_SoundFolder = "vietnamese";
	};
	default {
		_SoundFolder = "russian";
	};
};

if (alive _Unit && [_Unit] call ace_common_fnc_isAwake) then {
	// Alert shout
	if (_debug) then {
		format ["[STEALTH] Sentry %1 detected player! Playing alert sound", _Unit] spawn OKS_fnc_LogDebug;
	};
	_SoundFileName = "";
	_LastSound = _Unit getVariable ["OKS_Last_Alert_Sound", ""];
	switch (_Nationality) do {
		case "russian": {
			_RandomNum = floor(random 15) + 1;
			_SoundFileName = "ru-alert-" + str _RandomNum;
			// Prevent same sound twice in a row
			while { _SoundFileName == _LastSound } do {
				_RandomNum = floor(random 15) + 1;
				_SoundFileName = "ru-alert-" + str _RandomNum;
			};
		};
		case "arabic": {
			// Arabic alerts not yet implemented
			["Arabic sentry alerts not yet supported. Please use Russian or Vietnamese."] remoteExec ["systemChat", 0];
			_SoundFileName = "";
		};
		case "vietnamese": {
			_RandomNum = floor(random 6) + 1;
			_SoundFileName = "vn-alert-" + str _RandomNum;
			// Prevent same sound twice in a row
			while { _SoundFileName == _LastSound } do {
				_RandomNum = floor(random 6) + 1;
				_SoundFileName = "vn-alert-" + str _RandomNum;
			};
		};
		default {
			_RandomNum = floor(random 15) + 1;
			_SoundFileName = "ru-alert-" + str _RandomNum;
			// Prevent same sound twice in a row
			while { _SoundFileName == _LastSound } do {
				_RandomNum = floor(random 15) + 1;
				_SoundFileName = "ru-alert-" + str _RandomNum;
			};
		};
	};
	_Unit setVariable ["OKS_Last_Alert_Sound", _SoundFileName, true];
	if (_SoundFileName != "") then {
		playSound3D [format ["\OKS_GOL_Misc\Sounds\Talk\%1\%2.wav", _SoundFolder, _SoundFileName], _Unit, false, getPosASL _Unit, 5, 1, 150];
	};
};

sleep 5;

if (alive _Unit && [_Unit] call ace_common_fnc_isAwake) then {
	_RadioNearby = false;
	_HasRadioAccess = false;

	// Check radio access
	if (_Unit getVariable ["GOL_HasRadio", false]) then {
		_HasRadioAccess = true;
	};
	if (_RequiresRadioToCallHunt) then {
		_NearFriendliesWithRadio = (_Unit nearEntities ["Man", 300]) select {
			!isPlayer _x &&
			side _x == _Side &&
			(_x getVariable ["GOL_HasRadio", false] isEqualTo true) &&
			alive _x &&
			[_x] call ace_common_fnc_isAwake
		};
		if (count _NearFriendliesWithRadio > 0) then {
			_RadioNearby = true;
			_HasRadioAccess = true;
		};
	};

	// set nearby sentries to combat based on radio access
	if (_HasRadioAccess) then {
		// Has radio: alert sentries within hunt range
		_NearbySentries = (_Unit nearEntities ["Man", _HuntRange]) select {
			!isPlayer _x &&
			side _x == _Side &&
			alive _x &&
			(_x getVariable ["GOL_IsStatic", false])
		};

		{
			_x setBehaviour "COMBAT";
			group _x setBehaviour "COMBAT";
			if (_debug) then {
				format ["[STEALTH] Setting nearby sentry %1 (group: %2) to COMBAT (within hunt range %3m)", _x, groupId group _x, _HuntRange] spawn OKS_fnc_LogDebug;
			};
		} forEach _NearbySentries;
	} else {
		// No radio: only alert sentries within 100m
		_NearbySentries100m = (_Unit nearEntities ["Man", 100]) select {
			!isPlayer _x &&
			side _x == _Side &&
			alive _x &&
			(_x getVariable ["GOL_IsStatic", false])
		};

		{
			_x setBehaviour "COMBAT";
			group _x setBehaviour "COMBAT";
			if (_debug) then {
				format ["[STEALTH] Setting nearby sentry %1 (group: %2) to COMBAT (within 100m, no radio)", _x, groupId group _x] spawn OKS_fnc_LogDebug;
			};
		} forEach _NearbySentries100m;
	};

	if (_RequiresRadioToCallHunt && !_HasRadioAccess) exitWith {
		if (_debug) then {
			format ["[STEALTH] Sentry %1 has no radio access - cannot call reinforcements", _Unit] spawn OKS_fnc_LogDebug;
		};
	};

	if (_debug) then {
		format ["[STEALTH] Sentry %1 calling for reinforcements (HasRadio: %2, RadioNearby: %3)", _Unit, _Unit getVariable ["GOL_HasRadio", false], _RadioNearby] spawn OKS_fnc_LogDebug;
	};

	// Radio call for reinforcements
	_RadioFileName = "";
	_LastSound = _Unit getVariable ["OKS_Last_Call_Sound", ""];
	switch (_Nationality) do {
		case "russian": {
			_RandomNum = floor(random 3) + 1;
			_RadioFileName = "ru-call-" + str _RandomNum;
			// Prevent same sound twice in a row
			while { _RadioFileName == _LastSound } do {
				_RandomNum = floor(random 3) + 1;
				_RadioFileName = "ru-call-" + str _RandomNum;
			};
		};
		case "arabic": {
			// Arabic radio calls not yet implemented - skip notification (already shown for alerts)
			_RadioFileName = "";
		};
		case "vietnamese": {
			_RandomNum = floor(random 5) + 1;
			_RadioFileName = "vn-call-" + str _RadioNum;
			// Prevent same sound twice in a row
			while { _RadioFileName == _LastSound } do {
				_RandomNum = floor(random 5) + 1;
				_RadioFileName = "vn-call-" + str _RandomNum;
			};
		};
		default {
			_RandomNum = floor(random 3) + 1;
			_RadioFileName = "ru-call-" + str _RandomNum;
			// Prevent same sound twice in a row
			while { _RadioFileName == _LastSound } do {
				_RandomNum = floor(random 3) + 1;
				_RadioFileName = "ru-call-" + str _RandomNum;
			};
		};
	};
	_Unit setVariable ["OKS_Last_Call_Sound", _RadioFileName, true];
	if (_RadioFileName != "") then {
		playSound3D [format ["\OKS_GOL_Misc\Sounds\Talk\%1\%2.wav", _SoundFolder, _RadioFileName], _Unit, false, getPosASL _Unit, 5, 1, 150];
	};
	if (!isNil "_Variable") then {
		diag_log format ["OKS Stealth: %1 set to true", _Variable];
		call compile format ["%1 = true;
		publicVariable '%1'", _Variable];
	};

	if (_ShouldSetNearbyToHunt isEqualType _Side) exitWith {
		diag_log format ["OKS Stealth: Broken variables for unit: %1. Exiting..", _Unit];
	};

	if (!(isNil "lambs_wp_fnc_taskHunt") && _ShouldSetNearbyToHunt) then {
		_EnemyGroups = [];
		{
			if (side _x == [_Unit] call GW_Common_Fnc_getSide && leader _x distance2D _Unit < _NearbyHunterRange) then {
				_EnemyGroups pushBackUnique _x
			}
		} forEach allGroups;

		{
			if (!(_x getVariable ["LAMBS_HUNTING", false]) && !(_x getVariable ["GOL_IsStatic", false])) then {
				_x setVariable ["LAMBS_HUNTING", true, true];
				_x setBehaviour "AWARE";
				_x setSpeedMode "FULL";
				{
					[_x, "FSM"] remoteExec ["disableAI", 0]
				} forEach units _x;
				[_x, _HuntRange, 15, [], getPos _Unit, true, false, true] remoteExec ["lambs_wp_fnc_taskHunt", 0];
			};
		} forEach _EnemyGroups;
	} else {
		_EnemyGroups = [];
		{
			if (side _x == [_Unit] call GW_Common_Fnc_getSide &&
			leader _x distance2D _Unit < _NearbyHunterRange &&
			!(_x getVariable ["LAMBS_HUNTING", false]) &&
			!(_x getVariable ["GOL_IsStatic", false])) then {
				_EnemyGroups pushBackUnique _x
			}
		} forEach allGroups;

		{
			if (!(_x getVariable ["LAMBS_HUNTING", false]) && !(_x getVariable ["GOL_IsStatic", false])) then {
				_Group = _x;
				_Group setVariable ["LAMBS_HUNTING", true, true];
				_Group setBehaviour "AWARE";
				_Group setSpeedMode "FULL";
				{
					_x disableAI "FSM";
					_x enableAttack false
				} forEach units _Group;

				diag_log format ["OKS Stealth: %1 responding to hunt", _Group];

				while { (count (waypoints _Group)) > 0 } do {
					deleteWaypoint ((waypoints _Group) select 0);
				};

				_DetectedPlayer = selectRandom (allPlayers select {
					(getPos _Unit) distance _x < 200 && (side _Unit) knowsAbout _x > 3.5
				});

				if (isNil "_DetectedPlayer") then {
					_DetectedPlayer = _Unit
				};

				private _WP = _Group addWaypoint [getPos _DetectedPlayer, 30];
				_WP setWaypointBehaviour "AWARE";
				_WP setWaypointSpeed "FULL";

				// Flare
				_Position = getPosATL (leader _Group);
				_Temp = createVehicle ["F_40mm_Red", [(_Position select 0), (_Position select 1), ((_Position select 2) + 140)], [], 20, "CAN_COLLIDE"];
				_Temp setVelocity [0, 0, -10];
				sleep 3;
				playSound3D ["A3\Sounds_F\weapons\Flare_Gun\flaregun_2_shoot.wss", (leader _Group), false, [(_Position select 0), (_Position select 1), (_Position select 2)], 8, 1, 300];
				_Group setVariable ["OKS_isTracking", true, true];

				[_Group, _WP, _DetectedPlayer, _NearbyHunterRange] spawn {
					params ["_Group", "_WP", "_DetectedPlayer", "_NearbyHunterRange"];
					waitUntil {
						sleep 5;
						{
							_x distance (getWPPos _WP) < 25
						} count units _Group > 0
					};

					[_Group, getPos _DetectedPlayer, _NearbyHunterRange, 5, [], true, true] call lambs_wp_fnc_taskPatrol;
					_Group setVariable ["OKS_isTracking", false, true];
				};
			}
		} forEach _EnemyGroups;
	};
};