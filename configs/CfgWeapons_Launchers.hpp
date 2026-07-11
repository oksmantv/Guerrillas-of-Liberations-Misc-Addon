class rhs_weap_igla;
class gol_weapon_igla : rhs_weap_igla {
	displayName = "9K38 Igla (Disabled ACE Guidance)";
        magazines[] = { "gol_mag_9k38_rocket" };
	scope = 2;
    };

class weapon_s750Launcher;
class gol_weapon_s750Launcher : weapon_s750Launcher {
	displayName = "S-400 (Disabled ACE Guidance)";
        magazines[] = { "gol_magazine_Missile_s750_x4" };
	scope = 2;
    };

// ==================== SHORAD IR Launcher (turret weapon) ====================
class gol_weapon_shorad_ir : rhs_weap_igla {
	displayName = "SHORAD IR Launcher (GOL)";
	magazines[] = {
		"gol_magazine_shorad_light_x1",
		"gol_magazine_shorad_medium_x1",
		"gol_magazine_shorad_heavy_x1"
	};
	scope = 2;
};

// ==================== GOL PSRL-1 (accurate RPG-7 variant) ====================
// Standalone weapon inheriting from rhs_weap_rpg7. No body on the parent —
// safe forward declaration only. dispersion = 0 removes launch spread.
// GOL ammo variants have deflecting = 0 for stable flight.
class rhs_weap_rpg7;
class GOL_weap_PSRL1: rhs_weap_rpg7 {
	author = "Guerrillas of Liberation";
	displayName = "PSRL-1 (GOL)";
	descriptionShort = "US-made RPG-7 variant. Precision-tuned rounds, near-zero deviation.";
	scope = 2;
	scopeArsenal = 2;
	baseWeapon = "GOL_weap_PSRL1";
	dispersion = 0;
	recoil = "recoil_rpg";
	reloadAction = "GestureReloadRPG7";
	magazineReloadSwitchPhase = 0.48;
	magazines[] = {
		// LEFT reticle (VM markings)
		"GOL_mag_rpg7_Modern",
		"GOL_mag_rpg7_Type59",
		"GOL_mag_rpg7_Type69",
		// RIGHT reticle (VL markings)
		"GOL_mag_rpg7_Type69II",
		"GOL_mag_rpg7_OG7V",
		"GOL_mag_rpg7_TBG7V",
		"GOL_mag_rpg7_VR"
	};
	class Single: Mode_SemiAuto  {
		reloadAction = "GestureReloadRPG7";
		sounds[] = {"StandardSound"};
		class StandardSound {
			begin1[] = {"rhsafrf\addons\rhs_sounds\rpg\rpg_1", 2.35, 1, 1100};
			begin2[] = {"rhsafrf\addons\rhs_sounds\rpg\rpg_2", 2.35, 1, 1100};
			soundBegin[] = {"begin1", 0.5, "begin2", 0.5};
			weaponSoundEffect = "DefaultRifle";
		};
	};
};

// ==================== GOL RPG-7 RHS (standard, AI-use variant) ====================
// Standard dispersion, accepts all known RHS mags + GOL rounds. Use for enemy/ally AI.
// PSRL-1 is the precision (zero-dispersion) player variant.
class GOL_weap_RPG7_RHS: rhs_weap_rpg7 {
	author = "Guerrillas of Liberation";
	displayName = "RPG-7V2 (GOL)";
	descriptionShort = "Standard RPG-7. Accepts GOL rounds including Type-69 reduced-charge.";
	scope = 2;
	scopeArsenal = 2;
	baseWeapon = "GOL_weap_RPG7_RHS";
	magazines[] = {
		// Standard RHS rounds
		"rhs_rpg7_PG7V_mag",
		"rhs_rpg7_PG7VM_mag",
		"rhs_rpg7_PG7VL_mag",
		"rhs_rpg7_PG7VR_mag",
		// GOL rounds
		"GOL_mag_rpg7_Type59",
		"GOL_mag_rpg7_Type69",
		"GOL_mag_rpg7_Type69II",
		"GOL_mag_rpg7_Modern",
		"GOL_mag_rpg7_OG7V",
		"GOL_mag_rpg7_TBG7V",
		"GOL_mag_rpg7_VR"
	};
};

// ==================== GOL RPG-7 Vanilla (BIS launcher variant) ====================
// Inherits from launch_RPG7_F. Adds Type-69 alongside the standard BIS round.
class launch_RPG7_F;
class GOL_weap_RPG7_F: launch_RPG7_F {
	author = "Guerrillas of Liberation";
	displayName = "RPG-7 (GOL)";
	descriptionShort = "Standard RPG-7. Accepts vanilla and Type-69 reduced-charge rounds.";
	scope = 2;
	scopeArsenal = 2;
	baseWeapon = "GOL_weap_RPG7_F";
	magazines[] = {
		"RPG7_F",
		"GOL_mag_rpg7_Type59",
		"GOL_mag_rpg7_Type69",
		"GOL_mag_rpg7_Type69II"
	};
};

// ==================== GOL RPG-17 (Type 59) — disposable single-shot ====================
// Weakest tier. Anti-personnel HEAT, minimal structural blast.
class rhs_weap_rpg18;
class GOL_weap_RPG17_Type59: rhs_weap_rpg18 {
	author = "Guerrillas of Liberation";
	displayName = "RPG-17 (Type 59)";
	descriptionShort = "Disposable RPG. Pre-loaded with Type-59 anti-personnel HEAT round.";
	scope = 2;
	scopeArsenal = 2;
	baseWeapon = "GOL_weap_RPG17_Type59";
	magazines[] = {"GOL_mag_rpg17_Type59"};
	magazineWell[] = {};
	magazineReloadTime = 0.1;
	reloadMagazineSound[] = {"",1,1};
	class EventHandlers {
		fired = "_this call CBA_fnc_firedDisposable";
	};
};

