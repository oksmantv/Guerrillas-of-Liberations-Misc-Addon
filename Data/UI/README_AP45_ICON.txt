AP45 Icon Required
==================

You need to create an icon file at this location:
data/ui/ap45_icon_ca.paa

This icon will be displayed in the Arsenal for all weapons that have been patched to use AP45 ammunition.

Recommended specifications:
- Format: PAA (Arma texture format)
- Size: 512x512 pixels or 256x256 pixels
- Transparent background recommended
- Should clearly indicate AP45 compatibility (e.g., "AP45" text, special symbol, colored border)

You can use Texview 2 or ImageToPAA to convert a PNG/TGA to PAA format.

Alternative: Use an existing weapon icon as a placeholder by copying it here and renaming to ap45_icon_ca.paa

Temporary workaround: Comment out the "picture = GOL_AP45_ICON;" lines in compat files if you don't want custom icons yet.
