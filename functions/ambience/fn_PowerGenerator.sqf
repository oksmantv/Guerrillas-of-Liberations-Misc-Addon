// [Generator_1,true,true,1000] spawn OKS_fnc_PowerGenerator;
Params ["_Generator","_AddAction","_TurnOffNearbyLights","_RangeOfPowerSupply"];

if (_AddAction) then {
    [_Generator,_TurnOffNearbyLights,_RangeOfPowerSupply] remoteExec ["OKS_fnc_addGeneratorAction", 0, _Generator];
};

private _Debug = missionNamespace getVariable ["GOL_Ambience_Debug", false];
if(_Debug) then {
    format["[Generator] Power Generator Started"] spawn OKS_fnc_logDebug;
};

playSound3D ["\OKS_GOL_Misc\sounds\GeneratorOn.wav", _Generator, false, getPosASL _Generator, 4, 1, 40];
sleep 8.66;
_Generator setVariable ["GeneratorActive", true, true];
format["[Generator] Power Generator Active"] spawn OKS_fnc_logDebug;

[{
    params ["_args","_pfhID"];
    _args params ["_Generator"];
    private _Debug = missionNamespace getVariable ["GOL_Ambience_Debug", false];
    
    if (!(_Generator getVariable ["GeneratorActive", false]) || !alive _Generator) exitWith {
        if(_Debug) then {
            format["[Generator] Power Generator Off"] spawn OKS_fnc_logDebug;
        };        

        playSound3D ["\OKS_GOL_Misc\sounds\GeneratorOff.wav", _Generator, false, getPosASL _Generator, 4, 1, 40];
        [_pfhID] call CBA_fnc_removePerFrameHandler;
    };

    if(_Debug) then {
        format["[Generator] Power Generator Idling"] spawn OKS_fnc_logDebug;
    };        
    playSound3D ["\OKS_GOL_Misc\sounds\GeneratorIdle.wav", _Generator, false, getPosASL _Generator, 4, 1, 40];
}, 5.88, [_Generator]] call CBA_fnc_addPerFrameHandler;



