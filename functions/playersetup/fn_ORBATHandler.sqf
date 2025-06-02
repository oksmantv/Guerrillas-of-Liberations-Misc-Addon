/*
    Setup ORBAT Handler
*/
private _interval = 10;        // Check every 10 seconds
private _timeout = time + 60;  // Stop after 60 seconds
private _handler = [
    {
        // Condition: Either both variables are defined, or timeout reached
        (!isNil "ORBAT_GROUP" && !isNil "GOL_SelectedComposition") || {time > _timeout}
    },
    {
        // Execution: Check which case triggered
        if (!isNil "ORBAT_GROUP" && !isNil "GOL_SelectedComposition") then {
            private _composition = missionNamespace getVariable "GOL_SelectedComposition";
            [_composition] spawn OKS_fnc_Orbat_Setup;
        } else {
            if (isServer) then {
                if (isNil "ORBAT_GROUP") then {
                    "The ORBAT Group module is missing." spawn OKS_fnc_LogDebug;
                };
                if (isNil "GOL_SelectedComposition") then {
                    "GOL_SelectedComposition variable is undefined. If you want to use the ORBAT, make sure to assign it in missionSettings.sqf." spawn OKS_fnc_LogDebug;
                };
            };
        };
    },
    [],
    _interval
] call CBA_fnc_waitUntilAndExecute; 