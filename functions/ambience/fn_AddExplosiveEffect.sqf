/*
	Add Explosive Effect Module Function

	File: fn_AddExplosiveEffect.sqf
	Author: Oksman

	Description: Spawns a large explosion on the position.

	Example:
	[getPos player,"Bo_GBU12_LGB", 1] spawn OKS_fnc_AddExplosiveEffect;

	Parameter 1: Position - Position of the module
	Parameter 2: Classname - Explosive class name (default: Bo_GBU12_LGB)
		Examples: 
	Parameter 3: Explosive Count - Number of explosives to spawn (default: 1)
	Parameter 4: (Optional) Destroy NearestBuilding (default: false)
*/

Params [
	"_Position",
	["_CustomExplosiveClass", "Bo_GBU12_LGB", [""]],
	["_ExplosiveCount", 1, [0]],
	["_DestroyNearestBuilding", false, [false]],
	["_BuildingClassname","Land_Tenement_01",[""]]
];
 
private _debug = missionNamespace getVariable ["GOL_Ambience_Debug", false];
if(_debug) then {
	format["[EXPLOSIVES] Called with Position: %1, Classname: %2, Count: %3", _Position, _CustomExplosiveClass, _ExplosiveCount] spawn OKS_fnc_LogDebug;
};

for "_i" from 1 to _ExplosiveCount do {
	_RandomPosition = _Position getPos [5, random 360];
	private _explosive = createVehicle [_CustomExplosiveClass, _RandomPosition, [], 0, "CAN_COLLIDE"];
	_explosive setPosATL _RandomPosition;
	_explosive setVelocity [0,0,0];
	_explosive setDamage 1;
	if(_debug) then {
		format["[EXPLOSIVES] Spawned explosive %1 at position %2", _CustomExplosiveClass, _Position] spawn OKS_fnc_LogDebug;
	};
	sleep 0.25;
};
if (_DestroyNearestBuilding) then {
	private _nearestBuildings = (nearestObjects [_Position, ["House"], 35]) select {typeOf _X == _BuildingClassname};
	_nearestBuilding = selectRandom _nearestBuildings;
	if (!isNull _nearestBuilding) then {
		// Kill units inside building before destroying it
		private _buildingPositions = _nearestBuilding buildingPos -1;
		if (count _buildingPositions > 0) then {
			// Get average position of building
			private _buildingCenter = getPosATL _nearestBuilding;
			// Find units near the building (use boundingBox for more accuracy)
			private _boundingBox = boundingBoxReal _nearestBuilding;
			private _maxDistance = ((_boundingBox select 1) distance (_boundingBox select 0)) / 2;
			
			// Find all units within the building's area
			private _nearUnits = _buildingCenter nearEntities [["Land"], _maxDistance + 5];
			{
				// Check if unit is actually inside (Z coordinate within building height)
				private _unitPos = getPosATL _x;
				private _heightCheck = (_unitPos select 2) < ((_buildingCenter select 2) + 20); // Adjust 20 as needed
				if (_heightCheck && !isPlayer _x) then {
					_x setDamage 1;
					if(_debug) then {
						format["[EXPLOSIVES] Killed unit %1 inside building", _x] spawn OKS_fnc_LogDebug;
					};
				};
			} forEach _nearUnits;
		};
		
		_nearestBuilding setDamage 1;
		if(_debug) then {
			format["[EXPLOSIVES] Destroyed nearest building %1 at position %2", _nearestBuilding, getPosATL _nearestBuilding] spawn OKS_fnc_LogDebug;
		};
	} else {
		if(_debug) then {
			format["[EXPLOSIVES] No building found near position %1 to destroy", _Position] spawn OKS_fnc_LogDebug;
		};
	};
};

