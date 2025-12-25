/*
    OKS_fnc_ExtractGearFromAI

	Extract gear from selected AI units in Eden Editor
	Reads gear configuration from unit configs
*/
private _Objects = get3DENSelected "object";

if (count _Objects == 0) exitWith {
	"Extract Gear: No objects selected!" call OKS_fnc_LogDebug;
	["Extract Gear: select one or more units", 1, 5, true] call BIS_fnc_3DENNotification;
};

// Helper function to get gear from config
private _fnc_getUnitGear = {
	params ["_unitClass"];
	
	private _cfg = configFile >> "CfgVehicles" >> _unitClass;
	if (!isClass _cfg) exitWith {
		["", "", "", "", [], [], "", "", "", ""]
	};
	
	private _headgearList = getArray (_cfg >> "headgearList");
	private _helmet = "";
	if (!(_headgearList isEqualTo [])) then {
		private _h0 = _headgearList select 0;
		_helmet = if (_h0 isEqualType []) then {
			if ((count _h0) > 0) then { _h0 select 0 } else { "" }
		} else {
			_h0
		};
	};
	
	private _uniform = getText (_cfg >> "uniformClass");
	private _vest = getText (_cfg >> "vestClass"); 
	private _backpack = getText (_cfg >> "backpack");
	
	private _weapons = getArray (_cfg >> "weapons");
	private _magazines = getArray (_cfg >> "magazines");
	
	private _primary = "";
	private _secondary = "";
	private _handgun = "";
	private _items = [];
	
	{
		private _weaponCfg = configFile >> "CfgWeapons" >> _x;
		private _type = getNumber (_weaponCfg >> "type");
		
		switch (_type) do {
			case 1: {_primary = _x}; // Primary weapon
			case 2: {_handgun = _x}; // Handgun
			case 4: {_secondary = _x}; // Secondary (launcher)
		};
	} forEach _weapons;
	
	[_helmet, _uniform, _vest, _backpack, _weapons, _magazines, _primary, _secondary, _handgun, _items]
};

private _copyOfficerHelmet = "";
private _copyLMGVariable = "";
private _copyMMGVariable = "";
private _copyHATVariable = "";
private _copySightList = "";
private _pilotHelmet = "";
private _pilotUniform = "";
private _pilotVest = "";
private _sniperUniform = "";
private _crewHelmet = "";
private _copyInsignia = "";
private _copyBackpackRadio = "";
private _copySilencer = "";
private _copyPointer = "";
private _copySight = "";
private _copyBipod = "";
private _copyMarksmanSilencer = "";
private _copyMarksmanPointer = "";
private _copyMarksmanSight = "";
private _copyMarksmanBipod = "";
private _copyRifleVariable = "";
private _copyRifleCVariable = "";
private _copyRifleGLVariable = "";
private _copyRifleLVariable = "";
private _copyRifleMarksmanVariable = "";
private _copyRifle = "";
private _copyRifleC = "";
private _copyRifleGL = "";
private _copyRifleL = "";
private _copyLMG = "";
private _copyMMG = "";
private _copyLATVariable = "";
private _copyMATVariable = "";
private _copyAAVariable = "";
private _copyPistolVariable = "";
private _copyPDWVariable = "";
private _copyRifle_mag = "";
private _copyRifle_mag_tr = "";
private _copyRifleGL_mag = "";
private _copyRifleGL_mag_tr = "";
private _copyRifleC_mag = "";
private _copyRifleC_mag_tr = "";
private _copyRifleL_mag = "";
private _copyRifleL_mag_tr = "";
private _copyLMG_mag = "";
private _copyMMG_mag = "";
private _MedicBag = "";
private _copyLAT_mag = "";
private _copyLAT_ReUsable = false;
private _copyMAT_mag = "";
private _copyMAT_mag_HE = "";
private _copyHAT_mag = "";
private _copyAA_mag = "";
private _copyPistol_mag = "";
private _copyPDW_mag = "";
private _copyPDW_mag_tr = "";
private _copyRifleMarksman_mag = "";
private _copyRifleMarksman_mag_tr = "";
private _copyHelmet = [];
private _copyGoggles =[];
private _copyUniform = [];
private _copyVest = [];
private _copyBackpack = [];
private _silencers = [];
private _pointers = [];
private _sights = [];
private _bipods = [];
private _rifles = [];
private _pistols = [];

private _processedCount = 0;

