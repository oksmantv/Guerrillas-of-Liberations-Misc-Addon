/*
    Add Unconscious Camera
*/
_Enabled = missionNamespace getVariable ["GOL_Unconscious_CameraEnabled",true];
if (!_Enabled) exitWith {
    if (missionNamespace getVariable ["GOL_Core_Debug", false]) then {
        "Unconscious Camera is disabled. Exiting setup." spawn OKS_fnc_LogDebug;
    };
};

["ace_unconscious", {
    params ["_unit","_unconscious"];
    private _Debug = missionNamespace getVariable ["GOL_Unconscious_CameraDebug",false];
    if (_unit isNotEqualTo player) exitWith {
        if(_Debug) then {
            "Camera: _unit was not equal to player. Exiting.." spawn OKS_fnc_LogDebug;
        };
    };
    if(_unconscious) then {
        _unit spawn {
            params ["_Unit"];
            sleep 0.5;
            private _Debug = missionNamespace getVariable ["GOL_Unconscious_CameraDebug",false];
            private _camera = nil;
            while {!([_Unit] call ace_common_fnc_isAwake) && Alive _Unit} do {               
                _playerbloodVolume = _unit getVariable ["ace_medical_bloodVolume", 6];
                if(_Debug) then {
                    format["Camera: Player Blood: %1 | Camera Active Already: %2 | IsAwake: %3",_playerBloodVolume,_Unit getVariable ["UnconsciousCameraActivated",false],[_Unit] call ace_common_fnc_isAwake] spawn OKS_fnc_LogDebug;
                };
                if(_playerbloodVolume < 5.1 && !(_Unit getVariable ["UnconsciousCameraActivated",false]) && !([_Unit] call ace_common_fnc_isAwake) && Alive _Unit) then {
                    _Unit setVariable ["UnconsciousCameraActivated",true,true];
                    private _dir = 0;
                    private _height = 4;
                    private _distance = 3;

                    if(_Debug) then {
                        format["Added Camera to %1",name _unit] spawn OKS_fnc_LogDebug;
                    };

                    _camera = _unit getVariable ["GOL_SpectatorCamera",nil];
                    if(isNil "_camera") then {
                        _Position = (getPosATL _unit) getPos [_distance,_Dir];
                        _camera = "camera" camCreate [_Position select 0,_Position select 1,_height];     
                    };
                    _camera camSetTarget _unit;
                    _unit setVariable ["GOL_SpectatorCamera",_camera,true];
                    _unit setVariable ["GOL_UnconsciousCameraNVG", false];
                    camUseNVG false;
                    cutText ["", "BLACK OUT",1]; sleep 1;
                    
                    waitUntil {!isNil "ace_medical_feedback_ppUnconsciousBlur"};
                    ppEffectDestroy ace_medical_feedback_ppUnconsciousBlur;            

                    waitUntil {!isNil "ace_medical_feedback_ppUnconsciousBlackout"};
                    ppEffectDestroy ace_medical_feedback_ppUnconsciousBlackout;      

                    showCinemaBorder true;
                    _camera cameraEffect ["internal", "back"];
                    sleep 2;
                    cutText ["", "BLACK IN",3];

                    private _tick = 0;
                    while {!([_unit] call ace_common_fnc_isAwake) && Alive _unit} do {
                        if([_unit] call ace_common_fnc_isAwake || !Alive _unit) exitWith {
                            if(_Debug) then {
                                format["Camera: %1 is now awake or dead. Exiting camera loop.",name _unit] spawn OKS_fnc_LogDebug;
                            };
                            ["", -1, 0, 1, 2, 0, 935] spawn BIS_fnc_dynamicText;
                        };

                        if(_tick % 3 == 0) then {
                            private _startPos = eyePos _unit;
                            private _endPos = _startPos vectorAdd [0, 0, 3]; // 3m above eye level

                            private _hits = lineIntersectsSurfaces [_startPos, _endPos, _unit, objNull, true, 1, "GEOM", "FIRE"];
                            private _isIndoors = count _hits > 0;
                            if(_isIndoors) then {
                                if(_Debug) then {
                                    format["Inside - Camera adjusted",name _unit] spawn OKS_fnc_LogDebug;
                                };                           
                                _height = 1.5;
                                _distance = 2;
                            };
                        };

                        _playerbloodVolume = _unit getVariable ["ace_medical_bloodVolume", 6];
                        private _Tier = "<t color='#ffff66'>TIER 3</t>";
                        private _TierDebug = "TIER 3";
                        if(_playerbloodVolume < 5.1) then {
                            _Tier = "<t color='#ff9933'>TIER 2</t>";
                            _TierDebug = "TIER 2";
                        };
                        if (_playerbloodVolume < 3.6) then {
                            _Tier = "<t color='#ff0000'>TIER 1</t>";
                            _TierDebug = "TIER 1";
                        };

                        // Cardiac arrest is checked every second since every second out of the (default 90s) window matters.
                        // While active, it overrides the blood-volume tier so the player always sees TIER 1 / the countdown.
                        private _isCardiacArrest = _unit getVariable ["ace_medical_inCardiacArrest", false];
                        private _statusText = format["YOU ARE A %1 CASUALTY.",_Tier];
                        private _cardiacDebug = "Not in Cardiac Arrest";
                        if(_isCardiacArrest) then {
                            _Tier = "<t color='#ff0000'>TIER 1</t>";
                            _TierDebug = "TIER 1";
                            _TimeColor = "#ffffff"; // White for >=45s
                            private _cardiacTimeLeft = 0 max (_unit getVariable ["ace_medical_statemachine_cardiacArrestTimeLeft", 0]);
                            if(_cardiacTimeLeft < 45) then {
                                _TimeColor = "#e09f06"; // Red for <45s
                            };
                            if(_cardiacTimeLeft < 15) then {
                                _TimeColor = "#ff0000"; // Red for <15s
                            };
                            _statusText = format["YOU ARE A %1 CASUALTY.<br/><t color='#ff0000'>CARDIAC ARREST</t> <t color='%3'> - %2</t>",_Tier,floor _cardiacTimeLeft,_TimeColor];
                            _cardiacDebug = format["Cardiac Arrest - %1s remaining", floor _cardiacTimeLeft];
                        };

                        private _Debug = missionNamespace getVariable ["GOL_Unconscious_CameraDebug",false];
                        if(_Debug) then {
                            format["Camera Status for %1 - %2 | %3",name _unit,_TierDebug,_cardiacDebug] spawn OKS_fnc_LogDebug;
                        };

                        [_statusText, -1, 0, 2, 0, 0, 935] spawn BIS_fnc_dynamicText;

                        if(_tick % 3 == 0) then {
                            _Position = (getPosATL _unit) getPos [_distance,_Dir];
                            _Dir = _dir + 20;
                            _camera camSetPos [_Position select 0,_Position select 1,_height];
                            _camera camCommit 3;
                        };

                        // Manual NVG keypresses are unreliable while the unit is unconscious (input is locked),
                        // so night vision is instead toggled automatically based on time of day.
                        private _isDark = (daytime < 6) || (daytime > 20);
                        if (_isDark != (_unit getVariable ["GOL_UnconsciousCameraNVG", false])) then {
                            _unit setVariable ["GOL_UnconsciousCameraNVG", _isDark];
                            camUseNVG _isDark;
                            if(_Debug) then {
                                format["Camera: NVG auto-set to %1 for %2 (daytime %3)",_isDark,name _unit,daytime] spawn OKS_fnc_LogDebug;
                            };
                        };

                        _tick = _tick + 1;
                        sleep 1;
                        if([_unit] call ace_common_fnc_isAwake || !Alive _unit) exitWith {
                            if(_Debug) then {
                                format["Camera: %1 is now awake or dead. Exiting camera loop.",name _unit] spawn OKS_fnc_LogDebug;
                            };
                            ["", -1, 0, 1, 2, 0, 935] spawn BIS_fnc_dynamicText;
                        };                       
                    };			
                };
                sleep 5;
                if([_Unit] call ace_common_fnc_isAwake || !Alive _Unit) exitWith {
                    ["", -1, 0, 1, 2, 0, 935] spawn BIS_fnc_dynamicText;
                };
            };  
        };
    };
    if(!(_unconscious)) then {
        _unit spawn {
            _this setVariable ["UnconsciousCameraActivated",false,true];
            _this setVariable ["GOL_UnconsciousCameraNVG", false];
            camUseNVG false;
            private _Debug = missionNamespace getVariable ["GOL_Unconscious_CameraDebug",false];
            if(_Debug) then {
                format["Camera Disabled for %1. Left unconscious state.",name _this] spawn OKS_fnc_LogDebug;
            };                       
            _camera = _this getVariable ["GOL_SpectatorCamera",objNull];
            _camera camSetPos [(getPosATL _this) select 0,(getPosATL _this) select 1,0.1];
            _camera camSetTarget _this;
            _camera camCommit 0.5;      
            cutText ["", "BLACK OUT",0.5]; sleep 0.6;
            _this setVariable ["GOL_SpectatorCamera",nil,true];
            _camera cameraEffect ["terminate", "back"];			
            camDestroy _camera;
            ["", -1, 0, 1, 2, 0, 935] spawn BIS_fnc_dynamicText;
            sleep 0.05;
            cutText ["", "BLACK IN",1];   
        }
    };
}] call CBA_fnc_addEventHandler;

/* Add Fallback Exit if killed during unconscious camera */
player addEventHandler ["Killed", {
    params ["_unit", "_killer"];
    _unit setVariable ["UnconsciousCameraActivated",false,true];
    _unit setVariable ["GOL_UnconsciousCameraNVG", false];
    camUseNVG false;
    private _camera = _unit getVariable ["GOL_SpectatorCamera", objNull];
    private _Debug = missionNamespace getVariable ["GOL_Unconscious_CameraDebug",false];
    if (!isNull _camera) then {        
        _camera cameraEffect ["terminate", "back"];
        camDestroy _camera;
        _unit setVariable ["GOL_SpectatorCamera", nil, true];
        ["", -1, 0, 1, 2, 0, 935] spawn BIS_fnc_dynamicText;
        if(_Debug) then {
            format["Camera Disabled for %1. Killed.",name _unit] spawn OKS_fnc_LogDebug;
        };    
    } else {
        ["", -1, 0, 1, 2, 0, 935] spawn BIS_fnc_dynamicText;
        if(_Debug) then {
            format["Camera did not exist when %1 was killed.",name _unit] spawn OKS_fnc_LogDebug;
        };      
    }
}];