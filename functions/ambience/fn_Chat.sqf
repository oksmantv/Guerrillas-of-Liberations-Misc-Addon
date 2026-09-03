Params [
	"_Talker",
	"_Channel",
	"_Message",
	["_Callsign","",[""]],
	["_TargetSide", sideUnknown, [sideUnknown]],
	["_IconPath", "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\radio_ca.paa", [""]],
	["_ShowNotification", true, [true]]
];

private _RadioRange = missionNamespace getVariable ["GOL_Player_ChatRadioRange", 25000];
private _LocalRange = missionNamespace getVariable ["GOL_Player_ChatLocalRange", 20];
if !(_RadioRange isEqualType 0) then {_RadioRange = 25000};
if !(_LocalRange isEqualType 0) then {_LocalRange = 20};
_RadioRange = (_RadioRange max 100) min 100000;
_LocalRange = (_LocalRange max 1) min 250;
/* 
 Local Execution - Requires to be run on all Clients (Globally) to show everyone a message.
   
 Parameters:
 _Talker = Entity (Person) or String (Custom Callsign)
 _Channel = "side" or "local" defaults to "side". "Side" is a radio message, and must be sent by the same side as the player to be visible (Cannot be captive).
			"local" can be sent by any entity however cannot be sent by Preset callsigns. Local/radio ranges are controlled by addon options.
 _TargetSide = Optional side filter. If provided (west/east/independent/civilian), only players on that side will see the message.
 _IconPath = Optional icon path shown left of the callsign (e.g. \A3\ui_f\data\IGUI\Cfg\simpleTasks\types\radio_ca.paa).
 _ShowNotification = Optional bool. When false, skips the top-center "Received Message" notification.
 
 --["HQ","side","Test"] spawn OKS_fnc_Chat--; - DO NOT DO THIS! It sas to be executed globally, for example using a trigger.
   [person1,"local","Hello World!"] remoteExec ["OKS_fnc_Chat",0]; - Has to be executed server/1 client ONLY, for example using a trigger with "Server Only" or use the spawnlist.

   The global version which is exactly the same except you may use the spawn OKS_fnc_ChatGlobal;
*/ 

if(!HasInterface) exitWith {false};

if (!(_TargetSide isEqualTo sideUnknown) && {(side group player) != _TargetSide}) exitWith {false};

private _intelMessageMode = missionNamespace getVariable ["GOL_Player_IntelMessage_Setting", 2];
_intelMessageMode = (_intelMessageMode max 0) min 2;

Private _Code = {};
Private ["_Range","_Color","_SideCode","_LocalCode"];

private _ShowDiaryNotification = {
	params ["_NotificationClass", "_Callsign"];
	[_NotificationClass, [_Callsign]] call BIS_fnc_showNotification;
};

private _ShowStaticChat = {
	params ["_Color", "_Callsign", "_Message", "_DisplayDuration", "_TransitionDuration", "_IconPath", ["_TalkerSide", sideUnknown, [sideUnknown]]];
	// sideChat requires either an object or a [side, identity] pair - a bare string is invalid syntax.
	// _TalkerSide is passed in explicitly since this runs inside a spawned thread that does not
	// inherit the outer script's private variables.
	private _resolvedSide = if (_TalkerSide isEqualTo sideUnknown) then {side (group player)} else {_TalkerSide};
	[_resolvedSide, "HQ"] sideChat _Message;
};

