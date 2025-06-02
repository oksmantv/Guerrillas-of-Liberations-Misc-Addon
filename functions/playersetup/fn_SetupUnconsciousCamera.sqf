/*
    Add Unconscious Camera
*/
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
            while {!([_Unit] call ace_common_fnc_isAwake)} do {               
                _playerbloodVolume = _unit getVariable ["ace_medical_bloodVolume", 6];
                if(_Debug) then {
                    format["Camera: Player Blood: %1 | Camera Active Already: %2 | IsAwake: %3",_playerBloodVolume,_Unit getVariable ["UnconsciousCameraActivated",false],[_Unit] call ace_common_fnc_isAwake] spawn OKS_fnc_LogDebug;
                };
                if(_playerbloodVolume < 5.1 && !(_Unit getVariable ["UnconsciousCameraActivated",false]) && !([_Unit] call ace_common_fnc_isAwake)) then {
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
                    _camera camSetTarget player;
                    _unit setVariable ["GOL_SpectatorCamera",_camera,true];	
                    cutText ["", "BLACK OUT",1]; sleep 1;
                    
                    waitUntil {!isNil "ace_medical_feedback_ppUnconsciousBlur"};
                    ppEffectDestroy ace_medical_feedback_ppUnconsciousBlur;            

                    waitUntil {!isNil "ace_medical_feedback_ppUnconsciousBlackout"};
                    ppEffectDestroy ace_medical_feedback_ppUnconsciousBlackout;      

                    showCinemaBorder true;
                    _camera cameraEffect ["internal", "back"];
                    sleep 2;
                    cutText ["", "BLACK IN",3];

                    while {!([_unit] call ace_common_fnc_isAwake)} do {
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

                        private _Debug = missionNamespace getVariable ["GOL_Unconscious_CameraDebug",false];
                        if(_Debug) then {
                            format["Camera Status for %1 - %2",name _unit,_TierDebug] spawn OKS_fnc_LogDebug;
                        };

                        [format["YOU ARE A %1 CASUALTY.",_Tier], -1, 0, 5, 0, 0, 935] spawn BIS_fnc_dynamicText;
                        _Position = (getPosATL _unit) getPos [_distance,_Dir];
                        _Dir = _dir + 10;
                        _camera camSetPos [_Position select 0,_Position select 1,_height];
                        _camera camCommit 1;
                        sleep 3;
                    };			
                };
                sleep 5;
                if([_Unit] call ace_common_fnc_isAwake) exitWith {

                };
            };  
        };
    };
    if(!(_unconscious)) then {
        _unit spawn {
            _this setVariable ["UnconsciousCameraActivated",false,true];
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
    private _camera = _unit getVariable ["GOL_SpectatorCamera", objNull];
    private _Debug = missionNamespace getVariable ["GOL_Unconscious_CameraDebug",false];
    if (!isNull _camera) then {
        if(_Debug) then {
            format["Camera Disabled for %1. Killed.",name _this] spawn OKS_fnc_LogDebug;
        };    
        
        _camera cameraEffect ["terminate", "back"];
        camDestroy _camera;
        _unit setVariable ["GOL_SpectatorCamera", nil, true];
        ["", -1, 0, 1, 2, 0, 935] spawn BIS_fnc_dynamicText;
    } else {
        if(_Debug) then {
            format["Camera did not exist when %1 was killed.",name _unit] spawn OKS_fnc_LogDebug;
        };      
    }
}];