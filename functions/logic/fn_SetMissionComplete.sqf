// [] spawn OKS_fnc_SetMissionComplete;
#define CURRENT_WEAPONS player, currentWeapon player, currentMuzzle player

if !(serverCommandAvailable "#kick" || isServer) exitWith {
    hint "Only admins are allowed to use this function.";
};

if (isNil {missionNamespace getVariable "GOL_ShowMissionCompleteHint"}) then {
    missionNamespace setVariable ["GOL_ShowMissionCompleteHint", false];
};

private _show = !(missionNamespace getVariable ["GOL_ShowMissionCompleteHint", false]);
missionNamespace setVariable ["GOL_ShowMissionCompleteHint", _show];

if (_show) then {
    [] spawn {
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
            private _groundPlayers = allPlayers select {!(str _x in _SupportUnits) && alive _x};
            private _supportPlayers = allPlayers select {str _x in _SupportUnits && alive _x};

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
            private _civiliansKilled = missionNamespace getVariable ["OKS_fnc_AvoidCasualties_CIVILIAN", 0];
            private _totalSeconds = time; // Or your own elapsed seconds value

            private _hours = floor (_totalSeconds / 3600);
            private _minutes = floor ((_totalSeconds % 3600) / 60);
            private _seconds = floor (_totalSeconds % 60);

            // Pad with zeros using format
            private _hoursStr = if (_hours < 10) then { format ["0%1", _hours] } else { str _hours };
            private _minutesStr = if (_minutes < 10) then { format ["0%1", _minutes] } else { str _minutes };
            private _secondsStr = if (_seconds < 10) then { format ["0%1", _seconds] } else { str _seconds };
            private _formattedTime = format ["%1:%2:%3", _hoursStr, _minutesStr, _secondsStr];
            
            // Structured text for hintSilent
            private _imagePath = "\OKS_GOL_MISC\data\images\logo.paa"; // Path to your image
            private _hintText = format [
                "<img image='%1' size='8'/><br/>" +
                "<t size='1.9' color='#FFD700'>MISSION COMPLETE</t><br/>" +
                "<t size='1.1' color='#FFFFFF'>%2</t><br/><br/>" +
                "<t color='#FFFFFF'>Active Players: %3</t><br/>" +
                "<t color='#FFFFFF'>Enemies Killed: %4</t><br/>" +
                "<t color='#FFFFFF'>Civilians Killed: %5</t><br/>" +
                "<t color='#FFFFFF'>Time Elapsed: %6</t><br/><br/>" +
                "<t size='1.0'>Platoon Casualty Rate: <t color='%7'>%8%%</t></t><br/>" +
                "<t color='#FFFFFF'>%9</t><br/>" +
                "<t size='1.0'>Support Casualty Rate: <t color='%10'>%11%%</t></t><br/>" +
                "<t color='#FFFFFF'>%12</t>",
                _imagePath,
                _missionName,
                (_groundTotal + _supportTotal),
                _enemiesKilled,
                _civiliansKilled,
                _formattedTime,
                _groundColor,
                _groundCasualty,
                _groundDeathsList,
                _supportColor,
                _supportCasualty,
                _supportDeathsList
            ];

            hintSilent parseText _hintText;

            // Safety Zone
            {
                _X allowDamage false;
                _X setCaptive true;
                _X addEventHandler ["FiredMan",{
                    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
                    deleteVehicle _projectile;
                }];
            } foreach AllPlayers; 

            // Throw EventHandler
            _ThrowableEventHandler = ["ace_throwableThrown", {
                params ["_unit", "_projectile", "_ammo"];
                deleteVehicle _projectile;
            }] call CBA_fnc_addEventHandler;
            missionNamespace setVariable ["ThrowableEventHandlerId", _ThrowableEventHandler, true];

            sleep 0.5;
        };
        hintSilent "";
    };
} else {
    hintSilent "";
    {
        _X allowDamage true;
        _X setCaptive false;
        _X removeAllEventHandlers "FiredMan";
    } foreach AllPlayers;   
    _ThrowableEventHandler = missionNamespace getVariable ["ThrowableEventHandlerId", nil, true];
    if(!isNil "_ThrowableEventHandler") then {
        ["ace_throwableThrown", _ThrowableEventHandler] call CBA_fnc_removeEventHandler;   
    };
};
