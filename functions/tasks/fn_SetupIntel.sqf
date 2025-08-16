/*

	[intel_1,""] spawn OKS_fnc_SetupIntel;

*/

	Params [
		["_IntelPiece",[],[[],grpNull,objNull]],
		["_Target",nil,[objNull,[]]],
		["_Parent",nil,[""]],
		["_CustomText","ENEMY INTEL\nYou have found intel regarding enemy assets.\n\n%1",[""]]
	];
	Private ["_AssetText","_AssetList"];

	_IntelPiece setVariable ["GOL_TargetIntel",_Target,true];
	_AllIntel = missionNamespace getVariable ["GOL_IntelPieces",[]];
	_AllIntel pushBack _IntelPiece;
	missionNamespace setVariable ["GOL_IntelPieces",_AllIntel,true];

	_TaskPosition = getPos _IntelPiece;

	if(typeName _Target == "OBJECT") then {
		if(_target isKindOf "Man") then {
			_AssetList = format["Enemy Officer: %1\nLocation: %2",name _Target, mapGridPosition getPos _Target];
		} else {
			_AssetList = format["%1\nLocation: %2",[configFile >> "CfgVehicles" >> typeOf _Target] call BIS_fnc_displayName, mapGridPosition getPos _Target];
		};
	} else {
		_AssetList = "";
		{
			if(_X isKindOf "Man") then {
				_AssetText = format["Enemy Officer: %1\nLocation: %2\n\n",name _X, mapGridPosition getPos _X];
				_AssetList = _AssetList + _AssetText;
			} else {
				_AssetText = format["%1\nLocation: %2\n\n",[configFile >> "CfgVehicles" >> typeOf _X] call BIS_fnc_displayName, mapGridPosition getPos _X];
				_AssetList = _AssetList + _AssetText;
			};
		} foreach _Target;
	};

	_MergedText = format[_CustomText, _AssetList];
	[_IntelPiece, _MergedText] remoteExec ["ace_intelitems_fnc_setObjectData",0];

	waitUntil {sleep 1; !alive _IntelPiece};
	private _NearPlayers = (_TaskPosition nearEntities ["Man",15]);

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
		
