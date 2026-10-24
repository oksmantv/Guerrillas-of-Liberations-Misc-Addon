/*
	TFAR Wireless Intercom — Client-side setup
	Runs from the addon (OKS_GOL_Misc) so it can be updated independently
	of the mission framework.

	• GetOut handler:  saves channel and automatically connects wirelessly
	• CBA keybind:     Shift+Tab toggle for the active wireless intercom
	• ACE self-action: manual fallback (disconnect is provided by TFAR)

	Deferred via waitUntilAndExecute because:
	  - TFAR isn't in requiredAddons, so its functions may not exist yet at postInit
	  - player / typeOf player may not be valid yet at postInit
*/
diag_log "OKS_GOL_Misc: XEH_postInit_Intercom.sqf executed";

if (!hasInterface) exitWith {};

[{
	!isNil "TFAR_fnc_setIntercomChannel"
	&& !isNil "TFAR_fnc_getIntercomChannel"
	&& !isNil "TFAR_external_intercom_fnc_connect"
	&& !isNil "TFAR_external_intercom_fnc_hasWirelessHeadgear"
	&& !isNull player
	&& {typeOf player != ""}
}, {
	diag_log "OKS_GOL_Misc: TFAR intercom setup running (player + TFAR ready)";

	// This must persist beyond this postInit callback because CBA keybinds,
	// ACE actions, and class event handlers execute in later script scopes.
	OKS_fnc_isIntercomVehicle = {
		params ["_vehicle"];

		!isNull _vehicle
		&& {getNumber (configFile >> "CfgVehicles" >> typeOf _vehicle >> "TFAR_hasIntercom") > 0}
	};

	OKS_fnc_connectWirelessIntercom = {
		params ["_vehicle", "_unit", ["_showHint", true]];

		if (isNull _vehicle || {!alive _vehicle} || {!alive _unit}) exitWith {false};
		if !([_vehicle] call OKS_fnc_isIntercomVehicle) exitWith {false};
		if (isNil "TFAR_external_intercom_fnc_connect") exitWith {false};
		if !([_unit] call TFAR_external_intercom_fnc_hasWirelessHeadgear) exitWith {false};

		// Restore the channel selected before dismounting. If it was Disabled,
		// fall back to the first crew member's channel, then Channel 1.
		private _crew = crew _vehicle;
		private _channel = _unit getVariable ["GOL_lastIntercomChannel", -1];
		if (_channel < 0 && {!(_crew isEqualTo [])}) then {
			_channel = [_vehicle, _crew select 0] call TFAR_fnc_getIntercomChannel;
		};
		if (_channel < 0) then {
			_channel = _vehicle getVariable ["TFAR_defaultIntercomSlot", 0];
		};

		_vehicle setVariable ["TFAR_externalIntercomMaxRange_Wireless", 50, true];
		[_vehicle, _unit, _channel] call TFAR_fnc_setIntercomChannel;
		[_vehicle, _unit, [true]] call TFAR_external_intercom_fnc_connect;

		if ((_unit getVariable ["TFAR_ExternalIntercomVehicle", objNull]) isEqualTo _vehicle) then {
			if (_showHint) then {
				private _activeChannel = [_vehicle, _unit] call TFAR_fnc_getIntercomChannel;
				if (_activeChannel < 0) then {
					_activeChannel = _channel;
				};
				private _vehicleName = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName");
				if (_vehicleName isEqualTo "") then {
					_vehicleName = typeOf _vehicle;
				};
				[format ["Wireless intercom connected: %1 — Channel %2.", _vehicleName, _activeChannel + 1]] call ace_common_fnc_displayTextStructured;
			};
			true
		} else {
			false
		};
	};

	// ── GetOut handler: retain the vehicle and selected channel ────────────────
	// No role filter — passengers ("cargo") in MRAPs etc. also need this.
	["AllVehicles", "GetOut", {
		params ["_vehicle", "_role", "_unit"];
		if (isPlayer _unit && {local _unit} && {[_vehicle] call OKS_fnc_isIntercomVehicle}) then {
			_unit setVariable ["GOL_lastIntercomVehicle", _vehicle];
			_unit setVariable ["GOL_lastIntercomChannel", [_vehicle, _unit] call TFAR_fnc_getIntercomChannel];
			_vehicle setVariable ["TFAR_externalIntercomMaxRange_Wireless", 50, true];

			// Wireless intercom is optional. Wait for dismount completion, then clear
			// any active external connection so its indicator is no longer visible.
			// The keybind reconnects later using GOL_lastIntercomChannel.
			[{
				params ["_vehicle", "_unit"];
				vehicle _unit == _unit
			}, {
				params ["_vehicle", "_unit"];
				if (!isNil "TFAR_external_intercom_fnc_disconnect" && {!(_unit isNil "TFAR_ExternalIntercomVehicle")}) then {
					[_unit getVariable "TFAR_ExternalIntercomVehicle", _unit] call TFAR_external_intercom_fnc_disconnect;
				};
			}, [_vehicle, _unit], 2, {}] call CBA_fnc_waitUntilAndExecute;
		};
	}, true, [], true] call CBA_fnc_addClassEventHandler;

	// ── ACE vehicle interaction: select, assign, and connect manually ─────────
	// This supports an initial wireless connection without entering the vehicle.
	OKS_fnc_removeTFARWirelessConnectAction = {
		params ["_vehicle"];

		// TFAR's runtime action name is lowercase. This must be removed from the
		// object action list, not the vehicle's config-defined ACE actions.
		[_vehicle, 0, ["ACE_MainActions", "tfar_external_intercom_wirelessConnect"]] call ace_interact_menu_fnc_removeActionFromObject;
	};

	OKS_fnc_addWirelessIntercomAction = {
		params ["_vehicle"];

		if !([_vehicle] call OKS_fnc_isIntercomVehicle) exitWith {};

		// TFAR adds this object action during vehicle initialisation. Its stock
		// connection has different range/selection behaviour, so GOL replaces it.
		[_vehicle] call OKS_fnc_removeTFARWirelessConnectAction;
		[OKS_fnc_removeTFARWirelessConnectAction, [_vehicle], 0] call CBA_fnc_waitAndExecute;

		if (_vehicle getVariable ["GOL_wirelessIntercomActionAdded", false]) exitWith {};

		private _connectAction = [
			"GOL_IntercomConnectVehicle",
			"Connect to GOL Intercom",
			"\A3\ui_f\data\igui\cfg\simpletasks\types\radio_ca.paa",
			{
				params ["_target", "_player"];
				_player setVariable ["GOL_lastIntercomVehicle", _target];
				_target setVariable ["TFAR_externalIntercomMaxRange_Wireless", 50, true];
				[_target, _player, true] call OKS_fnc_connectWirelessIntercom;
			},
			{
				params ["_target", "_player"];
				private _connectedVehicle = _player getVariable ["TFAR_ExternalIntercomVehicle", objNull];
				[_target] call OKS_fnc_isIntercomVehicle
				&& {!(_connectedVehicle isEqualTo _target)}
				&& {[_player] call TFAR_external_intercom_fnc_hasWirelessHeadgear}
			}
		] call ace_interact_menu_fnc_createAction;

		[_vehicle, 0, ["ACE_MainActions"], _connectAction] call ace_interact_menu_fnc_addActionToObject;
		_vehicle setVariable ["GOL_wirelessIntercomActionAdded", true];
	};

	{
		[_x] call OKS_fnc_addWirelessIntercomAction;
	} forEach vehicles;

	["AllVehicles", "Init", {
		params ["_vehicle"];
		[_vehicle] call OKS_fnc_addWirelessIntercomAction;
	}, true, [], true] call CBA_fnc_addClassEventHandler;

	// ── Keybind: Toggle wireless intercom (default Shift+Tab) ─────────────────
	["GOL Custom Controls", "GOL_toggleWirelessIntercom",
		["Toggle Wireless Intercom", "Connect or disconnect wireless intercom to your last dismounted vehicle"],
		{
			if (isNil "TFAR_external_intercom_fnc_connect") exitWith {};

			// Currently connected → disconnect
			if !(player isNil "TFAR_ExternalIntercomVehicle") exitWith {
				private _vehicle = player getVariable "TFAR_ExternalIntercomVehicle";
				private _channel = [_vehicle, player] call TFAR_fnc_getIntercomChannel;
				private _vehicleName = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName");
				if (_vehicleName isEqualTo "") then {
					_vehicleName = typeOf _vehicle;
				};
				[_vehicle, player] call TFAR_external_intercom_fnc_disconnect;
				[format ["Wireless intercom disconnected: %1 — Channel %2.", _vehicleName, _channel + 1]] call ace_common_fnc_displayTextStructured;
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

			[_vehicle, player, true] call OKS_fnc_connectWirelessIntercom;
		}, {}, [15, [true, false, false]], false
	] call CBA_fnc_addKeybind;

	// ── ACE self-interaction: GOL wireless connection (under TFAR Radio) ──────
	// This intentionally remains separate from TFAR's own 20 m action.
	// Disconnect + channel choice are provided natively by TFAR in this category.
	private _connectAction = [
		"GOL_IntercomConnect",
		"Connect to GOL Intercom",
		"\A3\ui_f\data\igui\cfg\simpletasks\types\radio_ca.paa",
		{
			private _vehicle = _player getVariable ["GOL_lastIntercomVehicle", objNull];
			[_vehicle, _player, true] call OKS_fnc_connectWirelessIntercom;
		},
		{
			if (isNil "TFAR_external_intercom_fnc_connect") exitWith {false};
			private _vehicle = _player getVariable ["GOL_lastIntercomVehicle", objNull];
			if (isNull _vehicle || {!alive _vehicle}) exitWith {false};
			if !([_vehicle] call OKS_fnc_isIntercomVehicle) exitWith {false};
			if !(_player isNil "TFAR_ExternalIntercomVehicle") exitWith {false};
			if !([_player] call TFAR_external_intercom_fnc_hasWirelessHeadgear) exitWith {false};
			private _maxRange = (((boundingBoxReal _vehicle) select 2) / 2)
				+ (_vehicle getVariable ["TFAR_externalIntercomMaxRange_Wireless",
					TFAR_externalIntercomMaxRange_Wireless]);
			_player distance _vehicle <= _maxRange
		}
	] call ace_interact_menu_fnc_createAction;

	[typeOf player, 1, ["ACE_SelfActions", "TFAR_Radio"], _connectAction] call ace_interact_menu_fnc_addActionToClass;
}, []] call CBA_fnc_waitUntilAndExecute;