{
	private _entity = _x;
	private _unitClass = _entity get3DENAttribute "ItemClass" select 0;
	
	if (_unitClass == "") then {continue};
	
	private _displayName = getText (configFile >> "CfgVehicles" >> _unitClass >> "displayName");
	private _cfg = configFile >> "CfgVehicles" >> _unitClass;
	
	// Get gear from config
	private _headgearList = getArray (_cfg >> "headgearList");
	private _helmet = "";
	if (!(_headgearList isEqualTo [])) then {
		private _h0 = _headgearList select 0;
		_helmet = if (_h0 isEqualType []) then {
			if ((count _h0) > 0) then { _h0 select 0 } else { "" }
		} else {
			_h0
		};
	};
	private _uniform = getText (_cfg >> "uniformClass");
	private _vest = getText (_cfg >> "vestClass");
	private _backpack = getText (_cfg >> "backpack");
	private _goggles = getText (_cfg >> "goggles");
	
	// Get weapons from config
	private _weapons = getArray (_cfg >> "weapons");
	private _magazines = getArray (_cfg >> "magazines");
	private _items = getArray (_cfg >> "items");
	private _linkedItems = getArray (_cfg >> "linkedItems");
	
	// Parse weapons
	private _primary = "";
	private _secondary = "";
	private _handgun = "";
	
	{
		private _weaponCfg = configFile >> "CfgWeapons" >> _x;
		private _type = getNumber (_weaponCfg >> "type");
		
		switch (_type) do {
			case 1: {_primary = _x}; // Primary weapon
			case 2: {_handgun = _x}; // Handgun  
			case 4: {_secondary = _x}; // Secondary (launcher)
		};
	} forEach _weapons;
	
	// Get weapon attachments from primary weapon
	private _primaryItems = [];
	if (_primary != "") then {
		private _weaponCfg = configFile >> "CfgWeapons" >> _primary;
		private _muzzles = getArray (_weaponCfg >> "muzzles");
		
		{
			private _itemSlot = _x;
			{
				if (isClass (configFile >> "CfgWeapons" >> _x >> _itemSlot)) then {
					_primaryItems pushBack _x;
				};
			} forEach _items;
		} forEach ["MuzzleSlot", "PointerSlot", "OpticSlot", "UnderBarrelSlot"];
	};
	
	// Role detection and assignment
	if (["Officer", _displayName] call BIS_fnc_inString) then {
        _copyOfficerHelmet = _helmet;
    };
	if (["radio", toLower _displayName] call BIS_fnc_inString) then {
        _copyBackpackRadio = _backpack;
    };	
	if (["Grenadier", _displayName] call BIS_fnc_inString) then {
        _copyRifleGLVariable = _primary;
		if (_primary != "") then {
			private _mags = compatibleMagazines _primary;
			if (count _mags > 0) then {_copyRifleGL_mag = _mags select 0};
			if (count _mags > 1) then {_copyRifleGL_mag_tr = _mags select 1};
		};
    };	
	if (["Marksman", _displayName] call BIS_fnc_inString) then {
        _copyRifleLVariable = _primary;
		if (_primary != "") then {
			private _mags = compatibleMagazines _primary;
			if (count _mags > 0) then {_copyRifleL_mag = _mags select 0};
			if (count _mags > 1) then {_copyRifleL_mag_tr = _mags select 1};
		};
    };	
	if (["Sniper", _displayName] call BIS_fnc_inString) then {
        _copyRifleMarksmanVariable = _primary;
		if (_primary != "") then {
			private _mags = compatibleMagazines _primary;
			if (count _mags > 0) then {_copyRifleMarksman_mag = _mags select 0};
			if (count _mags > 1) then {_copyRifleMarksman_mag_tr = _mags select 1};
		};
	    _sniperUniform = _uniform;
		
		// Get attachments
		if (count _primaryItems >= 4) then {
			_copyMarksmanSilencer = _primaryItems select 0;
			_copyMarksmanPointer = _primaryItems select 1;
			_copyMarksmanSight = _primaryItems select 2;
			_copyMarksmanBipod = _primaryItems select 3;
		};
    };				
	if (["Ammo Bearer", _displayName] call BIS_fnc_inString || ["Medic", _displayName] call BIS_fnc_inString || ["Engineer", _displayName] call BIS_fnc_inString || ["Asst. Gunner", _displayName] call BIS_fnc_inString) then {
        _MedicBag = _backpack;
    };
	if (["Automatic Rifleman", _displayName] call BIS_fnc_inString || ["Light Machine Gunner", _displayName] call BIS_fnc_inString) then {
        _copyLMGVariable = _primary;
		if (_primary != "") then {
			private _mags = compatibleMagazines _primary;
			if (count _mags > 0) then {_copyLMG_mag = _mags select 0};
		};
    };
	if (["Machine Gunner", _displayName] call BIS_fnc_inString) then {
        _copyMMGVariable = _primary;
		if (_primary != "") then {
			private _mags = compatibleMagazines _primary;
			if (count _mags > 0) then {_copyMMG_mag = _mags select 0};
		};
    };
	if (["Crew", _displayName] call BIS_fnc_inString) then {
        _crewHelmet = _helmet;
		_copyRifleCVariable = _primary;
		if (_primary != "") then {
			private _mags = compatibleMagazines _primary;
			if (count _mags > 0) then {_copyRifleC_mag = _mags select 0};
			if (count _mags > 1) then {_copyRifleC_mag_tr = _mags select 1};
		};
    };
	if (["Pilot", _displayName] call BIS_fnc_inString) then {
        _pilotHelmet = _helmet;
        _pilotUniform = _uniform;
        _pilotVest = _vest;
    };

	if (["LAT", _displayName] call BIS_fnc_inString) then {
		if (_secondary != "") then {
        	_copyLATVariable = _secondary;
			private _mags = compatibleMagazines _secondary;
			if (count _mags > 0) then {_copyLAT_mag = _mags select 0};
		};
    };	

	if (["Anti-Air", _displayName] call BIS_fnc_inString || ["AA", _displayName] call BIS_fnc_inString || ["Igla", _displayName] call BIS_fnc_inString || ["FIM", _displayName] call BIS_fnc_inString) then {
		if (_secondary != "") then {
        	_copyAAVariable = _secondary;
			// Get magazine from unit's magazines array
			{
				if (_x in (compatibleMagazines _secondary)) exitWith {
					_copyAA_mag = _x;
				};
			} forEach _magazines;
		};
    };	

	if (["Anti Tank", _displayName] call BIS_fnc_inString || ["Anti-tank", _displayName] call BIS_fnc_inString) then {
		if (_secondary != "") then {
        	_copyMATVariable = _secondary;
			{
				if (_x in (compatibleMagazines _secondary)) exitWith {
					_copyMAT_mag = _x;
				};
			} forEach _magazines;
		};	
    };	
	if (["AT Specialist", _displayName] call BIS_fnc_inString) then {
		if (_secondary != "") then {
        	_copyHATVariable = _secondary;
			{
				if (_x in (compatibleMagazines _secondary)) exitWith {
					_copyHAT_mag = _x;
				};
			} forEach _magazines;
		};
    };

	// Collect unique items
	if (_helmet != "") then {_copyHelmet pushBackUnique _helmet};
	if (_uniform != "") then {_copyUniform pushBackUnique _uniform};
	if (_vest != "") then {_copyVest pushBackUnique _vest};
    if (_goggles != "") then {_copyGoggles pushBackUnique _goggles};
	if (_backpack != "") then {_copyBackpack pushBackUnique _backpack};

    // Collect attachments
	if (count _primaryItems >= 4) then {
		private _silence = _primaryItems select 0;
		private _pointer = _primaryItems select 1;
		private _sight = _primaryItems select 2;
		private _bipod = _primaryItems select 3;
		
		if (_silence != "") then {_silencers pushBackUnique _silence};
		if (_pointer != "") then {_pointers pushBackUnique _pointer};
		if (_sight != "") then {_sights pushBackUnique _sight};
		if (_bipod != "") then {_bipods pushBackUnique _bipod};
	};
	
    if (_primary != "") then {_rifles pushBackUnique _primary};
	if (_handgun != "") then {_pistols pushBackUnique _handgun};
	
	_processedCount = _processedCount + 1;
} foreach _Objects;

