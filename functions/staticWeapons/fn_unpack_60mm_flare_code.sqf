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
            2,
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
                private _uMax  = if (uniform _player != "") then { getContainerMaxLoad (uniform _player) } else { 0 };
                private _vMax  = if (vest _player != "") then { getContainerMaxLoad (vest _player) } else { 0 };
                private _bpMax = if (backpack _player != "") then { getContainerMaxLoad (backpack _player) } else { 0 };
                private _totalMax  = _uMax + _vMax + _bpMax;
                private _totalLoad = (loadUniform _player) * _uMax + (loadVest _player) * _vMax + (loadBackpack _player) * _bpMax;
                private _invUsagePct = if (_totalMax > 0) then { round (_totalLoad / _totalMax * 100) } else { 0 };
                private _invSpaceStr = str _invUsagePct + "% Inventory Usage";
                if (_FailedUnpack) then {
                    systemChat format ["Unpacked Flare: %1 to inventory, %2 on ground. %3.", _UnpackedRounds, (4 - _UnpackedRounds), _invSpaceStr];
                } else {
                    systemChat format ["You unpacked %1 Flare rounds. %2.", _UnpackedRounds, _invSpaceStr];
                };
                if (_FailedUnpack) then {
                    [_player, _GroundWeaponHolder, _item] spawn {
                        params ["_player", "_holder", "_item"];
                        private _endTime = time + 60;
                        private _done = false;
                        while {time < _endTime && !_done} do {
                            sleep 1;
                            if (!alive _holder) then {
                                _done = true;
                            } else {
                                private _holderMags = magazinesAmmoCargo _holder;
                                private _match = _holderMags select { (_x select 0) == _item };
                                if (count _match == 0) then {
                                    _done = true;
                                } else {
                                    if (_player canAdd [_item, 1, true]) then {
                                        private _ammoCount = (_match select 0) select 1;
                                        _player addMagazine [_item, _ammoCount];
                                        _holder addMagazineAmmoCargo [_item, -1, _ammoCount];
                                        private _uMax  = if (uniform _player != "") then { getContainerMaxLoad (uniform _player) } else { 0 };
                                        private _vMax  = if (vest _player != "") then { getContainerMaxLoad (vest _player) } else { 0 };
                                        private _bpMax = if (backpack _player != "") then { getContainerMaxLoad (backpack _player) } else { 0 };
                                        private _totalMax  = _uMax + _vMax + _bpMax;
                                        private _totalLoad = (loadUniform _player) * _uMax + (loadVest _player) * _vMax + (loadBackpack _player) * _bpMax;
                                        private _pct = if (_totalMax > 0) then { round (_totalLoad / _totalMax * 100) } else { 0 };
                                        private _pctStr = str _pct + "% Inventory Usage";
                                        systemChat format ["✓ Auto-picked up %1 from ground. %2.", getText (configFile >> "CfgMagazines" >> _item >> "displayName"), _pctStr];
                                        _done = true;
                                    };
                                };
                            };
                        };
                    };
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
