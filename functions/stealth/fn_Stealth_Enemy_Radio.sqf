/*
	Function: OKS_fnc_Stealth_Enemy_Radio
	
	Description:
		Creates ambient radio chatter from dead enemy corpses when players are nearby 
		and the enemy side has high awareness of players. Adds immersion to stealth gameplay.
	
	Parameter(s):
		0: SIDE - The enemy faction side (east, west, independent)
	
	Returns:
		Nothing
	
	Example:
		[east] spawn OKS_fnc_Stealth_Enemy_Radio;
*/

params [
	["_EnemyFaction", east, [sideUnknown]]
];

if (!isServer) exitWith {false};

private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];

if (_debug) then {
	format ["[STEALTH] Radio chatter system initialized for faction %1", _EnemyFaction] spawn OKS_fnc_LogDebug;
};

OKS_Radios = [];

OKS_Loop_Radio = {
	params ["_Corpse", "_EnemyFaction"];

	while {!(isNull _Corpse)} do {
		_RandomNumber = random 1;
		_AllMen = allDeadMen;
		_EnemyCorpses = _AllMen select {!alive _x && !isPlayer _x && [_x] call GW_Common_Fnc_getSide == _EnemyFaction && _x isKindOf "Man"};
		_TransmittingCorpses = _EnemyCorpses select {_x getVariable ["OKS_Transmit_Currently", false]};
		
		_Corpse addEventHandler ["Deleted", {
			params ["_entity"];
			OKS_Radios deleteAt (OKS_Radios find _entity);
		}];

		if (!(isNull _Corpse) && 
			{_Corpse distance _x < 15} count allPlayers > 0 && 
			{_Corpse distance _x < 30} count _TransmittingCorpses == 0 && 
			{_EnemyFaction knowsAbout _x > 2.5} count allPlayers > 0) then {

			private _debug = missionNamespace getVariable ["GOL_Stealth_Debug", false];
			if (_debug) then {
				format ["[STEALTH] Playing radio chatter from corpse (player nearby, awareness high)"] spawn OKS_fnc_LogDebug;
			};
			_Corpse setVariable ["OKS_Transmit_Currently", true];
			
			// Determine sound based on nationality setting
			_Nationality = missionNamespace getVariable ["GOL_OKS_Enemy_Nationality", "russian"];
			_SoundFolder = "";
			_SoundFile = "";
			_LastSound = _Corpse getVariable ["OKS_Last_Radio_Sound", ""];
			
			switch (_Nationality) do {
				case "russian": {
					_SoundFolder = "russian";
					_RandomNum = floor(random 19) + 1;
					_SoundFile = "ru-radio-" + str _RandomNum;
					// Prevent same sound twice in a row
					while {_SoundFile == _LastSound} do {
						_RandomNum = floor(random 19) + 1;
						_SoundFile = "ru-radio-" + str _RandomNum;
					};
				};
				case "arabic": {
				// Arabic radio not yet implemented
				["Arabic radio chatter not yet supported. Please use Russian or Vietnamese."] remoteExec ["systemChat", 0];
				_SoundFolder = "";
				_SoundFile = "";
				};
			case "vietnamese": {
				_SoundFolder = "vietnamese";
				_RandomNum = floor(random 5) + 1;
				_SoundFile = "vn-radio-" + str _RandomNum;
				// Prevent same sound twice in a row
				while {_SoundFile == _LastSound} do {
					_RandomNum = floor(random 5) + 1;
					_SoundFile = "vn-radio-" + str _RandomNum;
				};
			};
			default {
				_SoundFolder = "russian";
				_RandomNum = floor(random 19) + 1;
				_SoundFile = "ru-radio-" + str _RandomNum;
				// Prevent same sound twice in a row
				while {_SoundFile == _LastSound} do {
					_RandomNum = floor(random 19) + 1;
					_SoundFile = "ru-radio-" + str _RandomNum;
				};
			};
		};
		// Save the current sound for next check
		_Corpse setVariable ["OKS_Last_Radio_Sound", _SoundFile, true];
		// Use addon path with nationality folder
		if (_SoundFile != "") then {
			playSound3D [format ["\OKS_GOL_Misc\Sounds\Radio\%1\%2.wav", _SoundFolder, _SoundFile], _Corpse, false, getPosASL _Corpse, 2.5, 1, 12];
		};
		
		sleep 5 + (random 5);
			_Corpse setVariable ["OKS_Transmit_Currently", false];

			if (typeName _Corpse isEqualType objNull && OKS_Radios isEqualType []) then {
				OKS_Radios pushBackUnique _Corpse;
			};
			publicVariable "OKS_Radios";
			sleep 60;
		};		
		sleep 10;
		
		if ({_Corpse distance _x < 300} count allPlayers == 0) then {
			deleteVehicle _Corpse;
		};
		sleep 1;
	};
};

waitUntil {sleep 5; {_x isKindOf "Man"} count allDeadMen > 0};

while {true} do {
	if ({_x isKindOf "Man"} count allDeadMen == 0) exitWith {false};
	
	_DeleteCorpses = allDeadMen select {
		_Unit = _x;
		!isPlayer _x &&
		[_x] call GW_Common_Fnc_getSide == _EnemyFaction &&
		_x isKindOf "Man" &&
		{_x distance _Unit < 600} count allPlayers == 0
	};
	{deleteVehicle _x} forEach _DeleteCorpses;
	
	_Corpses = allDeadMen select {!isPlayer _x && [_x] call GW_Common_Fnc_getSide == _EnemyFaction && _x isKindOf "Man"};
	
	if (_debug) then {
		format ["[STEALTH] Radio system checking %1 corpses", count _Corpses] spawn OKS_fnc_LogDebug;
	};
	
	{
		if (!(_x getVariable ["OKS_Transmit", false])) then {
			if (([_x] call GW_Common_Fnc_getSide) == _EnemyFaction) then {
				_x setVariable ["OKS_Transmit", true];
				[_x, _EnemyFaction] spawn OKS_Loop_Radio;
			};
		};
		sleep 1;
	} forEach _Corpses;

	sleep 10;
};
