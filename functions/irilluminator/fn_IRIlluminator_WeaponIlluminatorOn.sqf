/*
    GOL wrapper for BettIR weapon illuminator ON.
    Creates weapon light with correct strength-adjusted intensity from the start.
    
    Parameters:
        0 - _unit <OBJECT> - Unit to enable illuminator for
    
    Returns: None
    
    Usage:
    [player] call OKS_fnc_IRIlluminator_WeaponIlluminatorOn;
*/

params ['_unit'];

if (_unit getVariable ['BettIR_weapon_illuminator_on', false]) exitWith {};
if (currentVisionMode _unit != 1) exitWith {};
if (currentWeapon _unit != primaryWeapon _unit) exitWith {}; 

private _weaponsItems = primaryWeaponItems _unit;
private _attachmentClassname = toLower (_weaponsItems select 1);

if (_attachmentClassname != '') then {
    private _attachmentIndex = BettIR_CompatibleAttachments findIf { _x == _attachmentClassname };

    if (_attachmentIndex != -1) then {
        private _offset = BettIR_CompatibleAttachmentsOffsets select _attachmentIndex;
        _unit setVariable ['BettIR_weapon_illuminator_offset', _offset, false];
        _unit setVariable ['BettIR_weapon_illuminator_on', true, true]; 
        
        if (currentVisionMode player == 1) then {
            // ** GOL MODIFICATION: Create light with correct strength class **
            // Get unit's strength setting (default 1% - minimum)
            // Note: Load from profileNamespace if unit variable not set yet
            private _strength = _unit getVariable ["GOL_IRIlluminator_Strength", -1];
            if (_strength < 0) then {
                _strength = profileNamespace getVariable ["GOL_IRIlluminator_Strength", 1];
                _unit setVariable ["GOL_IRIlluminator_Strength", _strength, true];
                
                if (missionNamespace getVariable ["GOL_IRIlluminator_Debug", false]) then {
                    systemChat format ["[IR Illuminator] WeaponIlluminatorOn: Loaded strength from profile: %1%%", _strength];
                };
            };
            
            // Determine which light class to use based on strength
            private _lightClass = if (_strength >= 3) then {
                "BettIR_Illuminator_Weapon_3"  // Maximum (3%) - extended
            } else {
                if (_strength >= 2.5) then {
                    "BettIR_Illuminator_Weapon_2_5"  // Very High (2.5%) - extended
                } else {
                    if (_strength >= 2) then {
                        "BettIR_Illuminator_Weapon_2"  // High (2%)
                    } else {
                        if (_strength >= 1.5) then {
                            "BettIR_Illuminator_Weapon_1_5"  // Medium (1.5%)
                        } else {
                            "BettIR_Illuminator_Weapon_1"  // Low (1%)
                        }
                    }
                }
            };
            
            // Create light with correct intensity from the start
            private _light = _lightClass createVehicleLocal (getPosATL _unit);
            hideObject _light;
            _light setVariable ['BettIR_owner', _unit];
            _unit setVariable ['BettIR_weapon_illuminator_object', _light, false];
            
            // Update BettIR's unit list
            BettIR_UnitList_LastUpdate = time;
            [] spawn BettIR_fnc_updateUnitList;
            
            if (missionNamespace getVariable ["GOL_IRIlluminator_Debug", false]) then {
                systemChat format ["[IR Illuminator] Created %1 weapon light using class %2 (%3%% strength)", _attachmentClassname, _lightClass, _strength];
            };
        };
    };
};
