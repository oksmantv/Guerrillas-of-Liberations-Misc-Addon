	params ["_Player","_Helicopter"];

	private	_Index = 0;
	if(["UH1",TypeOf _Helicopter] call BIS_fnc_inString) then
	{
		_Index = 2;
	};
	if(["UH1Y",TypeOf _Helicopter] call BIS_fnc_inString) then
	{
		_Index = 0;
	};
	if(["CH47",TypeOf _Helicopter] call BIS_fnc_inString) then
	{
		_Index = 3;
	};

	if (isNull (_Helicopter turretUnit [_Index])) then {
		moveout _Player;
		waitUntil {isNull (objectParent _Player)};
		waitUntil {_Player moveInTurret [_Helicopter, [_Index]]; _Player in _Helicopter};
	};
