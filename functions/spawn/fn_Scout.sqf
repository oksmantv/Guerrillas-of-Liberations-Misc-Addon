/*
    Function: OKS_fnc_Scout

    Description:
        Backward-compatible wrapper that delegates directly to OKS_fnc_AirScout.
        All parameters are passed through unchanged. New missions should use
        OKS_fnc_AirScout directly. See OKS_fnc_AirScout for full parameter
        documentation and usage examples.

    Parameters:
        Same as OKS_fnc_AirScout (all params passed through via _this).

    Returns:
        Nothing

    Example:
        [getPos drone_1, getPos droneTarget_1, east, "rhs_pchela1t_vvs"] spawn OKS_fnc_Scout;
*/

	// Backward compatible wrapper. Prefer OKS_fnc_AirScout.
	if(HasInterface && !isServer) exitWith {};
	_this call OKS_fnc_AirScout;