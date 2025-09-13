
private _ConvoyDebug = missionNamespace getVariable ["GOL_Convoy_Debug",false];

Params ["_VehicleArray"];
waitUntil {
	sleep 0.5;
	// Code to check for Air Targets within 500m
};

// Find a vehicle in the VehicleArray that has weapons to engage air targets, so basically perhaps something with a gunner seat?

// Store the waypoints currently for the selected vehicle.

// Delete the waypoints and add a waypoint to drive off the road 50m in front to the area which is clear enough to setup.

// Once reached, lock the vehicle speed and set it to target enemy forces (set to combat mode and behaviour combat). We have to find a way to stop the WaitUntilCombat from triggering as I only want that code to be run at the end of the convoy path or an ambush.

// Once the air target is no longer present and all of the convoy vehicles are at least 100m away from the vehicle, we can continue the vehicle to the stored waypoints. We will have to reenable the speedCheck using the last vehicle of the vehicleArray.

// Perhaps we use a setVariable to mark that the vehicle used, is the air defence vehicle, meaning the WaitUntilCombat also checks if the vehicle is not an anti-air nor waitUntilTargets triggers?