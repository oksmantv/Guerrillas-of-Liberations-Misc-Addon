# GOL Weather Snowstorm

The snowstorm starts automatically on the server after mission initialization when `GOL_Weather_SnowstormEnabled` is enabled. It is indefinite by default. Mission scripts can also use `[] call OKS_fnc_Weather_Start` and `[] call OKS_fnc_Weather_Stop` on the server.

All behaviour is configured in the **GOL Weather / Snowstorm** CBA category. The options map to the original demo's snowfall, duration, ambient sounds, breath vapour, gust interval, object-force, vanilla fog, local fog, wind intensification, and unit cold-effect parameters.

Implementation is split by locality:

- `XEH_PreInit/XEH_preInit_weather.sqf` registers the mission-scoped CBA settings.
- `XEH_PostInit/XEH_postInit_weather.sqf` starts the server controller.
- `functions/weather/fn_Weather_Start.sqf` and `fn_Weather_ServerLoop.sqf` manage shared weather, gust selection, and optional object force.
- `functions/weather/fn_Weather_Client*.sqf` create client-local particles, sounds, camera effects, and player context tracking.
- `sounds/weather/` contains the user-approved bundled OGG assets from the Snow Storm Script Demo.

The original demo's particle and ambience design was created by ALIAS. This port restructures the implementation as addon functions, removes mission-relative paths and legacy global variables, and supplies JIP-safe client startup.