private _ShowChatDynamic = {
	params ["_Color", "_Callsign", "_Message", "_DisplayDuration", "_TransitionDuration", "_IconPath"];
	private _resolvedIconPath = if (_IconPath == "") then {
		"\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\radio_ca.paa"
	} else {
		_IconPath
	};
	// Confirmed via debug-console test: backslash paths render fine in <img> tags. No slash conversion needed.
	private _iconImagePath = _resolvedIconPath;

	// ---- Debug-tunable layout knobs (missionNamespace variables, no rebuild needed) ----
	// Adjust live via debug console, e.g.: missionNamespace setVariable ["GOL_ChatIconSize", 1.6];
	// then rerun the test script. Defaults below match the confirmed-working single-box layout.
	private _xOffset         = missionNamespace getVariable ["GOL_ChatXOffset", 0.004];      // safeZoneW factor - left margin
	private _boxWidth        = missionNamespace getVariable ["GOL_ChatBoxWidth", 0.245];     // safeZoneW factor - message box width
	private _headerSize      = missionNamespace getVariable ["GOL_ChatHeaderSize", 0.63];    // <t size='X'> for the callsign line
	private _bodySize        = missionNamespace getVariable ["GOL_ChatBodySize", 0.51];      // <t size='X'> for the message line
	private _iconSize        = missionNamespace getVariable ["GOL_ChatIconSize", 1.1];       // <img size='X'/> - shares the same font-size unit as _headerSize/_bodySize
	private _paddingFactor   = missionNamespace getVariable ["GOL_ChatPadding", 0.016];      // safeZoneH factor - bottom padding under wrapped text
	private _charsPerLine    = missionNamespace getVariable ["GOL_ChatCharsPerLine", 62];    // estimated characters per wrapped line
	private _minHeightFactor = missionNamespace getVariable ["GOL_ChatMinHeight", 0.075];    // safeZoneH factor - floor for message box height
	private _maxHeightFactor = missionNamespace getVariable ["GOL_ChatMaxHeight", 0.30];     // safeZoneH factor - ceiling for message box height
	private _baseYFactor     = missionNamespace getVariable ["GOL_ChatBaseY", 0.445];        // safeZoneH factor - vertical start of the message stack
	private _slotGapFactor   = missionNamespace getVariable ["GOL_ChatSlotGap", 0.014];      // safeZoneH factor - gap between stacked messages
	private _slotHoldExtra   = missionNamespace getVariable ["GOL_ChatSlotHoldExtra", 1.0];  // seconds - extra time a slot stays reserved after fade-out
	private _iconHeightMult  = missionNamespace getVariable ["GOL_ChatIconHeightMult", 1.0]; // safety multiplier on the derived icon height
	private _lineHeightMult  = missionNamespace getVariable ["GOL_ChatLineHeightMult", 1.0]; // safety multiplier on the derived body line height

	if !(_xOffset isEqualType 0) then {_xOffset = 0.004};
	if !(_boxWidth isEqualType 0) then {_boxWidth = 0.245};
	if !(_headerSize isEqualType 0) then {_headerSize = 0.63};
	if !(_bodySize isEqualType 0) then {_bodySize = 0.51};
	if !(_iconSize isEqualType 0) then {_iconSize = 1.1};
	if !(_paddingFactor isEqualType 0) then {_paddingFactor = 0.016};
	if !(_charsPerLine isEqualType 0) then {_charsPerLine = 62};
	if !(_minHeightFactor isEqualType 0) then {_minHeightFactor = 0.075};
	if !(_maxHeightFactor isEqualType 0) then {_maxHeightFactor = 0.30};
	if !(_baseYFactor isEqualType 0) then {_baseYFactor = 0.445};
	if !(_slotGapFactor isEqualType 0) then {_slotGapFactor = 0.014};
	if !(_slotHoldExtra isEqualType 0) then {_slotHoldExtra = 1.0};
	if !(_iconHeightMult isEqualType 0) then {_iconHeightMult = 1.0};
	if !(_lineHeightMult isEqualType 0) then {_lineHeightMult = 1.0};

	_xOffset = (_xOffset max 0) min 0.05;
	_boxWidth = (_boxWidth max 0.05) min 0.6;
	_headerSize = (_headerSize max 0.1) min 2;
	_bodySize = (_bodySize max 0.1) min 2;
	_iconSize = (_iconSize max 0.1) min 4;
	_paddingFactor = (_paddingFactor max 0) min 0.05;
	_charsPerLine = (_charsPerLine max 10) min 200;
	_minHeightFactor = (_minHeightFactor max 0.01) min 0.5;
	_maxHeightFactor = (_maxHeightFactor max 0.05) min 0.8;
	_baseYFactor = (_baseYFactor max 0) min 1;
	_slotGapFactor = (_slotGapFactor max 0) min 0.1;
	_slotHoldExtra = (_slotHoldExtra max 0) min 10;
	_iconHeightMult = (_iconHeightMult max 0.1) min 5;
	_lineHeightMult = (_lineHeightMult max 0.1) min 5;

	// SIMPLIFIED LAYOUT: confirmed via debug-console testing that Structured Text floats the icon
	// and header text on the SAME line (the image does not need its own box/layer at all) - so the
	// icon is now a sibling inside ONE combined string, rendered by a SINGLE dynamicText call. This
	// removes the entire second-layer/second-box bookkeeping (separate icon position, icon layer
	// rotation, icon Y offset, row-height reconciliation) that caused most of the earlier bugs.
	// valign='middle' vertically centers the (shorter) header text against the (taller) icon on
	// their shared line; the leading space before the callsign text is a small breathing gap
	// between the icon and the callsign text (confirmed working via debug-console testing).
	// NOTE: 'bgcolor' is NOT a real Structured Text attribute (confirmed against the official BIS
	// wiki attribute list) - it was silently ignored the whole time and has been removed. A visible
	// background panel requires an actual second UI control (colorBackground), not markup - see Tier 2.
	private _chatText = format [
		"<img image='%1' size='%2' align='left' valign='middle' shadow='2'/><t shadow='2' align='left' valign='middle' size='%3' color='#%4' font='PuristaSemibold'> %5</t><br/><t shadow='2' align='left' size='%6' color='#FFFFFF' font='PuristaSemibold'>%7</t>",
		_iconImagePath,
		_iconSize,
		_headerSize,
		_Color,
		_Callsign,
		_bodySize,
		toUpper _Message
	];
	// Measurement-only string: just the (unwrapped, single-line) header, no icon - ctrlTextHeight
	// reliably measures single-line text but not an isolated <img>, so the icon's height is derived
	// from this measurement by ratio instead (see _iconHeight below).
	private _headerOnlyText = format [
		"<t shadow='2' align='left' size='%1' color='#%2' font='PuristaSemibold'> %3</t>",
		_headerSize,
		_Color,
		_Callsign
	];

	// Single-layer fade pipeline for reliability: no slide handoff, no cross-layer replacement.
	private _dynamicLayer = player getVariable ["OKS_ChatDynamicLayer", 935];
	player setVariable ["OKS_ChatDynamicLayer", if (_dynamicLayer >= 946) then {935} else {_dynamicLayer + 1}];

	private _fadeIn = missionNamespace getVariable ["GOL_ChatFadeIn", 0.20];
	private _fadeOut = missionNamespace getVariable ["GOL_ChatFadeOut", 1.25];
	private _holdExtra = missionNamespace getVariable ["GOL_ChatHoldExtra", 1.4];

	if !(_fadeIn isEqualType 0) then {_fadeIn = 0.20};
	if !(_fadeOut isEqualType 0) then {_fadeOut = 1.25};
	if !(_holdExtra isEqualType 0) then {_holdExtra = 1.4};
	_fadeIn = (_fadeIn max 0) min 2;
	_fadeOut = (_fadeOut max 0.2) min 4;
	_holdExtra = (_holdExtra max 0) min 8;

	private _viewportLeft = safeZoneX + (safeZoneW * _xOffset);
	private _xLeft = _viewportLeft;
	private _xWidth = safeZoneW * _boxWidth;

	// Header, body and icon all share ONE underlying font-size unit: RscStructuredText's config
	// "size" is GUI_TEXT_SIZE_MEDIUM (baseControls.hpp), and a <t size='X'> or <img size='X'/> both
	// render at X * GUI_TEXT_SIZE_MEDIUM. Font/image HEIGHT is a font-metric property - identical no
	// matter which control instance renders it (this is different from word-WRAP point, which DOES
	// differ between control types and is why the body text below still uses a char-count estimate,
	// not a measurement). So: measure ONLY the single-line header (100% reliable, nothing to wrap),
	// then derive the body per-line height and the icon height from it by simple ratio - zero
	// guessing, and zero dependence on measuring an <img> tag directly (ctrlTextHeight does not
	// reliably report a height for structured text containing ONLY an image with no sibling <t>).
	private _measureCtrl = (call BIS_fnc_displayMission) ctrlCreate ["RscStructuredText", -1];
	_measureCtrl ctrlSetPosition [_xLeft, 0, _xWidth, 0];
	_measureCtrl ctrlCommit 0;
	_measureCtrl ctrlSetStructuredText parseText _headerOnlyText;
	_measureCtrl ctrlCommit 0;
	private _headerHeight = (ctrlTextHeight _measureCtrl) max (safeZoneH * 0.025);
	ctrlDelete _measureCtrl;

	private _lineHeight = _headerHeight * (_bodySize / _headerSize) * _lineHeightMult;
	private _iconHeight = _headerHeight * (_iconSize / _headerSize) * _iconHeightMult;

	// The icon and header text share the FIRST row (image floats left, text centered beside it via
	// valign='middle'), so that row's real height is whichever of the two is taller - usually the icon.
	private _topRowHeight = _headerHeight max _iconHeight;

	// Dynamic per-message sizing: at a FIXED font size and FIXED box width, chars-per-line is a
	// fixed constant, not something that needs runtime measurement. Calibrated from real in-game
	// wraps (55-63 chars/line observed at size='0.51' in a safeZoneW*0.245 box); using the low end
	// of that range so the estimate rounds UP to an extra line rather than ever underestimating and clipping.
	private _padding = safeZoneH * _paddingFactor;
	private _lineCount = (ceil ((count (trim _Message)) / _charsPerLine)) max 1;
	private _controlHeight = (_topRowHeight + (_lineCount * _lineHeight) + _padding) max (safeZoneH * _minHeightFactor) min (safeZoneH * _maxHeightFactor);

	private _phaseDuration = ((_DisplayDuration + _holdExtra) max 3.5) + _fadeOut;
	private _slotGap = safeZoneH * _slotGapFactor;

	// Each slot stores [occupiedUntil, height] so stacking collapses when a slot finishes early.
	private _slotState = player getVariable ["OKS_ChatSlotState", [[0,0],[0,0],[0,0]]];
	if !(_slotState isEqualType []) then {_slotState = [[0,0],[0,0],[0,0]]};
	if ((count _slotState) != 3) then {_slotState = [[0,0],[0,0],[0,0]]};

	private _slot = -1;
	private _now = time;
	{
		if (_now >= (_x select 0)) exitWith {_slot = _forEachIndex;};
	} forEach _slotState;

	if (_slot < 0) then {
		private _nextFreeAt = 999999;
		{
			if ((_x select 0) < _nextFreeAt) then {_nextFreeAt = _x select 0;};
		} forEach _slotState;
		private _waitForSlot = (_nextFreeAt - _now) max 0;
		if (_waitForSlot > 0) then { sleep _waitForSlot; };
		_slot = -1;
		_now = time;
		{
			if (_now >= (_x select 0)) exitWith {_slot = _forEachIndex;};
		} forEach _slotState;
		if (_slot < 0) then {_slot = 0;};
	};

	// Stack offset collapses gaps left by slots that already finished, instead of a fixed 3-row grid.
	private _stackOffset = 0;
	for "_i" from 0 to (_slot - 1) do {
		private _entry = _slotState select _i;
		if (_now < (_entry select 0)) then {
			_stackOffset = _stackOffset + (_entry select 1) + _slotGap;
		};
	};

	private _updatedSlotState = +_slotState;
	_updatedSlotState set [_slot, [time + _phaseDuration + _slotHoldExtra, _controlHeight]];
	player setVariable ["OKS_ChatSlotState", _updatedSlotState];

	private _xPos = [_xLeft, _xWidth];
	private _targetYPos = safeZoneY + (safeZoneH * _baseYFactor) + _stackOffset;
	private _targetY = [_targetYPos, _controlHeight];
	[_chatText, _xPos, _targetY, _phaseDuration, _fadeIn, 0, _dynamicLayer] spawn BIS_fnc_dynamicText;

	sleep _phaseDuration;
};

