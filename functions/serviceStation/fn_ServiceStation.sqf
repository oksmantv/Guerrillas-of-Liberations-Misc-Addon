//	null = [This, Radius, (is a Mobile Service Station), ["NearestObjects"]] spawn OKS_Fnc_ServiceStation;
///////////////////////////////////////////
//
//	1. Object name, the name of the object.
//		a. Can be the actual name of the Object. Generally used when activating Service Stations later in to the mission.
// 		b. This, when entered in the init line of an object, activates the Service Station instantly.
//	2. OPTIONAL: Radius, range of service station.
//		a. Any number (meters) from center of object chosen above.
//		b. Nil, will make it default to what is defined in NEKY_Settings.
//	3. OPTIONAL: If it is a Mobile Service Station. True/False.
//		a. Defaults to false, Always use false. If you want to use a Mobile Service Station use the extension OKS_fnc_MobileSS.
//		b. True, when this script is being executed via OKS_fnc_MobileSS.
//	4. OPTIONAL: Objects to scan for, an array of strings that will scan for types of vehicles ( https://community.bistudio.com/wiki/nearestObjects ).
//		a. This decides what "TYPES" of vehicles the Service Station will look for/work with. ["CAR","AIR","PLANE","HELICOPTER","TANK"] are some examples.
//		b. Defaults to all land vehicles and all aerial vehicles.
///////////////
//	Examples:
///////////////
//	null = [This, nil, false, ["LandVehicle","AIR"]] spawn OKS_Fnc_ServiceStation;
//	null = [Helipad, 15, false, ["LandVehicle"]] spawn OKS_Fnc_ServiceStation;
//	null = [This, nil] spawn OKS_Fnc_ServiceStation;
//	null = [This] spawn OKS_Fnc_ServiceStation;
///////////////
///////////////
//	Made by NeKo-ArroW with help from GuzzenVonLidl
//  Thanks to MacGregor and Parker for helping me out testing this on dedicated server
//	version 2.21
///////////////

Private ["_Variables","_FullService","_Radius","_InspectionSpeed","_RepairingSpeed","_RepairingTrackSpeed","_RepairingSpeedPlane","_Refueling","_RemoveWheelSpeed","_MountWheelSpeed","_RearmSpeed","_RearmSpeedPlane","_MRadius"];

if (isServer) then  // To avoid having all players loop the scanners
{
	#include "fn_Service_Settings.sqf"

	Params
	[
		["_SS", ObjNull, [ObjNull]],
		["_Radius", _Radius, [0]],
		["_IsMSS", false, [true]],
		["_Filter", ["LANDVEHICLE","AIR","SHIP"], [[]]]
	];

	_Variables = ["NEKY_ServiceStationArray","NEKY_ServiceStations"];
	{ call compile format ["if (isNil '%1') then {%1 = [];}", _x] } forEach _Variables;
	sleep 1;

	_FullService = False;
	NEKY_ServiceStations PushBack _SS;
	[] Spawn {sleep 5; PublicVariable "NEKY_ServiceStations"};

	// MSS Deactivate if moved or destroyed
	if (_IsMSS) then
	{
		_This spawn
		{
			Params ["_SS"];

			While {True} do
			{
				if ( !(Speed _SS isEqualTo 0) or !(Alive _SS) or !(_SS in NEKY_ServiceStations) ) exitWith
				{
//					SystemChat "MSS Moving, died or deactivated.";
					[_SS,false] call OKS_Fnc_Available;
					NEKY_ServiceStations deleteAt (NEKY_ServiceStations Find _SS);
					PublicVariable "NEKY_ServiceStations";
				};
				sleep 10;
			};
		};
	};

	[_SS,_Radius,_Filter] Spawn
	// Scanner
	{
		Params ["_SS","_Radius","_Filter"];

		While {_SS in NEKY_ServiceStations} do
		{
			_Vehicles = NearestObjects [_SS, _Filter, _Radius];
			{
				if (!(_x in NEKY_ServiceStationArray) && (Alive _x)) then
				{
					NEKY_ServiceStationArray pushBack _x;
					PublicVariable "NEKY_ServiceStationArray";
					if !(_x getVariable ["NEKY_ServiceStation_HasActions",false]) then
					{
						[[_x,_SS],{_This Spawn OKS_Fnc_ServiceAddActions}] remoteExec ["BIS_FNC_SPAWN",0,true];
						_x setVariable ["NEKY_ServiceStation_HasActions",true,true];
					};
					_x setVariable ["NEKY_ServiceStation_InStation",[true,_SS],true];
					[_x,_SS,_Radius] Spawn OKS_Fnc_ExitLoop;
				};
			} forEach _Vehicles;
			Sleep 4;
		};
	};
};
