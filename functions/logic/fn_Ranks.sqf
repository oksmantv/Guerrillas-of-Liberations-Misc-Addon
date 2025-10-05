private ["_ltd","_sgt","_uid","_cpl","_rank"];

_ltd = "LIEUTENANT";
_sgt = "SERGEANT";
_cpl = "CORPORAL";

_uid = getPlayerUID (player);

switch _uid do {
    case "76561198013929549": {_rank = _ltd}; // Oksman
    case "76561198086056020": {_rank = _ltd}; // Blu.
    case "76561199681025229": {_rank = _sgt}; // Rutters
    case "76561198005972885": {_rank = _cpl}; // Pilgrim
    case "76561198014971848": {_rank = _cpl}; // Filth
    case "76561198091519166": {_rank = _cpl}; // Juan Sanchez
    case "76561198058521961": {_rank = _cpl}; // Joona
    case "76561198210159148": {_rank = _cpl}; // Eric
    case "76561198073683939": {_rank = _cpl}; // Skeliton
    case "76561198082242266": {_rank = _cpl}; // Versed
    default {_rank ="PRIVATE"};
};

(player) setrank _rank;
