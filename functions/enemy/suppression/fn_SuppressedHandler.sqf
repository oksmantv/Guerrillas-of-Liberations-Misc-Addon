/*
	[_unit] spawn OKS_fnc_SuppressedHandler;
*/

Params ["_Unit", ["_Multiplier", 1, [0]]];

private ["_SuppressedStance"];
private _PreviousPosition = _Unit getVariable ["GOL_DefaultStance","up"];
switch (toLower _PreviousPosition) do {
	case "up": {
		_SuppressedStance = "down";
	};
	case "middle": {
		_SuppressedStance = "down";
	};       
	default {
		_SuppressedStance = "down";
	};
};

private _SuppressThreshold = _Unit getVariable ["GOL_SuppressedThreshold",0.8];
if(getSuppression _unit > _SuppressThreshold && !(_Unit getVariable ["GOL_IsSuppressed",false])) then {
	
	_Unit setVariable ["GOL_IsSuppressed",true,true];
	private _MinimumTime = _Unit getVariable ["GOL_SuppressedMin",3];
	private _MaximumTime = _Unit getVariable ["GOL_SuppressedMax",6];

	_RandomTime = (_MaximumTime - _MinimumTime);
	private _Delay = (_MinimumTime + (random _RandomTime));
	private _Delay = _Delay * _Multiplier;
	_Suppressed_Debug = missionNamespace getVariable ["GOL_Suppression_Debug",false];
	if(_Suppressed_Debug) then {
		format["[SUPPRESS] Suppressed for %1 in stance %2",_Delay,_SuppressedStance] spawn OKS_fnc_LogDebug;
	};  

	_skillSpeed = _Unit skill "aimingSpeed";
	_skillAccuracy = _Unit skill "aimingAccuracy";
	_skillShake = _Unit skill "aimingShake";
	{
		_Unit setSkill [_X,0.1]
	} foreach ["aimingSpeed","aimingAccuracy","aimingShake"];

	[_Unit,_SuppressedStance] remoteExec ["setUnitPos",0];
	sleep _Delay;

	if(getSuppression _unit < _SuppressThreshold) then {
		sleep (random [1,2,3]); 
		[_Unit,"UP"] remoteExec ["setUnitPos",0];   
		if(_Suppressed_Debug) then {
			format["[SUPPRESS] Suppress reset to %1",_PreviousPosition] spawn OKS_fnc_LogDebug;
		};                          
	};
	_Unit setVariable ["GOL_IsSuppressed",false,true];
	_Unit setSkill ["aimingAccuracy",_skillAccuracy];
	_Unit setSkill ["aimingSpeed",_skillSpeed];
	_Unit setSkill ["aimingShake",_skillShake];
};