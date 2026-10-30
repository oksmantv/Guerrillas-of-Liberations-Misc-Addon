// This file is included from CfgVehicles.cpp inside class CfgVehicles {}.

class House_F;
class Flag_Blue_F;
class RuggedTerminal_01_communications_F;

class OKS_InvisibleWall3m: House_F {
    scope = 2;
    scopeCurator = 2;
    displayName = "Invisible Wall (3 m)";
    model = "\OKS_GOL_Misc\data\models\OKS_invisiblewall3m.p3d";
    editorCategory = "GOL_GuerrillasOfLiberation";
    editorSubcategory = "GOL_Objects";
    vehicleClass = "Structures";
    mapSize = 3;
};

class GOL_Flagpole: Flag_Blue_F {
    scope = 2;
    scopeCurator = 2;
    displayName = "GOL Flagpole";
    model = "\a3\Structures_F\Mil\Flags\Mast_F.p3d";
    editorCategory = "GOL_GuerrillasOfLiberation";
    editorSubcategory = "GOL_Objects";
    vehicleClass = "Structures";
    mapSize = 3;
};

class GOL_Flagpole_West: GOL_Flagpole {
    displayName = "GOL Flagpole West";
    hiddenSelections[] = {"flag"};
    hiddenSelectionsTextures[] = {"\OKS_GOL_Misc\data\images\gol_west.paa"};
    class EventHandlers
    {
        init = "(_this select 0) setFlagTexture ""\OKS_GOL_Misc\data\images\gol_west.paa""";
    };
};

class GOL_Flagpole_East: GOL_Flagpole {
    displayName = "GOL Flagpole East";
    hiddenSelections[] = {"flag"};
    hiddenSelectionsTextures[] = {"\OKS_GOL_Misc\data\images\gol_east.paa"};
    class EventHandlers
    {
        init = "(_this select 0) setFlagTexture ""\OKS_GOL_Misc\data\images\gol_east.paa""";
    };
};

class GOL_Flagpole_Independent: GOL_Flagpole {
    displayName = "GOL Flagpole Independent";
    hiddenSelections[] = {"flag"};
    hiddenSelectionsTextures[] = {"\OKS_GOL_Misc\data\images\gol_indep.paa"};
    class EventHandlers
    {
        init = "(_this select 0) setFlagTexture ""\OKS_GOL_Misc\data\images\gol_indep.paa""";
    };
};

class GOL_Flagpole_Hellfish: GOL_Flagpole {
    displayName = "GOL Flagpole Hellfish";
    hiddenSelections[] = {"flag"};
    hiddenSelectionsTextures[] = {"\OKS_GOL_Misc\data\images\hellfishflag.paa"};
    class EventHandlers
    {
        init = "(_this select 0) setFlagTexture ""\OKS_GOL_Misc\data\images\hellfishflag.paa""";
    };
};

class GOL_Flagpole_AAC: GOL_Flagpole {
    displayName = "GOL Flagpole (AAC)";
    hiddenSelections[] = {"flag"};
    hiddenSelectionsTextures[] = {"\OKS_GOL_Misc\data\images\aacflag.paa"};
    class EventHandlers
    {
        init = "(_this select 0) setFlagTexture ""\OKS_GOL_Misc\data\images\aacflag.paa""";
    };    
};

class GOL_Mobile_HQ: RuggedTerminal_01_communications_F {
    scope = 2;
    scopeCurator = 2;
    displayName = "Mobile HQ";
    editorCategory = "GOL_GuerrillasOfLiberation";
    editorSubcategory = "GOL_Objects";
    vehicleClass = "Structures";
    mapSize = 3;
};