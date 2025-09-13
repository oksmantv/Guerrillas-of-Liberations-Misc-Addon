Params ["_ConvoyArray"];
private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug",false];
waitUntil {
	sleep 0.5;
	{
		private _ConvoyGroup = _X;
		{
			!Alive _X &&
			!([_X] call ace_common_fnc_isAwake)
		} count units _ConvoyGroup > 0
	} count _ConvoyArray > 0
};

{	
	private _ConvoyGroupLeader = leader _X;
	private _Vehicle = vehicle _ConvoyGroupLeader;
	private _SpeedKph = _Vehicle getVariable ["OKS_LimitSpeedBase", 20];
	if(!(_Vehicle getVariable ["OKS_ForceSpeedAdjusted", false])) then {
		_NewSpeed = (_SpeedKph + 10);
		_Vehicle setVariable ["OKS_ForceSpeedAdjusted", true, true];
		_Vehicle setVariable ["OKS_LimitSpeedBase", _SpeedKph * 1.5, true];
		(leader _ConvoyGroupLeader) forceSpeed _NewSpeed;
		if(_ConvoyDebug) then {
			format ["[CONVOY] %1 - %2 - Casualties detected. Speeding up to %3 kps", _X, _ConvoyGroupLeader, _NewSpeed] spawn OKS_fnc_LogDebug;
		};
	};
} foreach _ConvoyArray;