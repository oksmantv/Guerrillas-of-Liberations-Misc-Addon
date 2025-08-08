// [] spawn OKS_fnc_SetMissionComplete;
Params [
    ["_IsMissionSuccess",false,[false]]
];

#define CURRENT_WEAPONS player, currentWeapon player, currentMuzzle player
_uid = getPlayerUID (player);
_isNCO = false;
switch _uid do {
    case "76561198013929549": { _isNCO = true }; // Oksman
    case "76561198086056020": { _isNCO = true }; // Blu.
    case "76561199681025229": { _isNCO = true }; // Rutters
    case "76561198005972885": { _isNCO = true }; // Pilgrim
    case "76561198014971848": { _isNCO = true }; // Filth
    case "76561198091519166": { _isNCO = true }; // Juan Sanchez
    case "76561198058521961": { _isNCO = true }; // Joona
    case "76561198210159148": { _isNCO = true }; // Eric
    default { _isNCO = false; };
};


if (!(serverCommandAvailable "#kick" || isServer || _isNCO)) exitWith {};
if (isNil {missionNamespace getVariable "GOL_ShowMissionCompleteHint"}) then {
    missionNamespace setVariable ["GOL_ShowMissionCompleteHint", false, true];
};

private _show = !(missionNamespace getVariable ["GOL_ShowMissionCompleteHint", false]);
missionNamespace setVariable ["GOL_ShowMissionCompleteHint", _show, true];

