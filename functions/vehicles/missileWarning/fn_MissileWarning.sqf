params ["_target", "_missile", "_instigator"];

if (hasInterface) then {
	private _debug = missionNamespace getVariable ["GOL_MissileWarning_Debug", false];
	if (isNil "_target" || isNil "_missile") exitWith {
		if (_debug) then {
			format ["[MISSILEWARNING] isNil _target: %1. isNil _missile: %2.", isNil "_target", isNil "_missile"] call OKS_fnc_LogDebug;
		}
	};
	if (_debug) then {
		"[MISSILEWARNING] Missile Inbound" call OKS_fnc_LogDebug;
	};

	// 0=Both  1=Sound Only  2=Text Only  3=None
	private _displayMode = missionNamespace getVariable ["GOL_MissileWarning_DisplayMode", 0];
	private _showText  = _displayMode == 0 || _displayMode == 2;
	private _playSound = _displayMode == 0 || _displayMode == 1;

	if (_showText) then {
		cutText ["<t color='#ff0000' size='1.5'>INCOMING MISSILE DETECTED!</t>", "PLAIN DOWN", 0, true, true];
	};
	while {_missile distance2D _target > 300 && alive _missile} do {
		if (_playSound) then { playSound "GOL_MissileBeep"; };
		sleep 0.1;
	};

	if (_debug) then {
		"[MISSILEWARNING] Missile Imminent" call OKS_fnc_LogDebug;
	};

	if (_playSound) then { playSound "GOL_MissileHit"; };
	if (_showText) then {
		cutText ["<t color='#ff0000' size='2'>INCOMING MISSILE IMMINENT!</t>", "PLAIN DOWN", 0, true, true];
	};
	_target setVariable ["GOL_MissileWarning", false, true];
	waitUntil {sleep 0.01; !alive _missile || (_missile distance2D _target < 100)};
	waitUntil {sleep 0.1; !alive _missile || (_missile distance2D _target > 100)};
	if (_showText) then { cutText ["", "PLAIN DOWN", 0, true, true]; };

	if (_debug) then {
		"[MISSILEWARNING] Missile Reset" call OKS_fnc_LogDebug;
	};
};