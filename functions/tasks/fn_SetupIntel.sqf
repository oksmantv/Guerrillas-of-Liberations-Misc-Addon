/*
	Example Short: [intel_1,nil,nil,"Testing Testing Testing\n\nTesting Testing Testing\nSigned Hello","Special Intel",nil,false,nil,false,"Search for Intel"] spawn OKS_fnc_SetupIntel;

	Example Detailed:
	[
		intel_1, 																// ACE Intel Document Piece (object)
		nil,     																// Target or Target Array (objNull or nil for no target)													
		nil,																	// Parent Task ID or Array [Task ID, Parent Task ID] (nil for no parent)		
		"Testing Testing Testing\n\nTesting Testing Testing\nSigned Hello",		// Custom Text (use %1 for target/targets list, %2 for custom details)
		"Special Intel",														// Custom Header (Text when opening intel on map, nil for "Intel #X")
		nil,																	// Custom Details (Text inserted as %2 in Custom Text, "" for none)
		nil,																	// Enable Intel Task Complete (true/false)
		["marker1","marker2"],													// Turn Markers from Array or String to (Visibility 0 on start) and when completed (Visibility 1)
		false,																	// Show Task Position on map when ASSIGNED (false = no map marker until task completes)
		"Download Harddrive"													// Custom ACE interact action title ("" or omit for default "Search for Intel")
	] spawn OKS_fnc_SetupIntel;

	"ENEMY INTEL\nYou have found intel regarding enemy assets.\n\n%1\n%2"

	\n = New Line.
	%1 = Inserted Parameter (%1 or %2).
	_CustomText Parameter: %1 is the assets list specified in the _Target Parameter.
	_CustomText Parameter: %2 is the Custom Details parameter.
	_CustomHeader is the header text for the intel item. If left nil, it will be set to "Intel #X" where X is the number of intel items created so far + 1.
	_CustomDetails is the text that will be inserted in the _CustomText parameter as %2.

	If you want intel with only text and no target, set _Target to objNull or nil, and set _CustomText to your desired text.
*/

Params [
	["_IntelPiece",[],[[],grpNull,objNull]],
	["_Target",nil,[objNull,[]]],
	["_Parent",nil,[""]],
	["_CustomText","ENEMY INTEL\nYou have found intel regarding enemy assets.\n\n%1\n\n%2",[""]],
	["_CustomHeader",nil, [""]],
	["_CustomDetails","", [""]],
	["_EnableIntelTaskComplete",true, [false]],
	["_MarkerArray",[""],[[],""]],
	["_ShowTaskPosition",true,[false]],
	["_CustomActionTitle","Search for Intel",[""]]

];

if(!isServer) exitWith {
	// Only run on server
};

Private _AssetText = "";
Private _AssetList = "";

if(typename _MarkerArray == "ARRAY") then {
	{
		_X setMarkerAlpha 0;
	} foreach _MarkerArray;
};
if(typename _MarkerArray == "STRING") then {
	_MarkerArray setMarkerAlpha 0;
};
if(!(typeName _MarkerArray in ["STRING","ARRAY"])) then {
	// Invalid types
	format ["[SetupIntel] ERROR: Invalid _MarkerArray type %1. Must be STRING or ARRAY.", typeName _MarkerArray] spawn OKS_fnc_LogDebug;
};


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

// Wait for gear/identity to be applied on any relevant Man units before reading
// name/face data into the intel text. Timeout after 30s so we never block indefinitely
// when OKS_fnc_ReplaceUnitGear is not used.
private _GearWaitUnits = [];
if (_IntelPiece isKindOf "Man") then {
	_GearWaitUnits pushBack _IntelPiece;
};
if (!isNil "_Target") then {
	if (typeName _Target == "OBJECT" && {_Target isKindOf "Man"}) then {
		_GearWaitUnits pushBackUnique _Target;
	};
	if (typeName _Target == "ARRAY") then {
		{
			if (_X isKindOf "Man") then { _GearWaitUnits pushBackUnique _X; };
		} forEach _Target;
	};
};
format ["[SetupIntel] IntelPiece: %1 (isMan: %2), GearWaitUnits: %3", typeOf _IntelPiece, (_IntelPiece isKindOf "Man"), _GearWaitUnits] spawn OKS_fnc_LogDebug;

