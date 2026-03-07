/*
 * Toggle Konkurs/Metis ATGM launcher on GOL_BMP2DM.
 * Uses konkurs_hide_source for instant show/hide.
 * Removes ATGM magazines when stowed, restores with 3s delay when deployed.
 *
 * Arguments:
 *   0: Vehicle <OBJECT>
 *   1: Deploy (true) or Stow (false) <BOOL>
 *
 * Called from ACE self-interaction on commander seat.
 */

params ["_vehicle", "_deploy"];

private _turretPath = [0];
private _atgmMag = "rhs_mag_9m113M";

if (_deploy) then {
	// --- Deploy: reveal launcher FIRST (empty), then reload with animation ---
	_vehicle setVariable ["GOL_ATGM_Deployed", true, true];
	_vehicle animate ["konkurs_hide_source", 0];

	[_vehicle, _turretPath, _atgmMag] spawn {
		params ["_vehicle", "_turretPath", "_atgmMag"];

		// Let the deploy animation play out so the launcher is visible
		sleep 1;

		// Safety: abort if stowed again during deploy animation
		if !(_vehicle getVariable ["GOL_ATGM_Deployed", false]) exitWith {};
		if !("rhs_weap_9m113" in (_vehicle weaponsTurret _turretPath)) exitWith {};

		private _stored = _vehicle getVariable ["GOL_ATGM_StoredMags", [1]];

		// Restore stored magazines
		{
			_vehicle addMagazineTurret [_atgmMag, _turretPath, _x];
		} forEach _stored;
		_vehicle setVariable ["GOL_ATGM_StoredMags", nil, true];

		// Wait until the engine has registered the magazines in inventory.
		// addMagazineTurret can take multiple frames to propagate; a fixed
		// sleep is unreliable (works in debug because of human delay).
		private _timeout = diag_tickTime + 5;
		waitUntil {
			sleep 0.1;
			private _magsAvail = {_x == _atgmMag} count (_vehicle magazinesTurret _turretPath);
			(_magsAvail >= (count _stored - 1)) || {diag_tickTime > _timeout}
		};

		// Safety: abort if stowed while waiting
		if !(_vehicle getVariable ["GOL_ATGM_Deployed", false]) exitWith {};

		// Force reload — triggers the visible missile-loading animation.
		// If only 1 magazine was stored (already auto-chambered, no spare),
		// loadMagazine has nothing to swap in, so the missile is still ready.
		_vehicle loadMagazine [_turretPath, "rhs_weap_9m113", _atgmMag];

		// Fallback: if loadMagazine didn't trigger (edge cases), try once
		// more after a short wait to let the engine settle.
		sleep 1;
		if !(_vehicle getVariable ["GOL_ATGM_Deployed", false]) exitWith {};
		private _currentMag = _vehicle currentMagazineTurret _turretPath;
		if (_currentMag == "") then {
			_vehicle loadMagazine [_turretPath, "rhs_weap_9m113", _atgmMag];
		};
	};
} else {
	// --- Stow: save ammo (including loaded round), hide launcher ---
	// magazinesTurret does NOT include the currently loaded magazine.
	// Use magazinesAllTurrets to capture everything including partial ammo.
	private _allMags = magazinesAllTurrets _vehicle;
	private _stored = [];
	{
		_x params ["_mag", "_tPath", "_ammoCount"];
		if (_mag == _atgmMag && {_tPath isEqualTo _turretPath}) then {
			_stored pushBack _ammoCount;
		};
	} forEach _allMags;

	_vehicle setVariable ["GOL_ATGM_StoredMags", _stored, true];

	// Remove all ATGM magazines (including loaded one)
	{
		_vehicle removeMagazineTurret [_atgmMag, _turretPath];
	} forEach _stored;

	_vehicle animate ["konkurs_hide_source", 1];
	_vehicle setVariable ["GOL_ATGM_Deployed", false, true];
	systemChat "ATGM Stowed";
};
