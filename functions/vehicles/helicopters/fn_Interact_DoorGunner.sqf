params ["_Player","_Helicopter"];
if (isNull _Player || isNull _Helicopter) exitWith {};

_Index = 1;
if(["UH1",TypeOf _Helicopter] call BIS_fnc_inString || ["CH47",TypeOf _Helicopter] call BIS_fnc_inString || ["MH47",TypeOf _Helicopter] call BIS_fnc_inString) then
{
	_Index = 0;
};
if(["UH1Y",TypeOf _Helicopter] call BIS_fnc_inString) then
{
	_Index = 1;
};
if (isNull (_Helicopter turretUnit [_Index])) exitWith {
	moveout _Player;
	waitUntil {isNull (objectParent _Player)};
	waitUntil {_Player moveInTurret [_Helicopter,  [_Index]]; _Player in _Helicopter};
};

if (isNull (_Helicopter turretUnit [_Index+1])) exitWith {
	moveout _Player;
	waitUntil {isNull (objectParent _Player)};
	waitUntil {_Player moveInTurret [_Helicopter,  [_Index+1]]; _Player in _Helicopter};
};

if ( ["CH47",TypeOf _Helicopter] call BIS_fnc_inString || ["MH47",TypeOf _Helicopter] call BIS_fnc_inString) then {
	if (isNull (_Helicopter turretUnit [_Index+2])) exitWith {
		moveout _Player;
		waitUntil {isNull (objectParent _Player)};
		waitUntil {_Player moveInTurret [_Helicopter,  [_Index+2]]; _Player in _Helicopter};
	};
};

