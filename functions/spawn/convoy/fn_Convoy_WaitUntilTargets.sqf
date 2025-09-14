params ["_ConvoyArray"];
private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug", false];

// Detect any enemy ground targets (exclude AIR) known to any convoy group within 500m
waitUntil {
	sleep 1;
	{
		private _ConvoyAvailableTargets = _x targets [true, 300, [sideEnemy]];
		({ alive _x && {!(vehicle _x isKindOf "AIR")} } count _ConvoyAvailableTargets) > 0
	} count _ConvoyArray > 0
};
if(_ConvoyDebug) then {
	format ["[CONVOY] Detected Ground Enemy. Enabling Combat."] spawn OKS_fnc_LogDebug;
};
{
	_X setBehaviour "COMBAT";
} foreach _ConvoyArray;