class GOL_weap_RPG17_Type59_used: GOL_weap_RPG17_Type59 {
	scope = 1;
	scopeArsenal = 1;
	baseWeapon = "GOL_weap_RPG17_Type59"; // must match base — CBA lookup
	displayName = "RPG-17 (Type 59) (Used)";
	descriptionShort = "Spent tube. Disposable — cannot be reloaded.";
	weaponPoolAvailable = 0;
	magazines[] = {};
	class EventHandlers {}; // clear inherited fired EH
};

// ==================== GOL RPG-17 (Type 69) — disposable single-shot ====================
// CBA Disposable: Arsenal class is loaded. On fire → transitions to _used (spent tube).
// baseWeapon on _used MUST match base class — that's how CBA locates it.
class GOL_weap_RPG17_Type69: rhs_weap_rpg18 {
	author = "Guerrillas of Liberation";
	displayName = "RPG-17 (Type 69)";
	descriptionShort = "Disposable RPG. Pre-loaded with Type-69 reduced-charge HEAT round.";
	scope = 2;
	scopeArsenal = 2;
	baseWeapon = "GOL_weap_RPG17_Type69";
	magazines[] = {"GOL_mag_rpg17_Type69"};
	magazineWell[] = {};
	magazineReloadTime = 0.1;
	reloadMagazineSound[] = {"",1,1};
	class EventHandlers {
		fired = "_this call CBA_fnc_firedDisposable";
	};
};

class GOL_weap_RPG17_Type69_used: GOL_weap_RPG17_Type69 {
	scope = 1;
	scopeArsenal = 1;
	baseWeapon = "GOL_weap_RPG17_Type69"; // must match base — CBA lookup
	displayName = "RPG-17 (Type 69) (Used)";
	descriptionShort = "Spent tube. Disposable — cannot be reloaded.";
	weaponPoolAvailable = 0;
	magazines[] = {};
	class EventHandlers {}; // clear inherited fired EH
};

// ==================== GOL RPG-17 (Type 69-II) — disposable single-shot ====================
// Improved Type-69. VL trajectory. Type-69 damage +30%.
class GOL_weap_RPG17_Type69II: rhs_weap_rpg18 {
	author = "Guerrillas of Liberation";
	displayName = "RPG-17 (Type 69-II)";
	descriptionShort = "Disposable RPG. Pre-loaded with Type 69-II improved HEAT round.";
	scope = 2;
	scopeArsenal = 2;
	baseWeapon = "GOL_weap_RPG17_Type69II";
	magazines[] = {"GOL_mag_rpg17_Type69II"};
	magazineWell[] = {};
	magazineReloadTime = 0.1;
	reloadMagazineSound[] = {"",1,1};
	class EventHandlers {
		fired = "_this call CBA_fnc_firedDisposable";
	};
};

class GOL_weap_RPG17_Type69II_used: GOL_weap_RPG17_Type69II {
	scope = 1;
	scopeArsenal = 1;
	baseWeapon = "GOL_weap_RPG17_Type69II"; // must match base — CBA lookup
	displayName = "RPG-17 (Type 69-II) (Used)";
	descriptionShort = "Spent tube. Disposable — cannot be reloaded.";
	weaponPoolAvailable = 0;
	magazines[] = {};
	class EventHandlers {}; // clear inherited fired EH
};

// ==================== GOL NLAW (lightweight, backpack-portable) ====================
// Uses CBA Disposable Framework: base (Arsenal-visible) → ready (loaded) → used (spent tube).
class launch_NLAW_F;
class GOL_launch_NLAW_F: launch_NLAW_F {
	author = "Guerrillas of Liberation";
	displayName = "NLAW (GOL)";
	ace_overpressure_damage = 0.4;
	descriptionShort = "NLAW — Next Generation Light Anti-Tank Weapon. Backpack-portable variant.";
	scope = 2;
	scopeArsenal = 2;
	baseWeapon = "GOL_launch_NLAW_F";
	magazines[] = {"CBA_FakeLauncherMagazine"};
	magazineWell[] = {};
	magazineReloadTime = 0.1;
	reloadMagazineSound[] = {"",1,1};
	class WeaponSlotsInfo {
		mass = 45; // 4.5 kg — empty tube only
		allowedSlots[] = {901};
	};
};

class GOL_launch_NLAW_ready_F: GOL_launch_NLAW_F {
	scope = 1;
	scopeArsenal = 1;
	baseWeapon = "GOL_launch_NLAW_F";
	magazines[] = {"NLAW_F"};
	magazineWell[] = {"NLAW"};
	class EventHandlers {
		fired = "_this call CBA_fnc_firedDisposable";
	};
	class WeaponSlotsInfo: WeaponSlotsInfo {
		mass = 125; // 4.5 kg launcher + 8.0 kg magazine
		allowedSlots[] = {901};
	};
};

class GOL_launch_NLAW_used_F: GOL_launch_NLAW_F {
	scope = 1;
	scopeArsenal = 1;
	baseWeapon = "GOL_launch_NLAW_used_F";
	displayName = "NLAW (GOL) (Used)";
	descriptionShort = "Spent NLAW tube. Disposable — cannot be reloaded.";
	weaponPoolAvailable = 0;
	class WeaponSlotsInfo: WeaponSlotsInfo {
		mass = 45; // 4.5 kg — empty tube only
		allowedSlots[] = {901};
	};
};
