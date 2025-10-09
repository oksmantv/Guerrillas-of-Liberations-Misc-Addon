/*
    Add Wait Until Captive at Base Logic.
    
    Upon captive event, wait until captive is at base (within radius of flag and not in vehicle).
    When at base, increase POW count and decrease multiplier.

    [_unit] spawn OKS_fnc_WaitUntilCaptiveAtBase;
*/

Params ["_unit"];

if(hasInterface && !isServer) exitWith {};

sleep 1;

_radius = 300;
private _referencePlayer = if (count allPlayers > 0) then { allPlayers select 0 } else { objNull };
private _sidePrefix = "west";
if (!isNull _referencePlayer) then {
    private _side = side (group _referencePlayer);
    _sidePrefix = switch (_side) do {
        case west: {"west"};
        case east: {"east"};
        default {"west"};
    };
};

private _flagNames = [
    format ["flag_%1_1", _sidePrefix],
    format ["flag_%1_2", _sidePrefix]
];
private _flags = [];
{
    private _flag = missionNamespace getVariable [_x, objNull];
    if (!isNull _flag) then {_flags pushBack _flag};
} forEach _flagNames;

waitUntil {
    sleep 10;
    (!alive _unit) || {
        _atBase = false;
        {
            if ((_unit distance _x) < _radius && isNull objectParent _unit) exitWith { _atBase = true };
        } forEach _flags;
        _atBase
    }
};

if (alive _unit) then {
    private _currentPOWs = missionNamespace getVariable ["GOL_CapturedPOWs", 0];
    _currentPOWs = _currentPOWs + 1;
    missionNamespace setVariable ["GOL_CapturedPOWs", _currentPOWs ,true];
    
    [10] call OKS_fnc_DecreaseMultiplier;
};

