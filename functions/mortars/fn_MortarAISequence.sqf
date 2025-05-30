	Private ["_Mortar","_Unit","_Position","_Mag","_This"];
	
	systemChat "Firing Mortar.";

	_Mortar = (_This select 0);
	_Unit = (_This select 1);
	_Position = (_This select 2);
	_Mag = currentMagazine _Mortar;
	
	_Unit doWatch [(_Position select 0),(_Position select 1),((_Position select 2) + 1000)];
	_Mortar addMagazine _Mag;
	_Mortar Fire (CurrentWeapon _Mortar)