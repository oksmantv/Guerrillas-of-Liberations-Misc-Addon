/*
    OKS_fnc_ExtractGearFromAI

	Extract gear from selected AI units
*/
private _Objects = get3DENSelected "object";

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

{
    private _displayName = [configFile >> 'CfgVehicles' >> typeOf _X] call BIS_fnc_displayName;

	if (["Officer", _displayName] call BIS_fnc_inString) then {
        _copyOfficerHelmet = (headgear _X);
    };
	if (["radio", _displayName] call BIS_fnc_inString) then {
        _copyBackpackRadio = (backpack _X);
    };	
	if (["Grenadier", _displayName] call BIS_fnc_inString) then {
        _copyRifleGLVariable = primaryWeapon _X;
		_copyRifleGL_mag = (compatibleMagazines primaryWeapon _X) select 0;
		_copyRifleGL_mag_tr = (compatibleMagazines primaryWeapon _X) select 1;
    };	
	if (["Marksman", _displayName] call BIS_fnc_inString) then {
        _copyRifleLVariable = primaryWeapon _X;
		_copyRifleL_mag = (compatibleMagazines primaryWeapon _X) select 0;
		_copyRifleL_mag_tr = (compatibleMagazines primaryWeapon _X) select 1;
    };	
	if (["Sniper", _displayName] call BIS_fnc_inString) then {
        _copyRifleMarksmanVariable = primaryWeapon _X;
		_copyRifleMarksman_mag = (compatibleMagazines primaryWeapon _X) select 0;
		_copyRifleMarksman_mag_tr = (compatibleMagazines primaryWeapon _X) select 1;
	    _sniperUniform = (uniform _X);
		_items = primaryWeaponItems _X;
		_copyMarksmanSilencer = _items select 0;
		_copyMarksmanPointer = _items select 1;
		_copyMarksmanSight = _items select 2;
		_copyMarksmanBipod = _items select 3; 
    };				
	if (["Ammo Bearer", _displayName] call BIS_fnc_inString || ["Medic", _displayName] call BIS_fnc_inString || ["Engineer", _displayName] call BIS_fnc_inString || ["Asst. Gunner", _displayName] call BIS_fnc_inString) then {
        _MedicBag = (backpack _X);
    };
	if (["Automatic Rifleman", _displayName] call BIS_fnc_inString || ["Light Machine Gunner", _displayName] call BIS_fnc_inString) then {
        _copyLMGVariable = (primaryWeapon _X);
		_copyLMG_mag = (compatibleMagazines primaryWeapon _X) select 0;
    };
	if (["Machine Gunner", _displayName] call BIS_fnc_inString) then {
        _copyMMGVariable = (primaryWeapon _X);
		_copyMMG_mag = (compatibleMagazines primaryWeapon _X) select 0;
    };
	if (["Crew", _displayName] call BIS_fnc_inString) then {
        _crewHelmet = (headgear _X); // Crew helmet
		_copyRifleCVariable = primaryWeapon _X;
		_copyRifleC_mag = (compatibleMagazines primaryWeapon _X) select 0;
		_copyRifleC_mag_tr = (compatibleMagazines primaryWeapon _X) select 1;
    };
	if (["Pilot", _displayName] call BIS_fnc_inString) then {
        _pilotHelmet = (headgear _X);
        _pilotUniform = (uniform _X);
        _pilotVest = (vest _X);
    };

	if (["LAT", _displayName] call BIS_fnc_inString) then {
		_LATVariable = (secondaryWeapon _X);
		if(!isNil "_LATVariable" && _LATVariable != "") then {
        	_copyLATVariable = (secondaryWeapon _X);
			_copyLAT_mag = (compatibleMagazines secondaryWeapon _X) select 0;
		};
    };	

	if (["Anti-Air", _displayName] call BIS_fnc_inString || ["AA", _displayName] call BIS_fnc_inString || ["Igla", _displayName] call BIS_fnc_inString || ["FIM", _displayName] call BIS_fnc_inString) then {
		_AAVariable = (secondaryWeapon _X);
		if(!isNil "_AAVariable" && _AAVariable != "") then {
        	_copyAAVariable = _AAVariable;
			_copyAA_mag = selectRandom (secondaryWeaponMagazine _X);
			//systemchat str [_copyAA_mag, _AAVariable];
		};
    };	

	if (["Anti Tank", _displayName] call BIS_fnc_inString || ["Anti-tank", _displayName] call BIS_fnc_inString) then {
		_MATVariable = (secondaryWeapon _X);
		if(!isNil "_MATVariable" && _MATVariable != "") then {
        	_copyMATVariable = (secondaryWeapon _X);
			_copyMAT_mag = selectRandom (secondaryWeaponMagazine _X);
			systemChat str [_copyMATVariable, _copyMAT_mag];
		};	
    };	
	if (["AT Specialist", _displayName] call BIS_fnc_inString || ["Anti Tank", _displayName] call BIS_fnc_inString || ["Anti-tank", _displayName] call BIS_fnc_inString) then {
		_HATVariable = (secondaryWeapon _X);
		if(!isNil "_HATVariable" && _HATVariable != "") then {
        	_copyHATVariable = (secondaryWeapon _X);
			_copyHAT_mag = selectRandom (secondaryWeaponMagazine _X);
		};
    };

	_copyHelmet pushBackUnique (headgear _X);
	_copyUniform pushBackUnique (uniform _X);
	_copyVest pushBackUnique (vest _X);
    _copyGoggles pushBackUnique (goggles _X);
	if (backpack _X != "") then {
    	_copyBackpack pushBackUnique (backpack _X);
	};

    // Sights collection
    private _silence = (primaryWeaponItems _X) select 0;
	if(!isNil "_silence") then {
        _silencers pushBackUnique _silence;
    };	
    private _pointer = (primaryWeaponItems _X) select 1;
	if(!isNil "_pointer") then {
        _pointers pushBackUnique _pointer;
    };	
    private _sight = (primaryWeaponItems _X) select 2;
	if(!isNil "_sight") then {
        _sights pushBackUnique _sight;
    };
    private _bipod = (primaryWeaponItems _X) select 3;
	if(!isNil "_bipod") then {
        _bipods pushBackUnique _bipod;
    };	
    private _rifle = (primaryWeapon _X);
	if(!isNil "_rifle") then {
        _rifles pushBackUnique _rifle;
    };		

	_copyPistol = (handgunWeapon _X);
	if(!isNil "_copyPistol") then {
		_Pistols pushBackUnique _copyPistol;
	};
    // You can later count and select the most common sight from _copySightList
} foreach _Objects;

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
		_foreachItem = _X;
		private _currentCount = {_x == _foreachItem} count _Pistols;
		if (_currentCount > _maxCount) then {
			_maxCount = _currentCount;
			_mostCommon = _foreachItem;
		};
	} forEach _Pistols;
	_copyPistolVariable = _mostCommon;
	_copyPistol_mag = (compatibleMagazines _mostCommon) select 0;
};

_copySilencer = "";
if (count _silencers > 0) then {
	private _mostCommon = "";
	private _maxCount = 0;
	{
		_foreachItem = _X;
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
		_foreachItem = _X;		
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
		_foreachItem = _X;		
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
		_foreachItem = _X;		
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
		_foreachItem = _X;		
		private _currentCount = {_x == _foreachItem} count _rifles;
		if (_currentCount > _maxCount) then {
			_maxCount = _currentCount;
			_mostCommon = _foreachItem;
		};
	} forEach _rifles;
	_copyRifleVariable = _mostCommon;
	_copyRifle_mag = (compatibleMagazines _mostCommon) select 0;
	_copyRifle_mag_tr = (compatibleMagazines _mostCommon) select 1;
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
_copyLMG = format ["[%11, _silencer, _pointer, _sight, _bipod];", _copyLMGVariable];
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