if (hasInterface) then {
    _condition = {leader group player == player};
	_code =
	{
		openMap true;
		_Side = [player] call GW_Common_Fnc_getSide;
		[_Side, systemChat "Pilot: Awaiting coordinates"] onMapSingleClick
		{
			Private ["_BoxCode"];
			Switch (_This select 0) do
			{
				Case WEST: {_BoxCode = {[_Box, ["small_box","west"]] call GW_Gear_Fnc_Init; [_Box] spawn OKS_fnc_SetupMobileServiceStation}};
				Case EAST: {_BoxCode = {[_Box, ["small_box","east"]] call GW_Gear_Fnc_Init; [_Box] spawn OKS_fnc_SetupMobileServiceStation}};
				Case INDEPENDENT: {_BoxCode = {[_Box, ["small_box","indep"]] call GW_Gear_Fnc_Init; [_Box] spawn OKS_fnc_SetupMobileServiceStation}};
			};
			[(_This select 0),GOL_NEKY_SUPPLY_HELICOPTER,"drop", ["helicopter_spawn",_pos,"helicopter_despawn"],_BoxCode,true] spawn OKS_fnc_SupplyMapClick;
		};
	};

	_landcode =
	{
		openMap true;
		_Side = [player] call GW_Common_Fnc_getSide;
		[_Side, systemChat "Pilot: Awaiting coordinates"] onMapSingleClick
		{
			Private ["_BoxCode"];
			Switch (_This select 0) do
			{
				Case WEST: {_BoxCode = {[_Box, ["small_box","west"]] call GW_Gear_Fnc_Init; [_Box] spawn OKS_fnc_SetupMobileServiceStation}};
				Case EAST: {_BoxCode = {[_Box, ["small_box","east"]] call GW_Gear_Fnc_Init; [_Box] spawn OKS_fnc_SetupMobileServiceStation}};
				Case INDEPENDENT: {_BoxCode = {[_Box, ["small_box","indep"]] call GW_Gear_Fnc_Init; [_Box] spawn OKS_fnc_SetupMobileServiceStation}};
			};
			[(_This select 0),GOL_NEKY_SUPPLY_HELICOPTER,"unload", ["helicopter_spawn",_pos,"helicopter_despawn"],_BoxCode,true] spawn OKS_fnc_SupplyMapClick;
		};
	};

	_action = ["Resupply", "Resupply","\a3\ui_f\data\Map\VehicleIcons\iconCrateAmmo_ca.paa", {}, _condition] call ace_interact_menu_fnc_createAction;
	_drop = ["Airdrop", "Airdrop","\a3\ui_f\data\Map\VehicleIcons\iconParachute_ca.paa", _code, _condition] call ace_interact_menu_fnc_createAction;
	_unload = ["Unload", "Unload","\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\land_ca.paa", _landcode, _condition] call ace_interact_menu_fnc_createAction;

	[typeOf player, 1, ["ACE_SelfActions","Request_Support"], _action] call ace_interact_menu_fnc_addActionToClass;
	[typeOf player, 1, ["ACE_SelfActions","Request_Support","Resupply"], _drop] call ace_interact_menu_fnc_addActionToClass;
	[typeOf player, 1, ["ACE_SelfActions","Request_Support","Resupply"], _unload] call ace_interact_menu_fnc_addActionToClass;

};
