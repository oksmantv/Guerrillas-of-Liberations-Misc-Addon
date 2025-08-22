/*
	[_aircraft,_player, _ejected] spawn OKS_fnc_StaticJump_Code;
*/

params ["_aircraft","_player", "_ejected"];

_Debug = missionNamespace getVariable ["GOL_Paradrop_Debug",false];

if(!(_player getVariable ["GOL_Hooked",false])) exitWith {
	if(_Debug) then {
		format["[StaticLine] Static Jump Code - Hook was off, exiting..",_aircraft, name _player] spawn OKS_fnc_LogDebug;
	};
};

if(!(_ejected)) then {
	_player setVariable ["GOL_StaticJump", true, true];
	_player action ["Eject", _aircraft];
	if(_Debug) then {
		format["[StaticLine] Static Jump Code - Not Ejected - Triggering Action",_aircraft, name _player] spawn OKS_fnc_LogDebug;
	};
} else {
	if(_Debug) then {
		format["[StaticLine] Static Jump Code - Ejected - Skipping Action",_aircraft, name _player] spawn OKS_fnc_LogDebug;
	};
};

_aircraftVelocity = velocity _aircraft;
_aircraftDir = direction _aircraft;

waitUntil {vehicle _player == _player};
private _currentDamageThreshold = ace_medical_playerDamageThreshold;
ace_medical_playerDamageThreshold = (ace_medical_playerDamageThreshold * 1.25);

if(_Debug) then {
	format["[StaticLine] Static Jump Code - %2 left %1.",_aircraft,_player] spawn OKS_fnc_LogDebug;
	format["[StaticLine] Static Jump Code - Saved Threshold: %1 - New Threshold: %2", _currentDamageThreshold, ace_medical_playerDamageThreshold] spawn OKS_fnc_LogDebug;
};

_offsetPosition = _aircraft modelToWorld [-10, -5, -5];
_player disableCollisionWith _aircraft;
_player setPos _offsetPosition;
_player setDir (_aircraftDir  - 180);
_player setVelocity _aircraftVelocity;

sleep 1;
if((backpack _player) in ["rhsusf_eject_Parachute_backpack"]) then {
	_player action ["OpenParachute", _player];
	playSound "GOL_ParachuteDeploy";
	_playerVelocity = velocity _player;
	waitUntil {vehicle _player != _player};

    private _forwardSpeed = 5.5; // Meters per second
    private _dir = direction (vehicle _player);
    private _vx = sin _dir * _forwardSpeed;
    private _vy = cos _dir * _forwardSpeed;
    private _vz = (velocity (vehicle _player)) select 2;

    (vehicle _player) setVelocity [_vx, _vy, _vz];
};

[_aircraft, _player, false] call OKS_fnc_StaticJump_Hook;

waitUntil {sleep 1; vehicle _player == _player || !Alive _player};
ace_medical_playerDamageThreshold = _currentDamageThreshold;