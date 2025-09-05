/*
	[intel_1,destroy_1,"Task_Intel",nil,nil] spawn OKS_fnc_SetupIntel;

	"ENEMY INTEL\nYou have found intel regarding enemy assets.\n\n%1\n%2"

	\n = New Line.
	%1 = Inserted Parameter (%1 or %2).
	_CustomText Parameter: %1 is the assets list specified in the _Target Parameter.
	_CustomText Parameter: %2 is the Custom Details parameter.
	_CustomHeader is the header text for the intel item. If left nil, it will be set to "Intel #X" where X is the number of intel items created so far + 1.
	_CustomDetails is the text that will be inserted in the _CustomText parameter as %2.
*/

	Params [
		["_IntelPiece",[],[[],grpNull,objNull]],
		["_Target",nil,[objNull,[]]],
		["_Parent",nil,[""]],
		["_CustomText","ENEMY INTEL\nYou have found intel regarding enemy assets.\n\n%1\n\n%2",[""]],
		["_CustomHeader", nil, [""]],
		["_CustomDetails", "", [""]]
	];
	Private ["_AssetText","_AssetList"];

	_IntelPiece setVariable ["GOL_TargetIntel",_Target,true];
	_AllIntel = missionNamespace getVariable ["GOL_IntelPieces",[]];
	_AllIntel pushBack _IntelPiece;
	missionNamespace setVariable ["GOL_IntelPieces",_AllIntel,true];

	_GetKeyPadPosition = {
		Params ["_Position"];
		_gridX = floor(_Position select 0 / 100);
		_gridY = floor(_Position select 1 / 100);
		_withinGridX = (_Position select 0) % 100;
		_withinGridY = (_Position select 1) % 100;
		_keypadX = floor(_withinGridX / 33.33);
		_keypadY = floor(_withinGridY / 33.33);
		_keypadNum = 1 + _keypadY * 3 + _keypadX;
		_keypadNum;
	};

	_TaskPosition = getPos _IntelPiece;

	if(typeName _Target == "OBJECT") then {
		if(_target isKindOf "Man") then {
			private _ManType = "Enemy HVT";
			_FriendlySide = missionNameSpace getVariable ["GOL_Friendly_Side",(side group player)];
			if(side group _target == civilian || (side group _target) getFriend _FriendlySide > 0.6) then {
				_ManType = "Friendly HVT";
			};
			_AssetList = format["%4: %1\nGrid: %2 - Keypad: %3",name _Target, mapGridPosition getPos _Target, [getPos _Target] call _GetKeyPadPosition, _ManType];
		} else {
			_AssetList = format["%1\nGrid: %2 - Keypad: %3",[configFile >> "CfgVehicles" >> typeOf _Target] call BIS_fnc_displayName, mapGridPosition (getPos _Target), [getPos _Target] call _GetKeyPadPosition];
		};
	} else {
		// Collect grid and keypad info for all assets
		private _grids = [];
		private _keypads = [];
		{
			private _Position = getPos _X;
			_grids pushBackUnique (mapGridPosition _Position);
			_keypads pushBackUnique ([_Position] call _GetKeyPadPosition);
		} forEach _Target;

		// Check if all grids and keypads are the same
		private _sameGrid = (_grids arrayIntersect [_grids select 0]) isEqualTo _grids;
		private _sameKeypad = (_keypads arrayIntersect [_keypads select 0]) isEqualTo _keypads;

		format["[SetupIntel] Same Grid: %1 - Same Keypad: %2",_sameGrid,_sameKeypad] spawn OKS_fnc_LogDebug;
		format["[SetupIntel] Grids: %1",_grids] spawn OKS_fnc_LogDebug;
		format["[SetupIntel] Keypads: %1",_keypads] spawn OKS_fnc_LogDebug;

		if (_sameGrid && _sameKeypad) then {
			// All assets in same grid/keypad
			private _first = _Target select 0;
			private _assetNames = [];
			{
				if (_X isKindOf "Man") then {
					private _ManType = "Enemy HVT";
					_FriendlySide = missionNameSpace getVariable ["GOL_Friendly_Side",(side group player)];
					if(side group _X == civilian || (side group _X) getFriend _FriendlySide > 0.6) then {
						_ManType = "Friendly HVT";
					};
					_assetNames pushBack format["%2: %1", name _X, _ManType];
				} else {
					_assetNames pushBack ([configFile >> "CfgVehicles" >> typeOf _X] call BIS_fnc_displayName);
				};
			} forEach _Target;
			_AssetList = format["%1\n\nGrid: %2 - Keypad: %3", _assetNames joinString "\n", mapGridPosition (getPos _first), [getPos _first] call _GetKeyPadPosition];
		} else {
			// List each asset separately
			_AssetList = "";
			{
				if(_X isKindOf "Man") then {
					private _ManType = "Enemy HVT";
					_FriendlySide = missionNameSpace getVariable ["GOL_Friendly_Side",(side group player)];
					if(side group _X == civilian || (side group _X) getFriend _FriendlySide > 0.6) then {
						_ManType = "Friendly HVT";
					};
					_AssetText = format["%4: %1\n\nGrid: %2 - Keypad: %3\n\n", name _X, mapGridPosition (getPos _X), [getPos _X] call _GetKeyPadPosition, _ManType];
					_AssetList = _AssetList + _AssetText;
				} else {
					_AssetText = format["%1\n\nGrid: %2 - Keypad: %3\n\n", [configFile >> "CfgVehicles" >> typeOf _X] call BIS_fnc_displayName, mapGridPosition (getPos _X), [getPos _X] call _GetKeyPadPosition];
					_AssetList = _AssetList + _AssetText;
				};
			} forEach _Target;
		};
	};

	_MergedText = format[_CustomText, _AssetList, _CustomDetails];
	if(isNil "_CustomHeader") then {
		_CustomHeader = format["Intel #%1",(count _AllIntel + 1)];
	};

	[_IntelPiece, _MergedText, _CustomHeader] remoteExec ["ace_intelitems_fnc_setObjectData",2];
	waitUntil {sleep 10; (_TaskPosition nearEntities ["Man",100]) select {isPlayer _X} isNotEqualTo []};
	waitUntil {sleep 1; !alive _IntelPiece};
	private _NearPlayers = (_TaskPosition nearEntities ["Man",15]) select {isPlayer _X};
	if(count _NearPlayers == 0) exitWith {

	};
	private _PlayersWithIntel = _NearPlayers select {isPlayer _X && [_X, "acex_intelitems_document"] call BIS_fnc_hasItem};
	private _Player = selectRandom _PlayersWithIntel;
	if(isNil "_Player") then {
		_Player = selectRandom _NearPlayers;
	};
	_TaskId = format["IntelTask_%1",(random 9999)];
	_TaskArray = _TaskId;
	if(!isNil "_Parent") then {
		_TaskArray = [_TaskId,_Parent];
	};

	private _Name = "";
	if(isNil "_Player") then {
		_Name = "somebody";
	} else {
		_Name = name _Player;
	};

	_TaskDescription = format["You have found a piece of intel. Open your map and ACE Self-Interact to open the intel. The intel was picked up by %1.",_Name];
	[
		true,
		_TaskArray,
		[
			_TaskDescription,
			"Intel Found",
			"Intel"
		],
		_TaskPosition,
		"SUCCEEDED",
		-1,
		false,
		"intel",
		true
	] call BIS_fnc_taskCreate;	

	_AllIntel = missionNamespace getVariable ["GOL_IntelPieces",[]];
	_FilteredIntels = _AllIntel select {
		(_x getVariable ["GOL_TargetIntel",objNull]) isEqualTo _Target
	};
	{
		deleteVehicle _X;
	} foreach _FilteredIntels;
		