if (_GearWaitUnits isNotEqualTo []) then {
	// Wait for GOL_GearReady only — this is set by OKS_fnc_ReplaceUnitGear AFTER it finishes
	// applying custom gear/identity. Using GW_Gear_appliedGear here would be wrong because
	// that fires when the Framework module completes, which is BEFORE ReplaceUnitGear runs.
	// ReplaceUnitGear would then wipe the intel document we just added.
	private _GearWaitStart = time;
	private _GearDeadline = time + 30;
	format ["[SetupIntel] Waiting for GOL_GearReady on %1 unit(s), deadline T+30", count _GearWaitUnits] spawn OKS_fnc_LogDebug;
	waitUntil {
		sleep 0.5;
		(time > _GearDeadline) || {
			(_GearWaitUnits select {
				alive _X &&
				{!(_X getVariable ["GOL_GearReady", false])}
			}) isEqualTo []
		}
	};
	private _GearElapsed = time - _GearWaitStart;
	private _timedOut = _GearElapsed >= 29.5;
	format ["[SetupIntel] Gear wait ended after %.1fs - %2", _GearElapsed, if (_timedOut) then {"TIMEOUT"} else {"GOL_GearReady received"}] spawn OKS_fnc_LogDebug;
	if (_timedOut) then {
		format ["[SetupIntel] WARNING: Gear wait timed out. Unit GOL_GearReady states: %1", _GearWaitUnits apply {_X getVariable ["GOL_GearReady", false]}] spawn OKS_fnc_LogDebug;
	};
};

if(!isNil "_Target") then {
	_IntelPiece setVariable ["GOL_TargetIntel",_Target,true];
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
};

_MergedText = format[_CustomText, _AssetList, _CustomDetails];
if(isNil "_CustomHeader" || {_CustomHeader isEqualTo ""}) then {
	_CustomHeader = format["Intel #%1",(count _AllIntel + 1)];
};

if ((typeof _IntelPiece) == "acex_intelitems_document") then {
	// Native ACE document object — ACE adds its own interact action via setObjectData.
	format ["[SetupIntel] ACE document object, delegating to setObjectData: %1", typeOf _IntelPiece] spawn OKS_fnc_LogDebug;
	[_IntelPiece, _MergedText, _CustomHeader] call ace_intelitems_fnc_setObjectData;
} else {
	// Man, vehicle, prop, or any other world object — attach the GOL custom interact action.
	_IntelPiece setVariable ["GOL_IntelSearchText", _MergedText, true];
	_IntelPiece setVariable ["GOL_IntelSearchHeader", _CustomHeader, true];
	_IntelPiece setVariable ["GOL_IntelClaimed", false, true];
	_IntelPiece setVariable ["GOL_IntelClaimedBy", objNull, true];
	if (_IntelPiece isKindOf "Man") then {
		// Allow players to loot and interact with this unit.
		// The Framework InventoryOpened handler blocks access to any AI unit that does
		// not have GW_Common_isPlayer set. HVT intel units must be exempt.
		_IntelPiece setVariable ["GW_Common_isPlayer", true, true];
	};
	private _pieceLabel = if (_IntelPiece isKindOf "Man") then {name _IntelPiece} else {typeOf _IntelPiece};
	format ["[SetupIntel] Registering Search for Intel action on: %1", _pieceLabel] spawn OKS_fnc_LogDebug;
	[_IntelPiece, _CustomActionTitle] call OKS_fnc_AddSearchIntelAction;
};

