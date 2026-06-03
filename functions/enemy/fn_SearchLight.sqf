/*
 OKS_fnc_SearchLight

 Server-only loop that drives a searchlight vehicle to actively hunt and
 illuminate nearby air targets.

 Supports three calling conventions:
   - Object with crew    : pass an existing searchlight vehicle that already has a gunner.
   - Object without crew : pass a crewless vehicle; a gunner is spawned by side automatically.
   - Position            : pass a world position; the appropriate searchlight vehicle is spawned
                           at that position and a gunner is added by side.

 Vehicle classes spawned by position:
   east        -> UK3CB_O_SearchlightAA_CSAT_B
   west        -> UK3CB_B_SearchlightAA_NATO
   independent -> UK3CB_I_SearchlightAA_AAF

 What it does after setup:
   1. Marks the vehicle with OKS_SearchLight = true so OKS_fnc_AbandonVehicle
      skips it and never evicts the crew.
   2. Disables PATH and MOVE AI on the gunner so they cannot path out of the
      vehicle on their own (LAMBS or vanilla) — re-applied each iteration to
      cover gunner-slot refills.
   3. Sets lambs_danger_disableAI on the gunner and its group so LAMBS does
      not assign it combat tasks.
   4. Sets acex_headless_blacklist on the group so ACEX HC does not transfer
      it to a headless client.
   5. Each loop iteration scans a 2000 m radius for air entities, picks one
      at random, and commands the searchlight to target, watch, reveal, and
      illuminate it. Sleeps 5-15 seconds between updates.
   6. Exits when the gunner is dead or gone (alive gunner _Searchlight).

 Parameters:
   _SearchlightOrPos - Object or Array - Existing searchlight vehicle OR a world position [x,y,z]
   _Side             - Side            - Side used to pick the vehicle class and crew unit class (default: east)

 Usage:
   [this]                   spawn OKS_fnc_SearchLight;   // existing vehicle, east crew
   [this, west]             spawn OKS_fnc_SearchLight;   // existing vehicle, west crew if crewless
   [getPos marker_1, east]  spawn OKS_fnc_SearchLight;   // spawn vehicle + crew at position
*/

params [
	["_SearchlightOrPos", ObjNull, [ObjNull, []]],
	["_Side", east, [sideUnknown]]
];

if (!isServer) exitWith {};

// ---------- Resolve vehicle ----------
private _Searchlight = ObjNull;

if (_SearchlightOrPos isEqualType []) then {
	// Position given — spawn the correct vehicle class for this side
	private _vehicleClass = switch (_Side) do {
		case west:        { "UK3CB_B_SearchlightAA_NATO" };
		case independent: { "UK3CB_I_SearchlightAA_AAF" };
		default           { "UK3CB_O_SearchlightAA_CSAT_B" };
	};
	_Searchlight = createVehicle [_vehicleClass, _SearchlightOrPos, [], 0, "NONE"];
	_Searchlight setDir (random 360);
} else {
	_Searchlight = _SearchlightOrPos;
};

if (isNull _Searchlight) exitWith {};

// Mark the vehicle so OKS_fnc_AbandonVehicle skips it
_Searchlight setVariable ["OKS_SearchLight", true, true];

// ---------- Ensure a gunner exists ----------
if (isNull (gunner _Searchlight)) then {
	[_Searchlight, _Side, 2] call OKS_fnc_AddVehicleCrew; // 2 = gunner only
};

// ---------- Per-gunner setup ----------
private _setupCrew = {
	params ["_Searchlight"];
	private _gunner = gunner _Searchlight;
	if (isNull _gunner) exitWith {};

	_gunner disableAI "PATH";
	_gunner disableAI "MOVE";
	_gunner setVariable ["lambs_danger_disableAI", true, true];

	private _grp = group _gunner;
	_grp setVariable ["lambs_danger_disableAI", true, true];
	_grp setVariable ["acex_headless_blacklist", true, true];
};

[_Searchlight] call _setupCrew;

while {alive (gunner _Searchlight)} do {
	// Re-apply in case gunner slot was refilled
	[_Searchlight] call _setupCrew;

	private _nearAirTargets = _Searchlight nearEntities ["air", 2000];
	private _randomlySelectedAirTarget = selectRandom _nearAirTargets;
	if (!isNil "_randomlySelectedAirTarget") then {
		_Searchlight doTarget _randomlySelectedAirTarget;
		_Searchlight doWatch _randomlySelectedAirTarget;
		_Searchlight reveal [_randomlySelectedAirTarget, 4];
		_Searchlight setPilotLight true;
	};
	sleep (selectRandom [5, 10, 15]);
};
