if (hasInterface) then {
    _condition = {leader group player == player}; // Only leaders can use

	// NEKY EDIT START
	_code =
	{
		_EnemyNearUnits = (player nearEntities ["Man", GOL_OKS_MhqSafeZone]) select {(side _X) getFriend (side player) < 0.6 && side _X != civilian};
		if(count _EnemyNearUnits == 0) then {
			[Tent_MHQ,(player getPos [3,getDir player])] remoteExec ["setPos",2];

			_Players = allPlayers select {_X distance flag_west_1 < 100 || _X distance flag_east_1 < 100};
			_Players spawn {
				_Players = _this;
				sleep 5;
				_mhqMarkerId = Tent_MHQ getVariable ["MHQ_MarkerId",""];
				_mhqMarkerAreaId = format["%1_Area",_mhqMarkerId];
				[_mhqMarkerId,Tent_MHQ] remoteExec ["setMarkerPos",0];
				[_mhqMarkerAreaId,Tent_MHQ] remoteExec ["setMarkerPos",0];	
				["The MHQ has been moved to a new safe location."] remoteExec ["systemChat",_Players];
			};
		} else {
			systemChat format["Enemies are nearby. You cannot move the MHQ until the immediate area is secure (%1m).",GOL_OKS_MhqSafeZone];
		};	
	};

	// NEKY EDIT END
	_action = ["DeployMHQTent", "Deploy Tent MHQ","\A3\ui_f\data\map\mapcontrol\Tourism_CA.paa", _code, _condition] call ace_interact_menu_fnc_createAction;
	[typeOf player, 1, ["ACE_SelfActions","Request_Support"], _action] call ace_interact_menu_fnc_addActionToClass;

};

