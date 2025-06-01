/*
    Code to deploy Supply Drone.
*/

params ["_player"];	

[
    {
        _player = _this select 0;
        private _item = "GOL_Packed_Drone_Supply";
        private _type = missionNamespace getVariable ["GOL_PackedDroneReconClass", "B_UAV_06_F"];
        if (primaryWeapon _player != "") then {
            _player playMoveNow "AmovPknlMstpSlowWrflDnon";
        };

        private _actionName = "Deploying Supply Drone...";
        [
            _actionName,
            3,
            {true},
            {
                (_this select 0) params ["_player","_item","_type"];
                private _dir = (getDir _player);
                private _pos = (_player getRelPos [2, 0]);
                _pos set [2, ((getPosATL _player) select 2)];	
                _HasItem = [_player, _item, true] call BIS_fnc_hasItem;

                if (_HasItem && !(_type isEqualTo "")) then {
                    private _object = createVehicle [_type, [0,0,0], [], 0, "NONE"];
                    _object disableTIEquipment true;
                    _object setVariable ["A3TI_Disable", true,true];
                    _object setVariable ["GOL_ItemPacked",_item];
                    _player removeItem _item;
                    _DroneCrew = createVehicleCrew _object;
                    _player connectTerminalToUAV _object;					
                    _object setPosATL _pos;
                    _object setDir _dir;
                    _object spawn { 
                        sleep 5;
                        params ["_object"];
                        _object disableTIEquipment true;
                        _object setVariable ["A3TI_Disable", true,true];
                    };                    
                    [_object, "drone_box", toLower str (side _caller)] call GW_Gear_Fnc_Handler;
                    ["ace_interact_menu_newControllableObject", [typeOf _object]] call CBA_fnc_globalEvent;
                }
            },
            {
                systemChat "Cancelled deploying Supply Drone.."
            },
            [_player,_item,_type]
        ] call CBA_fnc_progressBar;	
    },
    [_player]
] call CBA_fnc_execNextFrame;