if(_EnableIntelTaskComplete) then {
	private _TaskId = format["IntelTask_%1", floor (random 9999999)];
	private _TaskArray = _TaskId;
	if(!isNil "_Parent" && {_Parent != ""}) then {
		_TaskArray = [_TaskId, _Parent];
	};

	private _Player = objNull;
	private _TaskSucceeded = false;
	private _TaskPosition = getPos _IntelPiece;

	// Create the task as ASSIGNED immediately so players see it in their task list
	// and know to recover the document. State will be updated after explicit recovery.
	private _initialDesc = if (_IntelPiece isKindOf "Man") then {
		"Locate the HVT and use ACE Interact to Search for Intel."
	} else {
		"Use ACE Interact on the target location and select Search for Intel."
	};
	[
		true,
		_TaskArray,
		[_initialDesc, _CustomHeader, "Intel"],
		if (_ShowTaskPosition) then {_TaskPosition} else {[]},
		"ASSIGNED",
		-1,
		false,
		"intel",
		false
	] call BIS_fnc_taskCreate;
	format ["[SetupIntel] Task %1 created as ASSIGNED (silent).", _TaskId] spawn OKS_fnc_LogDebug;

	if(_IntelPiece isKindOf "Man") then {
		private _loggedDeath = false;
		private _loggedCapture = false;
		private _diagIter = 0;

		waitUntil {
			sleep 0.5;

			if (isNull _IntelPiece) exitWith { true };

			_Player = _IntelPiece getVariable ["GOL_IntelClaimedBy", objNull];

			if (!alive _IntelPiece) then {
				_TaskPosition = getPos _IntelPiece;
				if (!_loggedDeath) then {
					_loggedDeath = true;
					format ["[SetupIntel] %1 is down. Waiting for a player to use Search for Intel.", name _IntelPiece] spawn OKS_fnc_LogDebug;
				};
			};

			if ((_IntelPiece getVariable ["OKS_InterceptHvt_Surrendered", false]) && {!_loggedCapture}) then {
				_loggedCapture = true;
				_TaskPosition = getPos _IntelPiece;
				format ["[SetupIntel] %1 surrendered/captured. Waiting for Search for Intel.", name _IntelPiece] spawn OKS_fnc_LogDebug;
			};

			_diagIter = _diagIter + 1;
			if (_diagIter >= 20) then {
				_diagIter = 0;
				format ["[SetupIntel DIAG] claimed=%1 player=%2 alive=%3 deleted=%4", _IntelPiece getVariable ["GOL_IntelClaimed", false], if (!isNull _Player) then {name _Player} else {"none"}, alive _IntelPiece, isNull _IntelPiece] spawn OKS_fnc_LogDebug;
			};

			(!isNull _Player) || {isNull _IntelPiece}
		};

		if (isNull _Player) then {
			format ["[SetupIntel] Search ended - no recovery detected (intel deleted before recovery)."] spawn OKS_fnc_LogDebug;
		};
		_TaskSucceeded = !isNull _Player;
	} else {
		// Object intel path: rolling 0.2s loop tracking nearest players and their
		// magazine snapshots. At the moment the object is destroyed, check who
		// gained a new magazine — that is the player who picked it up.
		private _lastNearPlayers = [];
		private _snapPlayers = [];
		private _snapMags = [];

		waitUntil {
			sleep 0.2;
			private _nearby = ((getPos _IntelPiece) nearEntities ["Man", 6]) select {isPlayer _X};
			if (_nearby isNotEqualTo []) then {
				_lastNearPlayers = _nearby;
				{
					private _idx = _snapPlayers find _X;
					if (_idx < 0) then {
						_snapPlayers pushBack _X;
						_snapMags pushBack (magazines _X);
					} else {
						_snapMags set [_idx, magazines _X];
					};
				} forEach _nearby;
			};
			(_IntelPiece getVariable ["GOL_IntelClaimed", false]) || {!alive _IntelPiece}
		};

		_TaskPosition = getPos _IntelPiece;

		// GOL interact action sets GOL_IntelClaimedBy directly — use it if available.
		// Fall back to magazine snapshot for ACE document objects that are destroyed on pickup.
		if (_IntelPiece getVariable ["GOL_IntelClaimed", false]) then {
			_Player = _IntelPiece getVariable ["GOL_IntelClaimedBy", objNull];
			format ["[SetupIntel] Object path: claimed via GOL interact by %1", if (!isNull _Player) then {name _Player} else {"unknown"}] spawn OKS_fnc_LogDebug;
		} else {
			{
				private _snapIdx = _snapPlayers find _X;
				private _prev = if (_snapIdx >= 0) then {_snapMags select _snapIdx} else {[]};
				private _gained = (magazines _X) - _prev;
				if (_gained isNotEqualTo []) exitWith {
					format ["[SetupIntel] Object path: magazine delta detected for %1: gained %2", name _X, _gained] spawn OKS_fnc_LogDebug;
					_Player = _X;
				};
			} forEach _lastNearPlayers;
		};

		_TaskSucceeded = !isNull _Player;
	};

	format ["[SetupIntel] Task result: %1, player: %2", if (_TaskSucceeded) then {"SUCCEEDED"} else {"CANCELED"}, if (!isNull _Player) then {name _Player} else {"none"}] spawn OKS_fnc_LogDebug;

	private _TaskState = if (_TaskSucceeded) then {"SUCCEEDED"} else {"CANCELED"};

	// Update task with final position and state in one call.
	// Using BIS_fnc_taskCreate on the existing ID updates it atomically and fires
	// exactly one notification — avoids the double-notify from taskSetDestination.
	private _finalDesc = if (_TaskSucceeded) then {
		format ["Intel secured. Open your map and ACE Self-Interact to view it. Picked up by %1.", name _Player]
	} else {
		"The intel was lost. The document was destroyed before it could be secured."
	};
	private _finalTitle = if (_TaskSucceeded) then {"Intel Secured"} else {"Intel Lost"};
	[
		true,
		_TaskId,
		[_finalDesc, _finalTitle, "Intel"],
		_TaskPosition,
		_TaskState,
		-1,
		true,
		"intel",
		true
	] call BIS_fnc_taskCreate;

	if (_TaskSucceeded) then {
		if(typename _MarkerArray == "ARRAY") then {
			{
				_X setMarkerAlpha 1;
			} foreach _MarkerArray;
		};
		if(typename _MarkerArray == "STRING") then {
			_MarkerArray setMarkerAlpha 1;
		};

		if(!isNil "_Target" && {(_Target isEqualType objNull && {!isNull _Target}) || (_Target isEqualType [] && {count _Target > 0})}) then {
			// Clean up any existing intel pieces with the same target to prevent duplicates.
			// Do NOT delete Man units — the intel piece may be a live HVT character.
			// Only delete non-Man objects (physical document props, spawned intel objects, etc).
			_AllIntel = missionNamespace getVariable ["GOL_IntelPieces", []];
			_FilteredIntels = _AllIntel select {
				(_x getVariable ["GOL_TargetIntel", objNull]) isEqualTo _Target
			};
			{
				if (!(_x isKindOf "Man")) then {
					deleteVehicle _X;
				};
			} forEach _FilteredIntels;
		};
	};
};
		