if (_processedCount == 0) exitWith {
	"Extract Gear: No valid units found in selection!" call OKS_fnc_LogDebug;
	["Extract Gear: no valid units", 1, 5, true] call BIS_fnc_3DENNotification;
};

(format ["Extract Gear: Processed %1 units", _processedCount]) call OKS_fnc_LogDebug;
[format ["Extract Gear: processed %1 units", _processedCount], 0, 4, true] call BIS_fnc_3DENNotification;

/// Assigning the variables from the object array.
_copyInsignia = "";
if(_copyBackpackRadio == "") then {
	_copyBackpackRadio = _copyBackpack select 0;
};

// Function to filter arrays by removing unwanted items
private _filterArray = {
	params ["_array", "_unwanted"];
	_array select { !(_x in _unwanted) };
};

// After collecting all gear arrays, filter out unwanted helmets/uniforms/vests
_copyHelmet = [_copyHelmet, [_crewHelmet, _copyOfficerHelmet, _pilotHelmet]] call _filterArray;
_copyUniform = [_copyUniform, [_pilotUniform,_sniperUniform]] call _filterArray;
_copyVest = [_copyVest, [_pilotVest]] call _filterArray;

_copyPistolVariable = "";
if (count _Pistols > 0) then {
	private _mostCommon = "";
	private _maxCount = 0;
	{
		private _foreachItem = _x;
		private _currentCount = {_x == _foreachItem} count _Pistols;
		if (_currentCount > _maxCount) then {
			_maxCount = _currentCount;
			_mostCommon = _foreachItem;
		};
	} forEach _Pistols;
	_copyPistolVariable = _mostCommon;
	private _mags = compatibleMagazines _mostCommon;
	if (count _mags > 0) then {_copyPistol_mag = _mags select 0};
};

