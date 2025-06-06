
// Set Platoon Leader
// [] spawn OKS_Fnc_Orbat_Platoon;
Private _OrbatPath = configFile >> "CfgORBAT" >> "GuerrillasOfLiberation" >> "1stPlatoon";

/// Change Commander name if applicable
if(!isNil "wpl") exitWith {
	if((alive wpl)) then {	
		[wpl,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupParams;
	} else {
		[wpl,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;
	};
};
if(!isNil "epl") exitWith {
	if((alive epl)) then {	
		[epl,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupParams;
	} else {
		[epl,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;
	};
};
[objNull,_OrbatPath] spawn OKS_Fnc_Orbat_SetGroupInactive;