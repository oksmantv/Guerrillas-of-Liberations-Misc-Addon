/*
    Disable All Active Protection Systems (APS).

    [] spawn OKS_fnc_DisableAPS;
*/

waitUntil{!(isNil"dapsDefinitionsLoaded")};
waitUntil{dapsDefinitionsLoaded};

dapsLight=[];
dapsMedium=[];
dapsHeavy=[];
dapsTrophyLV=[];
dapsTrophyMV=[];
dapsTrophyHV=[];
dapsTrophyHVe=[];
dapsArena=[];
dapsDazzler=[];
dapsDrozd=[];
dapsDrozd2=[];
dapsAfganit=[];
dapsAfganitE=[];
dapsIronFist=[];
dapsAMAP=[];
dapsPersonal=[];
dapsVitebsk=[];
dapsNemesis=[];

{
    publicVariable _x;
} forEach [
    "dapsLight",
    "dapsMedium",
    "dapsHeavy",
    "dapsTrophyLV",
    "dapsTrophyMV",
    "dapsTrophyHV",
    "dapsTrophyHVe",
    "dapsArena",
    "dapsDazzler",
    "dapsDrozd",
    "dapsDrozd2",
    "dapsAfganit",
    "dapsAfganitE",
    "dapsIronFist",
    "dapsAMAP",
    "dapsPersonal",
    "dapsVitebsk",
    "dapsNemesis"
];
