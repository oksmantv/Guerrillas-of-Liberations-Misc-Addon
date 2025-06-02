
private _ClientId = "";

if (isDedicated) then {
    _ClientId = "DEDICATED"
} else {
    if (!hasInterface && !isDedicated) then {
        _ClientId = "HC"
    } else {
        if (hasInterface && isServer) then {
            _ClientId = "SERVER"
        } else {
            _ClientId = "CLIENT"
        };
    };
};

_ClientId