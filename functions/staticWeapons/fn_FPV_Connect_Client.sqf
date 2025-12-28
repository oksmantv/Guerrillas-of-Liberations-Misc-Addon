/*
    Client-side helper: connect local player to a newly spawned FPV UAV.

    Params:
      0: UAV <OBJECT>
*/

params ["_uav"];

if (!hasInterface) exitWith {};
if (isNull _uav) exitWith {};

private _uavTerminalClass = ["B_UavTerminal", "O_UavTerminal", "I_UavTerminal", "C_UavTerminal", "I_E_UavTerminal"];
private _hasUAVTerminal = {
    if (_x in assignedItems player) exitWith { true };
    false
} forEach _uavTerminalClass;

if (_hasUAVTerminal && currentWeapon player == "") then {
    player connectTerminalToUAV _uav;
    driver _uav switchCamera "Internal";
    player remoteControl _uav;
};
