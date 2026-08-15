/// [this] spawn OKS_fnc_Mechanized;
/// [vehicle,ShouldAddMortar,AddServiceStationInCargo,ShouldDisableThermals,ShouldDisableNVG]
/// Add MSS Box true/false

if(!isServer) exitWith {};

params
[
	["_Vehicle", objNull, [objNull]],
	["_Flag",(missionNamespace getVariable ["GOL_Vehicle_Flag",""]),[""]],
	["_AddMortar", false, [true]],
	["_ServiceStation", true, [true]],
	["_ShouldDisableThermal", true, [true]],
	["_shouldDisableNVG", false, [true]],
	["_MortarType","heavy",[""]]
];

private _Debug = missionNamespace getVariable ["GOL_GroundVehicles_Debug",false];

if(_Debug) then {
	format["[MECHANIZED] Starting setup for vehicle: %1 (%2)", [configFile >> "CfgVehicles" >> typeOf _Vehicle] call BIS_fnc_displayName, typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	format["[MECHANIZED] Parameters - Mortar: %1 | ServiceStation: %2 | Thermal: %3 | NVG: %4 | MortarType: %5", _AddMortar, _ServiceStation, _ShouldDisableThermal, _shouldDisableNVG, _MortarType] spawn OKS_fnc_LogDebug;
};

sleep 5;

if(_Flag != "" && flagTexture _Vehicle == "") then {
	_Vehicle forceFlagTexture _Flag;
	if(_Debug) then {
		format["[MECHANIZED] Applied flag texture: %1", _Flag] spawn OKS_fnc_LogDebug;
	};
};

private _Debug_Variable = false;
_Vehicle setVariable ["GW_Disable_autoRemoveCargo",true,true];

// Disable ACE's default vehicle turret rearm handling for UK3CB vehicles.
// We use a custom cargo-magazine rearm workflow instead (via MSS).
if ((typeOf _Vehicle find "UK3CB_BAF") == 0) then {
	_Vehicle setVariable ["ace_rearm_disabled", true, true];
};

if(_Debug) then {
	format["[MECHANIZED] Clearing vehicle cargo and setting base properties"] spawn OKS_fnc_LogDebug;
};

clearItemCargoGlobal _Vehicle;
clearWeaponCargoGlobal _Vehicle;
clearMagazineCargoGlobal _Vehicle;
clearBackpackCargoGlobal _Vehicle;
_Vehicle setFuelConsumptionCoef 3;
_Vehicle setVariable ["gw_gear_blackList",true,true];

if(_ShouldDisableThermal) then {
	_Vehicle disableTIEquipment true;
	_Vehicle setVariable ["A3TI_Disable", true,true];
	if(_Debug) then {
		format["[MECHANIZED] Disabled thermal equipment for: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
};
if(_shouldDisableNVG) then {
	_Vehicle disableNVGEquipment true;
	if(_Debug) then {
		format["[MECHANIZED] Disabled NVG equipment for: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
	};
};

if(_Debug) then {
	format["[MECHANIZED] Starting modular function calls for: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
};

[_Vehicle] call OKS_fnc_SetupMissileWarning;
[_Vehicle, 40] call OKS_fnc_SetupCargoSpace;
[_Vehicle, _ServiceStation] call OKS_fnc_SetupServiceStation;
[_Vehicle, _AddMortar, _MortarType] call OKS_fnc_SetupVehicleInventory;
[_Vehicle] call OKS_fnc_Rearm3CBVehicle;
[_Vehicle] call OKS_fnc_SetupCargoItems;
[_Vehicle] call OKS_fnc_AdjustPlayerVehicleDamage;

// Proximity fuse — runs after sleep 5 so weaponState returns the real loaded magazine.
// Actions are persistent on the vehicle (condition limits visibility to gunner).
// FiredEH is server-side: vehicle is server-local so local _vehicle is true here.
if (_Vehicle isKindOf "LandVehicle") then {
    // Config-based HE detection — reads CfgVehicles/CfgWeapons directly so it works
    // at any time regardless of whether a gunner is currently seated in the turret.
    // (weaponState returns empty strings for uncrewed turrets, causing false negatives.)
    private _hasHECannon = (allTurrets _Vehicle) findIf {
        private _turretPath = _x;
        // weaponsTurret is binary: vehicle weaponsTurret turretPath
        // _turretPath from allTurrets is already an array like [0] — no extra wrapping
        (_Vehicle weaponsTurret _turretPath) findIf {
            private _weapon = _x;
            private _weaponCfg = configFile >> "CfgWeapons" >> _weapon;
            // Collect magazine classnames from both the top-level array and every named
            // muzzle sub-class (CTWS / dual-feed weapons store them under muzzle entries).
            private _mags = getArray (_weaponCfg >> "magazines");
            {
                private _muzzle = _x;
                // Skip the self-reference entry (single-muzzle weapons list the weapon
                // classname itself in muzzles[]; actual sub-muzzles are different names)
                if (_muzzle != _weapon && isClass (_weaponCfg >> _muzzle)) then {
                    _mags = _mags + getArray (_weaponCfg >> _muzzle >> "magazines");
                };
            } forEach (getArray (_weaponCfg >> "muzzles"));
            // Any magazine whose ammo has indirectHit + explosive qualifies
            _mags findIf {
                private _ammo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
                (_ammo != "") &&
                ((getNumber (configFile >> "CfgAmmo" >> _ammo >> "indirectHit")) > 0) &&
                ((getNumber (configFile >> "CfgAmmo" >> _ammo >> "explosive"))   > 0)
            } >= 0
        } >= 0
    } >= 0;

	diag_log format ["[MECHANIZED] Proximity fuse check for %1: HE cannon found = %2", typeOf _Vehicle, _hasHECannon];

    if (_hasHECannon) then {
        _Vehicle setVariable ["OKS_ProxRound_Capable", true, true];
		diag_log format ["[MECHANIZED] Proximity fuse enabled for %1", typeOf _Vehicle];
        _Vehicle addAction [
            "<t color='#FFB300'>Proximity Fuse: </t><img image='\a3\ui_f\data\IGUI\Cfg\Actions\ico_OFF_ca.paa' size='1'/>",
            {
				private _veh    = _this select 0;
				private _caller = _this select 1;
				_veh setVariable ["OKS_ProxRound_Active", false, true];
				[parseText (
					"<t align='center'>" +
					"<img image='\a3\ui_f\data\IGUI\Cfg\Actions\ico_OFF_ca.paa' size='2'/><br/>" +
					"<t size='1.5' font='PuristaBold' color='#FFFFFF'>Proximity Fuse</t><br/>" +
					"<t size='1.2' color='#FFB300'>INACTIVE</t>" +
					"</t>"
				)] remoteExec ["hintSilent", _caller];
				[{ hintSilent ""; }, [], 3.0] remoteExec ["CBA_fnc_waitAndExecute", _caller];
			},
            nil, 1.5, true, true, "",
            "(_this != vehicle _this) && (gunner _target == _this) && (_target getVariable ['OKS_ProxRound_Active', false])"
        ];
        _Vehicle addAction [
            "<t color='#66FF66'>Proximity Fuse: </t><img image='\a3\ui_f\data\IGUI\Cfg\Actions\ico_ON_ca.paa' size='1'/>",
            {
				private _veh    = _this select 0;
				private _caller = _this select 1;
				_veh setVariable ["OKS_ProxRound_Active", true, true];
				[parseText (
					"<t align='center'>" +
					"<img image='\a3\ui_f\data\IGUI\Cfg\Actions\ico_ON_ca.paa' size='2'/><br/>" +
					"<t size='1.5' font='PuristaBold' color='#FFFFFF'>Proximity Fuse</t><br/>" +
					"<t size='1.2' color='#66FF66'>ACTIVE</t><br/>" +
					"<t size='0.9' color='#AAAAAA'>Lase target first (T)</t>" +
					"</t>"
				)] remoteExec ["hintSilent", _caller];
				[{ hintSilent ""; }, [], 4.0] remoteExec ["CBA_fnc_waitAndExecute", _caller];
			},
            nil, 1.5, true, true, "",
            "(_this != vehicle _this) && (gunner _target == _this) && !(_target getVariable ['OKS_ProxRound_Active', false])"
        ];

        // Add FiredEH on ALL machines so it fires on the gunner's client too.
        // The handler gates on (local _gunner) — only the gunner's machine processes it,
        // which is where the projectile simulation lives.
        [_Vehicle, ["Fired", { _this call OKS_fnc_ProxRound_FiredHandler }]] remoteExec ["addEventHandler", 0];
		diag_log format ["[MECHANIZED] Proximity fuse Fired EH added for %1", typeOf _Vehicle];
        if (_Debug) then {
            format ["[MECHANIZED] Proximity fuse set up: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
        };
    };
};

// Clear persistent seat assignment when dead crew are unloaded.
// Without unassignVehicle the engine keeps the dead unit assigned,
// blocking the seat even though the body is gone.
_Vehicle addEventHandler ["GetOut", {
	params ["_vehicle", "_role", "_unit", "_turret"];
	if (!alive _unit) then {
		unassignVehicle _unit;
		if (_role == "driver") then {
			_vehicle lockDriver false;
		};
		if (missionNamespace getVariable ["GOL_GroundVehicles_Debug", false]) then {
			format["[MECHANIZED] Dead %1 unloaded from %2 — seat assignment cleared", _role, typeOf _vehicle] spawn OKS_fnc_LogDebug;
		};
	};
}];

private _VehicleEmptyEnabled = missionNamespace getVariable ["GOL_VehicleEmpty_Enabled", false];
if (_VehicleEmptyEnabled) then {
	[_Vehicle] spawn OKS_fnc_VehicleEmpty;
};

sleep 5;
if(_Debug_Variable) then {"[Mechanized] Remove dapsCanSmoke" spawn OKS_fnc_LogDebug};
_Vehicle setVariable["dapsCanSmoke",0,true];

if(_Debug) then {
	format["[MECHANIZED] Completed setup for vehicle: %1", typeOf _Vehicle] spawn OKS_fnc_LogDebug;
};