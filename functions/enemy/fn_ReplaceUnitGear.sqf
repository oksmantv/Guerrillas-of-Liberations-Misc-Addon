/*
    OKS_fnc_ReplaceUnitGear

    Signature:
    [unit, gearSpec, preserveItems, clearMagazines, face, name, identity, rank] call OKS_fnc_ReplaceUnitGear;

    gearSpec supports HASHMAP or ARRAY key/value pairs. Supported keys:
    uniform, vest, backpack,
    headgear, goggles, nvg,
    primaryWeapon, primaryWeaponItems, primaryWeaponMags,
    primaryWeaponMag, primaryWeaponMagCount,
    handgunWeapon, handgunItems, handgunMags,
    handgunMag, handgunMagCount,
    binocular, linkedItems

    Magazine input shortcuts:
    - primaryWeaponMags / handgunMags can be:
      ARRAY of classes: ["30Rnd_65x39_caseless_mag", "30Rnd_65x39_caseless_mag"]
      ARRAY pair: ["30Rnd_65x39_caseless_mag", 6]
      NUMBER: 6 (adds 6x first compatible magazine for selected weapon)
    - primaryWeaponMag + primaryWeaponMagCount and handgunMag + handgunMagCount are explicit class/count shortcuts.

    Example:
    [
        this,
        createHashMapFromArray [
            ["uniform", "U_O_OfficerUniform_ocamo"],
            ["vest", "V_TacVest_khk"],
            ["primaryWeapon", "arifle_Katiba_F"],
            ["primaryWeaponMag", "30Rnd_65x39_caseless_green"],
            ["primaryWeaponMagCount", 6],
            ["handgunWeapon", "hgun_Rook40_F"],
            ["handgunMags", 3],
            ["linkedItems", ["ItemMap", "ItemCompass", "ItemWatch", "ItemRadio", "NVGoggles_OPFOR"]]
        ],
        true,
        false,
        "PersianHead_A3_01",
        "Colonel Abbas Haddad",
        "",
        "COLONEL"
    ] call OKS_fnc_ReplaceUnitGear;
*/

params [
    ["_Unit", objNull, [objNull]],
    ["_GearSpec", createHashMap, [createHashMap, []]],
    ["_PreserveItems", true, [true]],
    ["_ClearMagazines", false, [true]],
    ["_Face", "", [""]],
    ["_Name", "", [""]],
    ["_Identity", "", [""]],
    ["_Rank", "", [""]]
];

private _Debug = missionNamespace getVariable ["GOL_EnemyGear_Debug", false];

if (isNull _Unit || {!alive _Unit}) exitWith {
    if (_Debug) then {
        "[ReplaceUnitGear] Invalid unit input. Exiting with false." spawn OKS_fnc_LogDebug;
    };
    false
};

// Wait for the Framework gear module to finish before overriding gear.
// GW_Gear_appliedGear is set by fnc_Handler.sqf once the module has run.
private _gearModuleDeadline = time + 30;
waitUntil {
    sleep 1;
    (_Unit getVariable ["GW_Gear_appliedGear", false]) || (time > _gearModuleDeadline) || !alive _Unit
};

if (!alive _Unit) exitWith {
    if (_Debug) then {
        "[ReplaceUnitGear] Unit died while waiting for gear module. Exiting with false." spawn OKS_fnc_LogDebug;
    };
    false
};

if (_Debug) then {
    format ["[ReplaceUnitGear] Starting gear application for %1. GW_Gear_appliedGear=%2, alive=%3",
        _Unit,
        _Unit getVariable ["GW_Gear_appliedGear", false],
        alive _Unit
    ] spawn OKS_fnc_LogDebug;
};

private _OriginalDamage = damage _Unit;
private _OriginalCaptive = captive _Unit;
private _OriginalGroup = group _Unit;

