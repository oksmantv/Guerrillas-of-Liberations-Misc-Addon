Params ["_Talker","_Channel","_Message",["_Callsign","",[""]]];
/* 
 Local Execution - Requires to be run on all Clients (Globally) to show everyone a message.
   
 Parameters:
 _Talker = Entity (Person) or String (Custom Callsign)
 _Channel = "side" or "local" defaults to "side". "Side" is a radio message, and must be sent by the same side as the player to be visible (Cannot be captive).
            "local" can be sent by any entity however cannot be sent by Preset callsigns. Local range is 20m, Radio range is 1000m.
 
 ["HQ","side","Test"] spawn OKS_fnc_Chat; - Has to be executed globally, for example using a trigger.
 [person1,"local","Hello World!"] remoteExec ["OKS_fnc_Chat",0]; - Has to be executed server/1 client ONLY, for example using a trigger with "Server Only".
*/ 

if(!HasInterface) exitWith {false};

Private _Code = {};
Private ["_Range","_Color","_SideCode","_LocalCode"];

true remoteExec ["showChat",0];

_SideCode = {
	Params ["_Talker","_Message","_Range","_Callsign","_Color"];
	
	// Preset callsigns (strings) bypass range check for off-map messages
	private _isPresetCallsign = _Talker isEqualType "";
	private _inRange = true;
	
	if (!_isPresetCallsign) then {
		_inRange = (player distance _Talker) < _Range;
	};
	
	if(_inRange) then {
		// Only set lip animation for actual entities
		if (!_isPresetCallsign) then {
			_Talker setRandomLip true;
		};
		
		if(!isNil "_Callsign" && _Callsign != "") then {
			if (!_isPresetCallsign) then {
				_Talker setGroupId [_Callsign];
				(Group _Talker) setGroupId [_Callsign];
			};
		} else {
			if (_isPresetCallsign) then {
				_Callsign = _Talker; // Use the string itself as callsign
			} else {
				_Callsign = "HQ";
			};
		};

		titleText [
			"<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>"+
			format["<t shadow='2' align='left' size='1.6' color='#%1' font='PuristaSemibold'>%2</t><br/>", _Color, _Callsign]+
			"<t shadow='2' align='left' size='1.3'  font='PuristaSemibold'>"+
			toUpper _Message+
			"<t/>",
			"PLAIN",
			1,
			false,
			true
		];

		sleep 10;
		if (!_isPresetCallsign) then {
			_Talker setRandomLip false;
		};
	};
};

_LocalCode = {
	Params ["_Talker","_Message","_Range","_Callsign","_Color"];

	if(_Callsign == "") then {
		_Callsign = name _Talker;
	};

	if(player distance _Talker < _Range) then {
		_Talker setRandomLip true;
		titleText [
			"<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>"+
			format["<t shadow='2' align='left' size='1.6' color='#%1' font='PuristaSemibold'>%2</t><br/>", _Color, _Callsign]+
			"<t shadow='2' align='left' size='1.3' font='PuristaSemibold'>"+
			toUpper _Message+
			"<t/>",
			"PLAIN",
			1,
			false,
			true
		];
	};

	sleep 10;
	_Talker setRandomLip false;
};

Switch (toLower _Channel) do {

	case "side": {
		_Range = 5000;
		_Code = _SideCode;
	};

	case "local": {
		if (_Talker isEqualType "") exitWith {
			[format ["[CHAT] Error: Local channel cannot use preset callsign '%1'. Local messages require an actual entity (object).", _Talker], true] call OKS_fnc_LogDebug;
			false
		};
		
		_Range = 20;
		_Code = _LocalCode;
	};

	default {
		systemChat "[CHAT] Invalid Channel specified, defaulting to 'side' channel.";
		_Range = 5000;
		_Code = _SideCode;	
	}
};

_Color = switch (side player) do {
	case west: { "0D64EC"};
	case east: { "AD2707" };
	case independent: { "06B42E"};
	default { "0D64EC" };
};

[_Talker,_Message,_Range,_Callsign,_Color] spawn _Code;
player createDiaryRecord ["Diary", ["Radio Messages", format["<br/>From: <font color='#%3' size='14'>%1</font><br/>Message: %2<br/>============",_Callsign,_Message,_Color]]];
