class CfgRecoils {
	class recoil_default;

	// muzzleOuter[] = {horizontal_pos, vertical_pos, horizontal_magnitude, vertical_magnitude}
	// vertical_pos drives muzzle climb; reference RHS PKM: {0.55, 1.0, 0.7, 0.35}
	// horizontal_pos (idx 0) and horizontal_magnitude (idx 2) are kept low to
	// avoid lateral RNG at range — vertical values drive the visible muzzle climb feel.

	// Light MG preset — 5.56mm / 5.45mm class
	class GOL_recoil_machinegun_light: recoil_default {
		kickBack[]    = {0.015, 0.035};
		muzzleOuter[] = {0.075, 0.6, 0.1, 0.18};
		temporary     = 0.0075;
	};
	class GOL_recoil_machinegun_light_prone: recoil_default {
		kickBack[]    = {0.010, 0.025};
		muzzleOuter[] = {0.05, 0.45, 0.075, 0.15};
		temporary     = 0.005;
	};
	// Medium MG preset — 7.62mm class (PKM, PKP, FN MAG, Zafir, MG3)
	class GOL_recoil_machinegun: recoil_default {
		kickBack[]    = {0.02, 0.045};
		muzzleOuter[] = {0.1, 0.72, 0.12, 0.21};
		temporary     = 0.010;
	};
	class GOL_recoil_machinegun_prone: recoil_default {
		kickBack[]    = {0.015, 0.035};
		muzzleOuter[] = {0.075, 0.54, 0.09, 0.17};
		temporary     = 0.0075;
	};
	// Heavy MG preset — 9.3mm/.338 class (HK121, LWMMG) — reduced 15% from original
	class GOL_recoil_machinegun_heavy: recoil_default {
		kickBack[]    = {0.021, 0.047};
		muzzleOuter[] = {0.085, 0.765, 0.102, 0.204};
		temporary     = 0.0106;
	};
	class GOL_recoil_machinegun_heavy_prone: recoil_default {
		kickBack[]    = {0.017, 0.034};
		muzzleOuter[] = {0.064, 0.561, 0.077, 0.153};
		temporary     = 0.0077;
	};
};
