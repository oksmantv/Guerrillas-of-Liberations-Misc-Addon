/*

	Civilian Presence Script by Oksman

	Parameters:
	1: Trigger (Object)
	2: Number of Civilians (Number)
	3: Number of Static Civilians (Number)
	4: Count of House Waypoints (Number)
	5: Count of Random Outside Waypoints (Number)
	6: Use Agents? (TRUE/FALSE)
	7: Use Panic Mode? (TRUE/FALSE)
	8: Undercover? (TRUE/FALSE)
	
	Example:
	[Trigger_1,15,5,12,15,false,true] spawn OKS_fnc_Civilians;

*/

if(HasInterface && !isServer) exitWith {};

Params ["_Trigger","_CivilianCount","_StaticCivilianCount","_HouseWaypoints","_RandomWaypoints","_UseAgents","_UsePanicMode",["_UnderCover",false,[false]]];
if(isNil "_Trigger") exitWith {};

Private _Debug_Variable = false;
Private _Spawns = 0;
Private _AllModules = [];

Private _CreateSafeSpot = {
	Params ["_Position","_UseBuilding","_SpawnPosition"];

	_SafeSpot = _Group createUnit ["ModuleCivilianPresenceSafeSpot_F", _Position, [], 0, "NONE"];
	_SafeSpot setVariable ["#capacity",2];
	_SafeSpot setVariable ["#usebuilding",_UseBuilding];
	_SafeSpot setVariable ["#terminal",false];
	_AllModules pushBackUnique _SafeSpot;
	//_m1 setVariable ["#type",5];

	if(_SpawnPosition && _Spawns < 4) then {
		_SpawnSpot = _Group createUnit ["ModuleCivilianPresenceUnit_F", _Position, [], 0, "NONE"];
		_SpawnSpot setPosATL _Position;
		_AllModules pushBackUnique _SpawnSpot;
		_Spawns = _Spawns + 1;
	};
	//if(_Debug_Variable) then { systemChat format ["Created SafeSpot: %1 %2 %3",_Position,_UseBuilding,_SpawnPosition]};
};

Private _CreateStaticCivilian = {
	Params ["_BuildingPositions","_UsePanicMode","_UnderCover"];

	_Group = createGroup civilian;
	_Position = selectRandom _BuildingPositions;
	"[CIV] Static Civilian Spawned" spawn OKS_fnc_LogDebug;
	_StaticCivilian = _Group createUnit ["C_man_polo_1_F", _Position, [], 0, "CAN_COLLIDE"];
	_StaticCivilian setPosATL _Position;
	[_StaticCivilian,"PATH"] remoteExec ["disableAI",0];
	
	private _AnimationLoop = {
		Params ["_Unit","_Stance"];
		[_Unit,_Stance] remoteExec ["setUnitPos",0];
		private _Animations = [];
		switch (_Stance) do {
			case "middle": { 
				_Animations = ["ApanPknlMstpSnonWnonDnon_G01","ApanPknlMstpSnonWnonDnon_G02","ApanPknlMstpSnonWnonDnon_G03"];
			};
			case "up": { 
				_Animations = ["ApanPercMstpSnonWnonDnon_G01","ApanPercMstpSnonWnonDnon_G02","ApanPercMstpSnonWnonDnon_G03"];
			};
			default { 
				_Animations = ["ApanPknlMstpSnonWnonDnon_G01","ApanPknlMstpSnonWnonDnon_G02","ApanPknlMstpSnonWnonDnon_G03"];
				[_Unit,"middle"] remoteExec ["setUnitPos",0];
			};
		};

		waitUntil{sleep 10; behaviour _unit == "COMBAT"};
		_Animation = selectRandom _Animations;
		_Unit switchMove _Animation;
		_Unit setVariable ["Loop_Animation", _Animation, true];
		_Unit addEventHandler ["AnimDone", { 
			params[ "_Unit", "_anim" ]; 
			_Animation = _Unit getVariable ["Loop_Animation",""];
			if (_anim == _Animation ) then { 
				_Unit playMove _Animation; 
			}; 
		}]; 
		_Unit disableAI "ANIM";	
	};

	if(_UsePanicMode) then {
		[_StaticCivilian,selectRandom["middle","up","middle","middle"]] spawn _AnimationLoop;
	} else {
		[_StaticCivilian,"UP"] remoteExec ["setUnitPos",0];
	};

	if(_UnderCover) then {
		[_StaticCivilian] spawn OKS_fnc_UndercoverAI;
	};

	
};

if(_Debug_Variable) then {
	format ["[CIV] Civilian Initiated.."] spawn OKS_fnc_LogDebug;
};

