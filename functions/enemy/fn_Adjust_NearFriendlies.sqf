params ["_unit","_adjustedChance"];
private _surrenderDebug = missionNamespace getVariable ["GOL_Surrender_Debug", false];

private _nearFriendliesDistance = _unit getVariable ["GOL_NearFriendliesDistance",200];
private _side = side (group _unit);
private _nearbyFriendlies = (_unit nearEntities [["Man"], _nearFriendliesDistance]) select {
    side (group _x) isEqualTo _side && alive _x && _x != _unit
};
private _nearbyFriendliesClose = (_unit nearEntities [["Man"], _nearFriendliesDistance * 0.5]) select {
    side (group _x) isEqualTo _side && alive _x && _x != _unit
};

if(count _nearbyFriendliesClose > 10) exitWith { _adjustedChance };

private _numFriendlies = count _nearbyFriendlies;

// Increase for few friendlies
if (_numFriendlies < 10) then {
    private _inc = 0.015 * (10 - _numFriendlies);
    _adjustedChance = _adjustedChance + _inc;
    if(_surrenderDebug) then {
        format ["[SURRENDER] Surrender chance increased by %1%% (few friendlies nearby: %2). New chance: %3%%",(_inc * 100), _numFriendlies, (_adjustedChance * 100)] spawn OKS_fnc_LogDebug;
    };
} else {
    _previousChange = _adjustedChance;  
    _adjustedChance = _adjustedChance * 0.05;
    if(_surrenderDebug) then {
        format ["[SURRENDER] Surrender chance decreased to %1%% of %2%%. New chance: %3%%",(0.05 * 100), (_previousChange * 100), (_adjustedChance * 100)] spawn OKS_fnc_LogDebug;
    };   
};

_adjustedChance