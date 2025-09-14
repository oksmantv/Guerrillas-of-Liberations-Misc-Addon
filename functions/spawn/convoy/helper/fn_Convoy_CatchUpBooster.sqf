// Catch-up booster: uncaps speed if vehicle falls behind its leader
params ["_veh","_prev","_baseKph","_disp"];
private _boosting = false;
while { alive _veh && {canMove _veh} } do {
	if (isNull _prev || {!alive _prev}) exitWith {};
	private _dist = _veh distance _prev;
	private _thresh = (_disp max 15) * 1.5;
	if (!_boosting && {_dist > _thresh}) then { _boosting = true; };
	if (_boosting && {_dist <= _disp}) then { _boosting = false; };
	if (_boosting) then {
		_veh limitSpeed 999; _veh forceSpeed -1;
	} else {
		_veh forceSpeed -1; _veh limitSpeed (_baseKph max 10);
	};
	sleep 0.5;
};