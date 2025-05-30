  params ["_caller", "_target", "_selectionName", "_className", "_itemUser", "_usedItem"];

    if (!(_caller == _target)) then {
        _uncon = _target getVariable ["ace_isUnconscious", false];
        _action = "Tending to";

        switch (_className) do {
            case "ApplyTourniquet": {
                _action = "applying a tourniquet to ";
            };

            case "Morphine": {
                _action = "injecting morphine to";
            };

            case "Epinephrine": {
                _action = "injecting epinephrine to";
            };

            case "FieldDressing";
            case "ElasticBandage";
            case "PackingBandage";
            case "QuikClot": {
                _action = "bandaging";
            };

            case "BloodIV";
            case "BloodIV_500";
            case "BloodIV_250";
            case "PlasmaIV";
            case "PlasmaIV_500";
            case "PlasmaIV_250";
            case "SalineIV";
            case "SalineIV_500";
            case "SalineIV_250": {
                _action = "transfusing fluids to";
            };

            case "PersonalAidKit": {
                _action = "PAKing";
            };

            case "CheckPulse": {
                _action = "checking your pulse";
            };

            case "CheckBloodPressure": {
                _action = "checking your blood pressure";
            };

            case "Diagnose": {
                _action = "diagnosing";
            };

            default {
                _action = "tending to";
            };
        };
        if !(_uncon) then {
            switch (_selectionName) do {
                case "head": {
                    [_caller, _target, "Head", _action] call fnc_displayText;
                };

                case "leftarm": {
                    [_caller, _target, "Left arm", _action] call fnc_displayText;
                };
                
                case "rightarm": {
                    [_caller, _target, "Right arm", _action] call fnc_displayText;
                };

                case "leftleg": {
                    [_caller, _target, "Left leg", _action] call fnc_displayText;
                };

                case "rightleg": {
                    [_caller, _target, "Right leg", _action] call fnc_displayText;
                };

                case "body": {
                    [_caller, _target, "Body", _action] call fnc_displayText;
                };

                default {
                    [_caller, _target, "", "tending to"] call fnc_displayText;
                };
            };
        } else {
            [_caller, _target, "", "tending to"] call fnc_displayText;
        };
    };