private _GearMap = createHashMap;
switch (typeName _GearSpec) do {
    case "HASHMAP": {
        {
            _GearMap set [toLower _x, _GearSpec get _x];
        } forEach (keys _GearSpec);
    };
    case "ARRAY": {
        if ((count _GearSpec) > 0) then {
            if ((_GearSpec#0) isEqualType []) then {
                {
                    if ((count _x) >= 2) then {
                        _GearMap set [toLower (_x#0), _x#1];
                    };
                } forEach _GearSpec;
            } else {
                for "_i" from 0 to ((count _GearSpec) - 2) step 2 do {
                    private _k = _GearSpec#_i;
                    private _v = _GearSpec#(_i + 1);
                    if (_k isEqualType "") then {
                        _GearMap set [toLower _k, _v];
                    };
                };
            };
        };
    };
};

private _GearKeys = keys _GearMap;
private _HasKey = {
    params ["_Key"];
    (toLower _Key) in _GearKeys
};

private _ToArray = {
    params ["_Value"];
    if (_Value isEqualType []) exitWith {_Value};
    if (_Value isEqualType "") exitWith {if (_Value isEqualTo "") then {[]} else {[_Value]}};
    []
};

// Allow face/name/identity/rank to be specified inside gearSpec as an alternative to
// positional parameters. Positional parameters take precedence when non-empty.
if (_Face     isEqualTo "") then { _Face     = _GearMap getOrDefault ["face",     ""]; };
if (_Name     isEqualTo "") then { _Name     = _GearMap getOrDefault ["name",     ""]; };
if (_Identity isEqualTo "") then { _Identity = _GearMap getOrDefault ["identity", ""]; };
if (_Rank     isEqualTo "") then { _Rank     = _GearMap getOrDefault ["rank",     ""]; };

if (_ClearMagazines) then {
    private _ExistingMags = magazines _Unit;
    {
        _Unit removeMagazines _x;
    } forEach (_ExistingMags arrayIntersect _ExistingMags);

    if (_Debug) then {
        format ["[ReplaceUnitGear] Cleared magazines for %1.", _Unit] spawn OKS_fnc_LogDebug;
    };
};

private _OldUniformItems = +uniformItems _Unit;
private _OldVestItems = +vestItems _Unit;
private _OldBackpackItems = +backpackItems _Unit;

if (_Debug) then {
    format ["[ReplaceUnitGear] Pre-removal containers — uniform:'%1' vest:'%2' backpack:'%3'",
        uniform _Unit, vest _Unit, backpack _Unit
    ] spawn OKS_fnc_LogDebug;
    format ["[ReplaceUnitGear] Pre-removal items — uniformItems:%1 | vestItems:%2 | backpackItems:%3",
        _OldUniformItems, _OldVestItems, _OldBackpackItems
    ] spawn OKS_fnc_LogDebug;
    format ["[ReplaceUnitGear] Pre-removal magazines: %1", magazines _Unit] spawn OKS_fnc_LogDebug;
};

private _ReplaceUniform = ["uniform"] call _HasKey;
private _ReplaceVest = ["vest"] call _HasKey;
private _ReplaceBackpack = ["backpack"] call _HasKey;

private _NewUniform = _GearMap getOrDefault ["uniform", ""];
private _NewVest = _GearMap getOrDefault ["vest", ""];
private _NewBackpack = _GearMap getOrDefault ["backpack", ""];

if (_ReplaceUniform) then {
    removeUniform _Unit;
};
if (_ReplaceVest) then {
    removeVest _Unit;
};
if (_ReplaceBackpack) then {
    removeBackpack _Unit;
};

if (_ReplaceUniform && {_NewUniform isEqualType ""} && {_NewUniform != ""}) then {
    _Unit forceAddUniform _NewUniform;
};
if (_ReplaceVest && {_NewVest isEqualType ""} && {_NewVest != ""}) then {
    _Unit addVest _NewVest;
};
if (_ReplaceBackpack && {_NewBackpack isEqualType ""} && {_NewBackpack != ""}) then {
    _Unit addBackpack _NewBackpack;
};

if (_Debug) then {
    format ["[ReplaceUnitGear] Post-container swap — uniform:'%1' vest:'%2' backpack:'%3'",
        uniform _Unit, vest _Unit, backpack _Unit
    ] spawn OKS_fnc_LogDebug;
};

if (_PreserveItems && {(_ReplaceUniform || _ReplaceVest || _ReplaceBackpack)}) then {
    private _GroundHolder = objNull;

    private _AddToContainer = {
        params ["_ContainerType", "_Item"];
        switch (_ContainerType) do {
            case "uniform": { _Unit addItemToUniform _Item };
            case "vest": { _Unit addItemToVest _Item };
            case "backpack": { _Unit addItemToBackpack _Item };
            default { false };
        };
    };

    private _TryAddPreservedItem = {
        params ["_Item", "_PreferredType"];

        private _Order = switch (_PreferredType) do {
            case "uniform": { ["uniform", "vest", "backpack"] };
            case "vest": { ["vest", "uniform", "backpack"] };
            case "backpack": { ["backpack", "vest", "uniform"] };
            default { ["uniform", "vest", "backpack"] };
        };

        // Use exitWith to stop at the first container that accepts the item.
        // The old `count` approach ran for ALL containers, duplicating items across
        // any that had space (filling capacity and creating duplicate gear).
        private _Added = false;
        {
            if ([_x, _Item] call _AddToContainer) exitWith { _Added = true; };
        } forEach _Order;

        if (!_Added) then {
            if (isNull _GroundHolder) then {
                _GroundHolder = createVehicle ["GroundWeaponHolder_Scripted", getPosATL _Unit, [], 0, "CAN_COLLIDE"];
                _GroundHolder setPosATL (_Unit modelToWorld [0.2, 0.2, 0]);
            };
            _GroundHolder addItemCargoGlobal [_Item, 1];
        };

        _Added
    };

    if (_ReplaceUniform) then {
        {
            [_x, "uniform"] call _TryAddPreservedItem;
        } forEach _OldUniformItems;
    };

    if (_ReplaceVest) then {
        {
            [_x, "vest"] call _TryAddPreservedItem;
        } forEach _OldVestItems;
    };

    if (_ReplaceBackpack) then {
        {
            [_x, "backpack"] call _TryAddPreservedItem;
        } forEach _OldBackpackItems;
    };
};

if (["headgear"] call _HasKey) then {
    removeHeadgear _Unit;
    private _Headgear = _GearMap getOrDefault ["headgear", ""];
    if (_Headgear isEqualType "" && {_Headgear != ""}) then {
        _Unit addHeadgear _Headgear;
    };
};

if (["goggles"] call _HasKey) then {
    removeGoggles _Unit;
    private _Goggles = _GearMap getOrDefault ["goggles", ""];
    if (_Goggles isEqualType "" && {_Goggles != ""}) then {
        _Unit addGoggles _Goggles;
    };
};

if (["nvg"] call _HasKey) then {
    private _CurrentHmd = hmd _Unit;
    if (_CurrentHmd != "") then {
        _Unit unlinkItem _CurrentHmd;
    };

    private _Nvg = _GearMap getOrDefault ["nvg", ""];
    if (_Nvg isEqualType "" && {_Nvg != ""}) then {
        _Unit linkItem _Nvg;
    };
};

private _AddWeaponPackage = {
    params ["_WeaponClass", "_MagazineSpec", "_AttachmentList", "_SlotType", ["_MagClassOverride", "", [""]], ["_MagCountOverride", -1, [0]]];

    if !(_WeaponClass isEqualType "") exitWith {};
    if (_WeaponClass isEqualTo "") exitWith {};

    _Unit addWeapon _WeaponClass;

    private _Compatible = compatibleMagazines _WeaponClass;
    private _DefaultCompatibleMag = if ((count _Compatible) > 0) then {_Compatible#0} else {""};
    private _MagazinePlan = [];

    if (_MagClassOverride != "" && {_MagCountOverride > 0}) then {
        _MagazinePlan pushBack [_MagClassOverride, _MagCountOverride];
    } else {
        switch (typeName _MagazineSpec) do {
            case "NUMBER": {
                if (_MagazineSpec > 0 && {_DefaultCompatibleMag != ""}) then {
                    _MagazinePlan pushBack [_DefaultCompatibleMag, floor _MagazineSpec];
                };
            };
            case "STRING": {
                if (_MagazineSpec != "") then {
                    _MagazinePlan pushBack [_MagazineSpec, 1];
                };
            };
            case "ARRAY": {
                if (
                    (count _MagazineSpec) == 2
                    && {(_MagazineSpec#0) isEqualType ""}
                    && {(_MagazineSpec#1) isEqualType 0}
                ) then {
                    _MagazinePlan pushBack [_MagazineSpec#0, floor (_MagazineSpec#1)];
                } else {
                    {
                        if (_x isEqualType "") then {
                            _MagazinePlan pushBack [_x, 1];
                        } else {
                            if (
                                _x isEqualType []
                                && {(count _x) == 2}
                                && {(_x#0) isEqualType ""}
                                && {(_x#1) isEqualType 0}
                            ) then {
                                _MagazinePlan pushBack [_x#0, floor (_x#1)];
                            };
                        };
                    } forEach _MagazineSpec;
                };
            };
            case "HASHMAP": {
                private _SpecClass = _MagazineSpec getOrDefault ["class", _MagazineSpec getOrDefault ["magazine", ""]];
                private _SpecCount = _MagazineSpec getOrDefault ["count", 1];
                if (_SpecClass isEqualType "" && {_SpecClass != ""} && {_SpecCount isEqualType 0}) then {
                    _MagazinePlan pushBack [_SpecClass, floor _SpecCount];
                };
            };
        };
    };

    if (_Debug) then {
        format ["[ReplaceUnitGear] Weapon '%1' — compatibleMagazines: %2", _WeaponClass, _Compatible] spawn OKS_fnc_LogDebug;
        format ["[ReplaceUnitGear] Weapon '%1' — magazine plan: %2", _WeaponClass, _MagazinePlan] spawn OKS_fnc_LogDebug;
    };

    {
        _x params ["_MagClass", "_MagCount"];
        if (_MagClass isEqualType "" && {_MagClass != ""} && {_MagCount > 0}) then {
            if ((count _Compatible) isEqualTo 0 || {_MagClass in _Compatible}) then {
                _Unit addMagazines [_MagClass, _MagCount];
                if (_Debug) then {
                    format ["[ReplaceUnitGear] addMagazines [%1, %2] — post-add mags: %3", _MagClass, _MagCount, magazines _Unit] spawn OKS_fnc_LogDebug;
                };
            } else {
                if (_Debug) then {
                    format ["[ReplaceUnitGear] SKIPPED incompatible mag '%1' for '%2'. Compatible list: %3", _MagClass, _WeaponClass, _Compatible] spawn OKS_fnc_LogDebug;
                };
            };
        };
    } forEach _MagazinePlan;

    {
        if (_x isEqualType "" && {_x != ""}) then {
            switch (_SlotType) do {
                case "primary": { _Unit addPrimaryWeaponItem _x; };
                case "handgun": { _Unit addHandgunItem _x; };
            };
        };
    } forEach _AttachmentList;
};

private _PrimaryWeapon = _GearMap getOrDefault ["primaryweapon", ""];
private _PrimaryWeaponItems = [_GearMap getOrDefault ["primaryweaponitems", []]] call _ToArray;
private _PrimaryWeaponMags = _GearMap getOrDefault ["primaryweaponmags", []];
private _PrimaryWeaponMag = _GearMap getOrDefault ["primaryweaponmag", ""];
private _PrimaryWeaponMagCount = _GearMap getOrDefault ["primaryweaponmagcount", -1];
private _HandgunWeapon = _GearMap getOrDefault ["handgunweapon", ""];
private _HandgunItems = [_GearMap getOrDefault ["handgunitems", []]] call _ToArray;
private _HandgunMags = _GearMap getOrDefault ["handgunmags", []];
private _HandgunMag = _GearMap getOrDefault ["handgunmag", ""];
private _HandgunMagCount = _GearMap getOrDefault ["handgunmagcount", -1];
private _Binocular = _GearMap getOrDefault ["binocular", ""];

private _ReplaceWeapons =
    (["primaryweapon"] call _HasKey)
    || (["primaryweaponitems"] call _HasKey)
    || (["primaryweaponmags"] call _HasKey)
    || (["primaryweaponmag"] call _HasKey)
    || (["primaryweaponmagcount"] call _HasKey)
    || (["handgunweapon"] call _HasKey)
    || (["handgunitems"] call _HasKey)
    || (["handgunmags"] call _HasKey)
    || (["handgunmag"] call _HasKey)
    || (["handgunmagcount"] call _HasKey)
    || (["binocular"] call _HasKey);

if (_ReplaceWeapons) then {
    removeAllWeapons _Unit;

    [_PrimaryWeapon, _PrimaryWeaponMags, _PrimaryWeaponItems, "primary", _PrimaryWeaponMag, _PrimaryWeaponMagCount] call _AddWeaponPackage;
    [_HandgunWeapon, _HandgunMags, _HandgunItems, "handgun", _HandgunMag, _HandgunMagCount] call _AddWeaponPackage;

    if (_Binocular isEqualType "" && {_Binocular != ""}) then {
        _Unit addWeapon _Binocular;
    };
};

if (["linkeditems"] call _HasKey) then {
    {
        _Unit unlinkItem _x;
    } forEach (assignedItems _Unit);

    private _LinkedItems = [_GearMap getOrDefault ["linkeditems", []]] call _ToArray;
    {
        if (_x isEqualType "" && {_x != ""}) then {
            _Unit linkItem _x;
        };
    } forEach _LinkedItems;
};

if (_Identity != "") then {
    private _IdentityExists =
        isClass (missionConfigFile >> "CfgIdentities" >> _Identity)
        || {isClass (configFile >> "CfgIdentities" >> _Identity)};

    if (_IdentityExists) then {
        [_Unit, _Identity] remoteExec ["setIdentity", 0];
    } else {
        if (_Debug) then {
            format ["[ReplaceUnitGear] Skipped identity '%1' (not found in CfgIdentities).", _Identity] spawn OKS_fnc_LogDebug;
        };
    };
};

if (_Face != "") then {
    _Unit setVariable ["GOL_FaceSwap_BlacklistedUnit", true, true];
    [_Unit, _Face] remoteExec ["setFace", 0];

    if (_Debug) then {
        format ["[ReplaceUnitGear] Face defined for %1. Enabled GOL_FaceSwap_BlacklistedUnit.", _Unit] spawn OKS_fnc_LogDebug;
    };
};

if (_Name != "") then {
    _Unit setNameSound "";
    _Unit setName _Name;
    // setName is not network-synced: broadcast to all current clients and JIP players.
    [_Unit, _Name] remoteExec ["setName", 0, _Unit];
    // DUI Squad Radar reads ACE_Name rather than the native name command.
    // ace_common_fnc_setName reads name _unit and writes ACE_Name/ACE_NameRaw (global).
    // Packets from the same machine are processed in order, so this runs after setName.
    if (isClass (configFile >> "CfgPatches" >> "ace_common")) then {
        [_Unit] remoteExec ["ace_common_fnc_setName", 0, _Unit];
    };
};

if (_Rank != "") then {
    private _RankUpper = toUpperANSI _Rank;
    private _ValidRanks = ["PRIVATE", "CORPORAL", "SERGEANT", "LIEUTENANT", "CAPTAIN", "MAJOR", "COLONEL"];
    if (_RankUpper in _ValidRanks) then {
        _Unit setRank _RankUpper;
    } else {
        if (_Debug) then {
            format ["[ReplaceUnitGear] Skipped invalid rank '%1' for %2.", _Rank, _Unit] spawn OKS_fnc_LogDebug;
        };
    };
};

_Unit setDamage _OriginalDamage;
_Unit setCaptive _OriginalCaptive;
if ((group _Unit) != _OriginalGroup) then {
    [_Unit] joinSilent _OriginalGroup;
};

_Unit setVariable ["GW_Gear_BlackList", true, true];
// Signal that gear replacement is fully applied so dependent scripts (e.g. SetupIntel) can proceed.
_Unit setVariable ["GOL_GearReady", true, true];

if (_Debug) then {
    format ["[ReplaceUnitGear] Applied gear replacement to %1. Face='%2' Name='%3' Identity='%4' Rank='%5'", _Unit, _Face, _Name, _Identity, _Rank] spawn OKS_fnc_LogDebug;
    format ["[ReplaceUnitGear] FINAL STATE — uniform:'%1' vest:'%2' backpack:'%3'", uniform _Unit, vest _Unit, backpack _Unit] spawn OKS_fnc_LogDebug;
    format ["[ReplaceUnitGear] FINAL STATE — magazines:%1", magazines _Unit] spawn OKS_fnc_LogDebug;
    format ["[ReplaceUnitGear] FINAL STATE — items:%1", items _Unit] spawn OKS_fnc_LogDebug;
};

true