/*
	[_aircraft, _player] spawn OKS_fnc_StaticJump_Action;
*/

Params ["_aircraft","_player"];

_Debug = missionNamespace getVariable ["GOL_Paradrop_Debug",false];
if(_Debug) then {
	format["[StaticLine] Static Jump Action Added to %1 for %2.",_aircraft,name _player] spawn OKS_fnc_LogDebug;
};

_StaticJumpActionId = _aircraft addAction [
	"<t color='#d12815' font='PuristaBold'>Static Line Jump</t><img image='\A3\ui_f\data\Map\VehicleIcons\iconParachute_ca.paa'/>", 									  			   // Title
	{ 
		params ["_target", "_caller", "_actionId", "_arguments"];
		_Debug = missionNamespace getVariable ["GOL_Paradrop_Debug",false];
		if(_Debug) then {
			format["[StaticLine] Static Line Jump Action used.", _target, name _caller] spawn OKS_fnc_LogDebug;
		};		
		[_target, _caller, false] spawn OKS_fnc_StaticJump_Code;  			   // Statement
	}, 
	[],	  													  	  			   // Arguments
	6,    														  			   // Priority
	true, 														  			   // ShowWindow
	true, 														  			   // Hide On Use
	"Action",															  	   // Keybind
	"_target getcargoindex player != -1 && (getPosATL _target) select 2 > 100" // Condition
];
_player setVariable ["GOL_StaticJumpAction",_StaticJumpActionId,true];