/*
	[_unit] spawn OKS_fnc_SuppressedHandler;
*/

Params ["_Unit", ["_Multiplier", 1, [0]]];

private _PreviousPosition = _Unit getVariable ["GOL_DefaultStance","up"];
private _SuppressedStance = switch (toLower _PreviousPosition) do {
	case "up":     { "down" };
	case "middle": { "down" };
	default        { "down" };
};

private _SuppressThreshold = _Unit getVariable ["GOL_SuppressedThreshold",0.8];
if(getSuppression _unit > _SuppressThreshold && !(_Unit getVariable ["GOL_IsSuppressed",false])) then {
	
	_Unit setVariable ["GOL_IsSuppressed",true,true];
	private _MinimumTime = _Unit getVariable ["GOL_SuppressedMin",3];
	private _MaximumTime = _Unit getVariable ["GOL_SuppressedMax",6];

	private _RandomTime = (_MaximumTime - _MinimumTime);
	private _Delay = (_MinimumTime + (random _RandomTime)) * _Multiplier;
	private _Suppressed_Debug = missionNamespace getVariable ["GOL_Suppression_Debug",false];
	if(_Suppressed_Debug) then {
		format["[SUPPRESS] Suppressed for %1 in stance %2",_Delay,_SuppressedStance] spawn OKS_fnc_LogDebug;
	};  

	private _skillAccuracy = _Unit skill "aimingAccuracy";
	private _skillShake = _Unit skill "aimingShake";
	{
		_Unit setSkill [_X,0.1]
	} foreach ["aimingAccuracy","aimingShake"];
	

	[_Unit,_SuppressedStance] remoteExec ["setUnitPos",0];
	_unit suppressFor _Delay;
	sleep _Delay;

	if(getSuppression _Unit < _SuppressThreshold) then {
		sleep (random [1,2,3]);
		if(!alive _Unit) exitWith {};
		[_Unit,"UP"] remoteExec ["setUnitPos",0];   
		if(_Suppressed_Debug) then {
			format["[SUPPRESS] Suppress reset to %1",_PreviousPosition] spawn OKS_fnc_LogDebug;
		};                          
	};

	if(!alive _Unit) exitWith {};
	_Unit setSkill ["aimingAccuracy",_skillAccuracy];
	_Unit setSkill ["aimingShake",_skillShake];
	_Unit setVariable ["GOL_IsSuppressed",false,true];
};