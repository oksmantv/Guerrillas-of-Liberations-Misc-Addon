/*
    [] spawn OKS_fnc_FlagTeleport;
*/

if(!isNil "flag_west_1" && !isNil "flag_west_2") then {
    flag_west_1 AddAction ["Teleport to FARP",{(_this select 1) setPosATL getPosATL flag_west_2}];
    flag_west_1 setFlagTexture "\OKS_GOL_Misc\data\images\hellfish.jpg";

    flag_west_2 AddAction ["Teleport to Staging area",{(_this select 1) setPosATL getPosATL flag_west_1}]; 
    flag_west_2 setFlagTexture "\OKS_GOL_Misc\data\images\aac.jpg";
};

if(!isNil "flag_east_1" && !isNil "flag_east_2") then {
    flag_east_1 AddAction ["Teleport to FARP",{(_this select 1) setPosATL getPosATL flag_east_2}];
    flag_east_1 setFlagTexture "\OKS_GOL_Misc\data\images\hellfish.jpg";

    flag_east_2 AddAction ["Teleport to Staging area",{(_this select 1) setPosATL getPosATL flag_east_1}]; 
    flag_east_2 setFlagTexture "\OKS_GOL_Misc\data\images\aac.jpg";
};