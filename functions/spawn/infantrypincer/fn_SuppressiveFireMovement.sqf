Params ["_Group","_KnowsAboutLimit","_SelectedPlayerTarget","_SpawnPosition","_BaseOfFireAngle"];

_FrontStepWP = _Group addWaypoint [_SelectedPlayerTarget getPos [((_SelectedPlayerTarget distance _SpawnPosition) * 0.5),((_SelectedPlayerTarget getDir _SpawnPosition) + _BaseOfFireAngle)],10];
_FrontStepWP setWaypointType "MOVE";
_FrontWP = _Group addWaypoint [getPos _SelectedPlayerTarget,25];
_FrontWP setWaypointType "SAD";

{		
	[_X,_KnowsAboutLimit] spawn {
		Params ["_aiUnit","_KnowsAboutLimit"];

		while {alive _aiUnit || [_aiUnit] call ace_common_fnc_isAwake} do {
			private ["_AvailableTargets"];
			waitUntil{
				sleep 5;
				_AvailableTargets = (_aiUnit targets [true]) select {
					[objNull, "VIEW"] checkVisibility [eyePos _aiUnit, eyePos _X] >= 0.4 && _aiUnit knowsAbout _X > _KnowsAboutLimit
				};
				//systemChat str [name _aiUnit, _AvailableTargets];
				count _AvailableTargets > 0 || (!alive _aiUnit || !([_aiUnit] call ace_common_fnc_isAwake))
			};

			if(!alive _aiUnit && !([_aiUnit] call ace_common_fnc_isAwake)) exitWith { /* systemChat "Killed or Unconscious."*/};

			_Target = selectRandom _AvailableTargets;

			if(!isNil "_Target") then { continue };
			_aiUnit doSuppressiveFire _Target;
			//systemChat format ["%1 is suppressing %2",name _aiUnit,name _Target];

			sleep 15;
		};
	}
} foreach units _Group;
