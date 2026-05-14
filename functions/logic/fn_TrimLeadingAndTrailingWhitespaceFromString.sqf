/*
    [text] call OKS_fnc_TrimLeadingAndTrailingWhitespaceFromString;
    Returns: STRING with leading/trailing spaces, tabs and newlines removed.
*/
params [["_text", "", [""]]];

private _out = _text;
private _isWhitespace = {
    params ["_ch"];
    _ch in [" ", toString [9], toString [10], toString [13]]
};

while {(count _out) > 0 && {[(_out select [0, 1])] call _isWhitespace}} do {
    _out = _out select [1, (count _out) - 1];
};

while {(count _out) > 0 && {[(_out select [(count _out) - 1, 1])] call _isWhitespace}} do {
    _out = _out select [0, (count _out) - 1];
};

_out;