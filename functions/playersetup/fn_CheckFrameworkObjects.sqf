/*
	call OKS_CheckFrameworkObjects;

	- Updating Old Missions
	This code is not in the older template versions, if you haven't imported the files, you can instead copy paste the code below into the debug console and run it.
	It will return the missing objects into the return field, and will be copied to your clipboard.

*/
private _ReturnText = "This template is not missing any NEW template items."; 
_Return = []; 
 
_HasGearBox = ({typeOf _X == "GOL_GearBox_WEST"} count (allMissionObjects "ALL") > 0); 
_HasGearBoxArray = [_HasGearBox,"Gear Box WEST: "]; 

_HasResupplyStation = ({typeOf _X == "GOL_ResupplyStation"} count (allMissionObjects "ALL") > 0); 
_HasResupplyStationArray = [_HasResupplyStation,"Resupply Station: "]; 

_HasMobileServiceStation = ({typeOf _X == "GOL_MobileServiceStation"} count (allMissionObjects "ALL") > 0); 
_HasMobileServiceStationArray = [_HasMobileServiceStation,"Mobile Service Station: "]; 
 
_HasAacServiceHelipad = ({typeOf _X == "GOL_Helipad"} count (allMissionObjects "ALL") > 0); 
_HasAacServiceHelipadArray = [_HasAacServiceHelipad,"AAC Service Helipad: "]; 
 
_HasMobileHQ = ({vehicleVarName _X == "Mobile_HQ"} count (allMissionObjects "ALL") > 0); 
_HasMobileHQArray = [HasMobileHQ,"Mobile HQ: "]; 
 
_HasHeadless = ({vehicleVarName _X in ["HC","HC2","HC3"]} count allMissionObjects "ALL" > 0); 
_HasHeadlessArray = [_HasHeadless,"Headless Clients: "]; 
 
{ 
    if((_X select 0) == false) then {
		_Return pushBack _X;
	} 
} foreach [
	_HasGearBoxArray,
	_HasResupplyStationArray,
	_HasMobileServiceStationArray,
	_HasAacServiceHelipadArray,
	_HasMobileHQArray,
	_HasHeadlessArray
]; 
 
if(_Return isNotEqualTo []) then { 
    _ReturnText = ""; 
    { 
        _ReturnText = _ReturnText + (_X select 1) + str(_x select 0) + " || "; 
    } foreach _Return; 

    _ReturnText = _ReturnText select [0, (count _ReturnText) - 3];
} else {
	_ReturnText = "";
};

_ReturnText

