// OKS_fnc_ActivateHiddenVehicle
//
// Activates a pre-placed hidden vehicle by spawning crew inside it.
// If the vehicle is destroyed or damaged beyond 0.5 the script exits silently.
// On activation:
//   - Crew is spawned via OKS_fnc_AddVehicleCrew
//   - Engine is started
//   - If _hunt is false: driver has PATH AI and speed locked (static pillbox)
//   - If _hunt is true:  Lambs taskHunt is assigned (players only); driver AI is left enabled
//   - Camouflage object is destroyed (setDamage 1)
//   - Group reveals enemy players at the faction's average knowsAbout value
//
// Usage:
//   [_vehicle, east, 0, _camoNetting]        call OKS_fnc_ActivateHiddenVehicle;  // static pillbox
//   [_vehicle, east, 0, _camoNetting, true]  call OKS_fnc_ActivateHiddenVehicle;  // Lambs hunt
//
// Parameters:
//   _vehicle    : Object  - The pre-placed empty vehicle
//   _side       : Side    - Side to spawn crew for
//   _crewSlots  : Number  - 0=full crew, 1=driver only, 2=gunner only, 3=commander only, -1=none
//   _camoObject : Object  - Camouflage object to destroy on activation (objNull to skip)
//   _hunt       : Bool    - If true, assign Lambs taskHunt (players only) instead of locking the driver in place

if (hasInterface && !isServer) exitWith {};

params [
    ["_vehicle",    objNull,     [objNull]],
    ["_side",       east,        [sideUnknown]],
    ["_crewSlots",  0,           [-1]],
    ["_camoObject", objNull,     [objNull]],
    ["_hunt",       false,       [false]]
];

// --- Damage check -----------------------------------------------------------
if (isNull _vehicle) exitWith {
    ["[ActivateHiddenVehicle] Vehicle is null, aborting."] spawn OKS_fnc_LogDebug;
};

if (damage _vehicle >= 0.5) exitWith {
    ["[ActivateHiddenVehicle] Vehicle is too damaged, aborting."] spawn OKS_fnc_LogDebug;
};

// --- Spawn crew -------------------------------------------------------------
private _group = [_vehicle, _side, _crewSlots, 0] call OKS_fnc_AddVehicleCrew;

// --- Engine on --------------------------------------------------------------
_vehicle engineOn true;

// --- Lock driver in place (static pillbox, only when not hunting) -----------
if (!_hunt) then {
    private _driver = driver _vehicle;
    if (!isNull _driver) then {
        _driver disableAI "PATH";
        _driver forceSpeed 0;
    };
};

// --- Destroy camouflage object ----------------------------------------------
if (!isNull _camoObject) then {
    _camoObject setDamage 1;
};

// --- Reveal enemy players at faction average knowsAbout ---------------------
// For each player that is enemy to the crew's side, calculate the average
// knowsAbout across all pre-existing units on sides friendly to the crew,
// then reveal the whole group at once.
private _groupSide = side _group;

{
    private _player     = _x;
    private _playerSide = side _player;

    // Only process if the crew side treats the player as an enemy
    if (_groupSide getFriend _playerSide < 0.6) then {

        // Collect knowsAbout values from pre-existing friendly-side units
        private _knowledgeValues = [];
        {
            private _unit     = _x;
            private _unitSide = side _unit;

            if (
                (_groupSide getFriend _unitSide >= 0.6) &&
                { !(_unit in units _group) }
            ) then {
                _knowledgeValues pushBack (_unit knowsAbout _player);
            };
        } forEach allUnits;

        // Average the collected values
        private _avgKnowledge = if (count _knowledgeValues > 0) then {
            private _sum = 0;
            { _sum = _sum + _x } forEach _knowledgeValues;
            _sum / (count _knowledgeValues)
        } else {
            0
        };

        if (_avgKnowledge > 0) then {
            _group reveal [_player, _avgKnowledge];
        };
    };
} forEach allPlayers;

// --- Lambs taskHunt (players only) -----------------------------------------
if (_hunt) then {
    [_group, 500, 30, [], [], true, false, false] remoteExec ["lambs_wp_fnc_taskHunt", 0];
    sleep 5;
    { _x setBehaviour "AWARE"; _x setCombatMode "RED" } forEach units _group;
    _group setBehaviour "AWARE";
    _group setCombatMode "RED";
};

_group