_copySilencer = "";
if (count _silencers > 0) then {
	private _mostCommon = "";
	private _maxCount = 0;
	{
		private _foreachItem = _x;
		private _currentCount = {_x == _foreachItem} count _silencers;
		if (_currentCount > _maxCount) then {
			_maxCount = _currentCount;
			_mostCommon = _foreachItem;
		};
	} forEach _silencers;
	_copySilencer = _mostCommon;
};

_copyPointer = "";
if (count _pointers > 0) then {
	private _mostCommon = "";
	private _maxCount = 0;
	{
		private _foreachItem = _x;
		private _currentCount = {_x == _foreachItem} count _pointers;
		if (_currentCount > _maxCount) then {
			_maxCount = _currentCount;
			_mostCommon = _foreachItem;
		};
	} forEach _pointers;
	_copyPointer = _mostCommon;
};

_copySight = "";
if (count _sights > 0) then {
	private _mostCommon = "";
	private _maxCount = 0;
	{
		private _foreachItem = _x;
		private _currentCount = {_x == _foreachItem} count _sights;
		if (_currentCount > _maxCount) then {
			_maxCount = _currentCount;
			_mostCommon = _foreachItem;
		};
	} forEach _sights;
	_copySight = _mostCommon;
};

_copyBipod = "";
if (count _bipods > 0) then {
	private _mostCommon = "";
	private _maxCount = 0;
	{
		private _foreachItem = _x;
		private _currentCount = {_x == _foreachItem} count _bipods;
		if (_currentCount > _maxCount) then {
			_maxCount = _currentCount;
			_mostCommon = _foreachItem;
		};
	} forEach _bipods;
	_copyBipod = _mostCommon;
};

_copyRifleVariable = "";
if (count _rifles > 0) then {
	private _mostCommon = "";
	private _maxCount = 0;
	{
		private _foreachItem = _x;
		private _currentCount = {_x == _foreachItem} count _rifles;
		if (_currentCount > _maxCount) then {
			_maxCount = _currentCount;
			_mostCommon = _foreachItem;
		};
	} forEach _rifles;
	_copyRifleVariable = _mostCommon;
	private _mags = compatibleMagazines _mostCommon;
	if (count _mags > 0) then {_copyRifle_mag = _mags select 0};
	if (count _mags > 1) then {_copyRifle_mag_tr = _mags select 1};
};

/// Replace Empty Values.
if(isNil "_copyPDWVariable" || _copyPDWVariable == "") then {
	if(!isNil "_copyrifleCVariable" && _copyrifleCVariable != "") then {
		_copyPDWVariable = _copyrifleCVariable;
		_copyPDW_mag = _copyRifleC_mag;
		_copyPDW_mag_tr = _copyRifleC_mag_tr;
	} else {
		_copyPDWVariable = _copyRifleVariable;
		_copyPDW_mag = _copyRifle_mag;
		_copyPDW_mag_tr = _copyRifle_mag_tr;
	};
};

