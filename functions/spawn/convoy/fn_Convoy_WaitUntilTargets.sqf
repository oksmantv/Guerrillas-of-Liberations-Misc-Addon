params ["_ConvoyArray"];
private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug",false];
waitUntil{
	sleep 1;
	{
		_ConvoyAvailableTargets = _X targets [true, 300, [sideEnemy]];
		{
			isTouchingGround (vehicle _X) &&
			(isPlayer _X) &&
			(vehicle _X isKindOf "AIR")
		} count _ConvoyAvailableTargets > 0;

	} count _ConvoyArray > 0
};
if(_ConvoyDebug) then {
	format ["[CONVOY] Detected Ground Enemy. Enabling Combat."] spawn OKS_fnc_LogDebug;
};
{
	_X setBehaviour "COMBAT";
	_X setCombatMode "RED"; 
} foreach _ConvoyArray;