if (!hasInterface) exitWith {};

waitUntil {!isNull player};
while {missionNamespace getVariable ["GOL_Weather_SnowstormActive", false]} do {
    private _state = "open";
    private _intersections = lineIntersectsSurfaces [getPosWorld player, (getPosWorld player) vectorAdd [0, 0, 50], player, objNull, true, 1, "GEOM", "NONE"];

    if (_intersections isNotEqualTo [] && {((_intersections # 0) # 3) isKindOf "House"}) then {
        _state = "inside";
    } else {
        private _altitude = (getPosASL player) # 2;
        if (_altitude < -3) then {
            _state = "deepWater";
        } else {
            if (_altitude < 0) then {
                _state = "underwater";
            } else {
                if (vehicle player != player) then { _state = "vehicle"; };
            };
        };
    };

    missionNamespace setVariable ["GOL_Weather_SnowstormPositionState", _state];
    sleep 0.5;
};