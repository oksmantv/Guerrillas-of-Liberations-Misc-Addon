player addMPEventHandler ["MPRespawn", {
    params ["_newUnit", "_corpse"];
    
    // Transfer death counter
    private _oldDeaths = _corpse getVariable ["GOL_Player_Deaths", 0];
    _newUnit setVariable ["GOL_Player_Deaths", _oldDeaths + 1, true];
    
    // Disable scoring
    _newUnit addEventHandler ["HandleScore", { false }];
    
    // Apply stealth trait if needed
    if (!isNil "GOL_OKS_Stealth_Mission" && { GOL_OKS_Stealth_Mission == 1 }) then {
        _newUnit setUnitTrait ["camouflageCoef", 0.4];
    };
    
    // Re-apply fastrope damage protection after respawn
    _fastRopeProtectionEnabled = missionNamespace getVariable ["GOL_FastropeDamage_Protection", false];
    if(_fastRopeProtectionEnabled) then {
        [_newUnit] call OKS_fnc_FastropeDamageProtection;
    };
}];