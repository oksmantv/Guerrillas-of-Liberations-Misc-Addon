/**
    Switches the weapon IR Illuminator ON
	
	Parameters: Array
		0 - _unit <OBJECT> - Unit which we're toggling it for
	Returns: None


	Example: [true] call BettIR_fnc_weaponIlluminatorOn
 */

params ['_unit'];

if !([] call GOL_IRLLM_fnc_initialize) exitWith {};

if (_unit getVariable ['BettIR_weapon_illuminator_on', false]) exitWith {};
if (currentVisionMode _unit != 1) exitWith { diag_log "[GOL_IRLLM] Weapon illuminator rejected: NVGs are not active."; };
if (currentWeapon _unit != primaryWeapon _unit) exitWith { diag_log "[GOL_IRLLM] Weapon illuminator rejected: primary weapon is not selected."; }; 

_weaponsItems = primaryWeaponItems _unit;
_attachmentClassname = toLower (_weaponsItems select 1);

if (_attachmentClassname != '') then {
	_attachmentIndex = BettIR_CompatibleAttachments findIf { _x == _attachmentClassname };

	if (_attachmentIndex != -1) then {
		diag_log format ["[GOL_IRLLM] Weapon illuminator accepted attachment: %1.", _attachmentClassname];
		_offset = BettIR_CompatibleAttachmentsOffsets select _attachmentIndex;
		_unit setVariable ['BettIR_weapon_illuminator_offset', _offset, false];
		_unit setVariable ['BettIR_weapon_illuminator_on', true, true]; 
		
		if (currentVisionMode player == 1) then {
			// A manual keybind can be used before a visionMode event has created
			// the positioning handler. Start it explicitly in that case.
			if (isNil "BettIR_EachFrameHandlerId" || {BettIR_EachFrameHandlerId == -1}) then {
				[true] spawn GOL_IRLLM_fnc_handleVisionModeChange;
			};

			_light = 'GOL_IRLLM_Illuminator_Weapon' createVehicleLocal (getPosATL _unit);
			hideObject _light;
			_light setVariable ['BettIR_owner', _unit];
			_unit setVariable ['BettIR_weapon_illuminator_object', _light, false];
			BettIR_UnitList_LastUpdate = time;
			[] spawn GOL_IRLLM_fnc_updateUnitList;
		};
	} else {
		diag_log format ["[GOL_IRLLM] Weapon illuminator rejected unsupported attachment: %1.", _attachmentClassname];
	};
};