_Group = createGroup civilian;

_Area = (TriggerArea _Trigger);
_Size = (_Area#0) max (_Area#1);
_Buildings = nearestObjects [_Trigger, ["House"], _Size];
_InArea = _Buildings inAreaArray _Trigger;
_InAreaStatic = _Buildings inAreaArray _Trigger;

if(_RandomWaypoints > 0) then {
	For "_i" from 0 to _RandomWaypoints do
	{
		_RandomPos = _Trigger call BIS_fnc_randomPosTrigger;
		_SafePos = [_RandomPos, 1, 100, 3, 0, 0, 0] call BIS_fnc_findSafePos;

		if(_HouseWaypoints <= 0) then {
			[_SafePos,false,true] call _CreateSafeSpot
		} else {
			[_SafePos,false,false] call _CreateSafeSpot
		};
	};
};

if (_StaticCivilianCount > 0) then {
    for "_i" from 0 to _StaticCivilianCount do {
        if (count _InAreaStatic == 0) exitWith {
            "[CIV] No valid buildings remaining" spawn OKS_fnc_LogDebug;
        };

        private _House = selectRandom _InAreaStatic;
        if (isNil "_House") exitWith {};

        private _BuildingPositions = _House buildingPos -1;
        private _validPositions = [];

        {
            private _pos = _x;
            // Check that the position isn't [0,0,0] and is not occupied by any unit
            if (!(_pos isEqualTo [0,0,0]) && {count (nearestObjects [_pos, ["Man"], 0.5]) == 0}) then {
                _validPositions pushBack _pos;
            };
        } forEach _BuildingPositions;

        if (count _validPositions == 0) then {
            if (_House in _InAreaStatic) then {
                _InAreaStatic deleteAt (_InAreaStatic find _House);
                format ["[CIV] Removed building %1 with no valid positions", _House] spawn OKS_fnc_LogDebug;
            };
            _i = _i - 1; // Retry for this civilian
            continue;
        };

        // Spawn civilian at a random valid position
        [_validPositions, _UsePanicMode,_UnderCover] call _CreateStaticCivilian;

        // Optionally remove building to avoid re-use
        if (count _InAreaStatic > _StaticCivilianCount) then {
            if (_House in _InAreaStatic) then {
                _InAreaStatic deleteAt (_InAreaStatic find _House);
            };
        };
    };
};

if(_HouseWaypoints > 0) then {
	For "_i" from 0 to _HouseWaypoints do
	{
		_House = selectRandom _InArea;
		if(isNil "_House") exitWith {};
		_InArea deleteAt (_InArea find _House);
		[getPos _House,true,true] call _CreateSafeSpot;
	};
};

if(_Debug_Variable) then { 
	format ["[CIV] Creating Civilian Module.."] spawn OKS_fnc_LogDebug;
};
if(_CivilianCount > 0) then {
	_Module = _Group createUnit ["ModuleCivilianPresence_F", [0,0,0], [], 0, "NONE"];
	_Trigger setVariable ["GOL_Civilians_Module", _Module, true];

	_AllModules pushBackUnique _Module;
	_Module setVariable ["#area",[getPos _Trigger,_Area#0,_Area#1,0,true,-1]];  // Fixed! this gets passed to https://community.bistudio.com/wiki/inAreaArray
	_Module setVariable ["#debug",_Debug_Variable]; // Debug mode on
	_Module setVariable ["#unitcount",_CivilianCount];
	if(_Undercover) then {
		if(_Debug_Variable) then { 
			format ["[UNDERCOVER] Undercover: %1",_Trigger] spawn OKS_fnc_LogDebug
		};
		_Module setVariable ["#onCreated",{
			format["[Undercover] Undercover Spawned %1",_this] spawn OKS_fnc_LogDebug;
			_this setVariable ["GOL_UndercoverAI",true,true];
			_this setVariable ["GOL_NonCombatant", true, true];
			[_this] spawn OKS_fnc_UndercoverAI;
		}];
		_Module setVariable ["#useagents",false];
		_Module setVariable ["#usepanicmode",false];
	} else {
		_Module setVariable ["#onCreated",{
			format["[CIV] Civilian Spawned %1",_this] spawn OKS_fnc_LogDebug;
			_this setVariable ["GOL_NonCombatant", true, true];
		}];
		_Module setVariable ["#useagents",_UseAgents];
		_Module setVariable ["#usepanicmode",_UsePanicMode];
	};
};
if(_Debug_Variable) then { format ["[UNDERCOVER] Area %1 - %2 - Count %3",_Area#0,_Area#1,_CivilianCount] spawn OKS_fnc_LogDebug};