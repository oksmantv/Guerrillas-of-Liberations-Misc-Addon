/*
	Function: OKS_fnc_Stealth_Enemy_Talk
	
	Description:
		Adds ambient enemy dialogue system that plays contextual voice sounds 
		when players are near enemy units, enhancing stealth immersion.
	
	Parameter(s):
		0: GROUP - The enemy group that will talk
		1: NUMBER (Optional) - Distance to detect players (default: 125)
		2: NUMBER (Optional) - Chance to talk when conditions met (default: 1)
		3: ARRAY (Optional) - Min/Max delay between talks in seconds (default: [9, 14])
		4: NUMBER (Optional) - Loop delay to check nearby players (default: 5)
		5: BOOL (Optional) - Should static units talk (default: true)
	
	Returns:
		Nothing
	
	Example:
		[group this] spawn OKS_fnc_Stealth_Enemy_Talk;
		[group this, 150, 0.8, [10, 20], 5, false] spawn OKS_fnc_Stealth_Enemy_Talk;
*/

params [
	["_Group", grpNull, [grpNull]],
	["_Distance", missionNamespace getVariable ["GOL_OKS_Talk_Distance", 125], [0]],
	["_Chance", missionNamespace getVariable ["GOL_OKS_Talk_Chance", 1], [0]],
	["_MinMaxDelayBetweenTalks", [missionNamespace getVariable ["GOL_OKS_Talk_MinDelay", 9], missionNamespace getVariable ["GOL_OKS_Talk_MaxDelay", 14]], [[]]],
	["_LoopDelayToCheckNearby", missionNamespace getVariable ["GOL_OKS_Talk_LoopDelay", 5], [0]],
	["_ShouldTalkAsStaticUnits", missionNamespace getVariable ["GOL_OKS_Talk_AllowStatic", true], [true]]
];

if (!isServer) exitWith {false};

private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];

if (_debug) then {
	format ["[STEALTH] Enemy Talk initialized for group %1", groupId _Group] spawn OKS_fnc_LogDebug;
};

// Store the initial group for validation
private _initialGroup = _Group;

