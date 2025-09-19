
private _ClientId = "";

if (isDedicated) then {
    _ClientId = "D"
} else {
    if (!hasInterface && !isDedicated) then {
        _ClientId = "H"
    } else {
        if (hasInterface && isServer) then {
            _ClientId = "S"
        } else {
            _ClientId = "C"
        };
    };
};

_ClientId