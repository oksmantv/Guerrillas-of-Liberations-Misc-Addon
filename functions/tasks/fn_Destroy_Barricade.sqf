	// OKS_Destroy_Barricade
	// [[barricade_1,barricade_2]] spawn OKS_fnc_Destroy_Barricade;
	// [[barricade_1,barricade_2],"TaskParent"] spawn OKS_fnc_Destroy_Barricade;
	if(HasInterface && !isServer) exitWith {};

	Params ["_Barricades",["_TaskParent",nil,[""]],["_ShouldAddActionToDestroy",false,[false]]];
	Private ["_startmarker","_TaskPosition","_TaskTitle","_BarricadeText"];
	Private _Debug_Variable = false;
	_TaskTitle = "Clear Barricade";
	_BarricadeText = "barricade";
	_TaskPosition = getPos (selectRandom _Barricades);
	if(count _Barricades > 1) then {
		_TaskTitle = "Clear Barricades";
		_BarricadeText = "barricades";
		_TaskPosition = [0, 0, 0];
		{
			_TaskPosition = _TaskPosition vectorAdd (getPosWorld _x);
		} forEach _Barricades;
		_TaskPosition = _TaskPosition vectorMultiply (1 / (count _Barricades));	
	};

	_startmarker = createMarker [format ["oks_barricade_marker_%1",str round(random 80000 + random 9999)],_TaskPosition];
	_startmarker setMarkerType "mil_destroy_noShadow";
	_startmarker setMarkerColor "colorRed";
	_startmarker setMarkerSize [0.9,0.9];
	_startmarker setMarkerAlpha 0;
	_startmarker setMarkerShape "ICON";
	_startMarker setMarkerText "Barricade";
	_startMarker setMarkerDir 45;

	private _TaskMain = format["OKS_BARRICADETASK_%1",(round(random 99999))];
	private _TaskMainArray = [_TaskMain];
	if(!isNil "_TaskParent") then {
		_TaskMainArray = [_TaskMain,_TaskParent];
	};

	// Create Main Task
	[true, _TaskMainArray, [format["We have reports of <font color='#84e4ff'><marker name = '%1'>%2</marker></font color> present in our area of operations. We need to clear a path, remove the %2.",_startmarker,_BarricadeText], _TaskTitle, "Obstacle"],_TaskPosition,"CREATED",-1, false,"container", false] call BIS_fnc_taskCreate;

	{
		_RandomSecondaryTaskId = _TaskMain + format["_SubTask_%1",round(random 9999)];
		[true, [_RandomSecondaryTaskId, _TaskMain], ["This obstacle needs to be destroyed to complete the parent task.", "Destroy Barricade", "Obstacle"], nil,"CREATED",-1, false,"destroy", false] call BIS_fnc_taskCreate;

		[_X, _RandomSecondaryTaskId] spawn {
			params ["_Barricade","_RandomSecondaryTaskId"];
			waitUntil {sleep 4; !Alive _Barricade || getDammage _Barricade > 0.8};
		
			[_RandomSecondaryTaskId,"SUCCEEDED"] call BIS_fnc_taskSetState;
		};
	} foreach _Barricades;

	if(_ShouldAddActionToDestroy && count _Barricades == 1) then {
		_Barricade = _Barricades select 0;
		[_Barricade] remoteExec ["OKS_fnc_Destroy_Barricade_Action", 0];
	};

	waitUntil {sleep 10; {_X call BIS_fnc_taskCompleted} count (_TaskMain call BIS_fnc_taskChildren) == count (_TaskMain call BIS_fnc_taskChildren)};
	[_TaskMain,"SUCCEEDED"] call BIS_fnc_taskSetState;


