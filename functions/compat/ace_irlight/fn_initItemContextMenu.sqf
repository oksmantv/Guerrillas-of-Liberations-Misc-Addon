#include "..\..\..\script_Component.hpp"
/*
 * Author: OksmanTV
 * Local context menu for the GOL-tagged DBAL copies.
 * Keeps IR dual, IR pointer, IR illuminator, and visible flashlight variants.
 */

{
    private _itemClass = _x;

    {
        _x params ["_variant", "_displayName"];

        [
            _itemClass,
            "POINTER",
            _displayName,
            [],
            "",
            {
                params ["", "", "_item", "", "_variant"];

                private _baseClass = getText (configFile >> "CfgWeapons" >> _item >> "baseWeapon");
                _item != _baseClass + _variant
            }, {
                params ["_unit", "", "_item", "_slot", "_variant"];

                private _weapon = switch (_slot) do {
                    case "RIFLE_POINTER": {primaryWeapon _unit};
                    case "LAUNCHER_POINTER": {secondaryWeapon _unit};
                    case "PISTOL_POINTER": {handgunWeapon _unit};
                    default {""};
                };

                if (_weapon == "") exitWith {};

                private _baseClass = getText (configFile >> "CfgWeapons" >> _item >> "baseWeapon");

                [_unit, _weapon, _item, _baseClass + _variant] call EFUNC(common,switchAttachmentMode);
            },
            false,
            _variant
        ] call CBA_fnc_addItemContextMenuOption;
    } forEach [
        ["", "IR Dual"],
        ["_IP", "IR Pointer"],
        ["_II", "IR Illuminator"],
        ["_FL", "Flashlight"]
    ];
} forEach [
    "GOL_OX3000",
    "GOL_OX3000_LR"
];