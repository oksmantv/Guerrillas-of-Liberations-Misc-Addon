params ["_Player","_Helicopter"];
if (isNull _Player || isNull _Helicopter) exitWith {};

if (isNull (driver _Helicopter)) then {
	moveout _Player;
	waitUntil {isNull (objectParent _Player)};
	waitUntil {_Player moveInDriver _Helicopter; _Player in _Helicopter};
};

