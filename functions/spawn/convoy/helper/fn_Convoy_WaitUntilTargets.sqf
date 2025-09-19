
params ["_ConvoyArray"];
private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug", false];

// Tunables for this gate; you can wire these to CBA later if you want
private _R        = 300;  // radius
private _minCount = 3;    // 3 targets
private _window   = 3;    // for 3 seconds
private _minKnows = 0.5;  // identification threshold

// Local LOS helper (kept self-contained)
private _hasLOS = {
	params ["_observer", "_target"];
	if (isNull _observer || isNull _target) exitWith { false };
	if (!alive _observer || !alive _target) exitWith { false };
	private _obs = eyePos _observer;
	private _tgt = eyePos _target;
	private _hit = lineIntersectsSurfaces [_obs, _tgt, _observer, _target, true, 1, "GEOM", "FIRE", false];
	private _vis = _observer checkVisibility [_obs, _tgt];
	(isNil "_hit" || {_hit isEqualTo []}) && {_vis > 0.1}
};

// Hostility check relative to observer's group side
private _isHostile = {
	params ["_observer", "_unit"];
	(side (group _observer) getFriend side _unit) < 0.6
};

private _steadySince = -1;

waitUntil {
	sleep 0.5;

	private _confirmedTotal = 0;

	{
		private _observer = _x;
		private _cand = _observer targets [true, _R, [sideEnemy]];
		{
			private _t = _x;
			if (
				alive _t
				&& {!(vehicle _t isKindOf "AIR")}
				&& { [_observer, _t] call _isHostile }
				&& { (_observer knowsAbout _t) >= _minKnows }
				&& { [_observer, _t] call _hasLOS }
			) then {
				_confirmedTotal = _confirmedTotal + 1;
			};
		} forEach _cand;
	} forEach _ConvoyArray;

	private _enough = (_confirmedTotal >= _minCount);
	if (_enough) then {
		if (_steadySince < 0) then { _steadySince = time; };
	} else {
		_steadySince = -1;
	};

	private _ready = _enough && ((time - _steadySince) >= _window);
	_ready
};

// Your existing behavior on trigger remains unchanged
if (_ConvoyDebug) then {
	"[CONVOY] Detected sustained ground threat (3/3s). Enabling Combat." spawn OKS_fnc_LogDebug;
};
{
	_x setBehaviour "COMBAT";
} forEach _ConvoyArray;