/*
	TFAR Wireless Intercom — Client-side setup
	Runs from the addon (OKS_GOL_Misc) so it can be updated independently
	of the mission framework.

	• GetOut handler:  prevents auto-connect, stores last vehicle
	• CBA keybind:     Shift+Tab toggle for wireless intercom
	• ACE self-actions: Connect / Disconnect under Equipment

	Deferred via waitUntilAndExecute because:
	  - TFAR isn't in requiredAddons, so its functions may not exist yet at postInit
	  - player / typeOf player may not be valid yet at postInit
*/
diag_log "OKS_GOL_Misc: XEH_postInit_Intercom.sqf executed";

if (!hasInterface) exitWith {};

[{
	!isNil "TFAR_fnc_setIntercomChannel"
	&& !isNull player
	&& {typeOf player != ""}
}, {
	diag_log "OKS_GOL_Misc: TFAR intercom setup running (player + TFAR ready)";

	// ── GetOut handler: disconnect on dismount, remember the vehicle ──────────
	["AllVehicles", "GetOut", {
		params ["_vehicle", "_role", "_unit"];
		if (isPlayer _unit && {local _unit} && {_role != "cargo"}) then {
			_unit setVariable ["GOL_lastIntercomVehicle", _vehicle];
			[{
				params ["_vehicle", "_unit"];
				if (!isNil "TFAR_external_intercom_fnc_disconnect") then {
					[_vehicle, _unit] call TFAR_external_intercom_fnc_disconnect;
				};
			}, [_vehicle, _unit], 0.1] call CBA_fnc_waitAndExecute;
		};
	}, true, [], true] call CBA_fnc_addClassEventHandler;

	// ── Keybind: Toggle wireless intercom (default Shift+Tab) ─────────────────
	["GOL Custom Controls", "GOL_toggleWirelessIntercom",
		["Toggle Wireless Intercom", "Connect or disconnect wireless intercom to your last dismounted vehicle"],
		{
			if (isNil "TFAR_external_intercom_fnc_connect") exitWith {};

			// Currently connected → disconnect
			if !(player isNil "TFAR_ExternalIntercomVehicle") exitWith {
				private _vehicle = player getVariable "TFAR_ExternalIntercomVehicle";
				[_vehicle, player] call TFAR_external_intercom_fnc_disconnect;
				["Wireless intercom disconnected."] call ace_common_fnc_displayTextStructured;
			};

			// Not connected → try connecting to last vehicle
			private _vehicle = player getVariable ["GOL_lastIntercomVehicle", objNull];
			if (isNull _vehicle || {!alive _vehicle}) exitWith {
				["No vehicle to connect to."] call ace_common_fnc_displayTextStructured;
			};

			if !([player] call TFAR_external_intercom_fnc_hasWirelessHeadgear) exitWith {
				["Your headgear is not wireless-capable."] call ace_common_fnc_displayTextStructured;
			};

			private _maxRange = (((boundingBoxReal _vehicle) select 2) / 2)
				+ (_vehicle getVariable ["TFAR_externalIntercomMaxRange_Wireless",
					TFAR_externalIntercomMaxRange_Wireless]);
			if (player distance _vehicle > _maxRange) exitWith {
				[format ["Too far from vehicle (%1m / %2m).",
					round (player distance _vehicle), round _maxRange]] call ace_common_fnc_displayTextStructured;
			};

			[_vehicle, player, [true]] call TFAR_external_intercom_fnc_connect;
			["Wireless intercom connected."] call ace_common_fnc_displayTextStructured;
		}, {}, [0x0F, [true, false, false]]
	] call CBA_fnc_addKeybind;

	// ── ACE self-interaction: Connect / Disconnect (under Equipment) ──────────
	private _connectAction = [
		"GOL_IntercomConnect",
		"Connect Intercom",
		"\z\tfar\addons\external_intercom\ui\tfar_ace_interaction_external_intercom_wireless.paa",
		{
			private _vehicle = _player getVariable ["GOL_lastIntercomVehicle", objNull];
			[_vehicle, _player, [true]] call TFAR_external_intercom_fnc_connect;
			["Wireless intercom connected."] call ace_common_fnc_displayTextStructured;
		},
		{
			if (isNil "TFAR_external_intercom_fnc_connect") exitWith {false};
			private _vehicle = _player getVariable ["GOL_lastIntercomVehicle", objNull];
			if (isNull _vehicle || {!alive _vehicle}) exitWith {false};
			if !(_player isNil "TFAR_ExternalIntercomVehicle") exitWith {false};
			if !([_player] call TFAR_external_intercom_fnc_hasWirelessHeadgear) exitWith {false};
			private _maxRange = (((boundingBoxReal _vehicle) select 2) / 2)
				+ (_vehicle getVariable ["TFAR_externalIntercomMaxRange_Wireless",
					TFAR_externalIntercomMaxRange_Wireless]);
			_player distance _vehicle <= _maxRange
		}
	] call ace_interact_menu_fnc_createAction;

	private _disconnectAction = [
		"GOL_IntercomDisconnect",
		"Disconnect Intercom",
		"\z\tfar\addons\external_intercom\ui\tfar_ace_interaction_external_intercom_wireless_disconnect.paa",
		{
			private _vehicle = _player getVariable "TFAR_ExternalIntercomVehicle";
			[_vehicle, _player] call TFAR_external_intercom_fnc_disconnect;
			["Wireless intercom disconnected."] call ace_common_fnc_displayTextStructured;
		},
		{
			!isNil "TFAR_external_intercom_fnc_disconnect"
			&& {!(_player isNil "TFAR_ExternalIntercomVehicle")}
		}
	] call ace_interact_menu_fnc_createAction;

	[typeOf player, 1, ["ACE_SelfActions", "ACE_Equipment"], _connectAction] call ace_interact_menu_fnc_addActionToClass;
	[typeOf player, 1, ["ACE_SelfActions", "ACE_Equipment"], _disconnectAction] call ace_interact_menu_fnc_addActionToClass;
}, []] call CBA_fnc_waitUntilAndExecute;
