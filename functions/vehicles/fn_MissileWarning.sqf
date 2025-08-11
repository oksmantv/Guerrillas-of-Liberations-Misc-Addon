params ["_target", "_missile"];

if(hasInterface) then {
	_Debug = missionNamespace getVariable ["GOL_MissileWarning_Debug", false];
	if (isNil "_target" || isNil "_missile") exitWith {
		if(_Debug) then {
			format["[MISSILEWARNING] isNil _target: %1. isNil _missile: %2.", isNil "_target", isNil "_missile"] call OKS_fnc_LogDebug;
		}
	};
	if(_Debug) then {
		"[MISSILEWARNING] Missile Inbound" call OKS_fnc_LogDebug;
	};

	[_target, _missile] spawn OKS_fnc_MissileDeflect;
	_target setVariable ["GOL_MissileWarning", true, true];
	private _message = format ["<t color='#ff0000' size='1.5'>INCOMING MISSILE DETECTED!</t>"];
	cutText [_message, "PLAIN DOWN", 0, true, true];	
	while {_missile distance2d _target > 300 && alive _missile} do {
		if(missionNamespace getVariable ["GOL_MissileWarningSound_Enabled", false]) then {
			playSound "GOL_MissileBeep";
		};
		sleep 0.1;
	};

	if(_Debug) then {
		"[MISSILEWARNING] Missile Imminent" call OKS_fnc_LogDebug;
	};

	if(missionNamespace getVariable ["GOL_MissileWarningSound_Enabled", false]) then {
		playSound "GOL_MissileHit";
	};	
	private _message = format ["<t color='#ff0000' size='2'>INCOMING MISSILE IMMINENT!</t>"];
	cutText [_message, "PLAIN DOWN", 0, true, true];

	waitUntil {sleep 0.1; !alive _missile};
	cutText ["", "PLAIN DOWN", 0, true, true];
	_target setVariable ["GOL_MissileWarning", false, true];
	if(_Debug) then {
		"[MISSILEWARNING] Missile Reset" call OKS_fnc_LogDebug;
	};
};