// _copyRifleCVariable     = '';
// _copyRifleGLVariable    = '';
// _copyRifleLVariable     = '';
// _copyLMGVariable        = '';
// _copyMMGVariable        = '';
// _copyLATVariable        = '';
// _copyMATVariable        = '';
// _copyHATVariable        = '';
// _copyAAVariable         = '';
// _copyPistolVariable     = '';
// _copyPDWVariable        = '';
// _copyRifleMarksmanVariable = '';

_copyRifle = format ["[%1, _silencer, _pointer, _sight, _bipod];", _copyRifleVariable];
_copyRifleC = format ["[%1, _silencer, _pointer, _sight, _bipod];", _copyRifleCVariable];
_copyRifleGL = format ["[%1, _silencer, _pointer, _sight, _bipod];", _copyRifleGLVariable];
_copyRifleL = format ["[%1, _silencer, _pointer, _sight, _bipod];", _copyRifleLVariable];
_copyLMG = format ["[%1, _silencer, _pointer, _sight, _bipod];", _copyLMGVariable];
_copyMMG = format ["[%1, _silencer, _pointer, _sight, _bipod];", _copyMMGVariable];
_copyLAT = format ["[%1, _silencer, _pointer, _sight, _bipod];", _copyLATVariable];
_copyMAT = format ["[%1, _silencer, _pointer, _sight, _bipod];", _copyMATVariable];
_copyHAT = format ["[%1, _silencer, _pointer, _sight, _bipod];", _copyHATVariable];
_copyAA = format ["[%1, _silencer, _pointer, _sight, _bipod];", _copyAAVariable];
_copyPistol = format ["[%1, _silencer, _pointer, _sight, _bipod];", _copyPistolVariable];
_copyPDW = format ["[%1, _silencer, _pointer, _sight, _bipod];", _copyPDWVariable];
_copyRifleMarksman = format ["[%1, _silencer, _pointer, _sight, _bipod];", _copyRifleMarksmanVariable];

