
params ["_ConvoyArray"];
private _ConvoyTargetDebug = missionNamespace getVariable ["GOL_Convoy_Target_Debug", false];

// Tunables for this gate; now wired to CBA settings
private _spottingRange = missionNamespace getVariable ["OKS_Convoy_SpottingRange", 400];
private _minimumTargets = missionNamespace getVariable ["OKS_Convoy_MinimumTargets", 1];
private _lockingTime = missionNamespace getVariable ["OKS_Convoy_LockingTime", 3];
private _minimumIdentification = missionNamespace getVariable ["OKS_Convoy_MinimumIdentification", 0.5];

if(hasInterface && isServer) then {
	_minimumTargets = 1; // Override for editor testing
	"[CONVOY] Editor Detected - Convoy will trigger on 1 ground target." spawn OKS_fnc_LogDebug;
};

// Local LOS helper (kept self-contained)
private _hasLOS = {
	params ["_observer", "_target", "_spottingRange"];
	if (isNull _observer || isNull _target) exitWith { false };
	if (!alive _observer || !alive _target) exitWith { false };
	private _eyePosObserver = eyePos _observer;
	private _eyePosTarget = eyePos _target;
	private _TargetsInLine = lineIntersectsSurfaces [_eyePosObserver, _eyePosTarget, _observer, _target, true, 1, "GEOM", "VIEW", false];
	private _VisibilityValue = [objNull, "FIRE"] checkVisibility [_eyePosObserver, _eyePosTarget];
	(isNil "_TargetsInLine" || {_TargetsInLine isEqualTo []}) && (_VisibilityValue > 0.3) || (_observer knowsAbout _target > 2) && (_observer distance2d _target < _SpottingRange)
};

// Hostility check relative to observer's group side
private _isHostile = {
	params ["_observer", "_unit"];
	(side (group _observer) getFriend (side (group _unit))) < 0.6
};

private _steadySince = -1;

waitUntil {
	sleep 0.5;

	private _confirmedTotal = 0;
	private _closeThreat = false;
	_detectors = [];

	{
		private _observer = _x;
		private _targetCandidates = _observer targets [true, _spottingRange, []];
		{
			private _target = _x;
			if (
				alive _target
				&& { !(vehicle _target isKindOf "AIR") }
				&& { [_observer, _target] call _isHostile }
				&& { (_observer knowsAbout _target) >= _minimumIdentification }
				&& { [_observer, _target, _spottingRange] call _hasLOS }
			) then {
				_confirmedTotal = _confirmedTotal + 1;
				if ((_observer distance _target) <= 50) then { _closeThreat = true; };
				if (_ConvoyTargetDebug) then {
					format ["[Convoy-Target] %1 confirmed target: %2 (knowsAbout: %3, LOS: %4)", _observer, _target, (_observer knowsAbout _target), [_observer, _target, _spottingRange] call _hasLOS] spawn OKS_fnc_LogDebug;
				};
			};
		} forEach _targetCandidates;
		if(_confirmedTotal >= _minimumTargets) then {
			_observer setVariable ["GOL_Convoy_TargetsConfirmed", true, true];
		};
		if(_observer getVariable ["OKS_Convoy_Casualties", false]) then {
			_lockingTime = 0;
		};
	} forEach _ConvoyArray;

	if (_ConvoyTargetDebug && (_confirmedTotal > 0 || _closeThreat)) then {
		format ["[Convoy-Target] ConfirmedTotal: %1, CloseThreat: %2", _confirmedTotal, _closeThreat] spawn OKS_fnc_LogDebug;
	};

	private _enough = (_confirmedTotal >= _minimumTargets);
	if (_enough) then {
		if (_steadySince < 0) then { _steadySince = time; };
	} else {
		_steadySince = -1;
	};
	
	private _spottingRangeReady = _enough && ((time - _steadySince) >= _lockingTime);
	if (_ConvoyTargetDebug) then {
		//format ["[Convoy-Target] SpottingRangeReady: %1, SteadySince: %2, Time: %3", _spottingRangeReady, _steadySince, time] spawn OKS_fnc_LogDebug;
	};
	_spottingRangeReady || _closeThreat
};

// Your existing behavior on trigger remains unchanged

if (_ConvoyTargetDebug) then {
	"[Convoy-Target] Detected sustained ground threat. Enabling Combat." spawn OKS_fnc_LogDebug;
};

_Detectors = _ConvoyArray select {_X getVariable ["GOL_Convoy_TargetsConfirmed", false]};
{
	_Dispersion = _X getVariable ["OKS_Convoy_Dispersion", 50];
	_Dispersion = _Dispersion * 1.5;
	_CombatSet = [_X, _ConvoyArray, _Dispersion] call OKS_fnc_Convoy_ProximityCombatFill;
} forEach _Detectors;

_CarelessConvoyArray = _ConvoyArray select {!(_X getVariable ["GOL_ConvoyAmbushed", false])};
[_CarelessConvoyArray] call OKS_fnc_Convoy_WaitUntilTargets;

