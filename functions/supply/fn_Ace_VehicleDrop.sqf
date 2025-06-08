if (hasInterface) then {
    _condition = {leader group player == player};
	_code =
	{
		openMap true;
		_Side = [player] call GW_Common_Fnc_getSide;
		[_Side, systemChat "Pilot: Awaiting coordinates"] onMapSingleClick
		{
			[
				(_This select 0),GOL_NEKY_SUPPLY_HELICOPTER,
				"drop",
				[
					"helicopter_spawn",
					_pos,
					"helicopter_despawn"
				],
				GOL_NEKY_VEHICLEDROP_CODE,
				true,
				GOL_NEKY_VEHICLEDROP_VEHICLECLASS
			] spawn OKS_fnc_VehicleDropMapClick;
		};
	};
	_action = ["Vehicle Drop", "Vehicle Drop","\a3\ui_f\data\Map\VehicleIcons\iconAPC_ca.paa", _code, _condition] call ace_interact_menu_fnc_createAction;
	[typeOf player, 1, ["ACE_SelfActions","Request_Support"], _action] call ace_interact_menu_fnc_addActionToClass;
};

