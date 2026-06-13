/*
 Global wrapper for OKS_fnc_Chat.
 Handles remoteExec internally so you can call it directly:
  ["HQ","side","Test"] spawn OKS_fnc_ChatGlobal;
  ["HQ","side","Test","",25000,20,west] spawn OKS_fnc_ChatGlobal;

 Must be executed on ONE machine only (server or a single client).

 Parameters: Same as OKS_fnc_Chat
   _Talker   - Entity (Person) or String (Custom Callsign)
   _Channel  - "side" or "local" (defaults to "side")
   _Message  - String message to display
   _Callsign - (Optional) Custom callsign override
   _TargetSide - (Optional, last param) Side filter for recipients (west/east/independent/civilian)
*/

params [
  "_Talker",
  "_Channel",
  "_Message",
  ["_Callsign", "", [""]],
  ["_RadioRange", 25000, [0]],
  ["_LocalRange", 20, [0]],
  ["_TargetSide", sideUnknown]
];

// Always execute on all clients and let OKS_fnc_Chat enforce side filtering.
[_Talker, _Channel, _Message, _Callsign, _RadioRange, _LocalRange, _TargetSide] remoteExec ["OKS_fnc_Chat", 0];
