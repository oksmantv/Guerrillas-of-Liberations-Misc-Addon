// Monitors lead vehicle for arrival at final waypoint, then assigns parking
params ["_leadVeh", "_endPos", "_primarySlots", "_reserveSlots"];
private _arrived = false;
while {!_arrived} do {
	sleep 2;
	if (isNull _leadVeh || {!alive _leadVeh}) exitWith {};
	if ((_leadVeh distance _endPos) < 20) then {
		_arrived = true;
		[_leadVeh, _endPos, _primarySlots, _reserveSlots] call OKS_fnc_Convoy_AssignParkingAtEnd;
	};
};