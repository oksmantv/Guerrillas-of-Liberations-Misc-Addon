class CfgAmmo {
    class M_Titan_AA;
    class oks_ammo_9k38_GOL: M_Titan_AA {
		displayName = "9K38 - GOL";
		maneuvrability = 15;
		irLock = 1;
		airLock = 2;
		cmImmunity = 0.5;
		maxSpeed = 600;
		thrust = 200;
		class ace_missileguidance {
			enabled = 1;                // Enable ACE guidance
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