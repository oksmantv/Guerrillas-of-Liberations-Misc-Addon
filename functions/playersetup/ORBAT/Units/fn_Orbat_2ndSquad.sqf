
// Set Platoon Leader
// [] spawn OKS_Fnc_Orbat_Platoon;
Private _OrbatPath = configFile >> "CfgORBAT" >> "GuerrillasOfLiberation" >> "1stPlatoon" >> "2ndSquad";
Private _CompositionValue = missionNamespace getVariable ["GOL_SelectedComposition",0];

/// Change Commander name if applicable
if(!isNil "w2a") exitWith {
	if((alive w2a)) then {	
		[w2a,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupParams;
	} else {
		[w2a,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;
	};
};
if(!isNil "e2a") exitWith {
	if((alive e2a)) then {	
		[e2a,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupParams;
	} else {
		[e2a,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;
	};
};

if(_CompositionValue isEqualTo 1) exitWith {
	if(!isNil "w2a1") exitWith {
		if((alive w2a1)) then {	
			[w2a1,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupParams;
		} else {
			[w2a1,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;
		};
	};
	if(!isNil "e2a1") exitWith {
		if((alive e2a1)) then {	
			[e2a1,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupParams;
		} else {
			[e2a1,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;
		};
	};
	[objNull,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;
};

// None active - Set to Inactive
[objNull,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;