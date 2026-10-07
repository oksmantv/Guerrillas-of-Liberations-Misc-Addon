/*
	[_Unit,_Side,_ChanceForRadioEquipment,_RequiresRadioToCallHunt] call OKS_fnc_Stealth_EnemySentry_CreateUnit;
*/

params ["_Unit", "_Side", "_ChanceForRadioEquipment", "_RequiresRadioToCallHunt"];
private ["_Leaders", "_Units"];
private _UnitArray = [];

switch (_Side) do {
	case blufor: {
		_Leaders = ["B_Soldier_SL_F"];
		_Units = [
			"B_Soldier_A_F",
			"B_Soldier_AR_F",
			"B_Soldier_AR_F",
			"B_medic_F",
			"B_medic_F",
			"B_Soldier_GL_F",
			"B_HeavyGunner_F",
			"B_soldier_M_F",
			"B_Soldier_F",
			"B_Soldier_F",
			"B_Soldier_F",
			"B_Soldier_LAT_F"
		];
	};
	case opfor: {
		_Leaders = ["O_Soldier_SL_F"];
		_Units = [
			"O_Soldier_A_F",
			"O_Soldier_AR_F",
			"O_Soldier_AR_F",
			"O_medic_F",
			"O_medic_F",
			"O_Soldier_GL_F",
			"O_HeavyGunner_F",
			"O_soldier_M_F",
			"O_Soldier_F",
			"O_Soldier_F",
			"O_Soldier_F",
			"O_Soldier_LAT_F"
		];
	};
	case independent: {
		_Leaders = ["I_Soldier_SL_F"];
		_Units = [
			"I_Soldier_A_F",
			"I_Soldier_AR_F",
			"I_Soldier_AR_F",
			"I_medic_F",
			"I_medic_F",
			"I_Soldier_GL_F",
			"I_HeavyGunner_F",
			"I_soldier_M_F",
			"I_Soldier_F",
			"I_Soldier_F",
			"I_Soldier_F",
			"I_Soldier_LAT_F"
		];
	};
	default { _Units = ""; };
};

if (typeName _Unit isEqualTo "ARRAY") then {
	private _Pos = _Unit;
	private _UnitClass = selectRandom _Units;
	private _Group = createGroup _Side;

	private _Dice = random 1;
	if (_Dice < _ChanceForRadioEquipment && _RequiresRadioToCallHunt) then {
		_Unit = _Group createUnit [_Leaders, _Pos, [], 0, "CAN_COLLIDE"];
		_Unit setVariable ["GOL_HasRadio", true, true];
	} else {
		_Unit = _Group createUnit [_UnitClass, _Pos, [], 0, "CAN_COLLIDE"];
	};
	_Unit setRank "PRIVATE";
	_Unit setDir (random 360);
	_UnitArray pushBackUnique _Unit;
};

if (typeName _Unit isEqualTo "OBJECT") then {
	if (_Unit isKindOf "Man") then {
		if (typeOf _Unit in _Leaders) then {
			_Unit setVariable ["GOL_HasRadio", true, true];
		};
		_UnitArray pushBackUnique _Unit;
	} else {
		private _Pos = getPosATL _Unit;
		private _PosObject = _Unit;
		private _UnitClass = selectRandom _Units;
		private _Group = createGroup _Side;

		private _Dice = random 1;
		if (_Dice < _ChanceForRadioEquipment && _RequiresRadioToCallHunt) then {
			_Unit = _Group createUnit [_Leaders, _Pos, [], 0, "CAN_COLLIDE"];
			_Unit setVariable ["GOL_HasRadio", true, true];
		} else {
			_Unit = _Group createUnit [_UnitClass, _Pos, [], 0, "CAN_COLLIDE"];
		};
		_Unit setRank "PRIVATE";
		_Unit setDir (getDir _PosObject);
		_Unit setFormDir (getDir _PosObject);
		_Unit doWatch (_Unit getPos [15, (getDir _Unit)]);
		_Unit lookAt (_Unit getPos [15, (getDir _Unit)]);
		_UnitArray pushBackUnique _Unit;
		deleteVehicle _PosObject;
	};
};

if (typeName _Unit isEqualTo "GROUP") then {
	{
		if (typeOf _X in _Leaders) then {
			_X setVariable ["GOL_HasRadio", true, true];
		};
		_UnitArray pushBackUnique _X;
	} forEach units _Unit;
	[_Unit] call OKS_fnc_Stealth_EnemySentry_IgnoreAir;
};

if (count _UnitArray == 0) exitWith { systemChat "OKS_Enemy_Sentry no units in _UnitArray. Exiting." };
_UnitArray