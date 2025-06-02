/*
    Inventory Warning System
*/
player addEventHandler ["InventoryOpened", {
    params ["_unit", "_container"];

    if(isNil "medical_box_west" || isNil "medical_box_east") exitWith {};
    if(isNil "flag_west_1" || isNil "flag_east_1") exitWith {};
    if(isNil "flag_west_2" || isNil "flag_east_2") exitWith {};

    // Medical crate check
    if (_container in [medical_box_west, medical_box_east]) then {
        format["%1 accessed the medical crate at base.", name _unit] remoteExec ["systemChat", 0];
    };

    // Ammo crate at base check
    if (
        typeOf _container in ["Box_Syndicate_Ammo_F", "Box_Syndicate_Wps_F", "B_supplyCrate_F"] &&
        { _container distance _x < 150 } count [flag_west_1, flag_east_1, flag_west_2, flag_east_2] > 0
    ) then {
        format["%1 accessed an ammo crate at base.", name _unit] remoteExec ["systemChat", 0];
    };

    // Equipment crate at base check
    if (
        typeOf _container in ["Box_NATO_Equip_F"] &&
        { _container distance _x < 150 } count [flag_west_1, flag_east_1, flag_west_2, flag_east_2] > 0
    ) then {
        format["%1 accessed the equipment crate at base.", name _unit] remoteExec ["systemChat", 0];
    };
}];