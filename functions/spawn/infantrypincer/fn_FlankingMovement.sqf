Params ["_Group","_SpawnPosition","_SelectedPlayerTarget","_FlankAngle","_FlankingDistance"];

if(_FlankingDistance == -1) then {
	_FlankingDistance = ((_SelectedPlayerTarget distance _SpawnPosition) * 0.6);
};

//systemChat str _FlankingDistance;
_FlankPosition = _SelectedPlayerTarget getPos [_FlankingDistance,((_SelectedPlayerTarget getDir _SpawnPosition) + _FlankAngle)];
_FlankWP = _Group addWaypoint [_FlankPosition,5];
_FlankWP setWaypointType "MOVE";
_FlankTargetWP = _Group addWaypoint [getPos _SelectedPlayerTarget,5];
_FlankTargetWP setWaypointType "MOVE";

{
	[_X,_FlankPosition,_SelectedPlayerTarget,_Group] spawn {
		Params ["_Unit","_FlankPosition","_SelectedPlayerTarget","_Group"];
		
		_Unit disableAI "FSM"; _Unit enableAttack false; _Unit forceSpeed 10; _Unit disableAI "COVER";
		[_Unit, _FlankPosition] spawn lambs_wp_fnc_taskAssault;

		waitUntil {sleep 2; _Unit distance _FlankPosition < 20};

		if(!(_Group getVariable ["FlankingRushActive",false])) then {
			_Group setVariable ["FlankingRushActive",true,true];
		};
	};
} foreach units _Group;
waitUntil {sleep 5; _Group getVariable ["FlankingRushActive",false]};
[_Group,1000,10,[],[],false] remoteExec ["lambs_wp_fnc_taskRush",0];