/*
    Examples:
    _null = [this] spawn OKS_fnc_Suppressed;
    _null = [this,0.8,3,6] spawn OKS_fnc_Suppressed;
*/
params [
    ["_Unit",objNull,[objNull]],                            // #0 OBJECT - Person who is going to be suppressed
    ["_SuppressThreshold",(missionNamespace getVariable ["GOL_Suppressed_Threshold",0.75]),[1]],    // #1 THRESHOLD - Numerical value of suppressed threshold (to trigger suppression)
    ["_MinimumTime",missionNamespace getVariable ["GOL_Suppressed_MinimumTime",6],[1]],        // #2 MINIMUM TIME - Number of seconds to be suppressed
    ["_MaximumTime",missionNamespace getVariable ["GOL_Suppressed_MaximumTime",10],[1]]         // #3 MAXIMUM TIME - Number of seconds to be suppressed
];

if(hasInterface && !isServer) exitWith {};

_Suppressed_Debug = missionNamespace getVariable ["GOL_Suppression_Debug",false];
if(vehicle _Unit != _Unit) exitWith {
    if(_Suppressed_Debug) then {
        format["[SUPPRESS] %1 is in a vehicle. Exiting.",name _Unit] spawn OKS_fnc_LogDebug;
    };
};

if(_Suppressed_Debug) then {
    format["[SUPPRESS] Script added to %1.",name _unit] spawn OKS_fnc_LogDebug;
}; 


_Unit setVariable ["lambs_danger_disableAI", true,true];
_Unit setVariable ["GOL_DefaultStance",UnitPos _Unit,true];
_Unit setVariable ["GOL_SuppressedThreshold",_SuppressThreshold,true];
_Unit setVariable ["GOL_SuppressedMin",_MinimumTime,true];
_Unit setVariable ["GOL_SuppressedMax",_MaximumTime,true];

_Unit addEventHandler ["Suppressed", {
	params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];

    if(!isPlayer _shooter) exitWith {
        // If the shooter is not a player, do not suppress the unit.
    };

    private ["_SuppressedStance"];
    _Suppressed_Debug = missionNamespace getVariable ["GOL_Suppression_Debug",false];

    if(_Unit getVariable ["GOL_IsSuppressed",false]) exitWith {
        if(_Suppressed_Debug) then {
            format["[SUPPRESS] %1 is already suppressed. Exiting.",name _Unit] spawn OKS_fnc_LogDebug;
        };
    };
    
    private _PreviousPosition = _Unit getVariable ["GOL_DefaultStance","up"];
    switch (toLower _PreviousPosition) do {
        case "up": {
            _SuppressedStance = "down";
        };
        case "middle": {
            _SuppressedStance = "down";
        };       
        default {
            _SuppressedStance = "down";
        }
    };

    private _SuppressThreshold = _Unit getVariable ["GOL_SuppressedThreshold",0.8];
    if(getSuppression _unit > _SuppressThreshold && !(_Unit getVariable ["GOL_IsSuppressed",false])) then {
       
        _Unit setVariable ["GOL_IsSuppressed",true,true];
        private _MinimumTime = _Unit getVariable ["GOL_SuppressedMin",3];
        private _MaximumTime = _Unit getVariable ["GOL_SuppressedMax",6];

        _RandomTime = (_MaximumTime - _MinimumTime);
        private _Delay = (_MinimumTime + (random _RandomTime));  

        if(_Suppressed_Debug) then {
            format["[SUPPRESS] Suppressed for %1 in stance %2",_Delay,_SuppressedStance] spawn OKS_fnc_LogDebug;
        };  

        [_Unit,_SuppressedStance,_Delay,_PreviousPosition,_Debug_Variable,_SuppressThreshold] spawn {

            Params["_Unit","_SuppressedStance","_Delay","_PreviousPosition","_Debug_Variable","_SuppressThreshold"];         
            _Suppressed_Debug = missionNamespace getVariable ["GOL_Suppression_Debug",false];
            _skillSpeed = _Unit skill "aimingSpeed";
            _skillAccuracy = _Unit skill "aimingAccuracy";
            _skillShake = _Unit skill "aimingShake";
            {
                _Unit setSkill [_X,0.1]
            } foreach ["aimingSpeed","aimingAccuracy","aimingShake"];

            [_Unit,_SuppressedStance] remoteExec ["setUnitPos",0];
            sleep _Delay;

            if(getSuppression _unit < _SuppressThreshold) then {
                sleep (random [1,2,3]); 
                [_Unit,"UP"] remoteExec ["setUnitPos",0];   
                if(_Suppressed_Debug) then {
                    format["[SUPPRESS] Suppress reset to %1",_PreviousPosition] spawn OKS_fnc_LogDebug;
                };                          
            };
            _Unit setVariable ["GOL_IsSuppressed",false,true];
            _Unit setSkill ["aimingAccuracy",_skillAccuracy];
            _Unit setSkill ["aimingSpeed",_skillSpeed];
            _Unit setSkill ["aimingShake",_skillShake];
        }
    };
}];