OKS_Enemy_Speak = {
	params ["_Group", "_Distance", "_Chance", "_MinMaxDelayBetweenTalks", "_ShouldTalkAsStaticUnits", "_InitialGroup"];
	private ["_Delay", "_SoundFileName", "_debug"];
	_debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];
	
	// Check if any unit's group has changed - if so, exit this loop
	private _groupChanged = false;
	{
		if (group _x != _InitialGroup) then {
			_groupChanged = true;
		};
	} forEach units _InitialGroup;
	
	if (_groupChanged) exitWith {
		if (_debug) then {
			private _currentGroups = [];
			{_currentGroups pushBackUnique (groupId group _x)} forEach units _InitialGroup;
			format ["[STEALTH] Group %1 changed (units now in: %2), exiting talk loop", groupId _InitialGroup, _currentGroups] spawn OKS_fnc_LogDebug;
		};
	};
	
	if (_Group getVariable ["GOL_IsStatic", false] && !(_ShouldTalkAsStaticUnits)) exitWith {
		if (_debug) then {
			format ["[STEALTH] Group %1 is static and talk disabled for static units", groupId _Group] spawn OKS_fnc_LogDebug;
		};
	};
	if ({alive _x} count units _Group == 0) exitWith {
		if (_debug) then {
			format ["[STEALTH] Group %1 has no alive units", groupId _Group] spawn OKS_fnc_LogDebug;
		};
	};
	if ({behaviour _x == "COMBAT"} count units _Group > 0) exitWith {
		if (_debug) then {
			format ["[STEALTH] Group %1 in combat, not talking", groupId _Group] spawn OKS_fnc_LogDebug;
		};
	};
	if (_Group getVariable ["OKS_Talking_Currently", false]) exitWith {};
	if (
		{
			_Unit = _x;
			{_Unit distance _x < _Distance} count allPlayers > 0
		} count units _Group == 0
	) exitWith {};

	_NearestViableArray = [];
	{
		_GroupUnit = _x;
		if (alive _GroupUnit) then {
			{
				if (isPlayer _x && _GroupUnit distance _x < _Distance) then {
					_InfoArray = [_x, _GroupUnit, _GroupUnit distance _x];
					_NearestViableArray pushBackUnique _InfoArray;
				};
			} forEach allPlayers;
		};
	} forEach units _Group;

	if (count _NearestViableArray == 0) exitWith {};
	
	// Set talking flag immediately to prevent multiple instances
	if (_Group getVariable ["OKS_Talking_Currently", false]) exitWith {};
	
	// Check if any nearby units are currently talking (within 30m)
	_NearbyTalking = false;
	{
		if (_x getVariable ["OKS_Talking_Currently", false]) exitWith {
			_NearbyTalking = true;
		};
	} forEach (leader _Group nearEntities [["Man"], 30] select {!isPlayer _x && side _x == side _Group});
	
	if (_NearbyTalking) exitWith {
		if (_debug) then {
			format ["[STEALTH] %1 - Nearby unit already talking, skipping", groupId _Group] spawn OKS_fnc_LogDebug;
		};
	};
	
	_Group setVariable ["OKS_Talking_Currently", true, true];
	
	_Dice = random 1;
	if (_Dice < _Chance) then {
		(_NearestViableArray select 0) params ["_Player", "_Enemy", "_Distance"];
		
		// Determine sound based on nationality setting
		_Nationality = missionNamespace getVariable ["GOL_OKS_Enemy_Nationality", "russian"];
		_SoundFolder = "";
		_SoundFileName = "";
		_LastSound = _Group getVariable ["OKS_Last_Talk_Sound", ""];
		
		switch (_Nationality) do {
			case "russian": {
				_SoundFolder = "russian";
				_RandomNum = floor(random 22) + 1;
				_SoundFileName = "ru-talk-" + str _RandomNum;
				// Prevent same sound twice in a row
				while {_SoundFileName == _LastSound} do {
					_RandomNum = floor(random 22) + 1;
					_SoundFileName = "ru-talk-" + str _RandomNum;
				};
			};
			case "arabic": {
				// Arabic dialogue not yet implemented
				["Arabic enemy dialogue not yet supported. Please use Russian or Vietnamese."] remoteExec ["systemChat", 0];
				_SoundFolder = "";
				_SoundFileName = "";
			};
			case "vietnamese": {
				_SoundFolder = "vietnamese";
				_RandomNum = floor(random 30) + 1;
				_SoundFileName = "vn-talk-" + str _RandomNum;
				// Prevent same sound twice in a row
				while {_SoundFileName == _LastSound} do {
					_RandomNum = floor(random 30) + 1;
					_SoundFileName = "vn-talk-" + str _RandomNum;
				};
			};
			default {
				_SoundFolder = "russian";
				_RandomNum = floor(random 22) + 1;
				_SoundFileName = "ru-talk-" + str _RandomNum;
				// Prevent same sound twice in a row
				while {_SoundFileName == _LastSound} do {
					_RandomNum = floor(random 22) + 1;
					_SoundFileName = "ru-talk-" + str _RandomNum;
				};
			};
		};
		
		// Save the current sound for next check
		_Group setVariable ["OKS_Last_Talk_Sound", _SoundFileName, true];
		
		if (_debug) then {
			format ["[STEALTH] %1 (%2 | %3) - Talk: %4, distance: %5m", groupId _Group, name _Enemy, str _Enemy, _SoundFileName, _Distance toFixed 0] spawn OKS_fnc_LogDebug;
		};
		
		// Set all nearby sentries within 100m to combat when unit talks
		_NearbySentries = (_Enemy nearEntities ["Man", 100]) select {
			!isPlayer _x && 
			side _x == side _Group && 
			alive _x && 
			(_x getVariable ["GOL_IsStatic", false]) &&
			behaviour _x != "COMBAT"
		};
		
		{
			_x setBehaviour "COMBAT";
			if (_debug) then {
				format ["[STEALTH] Setting nearby sentry %1 to COMBAT (heard talk from %2)", _x, groupId _Group] spawn OKS_fnc_LogDebug;
			};
		} forEach _NearbySentries;
		
		if (_SoundFileName != "") then {
			if (_Distance > 50) then {
				playSound3D [format ["\OKS_GOL_Misc\Sounds\Talk\%1\%2.wav", _SoundFolder, _SoundFileName], _Enemy, false, getPosASL _Enemy, 5, 1, 150];		
			} else {
				playSound3D [format ["\OKS_GOL_Misc\Sounds\Talk\%1\%2.wav", _SoundFolder, _SoundFileName], _Enemy, false, getPosASL _Enemy, 2.5, 1, 100];		
			};
		};
		
		// Sleep to prevent sound overlap (most voice lines are 3-5 seconds)
		sleep 6;
		
		// Additional delay between talks
		_MinMaxDelayBetweenTalks params ["_Min", "_Max"];
		_Mid = _Max - _Min;
		_Delay = (_Min + (random _Mid));
		sleep _Delay;
	} else {
		// Even if we don't talk, wait a bit before next check
		sleep 3;
	};

	_Group setVariable ["OKS_Talking_Currently", false, true];
};

while {{alive _x} count units _Group > 0} do {
	[_Group, _Distance, _Chance, _MinMaxDelayBetweenTalks, _ShouldTalkAsStaticUnits, _initialGroup] spawn OKS_Enemy_Speak;
	sleep _LoopDelayToCheckNearby;
};
