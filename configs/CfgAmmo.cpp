class CfgAmmo {
    class rhs_ammo_9k38;
    class gol_ammo_9k38: rhs_ammo_9k38
	{
		displayName = "9K38 (Disabled ACE Guidance)";
		maneuvrability = 15;
		cmImmunity = 0.8;
		class ace_missileguidance {
			enabled = 0;                // Enable ACE guidance
			pitchRate = 15;             // Max pitch rate (deg/sec)
			yawRate = 15;               // Max yaw rate (deg/sec)
			canVanillaLock = 1;         // Disables vanilla lock
			defaultSeekerType = "IR";   // Set appropriate seeker type, e.g., "IR"
			seekerTypes[] = { "IR" };   // List allowed seeker types
			defaultSeekerLockMode = "LOBL"; // Lock-On After Launch (or "LOBL" for Before Launch)
			seekerAccuracy = 0.2;
			leadExponent = 1.5;
			leadMultiplier = 1.5;
			// You can add more ACE parameters as needed
		};
    };	

    class ammo_Missile_s750;
    class gol_ammo_s750_GOL: ammo_Missile_s750
	{
		displayName = "S750 - GOL";
		maneuvrability = 20;
		cmImmunity = 0.85;
		class ace_missileguidance {
			enabled = 0;                // Enable ACE guidance
			pitchRate = 15;             // Max pitch rate (deg/sec)
			yawRate = 15;               // Max yaw rate (deg/sec)
			canVanillaLock = 1;         // Disables vanilla lock
			defaultSeekerType = "IR";   // Set appropriate seeker type, e.g., "IR"
			seekerTypes[] = { "IR" };   // List allowed seeker types
			defaultSeekerLockMode = "LOBL"; // Lock-On After Launch (or "LOBL" for Before Launch)
			seekerAccuracy = 0.2;
			leadExponent = 1.5;
			leadMultiplier = 1.5;
			// You can add more ACE parameters as needed
		};
    };	
};