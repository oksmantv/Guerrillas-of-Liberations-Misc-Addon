/*
    Add Killed EventHandler by Player.
    
    Upon killing captives that have surrendered using OKS_Surrender, will increases ForceMultiplier & ResponseMultiplier for enemy hunt bases.

    [_unit] spawn OKS_Fnc_KilledCaptiveEvent;
*/

Params ["_unit"];

if(hasInterface && !isServer) exitWith {};

sleep 1;
       
_unit addEventHandler ["Killed", {
    params ["_unit", "_killer"];
    if(_unit getVariable ["GOL_CaptiveKilled",false]) exitWith {};
    if (isPlayer _killer) then {
        _unit setVariable ["GOL_CaptiveKilled",true,true];

        // Get current values from mission namespace
        private _forceMultiplier = missionNamespace getVariable ["GOL_ForceMultiplier", 1];
        private _responseMultiplier = missionNamespace getVariable ["GOL_ResponseMultiplier", 1];
        
        // Increase values by 10%
        _forceMultiplier = _forceMultiplier * 1.1;
        _responseMultiplier = _responseMultiplier * 0.9;
        
        // Update global variables
        missionNamespace setVariable ["GOL_ForceMultiplier", _forceMultiplier, true];
        missionNamespace setVariable ["GOL_ResponseMultiplier", _responseMultiplier, true];

        private _Debug = missionNamespace getVariable ["GOL_Ambience_Debug", false];
        if(_Debug) then {
            format["Captive Killed - Increasing Multipliers by 10%% to %1%% (Force) & %2%% (Response)",round (_forceMultiplier * 100), round (_responseMultiplier * 100)] spawn OKS_fnc_LogDebug;
        };     
    };
}];

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

[_unit, _flags, _radius] spawn {
    params ["_unit", "_flags", "_radius"];
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
        private _forceMultiplier = missionNamespace getVariable ["GOL_ForceMultiplier", 1];
        private _responseMultiplier = missionNamespace getVariable ["GOL_ResponseMultiplier", 1];
        
        _forceMultiplier = 1 max (_forceMultiplier * 0.9);
        _responseMultiplier = 1 max (_responseMultiplier * 1.1);

        missionNamespace setVariable ["GOL_ForceMultiplier", _forceMultiplier, true];
        missionNamespace setVariable ["GOL_ResponseMultiplier", _responseMultiplier, true];

        private _Debug = missionNamespace getVariable ["GOL_Ambience_Debug", false];
        if(_Debug) then {
            format[" Captive Captured - Reducing Multipliers by 10%% to %1%% (Force) & %2%% (Response)",round (_forceMultiplier * 100), round (_responseMultiplier * 100)] spawn OKS_fnc_LogDebug;
        };  
    };
};