private _GetDisplayDuration = {
	params ["_Message"];

	private _trimmed = trim _Message;
	private _charCount = count _trimmed;
	private _wordCount = if (_trimmed == "") then {0} else {(count (_trimmed splitString " `t`r`n")) max 1};

	// Tuned for concise radio flow: readable, but avoids long on-screen stalls.
	private _duration = 3.5 + (_wordCount * 0.30) + (_charCount * 0.006);
	_duration max 5 min 14
};

showChat true;

_SideCode = {
	Params ["_Talker","_Message","_Range","_Callsign","_Color","_DisplayDuration","_TransitionDuration","_ShowMessageFn","_IconPath",["_TalkerSide", sideUnknown, [sideUnknown]]];
	
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

		format["[CHAT] %1 (%2) - Hold: %3s Transition: %4s", _Callsign, _Talker, _DisplayDuration, _TransitionDuration] call OKS_fnc_LogDebug;
		[_Color, _Callsign, _Message, _DisplayDuration, _TransitionDuration, _IconPath, _TalkerSide] call _ShowMessageFn;
		if (!_isPresetCallsign) then {
			_Talker setRandomLip false;
		};
	};
};

_LocalCode = {
	Params ["_Talker","_Message","_Range","_Callsign","_Color","_DisplayDuration","_TransitionDuration","_ShowMessageFn","_IconPath",["_TalkerSide", sideUnknown, [sideUnknown]]];

	if(_Callsign == "") then {
		_Callsign = name _Talker;
	};

	if(player distance _Talker < _Range) then {
		_Talker setRandomLip true;
		[_Color, _Callsign, _Message, _DisplayDuration, _TransitionDuration, _IconPath, _TalkerSide] call _ShowMessageFn;
		_Talker setRandomLip false;
	};
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

private _talkerSide = if (_Talker isEqualType "") then {
	if (_TargetSide isEqualTo sideUnknown) then {side player} else {_TargetSide}
} else {
	side _Talker
};
_Color = switch (_talkerSide) do {
	case west: { "0D64EC"};
	case east: { "AD2707" };
	case independent: { "06B42E"};
	default { "0D64EC" };
};

private _notificationClass = switch (_talkerSide) do {
	case west: { "OKS_RadioMessage_West" };
	case east: { "OKS_RadioMessage_East" };
	case independent: { "OKS_RadioMessage_Independent" };
	default { "OKS_RadioMessage_West" };
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

private _displayDuration = [_Message] call _GetDisplayDuration;
private _transitionDuration = 1;
private _showMessageFn = switch (_intelMessageMode) do {
	case 0: {{}};
	case 1: {_ShowStaticChat};
	default {_ShowChatDynamic};
};

[_Talker,_Message,_Range,_Callsign,_Color,_displayDuration,_transitionDuration,_showMessageFn,_IconPath,_talkerSide] spawn _Code;
if (_ShowNotification) then {
	[_notificationClass, _diaryCallsign] call _ShowDiaryNotification;
};

private _diaryCategory = "Radio Messages";
// createDiaryRecord's <img> width/height are ABSOLUTE pixel-style units (per BIS wiki example:
// width='500' height='800' for a near-fullscreen image) - NOT the 0..1 safeZone-relative fraction
// used by ctrlSetPosition/RscStructuredText controls elsewhere in this script. A fractional value
// like 0.025 renders at effectively zero pixels, which is why no icon showed up at all.
private _diaryIconSize = missionNamespace getVariable ["GOL_ChatDiaryIconSize", 48];
if !(_diaryIconSize isEqualType 0) then {_diaryIconSize = 48};
_diaryIconSize = (_diaryIconSize max 8) min 256;
player createDiaryRecord ["Diary", 
[_diaryCategory, format["<img image='%4' width='%5' height='%5'/><br/>From: <font color='#%3' size='14'>%1</font><br/>Message: %2",_diaryCallsign,_Message,_Color,_IconPath,_diaryIconSize]]];
