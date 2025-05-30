// [Generator_1,true,true,1000] spawn OKS_fnc_PowerGenerator;
Params ["_Generator","_AddAction","_TurnOffNearbyLights","_RangeOfPowerSupply"];

if (_AddAction) then {
    [_Generator,_TurnOffNearbyLights,_RangeOfPowerSupply] remoteExec ["OKS_fnc_addGeneratorAction", 0, _Generator];
};

systemChat format["[DEBUG] Power Generator Started"];
playSound3D ["\OKS_GOL_Misc\sounds\GeneratorOn.wav", _Generator, false, getPosASL _Generator, 4, 1, 40];
sleep 8.66;
_Generator setVariable ["GeneratorActive", true, true];
systemChat format["[DEBUG] Power Generator Active"];

[{
    params ["_args","_pfhID"];
    _args params ["_Generator"];
    
    if (!(_Generator getVariable ["GeneratorActive", false]) || !alive _Generator) exitWith {
        systemChat format["[DEBUG] Power Generator Off"];
        playSound3D ["\OKS_GOL_Misc\sounds\GeneratorOff.wav", _Generator, false, getPosASL _Generator, 4, 1, 40];
        [_pfhID] call CBA_fnc_removePerFrameHandler;
    };
    
    systemChat format["[DEBUG] Power Generator Idling"];
    playSound3D ["\OKS_GOL_Misc\sounds\GeneratorIdle.wav", _Generator, false, getPosASL _Generator, 4, 1, 40];
}, 5.88, [_Generator]] call CBA_fnc_addPerFrameHandler;



