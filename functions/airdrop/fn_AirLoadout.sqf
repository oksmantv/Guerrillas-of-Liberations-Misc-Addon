/*
	How to get custom loadout from existing vehicle.

	Debug Command whilst aiming at it in Editor:
	_pylonData = getAllPylonsInfo cursorObject apply { [_x select 0, _x select 3, _x select 4] }; 
	copyToClipboard str _pylonData 

	[_Helicopter] spawn OKS_fnc_AirLoadout;
*/


Params ["_Aircraft"];

private _GetAircraftClass = {
    params ["_type"];
    private _typeLower = toLower _type;
    if (_typeLower find "mtv3" > -1) exitWith { "mtv3" };
    if (_typeLower find "mi24p" > -1) exitWith { "mi24p" };
    if (_typeLower find "amtsh" > -1) exitWith { "amtsh" };
    ""
};

private _aircraftType = typeOf _Aircraft;
private _aircraftTypeClass = [_aircraftType] call _GetAircraftClass;
private _loadout = "";
if (_aircraftTypeClass == "") exitWith {}; // Exit if no match

switch (_aircraftTypeClass) do {
    case "mtv3": {
		  _loadout = [[1,"rhs_mag_ub16_s5k1",8],[2,"rhs_mag_ub16_s5k1",8],[3,"rhs_mag_upk23_mixed",250],[4,"",-1],[5,"",-1],[6,"",-1],[7,"rhs_ASO2_CMFlare_Chaff_Magazine_x6",96]];
    };
    case "mi24": {
		  _loadout = [[1,"rhs_mag_ub16_s5k1",4],[2,"rhs_mag_ub16_s5k1",4],[3,"rhs_mag_ub16_s5k1",4],[4,"rhs_mag_ub16_s5k1",4],[5,"",-1],[6,"",-1],[7,"rhs_ASO2_CMFlare_Chaff_Magazine_x4",64]];
    };
    case "mi_24": {
		  _loadout = [[1,"rhs_mag_ub16_s5k1",4],[2,"rhs_mag_ub16_s5k1",4],[3,"rhs_mag_ub16_s5k1",4],[4,"rhs_mag_ub16_s5k1",4],[5,"",-1],[6,"",-1],[7,"rhs_ASO2_CMFlare_Chaff_Magazine_x4",64]];
    };    
    case "amtsh": {
        _loadout = [[1,"",-1],[2,"",-1],[3,"rhs_mag_ub16_s5k1",8],[4,"rhs_mag_ub16_s5k1",8],[5,"",-1],[6,"rhs_mag_upk23_mixed",250],[7,"rhs_ASO2_CMFlare_Chaff_Magazine_x4",64]]
    };
    default { };
};

if(!isNil "_Aircraft") then {
	{ 
		_X Params ["_PylonIndex","_MagazineClass","_AmmoCount"];
		_Aircraft setPylonLoadout [_PylonIndex, _MagazineClass, true];
		_Aircraft setAmmoOnPylon [_PylonIndex, _AmmoCount];
	} forEach _loadout;
};