if (_show) then {
    [_IsMissionSuccess] spawn {
        params ["_IsMissionSuccess"];
        while {missionNamespace getVariable ["GOL_ShowMissionCompleteHint", false]} do {
            // Mission name
            private _missionName = getText (missionConfigFile >> "briefingName");
            if (_missionName isEqualTo "") then {_missionName = missionName;};

            // Support unit classnames
            private _SupportUnits = [
                "wcrew1","wcrew2","wcrew3","wcrew4","wcrew5","wcrew6","wecho1","wecho2","wecho3","wecho4","wecho5","wecho6",
                "ecrew1","ecrew2","ecrew3","ecrew4","ecrew5","ecrew6","eecho1","eecho2","eecho3","eecho4","eecho5","eecho6"
            ];

            // Separate players into platoon (ground) and support
            private _groundPlayers = (allPlayers - entities "HeadlessClient_F") select {!(str _x in _SupportUnits) && alive _x};
            private _supportPlayers = (allPlayers - entities "HeadlessClient_F") select {str _x in _SupportUnits && alive _x};
            if(isServer && !isDedicated) then {
                _groundPlayers = allUnits select {!(str _x in _SupportUnits) && alive _x && side group _X == side group player};
                _groundPlayers = _groundPlayers select [0, 20];
                { _Random = (selectRandom [0,0,0,0,1,2,3,4,5]); _x setVariable ["GOL_Player_Deaths",_Random] } foreach _groundPlayers;

                _supportPlayers = allUnits select {(str _x in _SupportUnits) && alive _x && side group _X == side group player};
                _supportPlayers = _supportPlayers select [0, 5];
                { _Random = (selectRandom [0,0,0,0,1,2,3,4,5]); _x setVariable ["GOL_Player_Deaths",_Random] } foreach _supportPlayers;
            };
            _groundPlayers = [_groundPlayers, [], { _x getVariable ["GOL_Player_Deaths", 0] }, "ASCEND"] call BIS_fnc_sortBy;
            _supportPlayers = [_supportPlayers, [], { _x getVariable ["GOL_Player_Deaths", 0] }, "ASCEND"] call BIS_fnc_sortBy;      

            // Platoon (ground) casualties
            private _groundTotal = count _groundPlayers;
            private _groundDeaths = 0;
            private _groundDeathsList = "";
            {
                private _deaths = _x getVariable ["GOL_Player_Deaths",0];
                _groundDeaths = _groundDeaths + _deaths;
                _groundDeathsList = _groundDeathsList + format ["%1: %2<br/>", name _x, _deaths];
            } forEach _groundPlayers;
            private _groundCasualty = if (_groundTotal > 0) then {round((_groundDeaths / _groundTotal) * 100)} else {0};
            private _groundColor = "#21d111";
            if (_groundCasualty > 15 && _groundCasualty <= 30) then {_groundColor = "#24930C";};
            if (_groundCasualty > 30 && _groundCasualty <= 45) then {_groundColor = "#c49102";};
            if (_groundCasualty > 45 && _groundCasualty <= 60) then {_groundColor = "#f26900";};
            if (_groundCasualty > 60) then {_groundColor = "#ff0000";};

            // Support casualties
            private _supportTotal = count _supportPlayers;
            private _supportDeaths = 0;
            private _supportDeathsList = "";
            {
                private _deaths = _x getVariable ["GOL_Player_Deaths",0];
                _supportDeaths = _supportDeaths + _deaths;
                _supportDeathsList = _supportDeathsList + format ["%1: %2<br/>", name _x, _deaths];
            } forEach _supportPlayers;
            private _supportCasualty = if (_supportTotal > 0) then {round((_supportDeaths / _supportTotal) * 100)} else {0};
            private _supportColor = "#21d111";
            if (_supportCasualty > 30 && _supportCasualty <= 60) then {_supportColor = "#fcba03";};
            if (_supportCasualty > 60) then {_supportColor = "#ff0000";};

            private _enemiesKilled = missionNamespace getVariable ["GOL_EnemiesKilled", 0];
            private _civiliansKilled = missionNamespace getVariable ["GOL_CiviliansKilled", 0];
            private _currentPOWs = missionNamespace getVariable ["GOL_CapturedPOWs", 0];
            private _totalSeconds = time; // Or your own elapsed seconds value
            private _friendlyFireKills = missionNamespace getVariable ["GOL_FriendlyFireKills", 0];

            private _hours = floor (_totalSeconds / 3600);
            private _minutes = floor ((_totalSeconds % 3600) / 60);
            private _seconds = floor (_totalSeconds % 60);

            // Pad with zeros using format
            private _hoursStr = if (_hours < 10) then { format ["0%1", _hours] } else { str _hours };
            private _minutesStr = if (_minutes < 10) then { format ["0%1", _minutes] } else { str _minutes };
            private _secondsStr = if (_seconds < 10) then { format ["0%1", _seconds] } else { str _seconds };
            private _formattedTime = format ["%1:%2:%3", _hoursStr, _minutesStr, _secondsStr];
            
            // Structured text for hintSilent
            _MissionStatus = "MISSION COMPLETE";
            _MissionStatusColor = "#FFD700";
            if(_IsMissionSuccess isEqualTo false) then {
                _MissionStatus = "MISSION FAILED";
                _MissionStatusColor = "#da1616";
            };
            private _armaPath = "\a3\ui_f\data\Logos\arma3_white_ca.paa";
            private _logoPath = "\OKS_GOL_MISC\data\images\logo.paa";
            private _playerPath = "\a3\ui_f\data\IGUI\Cfg\MPTable\infantry_ca.paa";
            private _deathPath = "\a3\ui_f\data\IGUI\Cfg\MPTable\killed_ca.paa";
            private _killsPath = "\a3\ui_f\data\GUI\Rsc\RscDisplayGarage\crew_ca.paa";
            private _civilianPath = "\a3\ui_f\data\GUI\Cfg\Hints\Death_ca.paa";
            private _timePath = "\a3\ui_f\data\GUI\Cfg\Hints\Timing_ca.paa";
            private _heliPath = "\a3\ui_f\data\GUI\Rsc\RscDisplayGarage\helicopter_ca.paa";
            private _tankPath = "\a3\ui_f\data\GUI\Rsc\RscDisplayGarage\tank_ca.paa";
            private _captivePath = "\OKS_GOL_MISC\data\UI\Surrender_ca.paa";
            private _captivePath = "\OKS_GOL_MISC\data\UI\Surrender_ca.paa";
            private _friendlyFirePath = "\a3\ui_f\data\IGUI\Cfg\Cursors\unitInjured_ca.paa";
            private _hintText = format [
                "<img image='%1' size='3'/><img image='%2' size='3'/><br/>" +
                "<t size='1.8' font='RobotoCondensedBold' color='%24'>%23</t><br/>" +
                "<t size='1.1' font='RobotoCondensedBold' color='#FFFFFF'>%3</t><br/><br/>" +
                "<img image='%4' size='1.3'/><t color='#FFFFFF' font='RobotoCondensedBold'> Active Players: %5</t><br/>" +
                "<img image='%6' size='1.3'/><t color='#FFFFFF' font='RobotoCondensedBold'> Enemies Killed: %7</t><br/>" +
                "<img image='%8' size='1.2'/><t color='#FFFFFF' font='RobotoCondensedBold'> Non-Combatants Killed: %9</t><br/>" +
                "<img image='%26' size='1.4'/><t color='#FFFFFF' font='RobotoCondensedBold'> Friendly Fire Incidents: %25</t><br/>" +
                "<img image='%22' size='1.2'/><t color='#FFFFFF' font='RobotoCondensedBold'> POWs Captured: %21</t><br/>" +                
                "<img image='%10' size='1.2'/><t color='#FFFFFF' font='RobotoCondensedBold'> Time Elapsed: %11</t><br/><br/>" +
                "<img image='%12' size='1.4'/><t size='1.0' font='RobotoCondensedBold'>Platoon Casualty Rate: <t color='%13'> %14%%</t></t><br/>" +
                "<t color='#FFFFFF' font='RobotoCondensedBold'>%15</t><br/>" +
                "<img image='%16' size='1.0'/><img image='%17' size='1.0'/><br/>" +
                "<t size='1.0' font='RobotoCondensedBold'> Support Casualty Rate: <t color='%18'> %19%%</t></t><br/>" +
                "<t color='#FFFFFF' font='RobotoCondensedBold'>%20</t>",
                _armaPath,                      // 1
                _logoPath,                      // 2
                _missionName,                   // 3
                _playerPath,                    // 4
                (_groundTotal + _supportTotal), // 5
                _killsPath,                     // 6
                _enemiesKilled,                 // 7
                _civilianPath,                  // 8
                _civiliansKilled,               // 9
                _timePath,                      // 10
                _formattedTime,                 // 11
                _deathPath,                     // 12
                _groundColor,                   // 13
                _groundCasualty,                // 14
                _groundDeathsList,              // 15
                _tankPath,                      // 16
                _helipath,                      // 17
                _supportColor,                  // 18
                _supportCasualty,               // 19
                _supportDeathsList,             // 20
                _currentPOWs,                   // 21
                _captivePath,                   // 22
                _MissionStatus,                 // 23
                _MissionStatusColor,            // 24
                _friendlyFireKills,             // 25
                _friendlyFirePath               // 26
            ];

            parseText _hintText remoteExec ["hintSilent",0];

            // Safety Zone
            {
                private _Player = _X;
                if(_Player getVariable ["GOL_SafetyZoneActive", false]) then {
                    _Player setVariable ["GOL_SafetyZoneActive", true, true];
                    _Player allowDamage false;
                    _Player setCaptive true;
                    _Player addEventHandler ["Fired",{
                        params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
                        deleteVehicle _projectile;
                    }];

                    private _launcher = secondaryWeapon _Player;
                    if(_launcher != "") then {
                        private _launcherReplaced = _Player getVariable ["ReplacedSecondaryWeapon",false];
                        if(!(_launcherReplaced)) then {
                            private _launcherAmmo = (_Player weaponState (secondaryWeapon _Player)) select 3;
                            private _RestoreAmmoArray = [];
                            if(_launcherAmmo != "") then {
                                _RestoreAmmoArray pushBack _launcherAmmo;
                            };

                            _Player setVariable ["ReplacedSecondaryWeapon",true,true];
                            _Player removeWeapon _launcher;

                            private _magTypes = getArray (configFile >> "CfgWeapons" >> _launcher >> "magazines");
                            {
                                _magType = _X;
                                while {(_magType in (magazines _Player))} do {
                                    _Player removeMagazine _magType;
                                    _RestoreAmmoArray pushBack _magType;
                                };
                            } forEach _magTypes;

                            // Add the launcher back without magazines
                            _Player addWeapon _launcher;
                            _RestoreLauncherArray = [_launcher,_RestoreAmmoArray];
                            _Player setVariable ["GOL_RestoreSecondaryArray", _RestoreLauncherArray, true];
                        };
                    };
                };
            } foreach AllPlayers; 

            // Throw EventHandler
            _throwEvent = ["ace_throwableThrown", {
                params ["_unit", "_projectile", "_ammo"];
                if (missionNamespace getVariable ["ThrowableHandlerActive", true]) then {
                    deleteVehicle _projectile;
                };
            }] call CBA_fnc_addEventHandler;
            missionNamespace setVariable ["ThrowableHandlerActive", true, true];
            sleep 0.5;
        };

        hintSilent "";
        {
            _Player = _X;
            _Player allowDamage true;
            _Player setCaptive false;
            _Player removeAllEventHandlers "Fired";
            _Player setVariable ["ReplacedSecondaryWeapon",false,true]; 
            _LauncherArray = _Player getVariable ["GOL_RestoreSecondaryArray", []];
            if(_LauncherArray isNotEqualTo []) then {
                _LauncherArray params ["_Launcher","_LauncherAmmo"];
                {
                    _Player addMagazine _X;
                } foreach _LauncherAmmo;
                _Player removeWeapon _Launcher;
                _Player addWeapon _Launcher;
            };         
            _Player setVariable ["GOL_RestoreSecondaryArray", [], true];         
        } foreach AllPlayers;   
        missionNamespace setVariable ["ThrowableHandlerActive", false, true];   
    };
} else {
    hintSilent "";
    {
        _Player = _X;
        _Player allowDamage true;
        _Player setCaptive false;
        _Player removeAllEventHandlers "Fired";
        _Player setVariable ["ReplacedSecondaryWeapon",false,true]; 
        _LauncherArray = _Player getVariable ["GOL_RestoreSecondaryArray", []];
        if(_LauncherArray isNotEqualTo []) then {
            _LauncherArray params ["_Launcher","_LauncherAmmo"];
            {
                _Player addMagazine _X;
            } foreach _LauncherAmmo;
            _Player removeWeapon _Launcher;
            _Player addWeapon _Launcher;
        };         
        _Player setVariable ["GOL_RestoreSecondaryArray", [], true];         
    } foreach AllPlayers;   
    missionNamespace setVariable ["ThrowableHandlerActive", false, true]
};
