/*
	JCA SignalFlare Module Function

	File: fn_SignalFlare.sqf
	Author: Oksman

	Description: Spawns signal flares at the position of the module when activated by a trigger.

	Example: [getPos player, trigger1, "red", "signal"] call OKS_fnc_SignalFlare;
	Parameter 1: Position - Position of the module
	Parameter 2: Trigger - Trigger to deactivate the module (optional, if nil, permanent flares)
	Parameter 3: Colour - Colour of the signal flare (red, green) (default: red)
	Parameter 4: Type - Type of the signal flare (signal, handflare) (default: signal)
*/

Params [
	"_Position",
	["_Trigger", objNull, [objNull]],
	["_colour","red",[""]],
	["_type","signal",[""]]
];

if(!canSuspend) exitWith {
	systemChat "You must use spawn to use OKS_fnc_SignalFlare, not call.";
};
 
private _debug = missionNamespace getVariable ["GOL_SignalFlare_Debug", false];
if(_debug) then {
	format["[SIGNALFLARE] Called with Position: %1, Trigger: %2, Colour: %3, Type: %4", _Position, _Trigger, _colour, _Type] spawn OKS_fnc_LogDebug;
};

if(isNil "_Trigger") then {
	_Trigger = createTrigger ["EmptyDetector", _Position];
	_Trigger setTriggerArea [0, 0, 0, false];
	_Trigger setTriggerActivation ["LOGIC", "PRESENT", true];
	_Trigger setTriggerStatements ["this", "", ""];
	if(_debug) then {
		format["[SIGNALFLARE] Created new trigger at %1", _Position] spawn OKS_fnc_LogDebug;
	};
};


private _flareClass = "JCA_GrenadeAmmo_SignalFlare_Red";
private _moduleClass = "JCA_ModuleSignalFlare_F";
private _delay = 350;

switch (toLower _colour) do {
	case "red": {
		_flareClass = "JCA_GrenadeAmmo_SignalFlare_Red";
		if(_debug) then {"[SIGNALFLARE] Flare color set to RED" spawn OKS_fnc_LogDebug;};
	};
	case "green": {
		_flareClass = "JCA_GrenadeAmmo_SignalFlare_Green";
		if(_debug) then {"[SIGNALFLARE] Flare color set to GREEN" spawn OKS_fnc_LogDebug;};
	};
};

switch (toLower _Type) do {
	case "signal": {
		_moduleClass = "JCA_ModuleSignalFlare_F";
		_delay = 270;
		if(_debug) then {"[SIGNALFLARE] Flare type set to SIGNAL" spawn OKS_fnc_LogDebug;};
	};
	case "handflare": {
		_moduleClass = "JCA_GrenadeAmmo_HandFlare";
		_delay = 280;
		if(_debug) then {"[SIGNALFLARE] Flare type set to HANDFLARE" spawn OKS_fnc_LogDebug;};
	};
};

while {!triggerActivated _Trigger} do {
	private _moduleGroup = createGroup sideLogic;
	private _signalFlare = _moduleClass createUnit [
		_Position,
		_moduleGroup,
		format["this setVariable ['BIS_fnc_initModules_disableAutoActivation',false, true]; this setVariable ['Type','%1', true]", _flareClass]
	];
	if(_debug) then {
		format["[SIGNALFLARE] Spawned flare of class %1 at %2", _moduleClass, _Position] spawn OKS_fnc_LogDebug;
	};
	sleep _delay;
	deleteGroup _moduleGroup;
};