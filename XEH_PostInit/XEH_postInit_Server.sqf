diag_log "OKS_GOL_Misc: XEH_postInit_Server.sqf executed";

GOL_Core_Enabled = missionNamespace getVariable ["GOL_CORE_Enabled",false];
if(GOL_Core_Enabled isEqualTo true) then {
    /*
        Server Side Executions
    */
    if(isServer) then {   

        GOL_MiscAddon_ServerVersion = getText(configFile >> "CBA_VERSIONING" >> "GOL_MISC_ADDON" >> "version");
        publicVariable "GOL_MiscAddon_ServerVersion";

        _EnabledDaps = missionNamespace getVariable ["GOL_DAPS_Enabled", false];
        if(!_EnabledDaps) then {
            /* DAPS Options */
            [] spawn OKS_fnc_DisableAPS;
        };

        /* Tent MHQ Setup */
        if (!isNil "Mobile_HQ") then {
            [Mobile_HQ, "small"] call GW_MHQ_Fnc_Handler;
        };
 
        /*
            Set Civilians to Friendly to all sides.
        */
        civilian setFriend [west,1];
        civilian setFriend [east,1];
        civilian setFriend [independent,1];

        /*
            OKS Locations for Dynamic Setup
        */
        OKS_AllUnits = [];
        OKS_Logics = (allMissionObjects "all") select {typeOf _X in ["LocationCamp_F","LocationResupplyPoint_F","LocationRespawnPoint_F","LocationEvacPoint_F","LocationFOB_F","LocationCityCapital_F","LocationCity_F","LocationVillage_F","LocationArea_F","LocationBase_F","LocationOutpost_F","LocationCamp_F","LocationRespawnPoint_F"]};

        OKS_Locations = OKS_Logics select {typeOf _X in ["LocationResupplyPoint_F","LocationEvacPoint_F","LocationCityCapital_F","LocationCity_F","LocationArea_F"]};
        OKS_Compounds = OKS_Logics select {typeOf _X in ["LocationOutpost_F"]};
        OKS_Strongholds = OKS_Logics select {typeOf _X in ["LocationBase_F"]};
        OKS_Objectives = OKS_Logics select {typeOf _X in ["LocationCamp_F"]};
        OKS_HuntLocations = OKS_Logics select {typeOf _X in ["LocationRespawnPoint_F"]};
        OKS_RoadBlocks = OKS_Logics select {typeOf _X in ["LocationFOB_F"]};
        OKS_Villages = OKS_Logics select {typeOf _X in ["LocationVillage_F"]};
        OKS_RoadBlock_Positions = [];
        OKS_Mortar_Positions = [];
        OKS_Objective_Positions = [];
        OKS_Hunt_Positions = [];

        /*
            OKS Force & Response Multiplier Values
            Used for increasing hunt intensity
        */
        _ForceMultiplier = missionNamespace getVariable "GOL_ForceMultiplier";
        _ResponseMultiplier = missionNamespace getVariable "GOL_ResponseMultiplier";
        if(isNil "_ForceMultiplier" && isNil "_ResponseMultiplier") then {
            missionNamespace setVariable ["GOL_ForceMultiplier", 1, true];
            missionNamespace setVariable ["GOL_ResponseMultiplier", 1, true];
        };
    
        if(isNil "NEKY_Hunt_CurrentCount") then {
            NEKY_Hunt_CurrentCount = [];
            publicVariable "NEKY_Hunt_CurrentCount";
        };

        /* Enable NEKY Casualty */
        _EnableNekyTasks = missionNamespace getVariable ["GOL_Neky_Tasks_Enabled", false];
        if(_EnableNekyTasks) then {
            [] spawn OKS_fnc_NekyTasks;
        };

        private _stealthEnabled = missionNamespace getVariable ["GOL_Stealth_Enabled", false];
        if (_stealthEnabled) then {
            [] call OKS_fnc_Stealth_Init;
        };
    };  
};