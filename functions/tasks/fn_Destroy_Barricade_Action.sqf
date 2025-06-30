
Params ["_Barricade"];

if(isNil "_Barricade") exitWith {
	"[BARRICADE] Barricade is not alive or not defined." call OKS_fnc_LogDebug;
};

_plantBombAction = [
	"Plant_Bomb",
	"Place Satchel Charge",
	"\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\destroy_ca.paa",
	{ 
		_relPos = [-1.53137,10.0522,198.065];
		_explosivePos = _target modelToWorld _relPos;

		if ([_player, "SatchelCharge_Remote_Mag"] call BIS_fnc_hasItem && [_player, "ACE_M26_Clacker"] call BIS_fnc_hasItem) then {
			_player removeMagazine "SatchelCharge_Remote_Mag";
			_explosive = [
				_player,
				_player modelToWorldVisual [0,1.5,0.1],
				getDir _player,
				"SatchelCharge_Remote_Mag",
				"Command",
				[]
			] call ace_explosives_fnc_placeExplosive;
			[_player, _explosive, "ACE_M26_Clacker"] call ace_explosives_fnc_connectExplosive;


			[_explosive,_target] spawn {
				params ["_explosive","_barricade"];
				waitUntil {sleep 0.01; !Alive _explosive};
				sleep 0.05;
				deleteVehicle _barricade;
			};
			systemChat "Satchel placed and linked to your clacker.";
		} else {
			systemChat "A Satchel Charge and M26 Firing Device is required to plant the explosives.";
		};
	},
	{ 
		true
	},
	{},
	[]
] call ace_interact_menu_fnc_createAction;

[_Barricade, 0, ["ACE_MainActions"], _plantBombAction] call ace_interact_menu_fnc_addActionToObject;