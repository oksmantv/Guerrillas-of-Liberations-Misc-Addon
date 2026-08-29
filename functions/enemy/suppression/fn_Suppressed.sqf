/*
    Examples:
    _null = [this] spawn OKS_fnc_Suppressed;
    _null = [this,0.8,3,6] spawn OKS_fnc_Suppressed;
*/
params [
    ["_Unit",objNull,[objNull]],                                                                    // #0 OBJECT - Person who is going to be suppressed
    ["_SuppressThreshold",(missionNamespace getVariable ["GOL_Suppressed_Threshold",0.75]),[1]],    // #1 THRESHOLD - Numerical value of suppressed threshold (to trigger suppression)
    ["_MinimumTime",missionNamespace getVariable ["GOL_Suppressed_MinimumTime",6],[1]],             // #2 MINIMUM TIME - Number of seconds to be suppressed
    ["_MaximumTime",missionNamespace getVariable ["GOL_Suppressed_MaximumTime",10],[1]]             // #3 MAXIMUM TIME - Number of seconds to be suppressed
];

if(hasInterface && !isServer) exitWith {};

private _ExitCode = false;
if((group _unit) getVariable ["GOL_isStatic", false]) then {
    if(([_unit] call OKS_fnc_Has_Sight) isEqualTo false) then {
        _ExitCode = true;
    };
};
if(_ExitCode) exitWith {
    _Suppressed_Debug = missionNamespace getVariable ["GOL_Suppression_Debug",false];
    if(_Suppressed_Debug) then {
        format["[SUPPRESS] %1 is in a static group and not exposed. Exiting.",name _Unit] spawn OKS_fnc_LogDebug;
    };
};

_Suppressed_Debug = missionNamespace getVariable ["GOL_Suppression_Debug",false];
if(vehicle _Unit != _Unit) exitWith {
    if(_Suppressed_Debug) then {
        format["[SUPPRESS] %1 is in a vehicle. Exiting.",name _Unit] spawn OKS_fnc_LogDebug;
    };
};

if(_Suppressed_Debug) then {
    format["[SUPPRESS] Script added to %1.",name _unit] spawn OKS_fnc_LogDebug;
}; 

_SuppressCodeAlreadyPresent = _Unit getVariable ["GOL_Suppressed_Initialized",false];
if(_SuppressCodeAlreadyPresent) exitWith {
    if(_Suppressed_Debug) then {
        format["[SUPPRESS] %1 already has suppression code initialized. Exiting.",name _Unit] spawn OKS_fnc_LogDebug;
    };
};

_Unit setVariable ["GOL_Suppressed_Initialized",true];
_Unit setVariable ["lambs_danger_disableAI", true,true];
_Unit setVariable ["GOL_DefaultStance",UnitPos _Unit,true];
_Unit setVariable ["GOL_SuppressedThreshold",_SuppressThreshold,true];
_Unit setVariable ["GOL_SuppressedMin",_MinimumTime,true];
_Unit setVariable ["GOL_SuppressedMax",_MaximumTime,true];

_Unit addEventHandler ["Suppressed", {
	params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];

    private _isNotPlayer = (!isPlayer _shooter && !isPlayer _instigator);
    private _isNotNearbyShot = (_distance > 10);
    private _isNotEnemy = (side (group _shooter)) getFriend (side (group _unit)) > 0.6;
    if(_isNotPlayer || _isNotEnemy || _isNotNearbyShot) exitWith {};

    private _Suppressed_Debug = missionNamespace getVariable ["GOL_Suppression_Debug",false];
    if(_Unit getVariable ["GOL_IsSuppressed",false]) exitWith {
        if(_Suppressed_Debug) then {
            format["[SUPPRESS] %1 is already suppressed. Exiting.",name _Unit] spawn OKS_fnc_LogDebug;
        };
    };

    [_unit] spawn OKS_fnc_SuppressedHandler;
}];

_Unit addEventHandler ["AmmoExplodedNear", {
    params ["_unit", "_shot", "_position", "_velocity", "_ammo", "_explosive", "_indirectHit", "_invArmor", "_damage"];
    _Instigator = getShotParents _shot;

    // Only process explosive ammo (filters out regular bullets)
    if (_explosive <= 0) exitWith {};

    // Check distance from explosion to unit (both in ASL space)
    private _expRadius = missionNamespace getVariable ["GOL_Suppression_ExplosionRadius", 40];
    if ((getPosASL _unit) distance _position > _expRadius) exitWith {};

    // Skip if already suppressed or mounted in a vehicle
    if (_unit getVariable ["GOL_IsSuppressed", false]) exitWith {};
    if (vehicle _unit != _unit) exitWith {};
    if(!isNil "_Instigator" && ((side group (_Instigator select 1)) getFriend (side group _unit) >= 0.6)) exitWith {
        diag_log format ["[SUPPRESS] Instigator: %1", str (_Instigator select 1)] spawn OKS_fnc_LogDebug;
        format ["[SUPPRESS] %1 is friendly to instigator %2. Exiting.", name _unit, name (_Instigator select 1)] spawn OKS_fnc_LogDebug;
    };

    // Scale suppression by indirectHit (explosion power) and distance using a power falloff.
    // _indirectHit is already provided by the EH params (matches CfgAmmo >> indirectHit).
    // Reference values: grenade ~8, 60mm mortar ~30, 82mm ~50, 120mm mortar ~80
    // Tuned targets:
    //   Grenade at <=10m  -> 1 hit suppresses
    //   Grenade at ~20m   -> 2-3 hits
    //   60mm at ~50m      -> 2 hits
    //   120mm at ~50m     -> 1 hit suppresses
    private _dist = ((getPosASL _unit) distance _position) max 1;
    private _suppressAdd = ((2.5 * _indirectHit) / (_dist ^ 1.3)) min 0.9;
    private _newSuppression = ((getSuppression _unit) + _suppressAdd) min 1.0;
    _unit setSuppression _newSuppression;

    private _Suppressed_Debug = missionNamespace getVariable ["GOL_Suppression_Debug", false];
    if (_Suppressed_Debug) then {    
        format ["[SUPPRESS] %1 explosion (%2) at %3m: +%4 suppression -> %5 by %6", name _unit, _ammo, round _dist, _suppressAdd, _newSuppression, _Instigator] spawn OKS_fnc_LogDebug;
    };

    // Only invoke suppression handler once threshold is crossed
    private _threshold = _unit getVariable ["GOL_SuppressedThreshold", 0.75];
    if (_newSuppression > _threshold) then {
        private _multiplier = missionNamespace getVariable ["GOL_Suppression_ExplosionMultiplier", 2];
        [_unit, _multiplier] spawn OKS_fnc_SuppressedHandler;
    };
}];