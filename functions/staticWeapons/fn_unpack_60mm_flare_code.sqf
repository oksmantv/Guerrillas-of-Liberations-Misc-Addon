/*
    Code to unpack 60mm mortar rounds.
*/
Params ["_player"];

[
    {
        _player = _this select 0;
        private _actionName = "Unpacking Flare Rounds...";	
        if (primaryWeapon _player != "") then {
            _player playMoveNow "AmovPknlMstpSlowWrflDnon";
        };

        [
            _actionName,
            3,
            {true},
            {
                (_this select 0) params ["_player"];
                _item = "UK3CB_BAF_1Rnd_60mm_Mo_Flare_White";
                _Position = _player getPos [1.4,(getDir _player)];
                _GroundWeaponHolder = createVehicle  ["GroundWeaponHolder", _Position, [], 0, "CAN_COLLIDE"];
                private _FailedUnpack = false;
                private _UnpackedRounds = 0;
                for "_i" from 1 to 4 do {
                    if (_player canAdd [_item, 1, true]) then {
                        _player addMagazineGlobal _item;
                        _UnpackedRounds = _UnpackedRounds + 1;	
                    } else {
                        _GroundWeaponHolder addMagazineCargoGlobal [_item,1];
                        _FailedUnpack = true;			
                    };
                };
                if(_FailedUnpack) then {
                    systemChat format["Your inventory is full. Unpacked %1 Flare rounds on ground.",(4 - _UnpackedRounds)];
                } else {
                    systemChat format["You unpacked %1 Flare rounds.",_UnpackedRounds];
                };
            },
            {
                systemChat "You cancelled unpacking rounds.";
            },
            _player
        ] call CBA_fnc_progressBar;
    },
    [_player]
] call CBA_fnc_execNextFrame;
