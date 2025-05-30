/*
	[RoadObject,Count] spawn OKS_fnc_RoadConnected;
*/
Params ["_Road","_Count"];
Private ["_Roads","_Road1","_Road2"];

_Repetitions = 0;

_AllRoads = [];

_Roads = roadsConnectedTo _Road;
_Roads1 = roadsConnectedTo (_Roads select 0);
_Roads2 = roadsConnectedTo (_Roads select 1);

SystemChat str _Road;
SystemChat str _Roads;
SystemChat str (roadsConnectedTo _Roads1);
SystemChat str (roadsConnectedTo _Roads2);

{{_AllRoads pushBackUnique _X} foreach _X} foreach [_Roads,_Roads1,_Roads2];

SystemChat str _AllRoads;