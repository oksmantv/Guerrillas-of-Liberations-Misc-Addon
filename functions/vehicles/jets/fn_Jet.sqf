/*
	[_aircraft] spawn OKS_fnc_Jet;
*/

if(!isServer) exitWith {};

Params
[
	["_aircraft", ObjNull, [ObjNull]]
];

private _radius = missionNamespace getVariable ["GOL_JetSuppression_Radius", 300];
private _minAGL = missionNamespace getVariable ["GOL_JetSuppression_MinAGL", 250];
private _minSpeedKph = missionNamespace getVariable ["GOL_JetSuppression_MinSpeed", 500];
private _multiplier = missionNamespace getVariable ["GOL_JetSuppression_Multiplier", 3];
private _minSpeed = (_minSpeedKph / 3.6); // Convert km/h to m/s

private _fnc_HasPassedUnit = {
    params ["_aircraft", "_unit"];

    private _aircraftDir = direction _aircraft;
    private _aircraftPos = getPosASL _aircraft;
    private _unitPos = getPosASL _unit;

    private _vec = [(_unitPos select 0) - (_aircraftPos select 0), (_unitPos select 1) - (_aircraftPos select 1)];
    private _angleToUnit = (_vec select 0) atan2 (_vec select 1);

    _angleToUnit = (_angleToUnit + 360) % 360; // Normalize
    private _diff = abs(_aircraftDir - _angleToUnit);

    if (_diff > 180) then { _diff = 360 - _diff; };
    _diff > 150
};

while {alive _aircraft} do {
    // Wait for a player driver
    waitUntil {
		sleep 30;
        !isNull driver _aircraft && {isPlayer driver _aircraft}
    };

    // Wait for speed threshold
    waitUntil {
		sleep 2;
        speed _aircraft > _minSpeed
    };

    // Suppression loop
    while {
        alive _aircraft &&
		!isNull driver _aircraft &&
		{isPlayer driver _aircraft} &&
		speed _aircraft > _minSpeed
    } do {

    	private _agl = getPosATL _aircraft select 2;
        if (_agl < _minAGL) then {
			private _enemies = _aircraft nearEntities ["Man", _radius] select {
				side group _x != side (group driver _aircraft)
			};
            {
                if ([_aircraft, _x] call _fnc_HasPassedUnit && !(_x getVariable ["GOL_JetSuppressed",false])) then {
                    _x setVariable ["GOL_JetSuppressed",true,true];
                    _x setSuppression 1;
                    [_x, _multiplier] spawn OKS_fnc_SuppressedHandler;
                    format ["[FLYBY] %1 Suppressed by jet %2", name _x, name driver _aircraft] spawn OKS_fnc_LogDebug;
                    _x spawn {
                        params ["_x"];
                        sleep 30;
                        _x setVariable ["GOL_JetSuppressed",false,true];
                    };
                };
                sleep 0.1;
            } forEach _enemies;
        };
        sleep 0.1;
    };
};