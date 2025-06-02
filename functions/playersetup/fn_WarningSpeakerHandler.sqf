/*
    Warning System for Speaker
*/
[
    { !isNil "TFAR_CurrentUnit" },
    {
        [
            {
                private _lrspeakers = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrSpeakers;
                private _swspeakers = (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwSpeakers;

                if (!isNil "_lrspeakers" && { _lrspeakers }) then {
                    systemChat "WARNING! You have your long-range set to speaker not headphones. Change it!";
                };
                if (!isNil "_swspeakers" && { _swspeakers }) then {
                    systemChat "WARNING! You have your short-range set to speaker not headphones. Change it!";
                };
            },
            10 // Check every 10 seconds
        ] call CBA_fnc_addPerFrameHandler;
    }
] call CBA_fnc_waitUntilAndExecute;