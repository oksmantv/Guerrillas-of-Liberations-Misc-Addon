
// Set Platoon Leader
// [] spawn OKS_Fnc_Orbat_1stSquad_Bravo;
Private _OrbatPath = configFile >> "CfgORBAT" >> "GuerrillasOfLiberation" >> "1stPlatoon" >> "1stSquad" >> "BravoTeam";
Private _CompositionValue = missionNamespace getVariable ["GOL_SelectedComposition",0];

private _CustomCallsign = objNull;
private _Composition = "Infantry";
switch (_CompositionValue) do {
	case 1: {
		_CustomCallsign = "1-1 Foxtrot";
		_Composition = "MechanizedInfantry";
	};
};

/// Change Commander name if applicable
if(_CompositionValue isEqualTo 1) exitWith {
	if(!isNil "wcrew1") exitWith {
		if((alive wcrew1)) then {	
			[wcrew1,_OrbatPath,_CustomCallsign,_Composition] spawn OKS_Fnc_Orbat_SetGroupParams;
		} else {
			[wcrew1,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;
		};
	};

	if(!isNil "ecrew1") exitWith {
		if((alive ecrew1)) then {	
			[ecrew1,_OrbatPath,_CustomCallsign,_Composition] spawn OKS_Fnc_Orbat_SetGroupParams;
		} else {
			[ecrew1,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;
		};
	};
};
if(!isNil "w1b1") exitWith {
	if((alive w1b1)) then {	
		[w1b1,_OrbatPath,_CustomCallsign,_Composition] spawn OKS_Fnc_Orbat_SetGroupParams;
	} else {
		[w1b1,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;
	};
};
if(!isNil "e1b1") exitWith {
	if((alive e1b1)) then {	
		[e1b1,_OrbatPath,_CustomCallsign,_Composition] spawn OKS_Fnc_Orbat_SetGroupParams;
	} else {
		[e1b1,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;
	};
};
[objNull,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;