/*
    Code to pack static/drone.
*/
Params ["_Player","_Target"];

private _actionName = "Packing...";	
if (primaryWeapon _Player != "") then {
    _Player playMoveNow "AmovPknlMstpSlowWrflDnon";
};
[_actionName, 3, {true}, {
    (_this select 0) params ["_player","_target"];
    private _item = _target getVariable ["GOL_ItemPacked",""];
    if(isNil "_item") exitWith { systemChat "Unable to find ItemPacked classname"};	
    if (_player canAdd [_item, 1, true]) then {
        _player additem _item;
        deleteVehicle _target;
    } else {
        systemChat "Your inventory is full. Unable to pack."
    };
},
{
},[_Player,_Target]] call CBA_fnc_progressBar;