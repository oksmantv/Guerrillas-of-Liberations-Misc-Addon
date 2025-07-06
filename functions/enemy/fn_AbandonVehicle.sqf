
// [this] spawn OKS_fnc_AbandonVehicle;

Params
[
	["_vehicle", ObjNull, [ObjNull]]
];

if(hasInterface && !isServer) exitWith {};

Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
if(isNull _vehicle) exitWith {
    if(_Debug) then {
        format ["AbandonVehicle Script, Vehicle was null. Exiting.."] spawn OKS_fnc_LogDebug;
    };
};
if(_vehicle isKindOf "StaticWeapon") exitWith {};
if((["vehicle_", vehicleVarName _vehicle] call BIS_fnc_inString) || (["mhq_", vehicleVarName _vehicle] call BIS_fnc_inString)) exitWith {
	if(_Debug) then {
		format ["AbandonVehicle Script, Vehicle_ or MHQ_ , exiting.."] spawn OKS_fnc_LogDebug;
	};
};

// Check if vehicle has any gunner turrets (occupied or empty)
private _hasGunnerSeat = {
    params ["_vehicle"];
	private _Return = false;
    _Gunner = gunner _vehicle;
	if(!isNil "_Gunner") then {
		if(!isNull _Gunner) then {
			_Return = true;
		}
	} else {
		if(_vehicle emptyPositions "Cargo" > 0) then {
			_Return = true;
		}
	};

	_Return
};
_Repetitions = 0;
waitUntil {_Repetitions = _Repetitions + 1; sleep 2; count (crew _vehicle) > 1 || _Repetitions > 10};

if(_Repetitions > 10) exitWith {
 	Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
	if(_Debug) then {
		//"Vehicle crew did not exist after 20 seconds. Exiting.." spawn OKS_fnc_LogDebug;
	};
};

// Only proceed if vehicle has weapons
if (_vehicle call _hasGunnerSeat) exitWith {
	[_vehicle,_hasGunnerSeat] spawn {
		params ["_vehicle","_hasGunnerSeat"];
		
		while {alive _vehicle} do {
			// Re-check gunner seats in case turret gets destroyed
			if ([_vehicle] call _hasGunnerSeat && !canFire _vehicle) then {
				Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
				if(_Debug) then {
					"HasGunnerSeat and cannot fire. Abandoning Vehicle." spawn OKS_fnc_LogDebug;
				};
				systemChat "";
				{_x leaveVehicle _vehicle} forEach crew _vehicle;
				_vehicle lock true;
				break;
			};
			sleep 5;
		};
	};
};

Private _Debug = missionNamespace getVariable ["GOL_Enemy_Debug",false];
if(_Debug) then {
	format["%1 does not have gunner. Exiting Abandon Vehicle", [configFile >> "CfgVehicles" >> typeOf _Vehicle] call BIS_fnc_displayName] spawn OKS_fnc_LogDebug;
};

//systemChat ;