// Formating the Clipboard Code.
_output =
	"_useMineDetector = false" + ";" + toString [13,10] +
	"_allowedNightStuff = true;" + toString [13,10] +
	toString [13,10] +
    "_insignia = " + str _copyInsignia + ";" + toString [13,10] +
	toString [13,10] +
    "_goggles = " + str _copyGoggles + ";" + toString [13,10] +
    "_helmet = " + str _copyHelmet + ";" + toString [13,10] +
    "_OfficerHelmet = " + str _copyOfficerHelmet + ";" + toString [13,10] +
    "_uniform = " + str _copyUniform + ";" + toString [13,10] +
    "_vest = " + str _copyVest + ";" + toString [13,10] +
    "_backpack = " + str _copyBackpack + ";" + toString [13,10] +
    "_backpackRadio = " + str _copyBackpackRadio + ";" + toString [13,10] + toString [13,10] +
	"if (_role in ['ag','ammg','lr','ab']) then {" + toString [13,10] +
	"   _backpack = "+ str _MedicBag + ";" + toString [13,10] +
	"};" + toString [13,10] +
	"if (_role isEqualTo 'crew') then {" + toString [13,10] +
	"   _helmet = "+ str _crewHelmet + ";" + toString [13,10] +
	"};" + toString [13,10] +
	"if (_role isEqualTo 'p') then {" + toString [13,10] +
	"   _helmet = "+ str _pilotHelmet + ";" + toString [13,10] +
	"   _vest = "+ str _pilotVest + ";" + toString [13,10] +
	"   _uniform = "+ str _pilotUniform + ";" + toString [13,10] +
	"};" + toString [13,10] +  toString [13,10] +
    "_silencer = " + str _copySilencer + ";" + toString [13,10] +
    "_pointer = " + str _copyPointer + ";" + toString [13,10] +
    "_sight = " + str _copySight + ";" + toString [13,10] +
    "_bipod = " + str _copyBipod + ";" + toString [13,10] + toString [13,10] +
	format ["_rifle = [%1, _silencer, _pointer, _sight, _bipod];%2", str _copyRifleVariable, toString [13,10]] +
	"_rifle_mag = " + str _copyRifle_mag + ";" + toString [13,10] +
	"_rifle_mag_tr = " + str _copyRifle_mag_tr + ";" + toString [13,10] + toString [13,10] +
	format ["_rifleC = [%1, _silencer, _pointer, _sight, _bipod];%2", str _copyRifleCVariable, toString [13,10]] +
	"_rifleC_mag = " + str _copyRifleC_mag + ";" + toString [13,10] +
	"_rifleC_mag_tr = " + str _copyRifleC_mag_tr + ";" + toString [13,10] + toString [13,10] +
	format ["_rifleGL = [%1, _silencer, _pointer, _sight, _bipod];%2", str _copyRifleGLVariable, toString [13,10]] +
	"_rifleGL_mag = " + str _copyRifleGL_mag + ";" + toString [13,10] +
	"_rifleGL_mag_tr = " + str _copyRifleGL_mag_tr + ";" + toString [13,10] + toString [13,10] +
	format ["_rifleL = [%1, _silencer, _pointer, _sight, _bipod];%2", str _copyRifleLVariable, toString [13,10]] +
	"_rifleL_mag = " + str _copyRifleL_mag + ";" + toString [13,10] +
	"_rifleL_mag_tr = " + str _copyRifleL_mag_tr + ";" + toString [13,10] + toString [13,10] +
	format ["_LMG = [%1, _silencer, _pointer, _sight, _bipod];%2", str _copyLMGVariable, toString [13,10]] +
	"_LMG_mag = " + str _copyLMG_mag + ";" + toString [13,10] + toString [13,10] +
	format ["_MMG = [%1, _silencer, _pointer, _sight, _bipod];%2", str _copyMMGVariable, toString [13,10]] +
	"_MMG_mag = " + str _copyMMG_mag + ";" + toString [13,10] + toString [13,10] +
	format ["_LAT = [%1, _silencer, _pointer, _sight, _bipod];%2", str _copyLATVariable, toString [13,10]] +
	"_LAT_mag = " + str _copyLAT_mag + ";" + toString [13,10] +
	"_LAT_ReUsable = " + str _copyLAT_ReUsable + ";" + toString [13,10] + toString [13,10] +
	format ["_MAT = [%1, _silencer, _pointer, _sight, _bipod];%2", str _copyMATVariable, toString [13,10]] +
	"_MAT_mag = " + str _copyMAT_mag + ";" + toString [13,10] +
	"_MAT_mag_HE = " + str _copyMAT_mag_HE + ";" + toString [13,10] + toString [13,10] +
	format ["_HAT = [%1, _silencer, _pointer, _sight, _bipod];%2", str _copyHATVariable, toString [13,10]] +
	"_HAT_mag = " + str _copyHAT_mag + ";" + toString [13,10] + toString [13,10] +
	format ["_AA = [%1, _silencer, _pointer, _sight, _bipod];%2", str _copyAAVariable, toString [13,10]] +
	"_AA_mag = " + str _copyAA_mag + ";" + toString [13,10] + toString [13,10] +
	format ["_pistol = [%1, _silencer, _pointer, _sight, _bipod];%2", str _copyPistolVariable, toString [13,10]] +
	"_pistol_mag = " + str _copyPistol_mag + ";" + toString [13,10] + toString [13,10] +
	format ["_pdw = [%1, _silencer, _pointer, _sight, _bipod];%2", str _copyPDWVariable, toString [13,10]] +
	"_pdw_mag = " + str _copyPDW_mag + ";" + toString [13,10] +
	"_pdw_mag_tr = " + str _copyPDW_mag_tr + ";" + toString [13,10] + toString [13,10] +
	"_silencer = " + str _copyMarksmanSilencer + ";" + toString [13,10] +
    "_pointer = " + str _copyMarksmanPointer + ";" + toString [13,10] +
    "_sight = " + str _copyMarksmanSight + ";" + toString [13,10] +
    "_bipod = " + str _copyMarksmanBipod + ";" + toString [13,10] + toString [13,10] +
	format ["_rifleMarksman = [%1, _silencer, _pointer, _sight, _bipod];%2", str _copyRifleMarksmanVariable, toString [13,10]] +
	"_rifleMarksman_mag = " + str _copyRifleMarksman_mag + ";" + toString [13,10] +
	"_rifleMarksman_mag_tr = " + str _copyRifleMarksman_mag_tr + ";" + toString [13,10];

copyToClipboard _output;

(format ["Extract Gear: Copied gear configuration for %1 units to clipboard!", _processedCount]) call OKS_fnc_LogDebug;
[format ["Extract Gear copied (%1 units)", _processedCount], 0, 5, true] call BIS_fnc_3DENNotification;