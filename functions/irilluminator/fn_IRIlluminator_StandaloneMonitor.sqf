/*
    Standalone client-side IR illuminator monitor.

    Replaces the retired BettIR bridge. GOL creates and manages local scripted
    lights for active OX3000 dual-mode IR lasers. The public strength variable
    keeps each client rendering nearby players at the same configured intensity.
*/

if (!hasInterface) exitWith { false };
if (missionNamespace getVariable ["OKS_IRIlluminator_Monitor_Started", false]) exitWith { true };
missionNamespace setVariable ["OKS_IRIlluminator_Monitor_Started", true];

[] spawn {
    waitUntil { sleep 0.25; !isNull player };

    // Local light records: [[unit, light], ...].
    private _unitLights = [];

    while { true } do {
        private _enabled = missionNamespace getVariable ["GOL_IRIlluminator_Enabled", true];

        if (!_enabled) then {
            {
                private _light = _x select 1;
                if (!isNull _light) then {
                    deleteVehicle _light;
                };
            } forEach _unitLights;
            _unitLights = [];
            sleep 1;
            continue;
        };

        private _maxDistance = missionNamespace getVariable ["GOL_IRIlluminator_MaxDistance", 150];
        private _nearPlayers = allPlayers select {
            alive _x && { (player distance _x) < _maxDistance }
        };
        private _unitsWithLights = [];
        private _forceUpdate = missionNamespace getVariable ["GOL_IRIlluminator_ForceUpdate", false];

        {
            private _unit = _x;
            private _weapon = currentWeapon _unit;

            if (_weapon != "") then {
                private _accessories = switch (_weapon) do {
                    case (primaryWeapon _unit): { primaryWeaponItems _unit };
                    case (handgunWeapon _unit): { handgunItems _unit };
                    case (secondaryWeapon _unit): { secondaryWeaponItems _unit };
                    default { [] };
                };
                private _attachment = _accessories param [1, ""];
                private _isGOLIRLaser = _attachment in ["GOL_OX3000", "GOL_OX3000_LR"];

                // The engine IR-laser state is the dual-mode illuminator toggle.
                if (_isGOLIRLaser && { _unit isIRLaserOn _weapon }) then {
                    _unitsWithLights pushBack _unit;

                    // Preserve the existing low/medium/high strength steps.
                    private _strength = _unit getVariable ["GOL_IRIlluminator_Strength", 1];
                    private _brightness = 0.2 + (_strength * 0.1);
                    private _intensity = _strength * 0.6;
                    private _existingIndex = _unitLights findIf { (_x select 0) isEqualTo _unit };
                    private _existingLight = if (_existingIndex isEqualTo -1) then {
                        objNull
                    } else {
                        (_unitLights select _existingIndex) select 1
                    };
                    private _lastStrength = if (isNull _existingLight) then {
                        -1
                    } else {
                        _existingLight getVariable ["GOL_LastStrength", -1]
                    };

                    if (isNull _existingLight || _lastStrength != _strength || _forceUpdate) then {
                        if (!isNull _existingLight) then {
                            deleteVehicle _existingLight;
                        };

                        private _light = "#lightpoint" createVehicleLocal (getPosATL _unit);
                        _light setLightBrightness _brightness;
                        _light setLightColor [1, 1, 1];
                        _light setLightAmbient [0.8, 0.8, 0.8];
                        _light setLightIntensity _intensity;
                        _light setLightUseFlare false;
                        _light setLightDayLight false;
                        _light setVariable ["GOL_LastStrength", _strength];
                        _light attachTo [_unit, [0, 0.3, 0.1], "head"];

                        if (_existingIndex isEqualTo -1) then {
                            _unitLights pushBack [_unit, _light];
                        } else {
                            _unitLights set [_existingIndex, [_unit, _light]];
                        };
                    } else {
                        _existingLight setLightBrightness _brightness;
                        _existingLight setLightIntensity _intensity;
                    };
                };
            };
        } forEach _nearPlayers;

        if (_forceUpdate) then {
            missionNamespace setVariable ["GOL_IRIlluminator_ForceUpdate", false];
        };

        // Remove lights for players that changed mode, died, or moved away.
        private _indicesToRemove = [];
        {
            private _unit = _x select 0;
            private _light = _x select 1;

            if (!(_unit in _unitsWithLights) || !alive _unit || (player distance _unit) >= _maxDistance) then {
                if (!isNull _light) then {
                    deleteVehicle _light;
                };
                _indicesToRemove pushBack _forEachIndex;
            };
        } forEach _unitLights;

        reverse _indicesToRemove;
        {
            _unitLights deleteAt _x;
        } forEach _indicesToRemove;

        sleep 0.15;
    };
};

true
