/* 

[this,
	[
		"uk3cb_baf_vehicles\addons\uk3cb_baf_vehicles_warrior_a3\data\apc_tracked_03_ext_baf_co.paa",
		"uk3cb_baf_vehicles\addons\uk3cb_baf_vehicles_warrior_a3\data\apc_tracked_03_ext2_baf_co.paa",
		"uk3cb_baf_vehicles\addons\uk3cb_baf_vehicles_warrior_a3\data\camonet_baf_co.paa",
		"uk3cb_baf_vehicles\addons\uk3cb_baf_vehicles_warrior_a3\data\cage_baf_co.paa"
	]
] spawn OKS_fnc_Retexture;

Find Retexture array using this example (Will be in clipboard) replace the array in the example above with the one you want to use:
copyToClipboard str (cursorObject getVariable ["hiddenSelectionsTextures", getObjectTextures cursorObject]);

*/

if(!isServer) exitWith {};

Params
[
	["_Vehicle", ObjNull, [ObjNull]],
	["_TextureArray",[],[[]]]
];

for "_i" from 0 to (count _TextureArray - 1) do {
	_Vehicle setObjectTextureGlobal [_i,_TextureArray select _i];
};


