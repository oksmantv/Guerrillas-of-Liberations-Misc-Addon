/*

	OKS_SpawnInfantryPincer

	[attack_1,east,[8,8,10,10],1500,-1,90,250,10,100] spawn OKS_fnc_SpawnInfantryPincer;

	Param 1: SpawnObject (Face it towards suspected player positions)
	Param 2: Side of Enemy
	Param 3: Enemy Numbers Array [BaseOfFire 1,BaseOfFire 2,Left Flank, Right Flank]
	Param 4: Range to check for players (if no players are found, the script will waitUntil players are found)
	Param 5: KnowsAbout Value (0-4: How much the enemy faction needs to know about us to activate)
	Param 6: Flanking Angle in Degrees (Left and Right)
	Param 7: Flanking Distance in Meters (Distance from Player, paired with angle to give flanking waypoint)
	Param 8: Base of Fire Angle (Angle of attack for the base of fireteams, increase to spread out the base of fire teams)
	Param 9: Flanking Spawn Spread (Flankers spawn distance from center)

*/

	if(!isServer) exitWith {};

	Params [
		"_SpawnPosition",
		["_Side",east,[sideUnknown]],
		["_NumbersArray",[10,10,10],[[]]],
		["_Range",1500,[0]],
		["_KnowsAboutLimit",-1,[0]],
		["_FlankAngle",45,[0]],
		["_FlankingDistance",-1,[0]],
		["_BaseOfFireAngle",15,[0]],
		["_FlankingSpawnSpread",50,[0]]
	];
	_NumbersArray Params ["_FrontNumbers","_FrontNumbers2","_LeftNumbers","_RightNumbers"];
	_Settings = [_Side] call OKS_fnc_Dynamic_Settings;
	_Settings Params ["_Units"];

	waitUntil {
		sleep 5;
		count (AllPlayers select {isTouchingGround (vehicle _X) && _Side knowsAbout _X > _KnowsAboutLimit && _X distance _SpawnPosition < _Range}) > 0;
	};

	// Randomly Selected Player Target
	_SelectedPlayerTarget = selectRandom (AllPlayers select {isTouchingGround (vehicle _X) && _Side knowsAbout _X > _KnowsAboutLimit && _X distance _SpawnPosition < _Range});
	systemChat format ["[DEBUG] Infantry Pincer - Selected Target %1",_SelectedPlayerTarget];

	// Front Group 1
	[[_SpawnPosition,_Units,_FrontNumbers,true] call OKS_fnc_SpawnInfantrySquad,_KnowsAboutLimit,_SelectedPlayerTarget,_SpawnPosition,(_BaseOfFireAngle * -1)] spawn OKS_fnc_SuppressiveFireMovement;

	// Front Group 2
	[[_SpawnPosition,_Units,_FrontNumbers2,true] call OKS_fnc_SpawnInfantrySquad,_KnowsAboutLimit,_SelectedPlayerTarget,_SpawnPosition,(_BaseOfFireAngle * 1)] spawn OKS_fnc_SuppressiveFireMovement;

	// Left Group	
	[[_SpawnPosition,_Units,_LeftNumbers,false,(-90),_FlankingSpawnSpread] call OKS_fnc_SpawnInfantrySquad,_SpawnPosition,_SelectedPlayerTarget,(_FlankAngle * 1),_FlankingDistance] spawn OKS_fnc_FlankingMovement;

	// Right Group
	[[_SpawnPosition,_Units,_RightNumbers,false,(90),_FlankingSpawnSpread] call OKS_fnc_SpawnInfantrySquad,_SpawnPosition,_SelectedPlayerTarget,(_FlankAngle * -1),_FlankingDistance] spawn OKS_fnc_FlankingMovement;
