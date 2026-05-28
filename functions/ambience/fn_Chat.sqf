Params [
	"_Talker",
	"_Channel",
	"_Message",
	["_Callsign","",[""]],
	["_RadioRange", 25000, [0]],
	["_LocalRange", 20, [0]]];
/* 
 Local Execution - Requires to be run on all Clients (Globally) to show everyone a message.
   
 Parameters:
 _Talker = Entity (Person) or String (Custom Callsign)
 _Channel = "side" or "local" defaults to "side". "Side" is a radio message, and must be sent by the same side as the player to be visible (Cannot be captive).
            "local" can be sent by any entity however cannot be sent by Preset callsigns. Local range is 20m, Radio range is 25000m.
 
 --["HQ","side","Test"] spawn OKS_fnc_Chat--; - DO NOT DO THIS! It sas to be executed globally, for example using a trigger.
   [person1,"local","Hello World!"] remoteExec ["OKS_fnc_Chat",0]; - Has to be executed server/1 client ONLY, for example using a trigger with "Server Only" or use the spawnlist.

   The global version which is exactly the same except you may use the spawn OKS_fnc_ChatGlobal;
*/ 

if(!HasInterface) exitWith {false};

Private _Code = {};
Private ["_Range","_Color","_SideCode","_LocalCode"];

showChat true;

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
			"</t>",
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
			"</t>",
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
		_Code = _SideCode;
		_Range = _RadioRange;
	};

	case "local": {
		if (_Talker isEqualType "") exitWith {
			[format ["[CHAT] Error: Local channel cannot use preset callsign '%1'. Local messages require an actual entity (object).", _Talker], true] call OKS_fnc_LogDebug;
			false
		};
		_Range = _LocalRange;
		_Code = _LocalCode;
	};

	default {
		systemChat "[CHAT] Invalid Channel specified, defaulting to 'side' channel.";
		_Code = _SideCode;	
		_Range = _RadioRange;
	}
};

private _talkerSide = if (_Talker isEqualType "") then {side player} else {side _Talker};
_Color = switch (_talkerSide) do {
	case west: { "0D64EC"};
	case east: { "AD2707" };
	case independent: { "06B42E"};
	default { "0D64EC" };
};

// Resolve display callsign before spawning so the diary gets the correct value
private _diaryCallsign = _Callsign;
if (_diaryCallsign == "") then {
	if (_Talker isEqualType "") then {
		_diaryCallsign = _Talker;
	} else {
		if (toLower _Channel == "local") then {
			_diaryCallsign = name _Talker;
		} else {
			_diaryCallsign = "HQ";
		};
	};
};

[_Talker,_Message,_Range,_Callsign,_Color] spawn _Code;
player createDiaryRecord ["Diary", ["Radio Messages", format["<br/>From: <font color='#%3' size='14'>%1</font><br/>Message: %2<br/>============",_diaryCallsign,_Message,_Color]]];
