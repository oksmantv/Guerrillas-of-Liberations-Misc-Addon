//	[Player] spawn OKS_fnc_MapClose;
//	
//	Clears 'map click' command if map is closed without selecting a drop position.
//	
//	Made by NeKo-ArroW

WaitUntil {Sleep 0.25; !visibleMap};

Player onMapSingleClick "";