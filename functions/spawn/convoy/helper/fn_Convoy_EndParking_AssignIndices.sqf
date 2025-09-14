/*
  OKS_fnc_Convoy_EndParking_AssignIndices
  Assigns final parking slot indices at destination:
    - Vehicles that kept up keep their original primary slots.
    - Vehicles that fell behind get reserve tail slots.

  Params:
    0: OBJECT - lead vehicle
    1: NUMBER - primarySlots (N), usually original convoy size (or desired front-row count)
    2: NUMBER - reserveSlots (R), how many tail reserve positions to provide
    3: ARRAY<OBJECT> (optional) - vehicle order to consider (defaults to current OKS_Convoy_VehicleArray)

  Returns:
    ARRAY of [veh, assignedIndex, isReserve] where assignedIndex is 0..(N+R-1)
*/
params ["_leadVeh", "_primarySlots", "_reserveSlots", ["_flowArr", []]];
if (isNull _leadVeh) exitWith { [] };
private _arr = if (_flowArr isEqualTo []) then { _leadVeh getVariable ["OKS_Convoy_VehicleArray", []] } else { _flowArr };

private _N = _primarySlots max 0;
private _R = _reserveSlots max 0;

// Build occupancy trackers
private _primaryFree = []; _primaryFree resize _N; _primaryFree = _primaryFree apply { true };
private _reserveNext = 0;

private _results = [];

// First pass: assign keep-up vehicles to their intended primary slots
{
  private _veh = _x;
  if (isNull _veh) then { continue };

  private _intended = _veh getVariable ["OKS_Convoy_IntendedSlot", _forEachIndex];
  private _curIdx   = _arr find _veh;

  // Fell behind if current flow position is after intended
  private _fellBehind = (_curIdx > _intended);

  if (!_fellBehind && {_intended < _N} && {_primaryFree select _intended}) then {
    // Assign intended primary slot directly
    _primaryFree set [_intended, false];
    _results pushBack [_veh, _intended, false];
  } else {
    // Defer: will go to reserve (or next primary if needed) in second pass
    _results pushBack [_veh, -1, _fellBehind];
  };
} forEach _arr;

// Second pass: fill unassigned
{
  _x params ["_veh", "_idx", "_fellBehind"];
  if (_idx >= 0) then { continue };

  if (_fellBehind && {_reserveNext < _R}) then {
    private _assigned = _N + _reserveNext;
    _reserveNext = _reserveNext + 1;
    _results set [_forEachIndex, [_veh, _assigned, true]];
  } else {
    // Try any free primary
    private _p = _primaryFree findIf { _x };
    if (_p != -1) then {
      _primaryFree set [_p, false];
      _results set [_forEachIndex, [_veh, _p, false]];
    } else {
      // Overflow: no primary free; if reserve left use it, else clamp to last
      if (_reserveNext < _R) then {
        private _assigned2 = _N + _reserveNext;
        _reserveNext = _reserveNext + 1;
        _results set [_forEachIndex, [_veh, _assigned2, true]];
      } else {
        // Safety clamp
        _results set [_forEachIndex, [_veh, (_N + _R - 1) max 0, true]];
      };
    };
  };
} forEach _results;

// Persist assigned index on vehicle for downstream parking code
{
  _x params ["_veh","_aIdx","_isRes"];
  _veh setVariable ["OKS_Convoy_EndParkIndex", _aIdx, true];
  _veh setVariable ["OKS_Convoy_EndParkIsReserve", _isRes, true];
} forEach _results;

_results
