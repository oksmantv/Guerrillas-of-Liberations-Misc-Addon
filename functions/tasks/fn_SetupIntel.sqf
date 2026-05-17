/*
	Example Short: [intel_1,nil,nil,"Testing Testing Testing\n\nTesting Testing Testing\nSigned Hello","Special Intel",nil,false,nil,false] spawn OKS_fnc_SetupIntel;

	Example Detailed:
	[
		intel_1, 																// ACE Intel Document Piece (object)
		nil,     																// Target or Target Array (objNull or nil for no target)													
		nil,																	// Parent Task ID or Array [Task ID, Parent Task ID] (nil for no parent)		
		"Testing Testing Testing\n\nTesting Testing Testing\nSigned Hello",		// Custom Text (use %1 for target/targets list, %2 for custom details)
		"Special Intel",														// Custom Header (Text when opening intel on map, nil for "Intel #X")
		nil,																	// Custom Details (Text inserted as %2 in Custom Text, "" for none)
		nil,																	// Enable Intel Task Complete (true/false)
		["marker1","marker2"],													// Turn Markers from Array to (Visibility 0 on start) and when completed (Visibility 1)
		false																	// Show Task Position on map when ASSIGNED (false = no map marker until task completes)
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
	["_MarkerArray",[""],[[]]],
	["_ShowTaskPosition",true,[false]]
];

if(!isServer) exitWith {
	// Only run on server
};

Private _AssetText = "";
Private _AssetList = "";
{
	_X setMarkerAlpha 0;
} foreach _MarkerArray;

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
if(isNil "_CustomHeader") then {
	_CustomHeader = format["Intel #%1",(count _AllIntel + 1)];
};

if(_IntelPiece isKindOf "Man") then {
	format ["[SetupIntel] Adding ACE unit intel to: %1 (alive: %2)", name _IntelPiece, alive _IntelPiece] spawn OKS_fnc_LogDebug;
	// Allow players to loot and interact with this unit.
	// The Framework InventoryOpened handler blocks access to any AI unit that does
	// not have GW_Common_isPlayer set. HVT intel units must be exempt.
	_IntelPiece setVariable ["GW_Common_isPlayer", true, true];
	[_IntelPiece, "acex_intelitems_document", _MergedText, _CustomHeader] call ace_intelitems_fnc_addIntel;
	// NOTE: ace_intelitems_fnc_addIntel stores unit intel as ACE variables, NOT as a
	// physical item in the unit's containers. items _unit will always be empty here.
	// The document is added to the player's inventory when they ACE-interact and take it.
	format ["[SetupIntel] ACE unit intel registered on %1. GW_Common_isPlayer set to allow looting.", name _IntelPiece] spawn OKS_fnc_LogDebug;
} else {
	format ["[SetupIntel] Setting object intel data on: %1", typeOf _IntelPiece] spawn OKS_fnc_LogDebug;
	[_IntelPiece, _MergedText, _CustomHeader] call ace_intelitems_fnc_setObjectData;
};

if(_EnableIntelTaskComplete) then {
	private _TaskId = format["IntelTask_%1", floor (random 9999999)];
	private _TaskArray = _TaskId;
	if(!isNil "_Parent") then {
		_TaskArray = [_TaskId, _Parent];
	};

	private _Player = objNull;
	private _TaskSucceeded = false;
	private _TaskPosition = getPos _IntelPiece;

	// Create the task as ASSIGNED immediately so players see it in their task list
	// and know to recover the document. State will be updated after the pickup poll.
	private _initialDesc = if (_IntelPiece isKindOf "Man") then {
		"Locate the HVT and recover the intel document."
	} else {
		"Recover the intel from the target location."
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
		// Snapshot which players already hold the intel document at registration time.
		// ACE intel documents can live in magazines _unit (CfgMagazines) rather than
		// items _unit, so both arrays are checked to ensure detection across ACE versions.
		private _intelDocClass = "acex_intelitems_document";
		private _snapPlayers = allPlayers select {isPlayer _x};
		private _snapHasDoc = _snapPlayers apply {
			_intelDocClass in (items _x) || {_intelDocClass in (magazines _x)}
		};
		format ["[SetupIntel] Unit path: snapshot taken for %1 player(s). Polling %2 for pickup.", count _snapPlayers, name _IntelPiece] spawn OKS_fnc_LogDebug;

		private _hvtDeadTime = -1;
		private _capturedTime = -1;
		private _diagIter = 0;

		waitUntil {
			sleep 0.5;

			// Register any player who joined after the initial snapshot.
			{
				if ((_snapPlayers find _x) < 0) then {
					_snapPlayers pushBack _x;
					_snapHasDoc pushBack (_intelDocClass in (items _x) || {_intelDocClass in (magazines _x)});
				};
			} forEach allPlayers;

			// While alive: check nearby players (15m).
			// If the doc has already left the HVT's inventory (taken while alive),
			// expand to all players — the picker may have moved away since.
			// After death or capture: always check all players.
			private _checkPlayers = if (alive _IntelPiece) then {
				private _docStillOnHvt = _intelDocClass in (items _IntelPiece) || {_intelDocClass in (magazines _IntelPiece)};
				if (_docStillOnHvt) then {
					(_IntelPiece nearEntities ["Man", 15]) select {isPlayer _x}
				} else {
					allPlayers select {isPlayer _x}
				}
			} else {
				allPlayers select {isPlayer _x}
			};

			{
				private _idx = _snapPlayers find _x;
				private _hadDoc = if (_idx >= 0) then {_snapHasDoc select _idx} else {false};
				private _hasDoc = _intelDocClass in (items _x) || {_intelDocClass in (magazines _x)};
				if (_hasDoc && {!_hadDoc}) exitWith {
					format ["[SetupIntel] Intel pickup: player=%1 hvtAlive=%2", name _x, alive _IntelPiece] spawn OKS_fnc_LogDebug;
					_Player = _x;
				};
			} forEach _checkPlayers;

			// Death window: 60s after unit dies to allow corpse looting.
			if (!alive _IntelPiece && {_hvtDeadTime < 0}) then {
				_hvtDeadTime = time;
				_TaskPosition = getPos _IntelPiece;
				format ["[SetupIntel] %1 died. Polling for corpse loot (60s window).", name _IntelPiece] spawn OKS_fnc_LogDebug;
			};

			// Capture window: 120s after HVT surrenders/is captured to allow intel recovery.
			// OKS_InterceptHvt_Surrendered is set by fn_InterceptHvt_SetHvtSurrendered.
			if ((_IntelPiece getVariable ["OKS_InterceptHvt_Surrendered", false]) && {_capturedTime < 0}) then {
				_capturedTime = time;
				_TaskPosition = getPos _IntelPiece;
				format ["[SetupIntel] %1 captured/surrendered. Polling for intel recovery (120s window).", name _IntelPiece] spawn OKS_fnc_LogDebug;
			};

			// Diagnostic: log every 10s so it is always visible in RPT during testing.
			_diagIter = _diagIter + 1;
			if (_diagIter >= 20) then {
				_diagIter = 0;
				private _docOnHvt = _intelDocClass in (magazines _IntelPiece) || {_intelDocClass in (items _IntelPiece)};
				format ["[SetupIntel DIAG] alive=%1 docOnHvt=%2 capturedTime=%3 deadTime=%4 checkPlayers=%5", alive _IntelPiece, _docOnHvt, _capturedTime, _hvtDeadTime, count _checkPlayers] spawn OKS_fnc_LogDebug;
				{
					private _p = _x;
					format ["[SetupIntel DIAG] Player %1: hasDoc=%2 magazines=%3", name _p, (_intelDocClass in (magazines _p)), magazines _p select {_x == _intelDocClass}] spawn OKS_fnc_LogDebug;
				} forEach _checkPlayers;
			};

			(!isNull _Player)
			|| {_hvtDeadTime >= 0 && {time > _hvtDeadTime + 60}}
			|| {_capturedTime >= 0 && {time > _capturedTime + 120}}
		};

		if (isNull _Player) then {
			private _reason = if (_capturedTime >= 0) then {"capture timeout"} else {"death timeout"};
			format ["[SetupIntel] Poll ended - no pickup detected (%1).", _reason] spawn OKS_fnc_LogDebug;
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
			!alive _IntelPiece
		};

		_TaskPosition = getPos _IntelPiece;

		{
			private _snapIdx = _snapPlayers find _X;
			private _prev = if (_snapIdx >= 0) then {_snapMags select _snapIdx} else {[]};
			private _gained = (magazines _X) - _prev;
			if (_gained isNotEqualTo []) exitWith {
				format ["[SetupIntel] Object path: magazine delta detected for %1: gained %2", name _X, _gained] spawn OKS_fnc_LogDebug;
				_Player = _X;
			};
		} forEach _lastNearPlayers;

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
		{
			_X setMarkerAlpha 1;
		} forEach _MarkerArray;

		if(!isNil "_Target") then {
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
		
