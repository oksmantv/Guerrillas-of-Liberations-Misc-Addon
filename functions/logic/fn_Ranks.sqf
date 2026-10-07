private ["_ltd","_sgt","_uid","_cpl","_rank"];

_ltd = "LIEUTENANT";
_sgt = "SERGEANT";
_cpl = "CORPORAL";

_uid = getPlayerUID (player);

switch _uid do {
    case "76561198013929549": {_rank = _ltd}; // Oksman
    case "76561198086056020": {_rank = _ltd}; // Blu.
    case "76561198082242266": {_rank = _sgt}; // Versed
    case "76561198014971848": {_rank = _cpl}; // Filth
    case "76561198210159148": {_rank = _cpl}; // Eric
    case "76561198157996716": {_rank = _cpl}; // Nordzs
    case "76561198355978081": {_rank = _cpl}; // Smith
    default {_rank ="PRIVATE"};
};

(player) setrank _rank;
