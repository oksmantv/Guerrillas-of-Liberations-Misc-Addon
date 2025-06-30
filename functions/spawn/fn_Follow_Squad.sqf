params ["_VehicleCrew","_InfantryScreen","_Vehicle"];
Private ["_WP"];
while { {Alive _X} count units _VehicleCrew > 0 && canMove _Vehicle && {Alive _X} count units _InfantryScreen > 0} do {
	
	if({_X distance _Vehicle < 50} count units _InfantryScreen == 0) then {
		_WP = _VehicleCrew addWaypoint [getPos (leader _InfantryScreen),10];
		_WP setWaypointType "HOLD";
	};
	
	if(!isNil "_WP") then {
		waitUntil { sleep 5; {_X distance (waypointPosition _WP) < 50} count units _InfantryScreen == 0};
		deleteWaypoint _WP;
	} else {
		sleep 5;
	};	
};