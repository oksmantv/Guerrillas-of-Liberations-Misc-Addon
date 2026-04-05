/*
 Global wrapper for OKS_fnc_Chat.
 Handles remoteExec internally so you can call it directly:
   ["HQ","side","Test"] spawn OKS_fnc_ChatGlobal;

 Must be executed on ONE machine only (server or a single client).

 Parameters: Same as OKS_fnc_Chat
   _Talker   - Entity (Person) or String (Custom Callsign)
   _Channel  - "side" or "local" (defaults to "side")
   _Message  - String message to display
   _Callsign - (Optional) Custom callsign override
*/

_this remoteExec ["OKS_fnc_Chat", 0];
