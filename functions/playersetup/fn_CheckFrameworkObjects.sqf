/*
	call OKS_CheckFrameworkObjects;

	- Updating Old Missions
	This code is not in the older template versions, if you haven't imported the files, you can instead copy paste the code below into the debug console and run it.
	It will return the missing objects into the return field, and will be copied to your clipboard.

*/
private _ReturnText = "This template is not missing any NEW template items."; 
_Return = []; 
 
_HasGearBoxWest = ({typeOf _X == "GOL_GearBox_WEST"} count (allMissionObjects "ALL") > 0); 
_HasGearBoxWestArray = [_HasGearBoxWest,"Gear Box WEST: "]; 

_HasGearBoxEAST = ({typeOf _X == "GOL_GearBox_EAST"} count (allMissionObjects "ALL") > 0); 
_HasGearBoxEASTArray = [_HasGearBoxEAST,"Gear Box EAST: "]; 

_HasResupplyStationWest = ({typeOf _X == "GOL_ResupplyStation_WEST"} count (allMissionObjects "ALL") > 0); 
_HasResupplyStationWestArray = [_HasResupplyStationWest,"Resupply Station WEST: "]; 

_HasResupplyStationEast = ({typeOf _X == "GOL_ResupplyStation_EAST"} count (allMissionObjects "ALL") > 0); 
_HasResupplyStationEastArray = [_HasResupplyStationEast,"Resupply Station EAST: "]; 

_HasMobileServiceStation = ({typeOf _X == "GOL_MobileServiceStation"} count (allMissionObjects "ALL") > 0); 
_HasMobileServiceStationArray = [_HasMobileServiceStation,"Mobile Service Station: "]; 
 
_HasAacServiceHelipad = ({typeOf _X == "GOL_Helipad"} count (allMissionObjects "ALL") > 0); 
_HasAacServiceHelipadArray = [_HasAacServiceHelipad,"AAC Service Helipad: "]; 
 
HasMobileHQ = ({vehicleVarName _X == "Mobile_HQ"} count (allMissionObjects "ALL") > 0); 
HasMobileHQArray = [HasMobileHQ,"Mobile HQ: "]; 
 
_HasArsenalGL = ({vehicleVarName _X == "GOL_Arsenal_GL"} count allMissionObjects "ALL" > 0); 
_HasArsenalGLArray = [_HasArsenalGL,"GL Arsenal Logic: "]; 
 
_HasArsenalLMG = ({vehicleVarName _X == "GOL_Arsenal_LMG"} count allMissionObjects "ALL" > 0); 
_HasArsenalLMGArray = [_HasArsenalLMG,"LMG Arsenal Logic: "]; 
 
_HasHeadless = ({vehicleVarName _X in ["HC","HC2","HC3"]} count allMissionObjects "ALL" > 0); 
_HasHeadlessArray = [_HasHeadless,"Headless Clients: "]; 

_HasDapsOptions = ({typeOf _X == "DAPS_Options"} count allMissionObjects "LOGIC" > 0); 
_HasDapsOptionsArray = [_HasDapsOptions,"DAPS Options: "]; 
 
{ 
    if((_X select 0) == false) then {
		_Return pushBack _X;
	} 
} foreach [
	_HasGearBoxWestArray,_HasGearBoxEASTArray,_HasResupplyStationWestArray,_HasAacRefuelArray,_HasAacServiceHelipadArray,
	HasMobileHQArray,_HasArsenalGLArray,_HasArsenalLMGArray,_HasHeadlessArray,
	_HasResupplyStationEastArray,_HasDapsOptionsArray
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

