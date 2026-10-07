/*
	Function Name: OKS_fnc_AddMultipleSearchIntelActions

	Params 1: Array of potential objects, these objects will receive a search action.
	Params 2: Array of Intel Task Data Arrays, each entry is an array of parameters for OKS_fnc_SetupIntel.
	Params 3: Add Collect Task (true/false) - If true, the intel will be added to the task list when collected.
	Params 4: Show Task Position (true/false) - If true, the task position will be shown on the map when the task is assigned. If false, the task position will not show.
	Params 5: Parent Task (string) - If provided, the intel tasks will be added as subtasks of the parent task.

	Per-entry array structure (Params 2 elements):
		[Target, CustomText, CustomHeader, CustomDetails, MarkerArray, CustomActionTitle]
		- Target:            objNull or object/array — intel target(s)
		- CustomText:        string — intel document body (%1=targets, %2=details)
		- CustomHeader:      string — document title ("" = auto "Intel #X")
		- CustomDetails:     string — inserted as %2 in CustomText
		- MarkerArray:       array  — marker names to hide/reveal
		- CustomActionTitle: string — ACE interact action label ("" = "Search for Intel")
	Example of Use:
	[
		[
			PossibleIntelObject_1, PossibleIntelObject_2, PossibleIntelObject_3,
			PossibleIntelObject_4, PossibleIntelObject_5, PossibleIntelObject_6,
			PossibleIntelObject_7, PossibleIntelObject_8, PossibleIntelObject_9,
			PossibleIntelObject_10, PossibleIntelObject_11
		],
		[
			[
				objNull,																// Target or Target Array (objNull for no target)
				"Testing Testing Testing\n\nTesting Testing Testing\nSigned Hello",		// Custom Text (use %1 for target/targets list, %2 for custom details)
				"Special Intel 1",														// Custom Header ("" or omit for auto "Intel #X")
				"",																		// Custom Details (inserted as %2 in Custom Text, "" for none)
				["marker1","marker2"],												   	// Turn Markers from Array to (Visibility 0 on start) and when completed (Visibility 1)
				"Download Harddrive"													// Custom Action Title ("" = "Search for Intel")
			],[
				objNull,																// Target or Target Array (objNull for no target)
				"Testing Testing Testing\n\nTesting Testing Testing\nSigned Hello",		// Custom Text (use %1 for target/targets list, %2 for custom details)
				"Special Intel 2",														// Custom Header ("" or omit for auto "Intel #X")
				"",																		// Custom Details (inserted as %2 in Custom Text, "" for none)
				["marker1","marker2"],													// Turn Markers from Array to (Visibility 0 on start) and when completed (Visibility 1)
				"Search Documents"					// Custom Action Title ("" = "Search for Intel")
			],[
				objNull,																// Target or Target Array (objNull for no target)
				"Testing Testing Testing\n\nTesting Testing Testing\nSigned Hello",		// Custom Text (use %1 for target/targets list, %2 for custom details)
				"Special Intel 3",														// Custom Header ("" or omit for auto "Intel #X")
				"",																		// Custom Details (inserted as %2 in Custom Text, "" for none)
				["marker1","marker2"],													// Turn Markers from Array to (Visibility 0 on start) and when completed (Visibility 1)
				"Inspect Vehicle"					// Custom Action Title ("" = "Search for Intel")
			]		
		],
		true,
		true
	] spawn OKS_fnc_AddMultipleSearchIntelActions;

*/
params [
	["_PossibleIntelObjects",[],[[]]],
	["_TaskDataArray",[],[[]]],
	["_AddCollectTask",true,[false]],
	["_ShowTaskPosition",true,[false]],
	["_ParentTask","",[""]] 
];

if(!isServer) exitWith {};


if (_PossibleIntelObjects isEqualTo []) exitWith { 
	"[MultipleSearchIntel] No possible intel objects provided!" spawn OKS_fnc_LogDebug;
};
if (count _TaskDataArray > count _PossibleIntelObjects) exitWith {
	diag_log "[MultipleSearchIntel] Not enough potential objects for the intel! - Exiting.";
};
if (_TaskDataArray isEqualTo []) exitWith {
	"[MultipleSearchIntel] No task data array provided!" spawn OKS_fnc_LogDebug;
};

/*
	Count will be divided on the _PossibleIntelObjects, if there are more than 3 objects, there's a chance some objects will not give any intel.
*/
private _ShuffledPossibleIntelObjects = _PossibleIntelObjects call BIS_fnc_arrayShuffle;
private _SelectedIntelObjects = _ShuffledPossibleIntelObjects select [0, count _TaskDataArray];

{
	private _IntelPiece = _x;
	_IntelPiece setVariable ["GOL_SearchIntelData", true];
} forEach _SelectedIntelObjects;

private _taskIdx = 0;
{
	private _IntelPiece = _X;
	if(_IntelPiece getVariable ["GOL_SearchIntelData", false] && {_taskIdx < count _TaskDataArray}) then {
		private _TaskDataEntry = _TaskDataArray select _taskIdx;
		_taskIdx = _taskIdx + 1;
		private _MarkerArray = [""];
		_TaskDataEntry params [
			["_Target",objNull,[objNull,[]]],
			["_CustomText","",[""]],
			["_CustomHeader","",[""]], 
			["_CustomDetails","",[""]], 
			["_MarkerArray",[""],[[]]], 
			["_CustomActionTitle","Search for Intel",[""]]
			
		];

		[		
			_IntelPiece,		// ACE Intel Document Piece (object)
			_Target,     		// Target or Target Array (objNull or nil for no target)													
			_ParentTask,			// Parent Task ID or Array [Task ID, Parent Task ID] (nil for no parent)		
			_CustomText,		// Custom Text (use %1 for target/targets list, %2 for custom details)
			_CustomHeader,		// Custom Header (Text when opening intel on map, nil for "Intel #X")
			_CustomDetails,		// Custom Details (Text inserted as %2 in Custom Text, "" for none)
			_AddCollectTask,		// Enable Intel Task Complete (true/false)
			_MarkerArray,			// Turn Markers from Array to (Visibility 0 on start) and when completed (Visibility 1)
			_ShowTaskPosition,		// Show Task Position on map when ASSIGNED (false = no map marker until task completes)
			_CustomActionTitle		// Custom ACE interact action label (e.g. "Download Harddrive")
		] spawn OKS_fnc_SetupIntel;
	} else {
		[		
			_IntelPiece,// ACE Intel Document Piece (object)
			nil,     	// Target or Target Array (objNull or nil for no target)													
			nil,		// Parent Task ID or Array [Task ID, Parent Task ID] (nil for no parent)		
			"",			// Custom Text — empty string triggers "no useful intel" path in ClaimIntel
			nil,		// Custom Header (Text when opening intel on map, nil for "Intel #X")
			nil,		// Custom Details (Text inserted as %2 in Custom Text, "" for none)
			false,		// Enable Intel Task Complete (true/false)
			nil,		// Turn Markers from Array to (Visibility 0 on start) and when completed (Visibility 1)
			false		// Show Task Position on map when ASSIGNED (false = no map marker until task completes)
		] spawn OKS_fnc_SetupIntel;	
	};
} forEach _ShuffledPossibleIntelObjects;
