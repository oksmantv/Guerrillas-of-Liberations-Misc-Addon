/*
    Destroy or damage all houses inside a trigger

    Example:
    [thisTrigger,true,[8,10],500] spawn OKS_fnc_Destroy_Houses;

    Param 1: TriggerName, trigger variable, on act in a trigger: "thisTrigger" OR Position.
    Param 2: Should set to random damage, if not then 100% damage always.
    Param 3: Array with two numbers, lower range, and max range, 0-10 (0 = 0%, 10 = 100%)
    Param 4: If Position is given, range from position in every direction (Ellipse Trigger)

    If you want to blacklist certain buildings, make sure to add a logic object found in Modules (F5) => Objects
    Add this in the init of the logic and place it as close to the center of the house as possible.

    Code:
    (nearestObject [getPos this,"HOUSE"]) setVariable ["OKS_Destroy_Blacklist",true,true];
    (nearestBuilding this) setVariable ["OKS_Destroy_Blacklist",true,true];

    We use two methods as certain old houses don't show up for nearestBuildings and some new buildings don't show up on nearestObject.
*/

Params [
    "_TriggerOrPosition",
    ["_RandomDamage",true,[true]],
    ["_DamageVariation",[8,10],[[]]],
    ["_Range",250,[0]]
];

private _Trigger = _TriggerOrPosition;
private _Debug = missionNamespace getVariable ["GOL_Ambience_Debug", false];

if(typename _TriggerOrPosition == "ARRAY") then {
    _Trigger = createTrigger ["EmptyDetector", getPos player];
    _Trigger setTriggerArea [_Range, _Range, 0, false];
    if(_Debug) then {
        format["[DESTROYHOUSES] Destroy Houses activated at %1 as array.",_TriggerOrPosition] spawn OKS_fnc_LogDebug;
    };
} else {
    _Range = ([[(triggerArea _Trigger) select 0,(triggerArea _Trigger) select 1], [], {_x}, "DESCEND"] call BIS_fnc_sortBy) select 0;
    if(_Debug) then {
        format["[DESTROYHOUSES] Destroy Houses activated at %1 as trigger.",_TriggerOrPosition] spawn OKS_fnc_LogDebug;
    };
};
sleep 1;

// Get trigger area and position
private _center = getPosATL _Trigger;
private _area = triggerArea _Trigger;
private _a = _area select 0; // width
private _b = _area select 1; // height

// Get all buildings in a bounding box covering the trigger
_Buildings = nearestTerrainObjects [_center, ["HOUSE"], (_a max _b)];

{
    _House = _X;
    if(_House inArea _Trigger && !(_House getVariable ["OKS_Destroy_Blacklist",false]) && {_X distance _House < 500} count allPlayers == 0) then {
        if(_RandomDamage && _DamageVariation isNotEqualTo []) then {
            _X setDamage (([_DamageVariation#0, _DamageVariation#1] call BIS_fnc_randomInt) / 10);
        } else {
            _X setDamage 1;
        };
        sleep 0.1;
        if(_Debug) then {
            format["[DESTROYHOUSES] Destroyed House %1 at %2", _House, getPos _House] spawn OKS_fnc_LogDebug;
        };
    }
} foreach _Buildings;

if(_Debug) then {
    format["Destroy Houses completed at %1",_TriggerOrPosition] spawn OKS_fnc_LogDebug;
};