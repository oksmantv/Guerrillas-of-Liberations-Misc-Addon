Params ["_ConvoyArray"];

private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug",false];
{
    private _Vehicle = vehicle _X;
    
    // Method 1: FiredNear detection (for shots that miss but are close)
    _Vehicle addEventHandler ["FiredNear", {
        params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];
        private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug",false];
        
        // Prevent multiple triggers from same vehicle
        if (_unit getVariable ["OKS_Convoy_UnderAttack", false]) exitWith {};
        
        // Check if firer exists and is not friendly
        if (!isNull _firer && (side group _unit) getFriend (side group _firer) < 0.6) then {
            private _firerVehicle = vehicle _firer;
            
            // Check if firer is on ground (not in air vehicle) and within ambush range
            if ((_firerVehicle isKindOf "Man" || 
                (_firerVehicle isKindOf "LandVehicle" && getPos _firerVehicle select 2 < 10)) &&
                _distance < 1500) then {

                if(_ConvoyDebug) then {
                    format [
                        "[CONVOY-CASUALTY-FIREDNEAR] %1 fired near %2 (distance: %3 m, weapon: %4) - Enabling Combat Mode.",
                        _firer,
                        _unit,
                        _distance,
                        _weapon
                    ] spawn OKS_fnc_LogDebug;
                };
                
                _unit setVariable ["OKS_Convoy_UnderAttack", true, true];
                private _currentConvoyArray = _X getVariable ["OKS_Convoy_VehicleArray", []];
                [_unit, _currentConvoyArray, 80] call OKS_fnc_Convoy_ProximityCombatFill;

                _unit removeEventHandler ["FiredNear", _thisEventHandler];
            };
        };
    }];
    
    // Method 2: HandleDamage detection (for direct hits)
    _Vehicle addEventHandler ["HandleDamage", {
        params ["_unit", "_selection", "_newDamage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit"];
        private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug",false];
        
        // Prevent multiple triggers from same vehicle
        if (_unit getVariable ["OKS_Convoy_UnderAttack", false]) exitWith {_newDamage};
        
        // Check if instigator exists and is ground-based enemy
        if (!isNull _instigator && (side group _unit) getFriend (side group _instigator) < 0.6) then {
            private _instigatorVehicle = vehicle _instigator;
            
            // Check if instigator is on ground (not in air vehicle)
            if (_instigatorVehicle isKindOf "Man" || 
                (_instigatorVehicle isKindOf "LandVehicle" && getPos _instigatorVehicle select 2 < 10)) then {

                if(_ConvoyDebug) then {
                    format [
                        "[CONVOY-CASUALTY-HIT] %1 hit %2 (hitPoint: %3, damage: %4, projectile: %5) - Enabling Combat Mode.",
                        _instigator,
                        _unit,
                        _hitPoint,
                        _newDamage,
                        _projectile
                    ] spawn OKS_fnc_LogDebug;
                };
                
                _unit setVariable ["OKS_Convoy_UnderAttack", true, true];
                private _currentConvoyArray = _X getVariable ["OKS_Convoy_VehicleArray", []];
                [_unit, _currentConvoyArray, 80] call OKS_fnc_Convoy_ProximityCombatFill;

                _unit removeEventHandler ["HandleDamage", _thisEventHandler];
            };
        };
        
        _newDamage
    }];
} foreach _ConvoyArray;

waitUntil {
    sleep 0.5;
    {
        private _ConvoyGroup = _X;
        {
            !Alive _X &&
            !([_X] call ace_common_fnc_isAwake)
        } count units _ConvoyGroup > 0
    } count _ConvoyArray > 0
};

{	
    private _ConvoyGroupLeader = leader _X;
    private _Vehicle = vehicle _ConvoyGroupLeader;
    private _SpeedKph = _Vehicle getVariable ["OKS_LimitSpeedBase", 20];
    if(!(_Vehicle getVariable ["OKS_ForceSpeedAdjusted", false])) then {
        _NewSpeed = (_SpeedKph + 10);
        _Vehicle setVariable ["OKS_ForceSpeedAdjusted", true, true];
        _Vehicle setVariable ["OKS_LimitSpeedBase", _SpeedKph * 1.5, true];
        _Vehicle setVariable ["OKS_Convoy_Casualties", true, true];
        (leader _ConvoyGroupLeader) forceSpeed _NewSpeed;
        if(_ConvoyDebug) then {
            format ["[CONVOY-CASUALTY-SPEEDUP] %1 - %2 -> %3 kph", _X, _ConvoyGroupLeader, _NewSpeed] spawn OKS_fnc_LogDebug;
        };
    };
} foreach _ConvoyArray;