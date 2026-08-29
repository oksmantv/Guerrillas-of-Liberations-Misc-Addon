/*
 Global wrapper for OKS_fnc_Chat.
 Handles remoteExec internally so you can call it directly:
  ["HQ","side","Test"] spawn OKS_fnc_ChatGlobal;
  ["HQ","side","Test",west] spawn OKS_fnc_ChatGlobal;
  [person1,"side","Test","VIKING 1",west] spawn OKS_fnc_ChatGlobal;

 Must be executed on ONE machine only (server or a single client).

 Parameters:
   [Talker, Channel, Message, Callsign?, TargetSide?, IconPath?, ShowNotification?]
*/

params [
  "_Talker",
  "_Channel",
  "_Message",
  ["_Callsign", "", [""]],
  ["_TargetSide", sideUnknown],
  ["_IconPath", "\\A3\\ui_f\\data\\IGUI\\Cfg\\simpleTasks\\types\\radio_ca.paa", [""]],
  ["_ShowNotification", true, [true]]
];

// Always execute on all clients and let OKS_fnc_Chat enforce side filtering.
[_Talker, _Channel, _Message, _Callsign, _TargetSide, _IconPath, _ShowNotification] remoteExec ["OKS_fnc_Chat", 0];
