/*
	Author: GOL Team
	Description:
	Displays the mission end-screen hint only while the local HUD is visible and
	the player is not using a camera interface.

	Arguments:
	0: Structured-text source <STRING>; an empty string clears the hint.

	Return Value:
	None
*/

params ["_hintText"];

if (!hasInterface) exitWith {};

missionNamespace setVariable ["OKS_MissionCompleteHintText", _hintText];

if (_hintText isEqualTo "") exitWith {
	hintSilent "";
	private _pfhId = missionNamespace getVariable ["OKS_MissionCompleteHintPFH", -1];
	if (_pfhId >= 0) then {
		[_pfhId] call CBA_fnc_removePerFrameHandler;
		missionNamespace setVariable ["OKS_MissionCompleteHintPFH", nil];
	};
};

if !(isNil {missionNamespace getVariable "OKS_MissionCompleteHintPFH"}) exitWith {};

private _pfhId = [{
	private _hintText = missionNamespace getVariable ["OKS_MissionCompleteHintText", ""];
	private _hudVisible = (shownHUD findIf {_x}) >= 0;
	private _cameraActive = !isNull findDisplay 314 || {!isNull findDisplay 312};

	if (_hintText isEqualTo "" || {!_hudVisible} || {_cameraActive}) exitWith {
		hintSilent "";
	};

	hintSilent (parseText _hintText);
}, 0.25] call CBA_fnc_addPerFrameHandler;

missionNamespace setVariable ["OKS_MissionCompleteHintPFH", _pfhId];