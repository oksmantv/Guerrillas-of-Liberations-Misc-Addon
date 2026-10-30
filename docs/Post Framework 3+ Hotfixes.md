# Post Framework 3+ Hotfixes

## GOL RPG-7V2 AI Label

Changed `GOL_weap_RPG7_RHS` to display as `RPG-7V2 [AI] (GOL)`, identifying
the standard-dispersion launcher as the AI-use variant.

## GOL MAAWS HEDP Round

Added `GOL_mag_MRAWS_HEDP_F`, displayed as `MAAWS HEDP 88 Round`, and
`GOL_ammo_MRAWS_HEDP_F`. The projectile inherits `R_MRAAWS_HE_F`, giving it a
native HE primary impact while its movement properties are set to the
`R_MRAAWS_HEAT_F` trajectory. The primary HE blast has reduced direct impact
damage of 150 to limit structural damage, with 65 indirect damage over a 10
metre radius for stronger anti-personnel coverage and the vanilla HE effects.

On impact, the projectile spawns `GOL_ammo_Penetrator_MRAAWS_HEDP` using the
vanilla HEAT submunition direction, speed, and offset. The penetrator inherits
the dedicated HEAT jet but uses `caliber = 0.85`, giving it stronger HEDP
penetration while remaining weaker than the dedicated HEAT round.

The HEDP magazine is registered in `CBA_Carl_Gustaf`, making it available to
the compatible default MAAWS launchers. The redundant GOL MAAWS launcher
subclasses were removed.