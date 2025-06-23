
// Set Platoon Leader
// [] spawn OKS_Fnc_Orbat_1stSquad_Bravo;
Private _OrbatPath = configFile >> "CfgORBAT" >> "GuerrillasOfLiberation" >> "1stPlatoon" >> "2ndSquad" >> "BravoTeam";
Private _CompositionValue = missionNamespace getVariable ["GOL_SelectedComposition",0];

private _CustomCallsign = objNull;
private _Composition = "Infantry";
switch (_CompositionValue) do {
	case 1: {
		_CustomCallsign = "1-2 Golf";
		_Composition = "MechanizedInfantry";
	};
};

if(_CompositionValue isEqualTo 1) exitWith {
	if(!isNil "wcrew4") exitWith {
		if((alive wcrew4)) then {	
			[wcrew4,_OrbatPath,_CustomCallsign,_Composition] spawn OKS_Fnc_Orbat_SetGroupParams;
		} else {
			[wcrew4,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;
		};
	};

	if(!isNil "ecrew4") exitWith {
		if((alive ecrew4)) then {	
			[ecrew4,_OrbatPath,_CustomCallsign,_Composition] spawn OKS_Fnc_Orbat_SetGroupParams;
		} else {
			[ecrew4,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;
		};
	};
};

/// Change Commander name if applicable
if(!isNil "w2b1") exitWith {
	if((alive w2b1)) then {	
		[w2b1,_OrbatPath,_CustomCallsign,_Composition] spawn OKS_Fnc_Orbat_SetGroupParams;
	} else {
		[w2b1,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;
	};
};
if(!isNil "e2b1") exitWith {
	if((alive e2b1)) then {	
		[e2b1,_OrbatPath,_CustomCallsign,_Composition] spawn OKS_Fnc_Orbat_SetGroupParams;
	} else {
		[e2b1,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;
	};
};
[objNull,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;