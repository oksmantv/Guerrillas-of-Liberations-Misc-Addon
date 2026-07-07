// OKS GOL Misc Addon Version Definition
// This is the single source of truth for the addon version
// Edit this value to update the addon version across all files

#define MISC_MAJOR 3 // 0-10
#define MISC_MINOR 4 // 0-10
#define MISC_PATCHLVL 2 // 0-10
#define MISC_BUILD 070726

#define MISC_VERSION MISC_MAJOR.MISC_MINOR.MISC_PATCHLVL.MISC_BUILD
#define MISC_VERSION_AR MISC_MAJOR,MISC_MINOR,MISC_PATCHLVL,MISC_BUILD

// Double expansion macros for proper stringification
#define STR(x) #x
#define XSTR(x) STR(x)
#define MISC_VERSION_STR XSTR(MISC_VERSION)
