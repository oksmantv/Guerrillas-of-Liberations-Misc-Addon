// Handles AA vehicle merge gap and speed ramp
params ["_aaVeh","_prevTail","_dispAA","_gapMin","_gapTimeout","_stepKph","_interval"];
private _t0 = time;
waitUntil {
	sleep 0.5;
	isNull _aaVeh || !canMove _aaVeh || (_aaVeh distance _prevTail) >= _gapMin || ((time - _t0) > _gapTimeout)
};
if (isNull _aaVeh || !canMove _aaVeh) exitWith {};
private _base = _aaVeh getVariable ["OKS_LimitSpeedBase", 40];
private _cur = 10 max 0;
while { _cur < _base && {alive _aaVeh} && {canMove _aaVeh} } do {
	_aaVeh limitSpeed _cur; _aaVeh forceSpeed _cur;
	sleep _interval;
	_cur = _cur + _stepKph;
};