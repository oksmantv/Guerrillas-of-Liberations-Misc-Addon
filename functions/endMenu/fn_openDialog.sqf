// Open the dialog (the name must match your dialog class in endMenu_dialog.hpp)
createDialog "MyEndMissionDialog";

// Now populate the listbox with player data (example IDC: 1500)
private _display = findDisplay 1234; // 1234 = your dialog's idd
if (!isNull _display) then {
    private _listbox = _display displayCtrl 1500; // 1500 = your listbox's idc
    lbClear _listbox;
    {
        private _score = _x getVariable ["score", 0];
        _listbox lbAdd format ["%1 - Kills: %2", name _x, _score];
    } forEach allPlayers;
};

// Optionally, disable damage and weapons (example)
{
    _x allowDamage false;
} forEach allPlayers;
