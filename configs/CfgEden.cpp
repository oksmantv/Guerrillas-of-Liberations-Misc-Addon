/*
================================================================================
Eden Editor Context Menu Entry: Hunt Base (Right-click Terrain)
================================================================================
- Right-click terrain in Eden Editor
- Select "GOL SCRIPTS" > "SPAWN" > "Hunter Base"
- Calls your SQF handler to place the base, spawn, and trigger objects
================================================================================
*/

class Display3DEN {
    class ContextMenu {
        class Items {
            items[] += {"GOL_SCRIPTS"};
            class GOL_SCRIPTS {
                text = "GOL SCRIPTS";
				picture = "\OKS_GOL_Misc\data\images\logo.paa";
                value = 0;
                items[] = {"GOL_SCRIPTS_SPAWN","GOL_SCRIPTS_TASK", "GOL_SCRIPTS_GEAR", "GOL_SCRIPTS_AMBIENCE", "GOL_SCRIPTS_MARKER"};
            };
            class GOL_SCRIPTS_SPAWN {
                text = "SPAWN";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_SPAWN_HUNTERBASE",
                    "GOL_SCRIPTS_SPAWN_HELICOPTERBASE",
                    "GOL_SCRIPTS_LAMBS"
                };
            };
            class GOL_SCRIPTS_SPAWN_HUNTERBASE {
                text = "Hunter Base";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenHuntBase;";
                conditionShow = "1";
            };            
            class GOL_SCRIPTS_SPAWN_HELICOPTERBASE {
                text = "Helicopter Base";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenAirBase;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_LAMBS {
                text = "LAMBS";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_LAMBSGROUP"
                };
            };
            class GOL_SCRIPTS_LAMBSGROUP {
                text = "LAMBS SpawnGroup";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_SPAWN_LAMBSGROUP_RUSH",
                    "GOL_SCRIPTS_SPAWN_LAMBSGROUP_HUNT",
                    "GOL_SCRIPTS_SPAWN_LAMBSGROUP_AMBUSHRUSH",
                    "GOL_SCRIPTS_SPAWN_LAMBSGROUP_AMBUSHHUNT"
                };
            };                     
            class GOL_SCRIPTS_SPAWN_LAMBSGROUP_RUSH {
                text = "LAMBS SpawnGroup (Rush)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'rush'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };  
            class GOL_SCRIPTS_SPAWN_LAMBSGROUP_HUNT {
                text = "LAMBS SpawnGroup (Hunt)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'hunt'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };  
            class GOL_SCRIPTS_SPAWN_LAMBSGROUP_AMBUSHRUSH {
                text = "LAMBS SpawnGroup (Ambush Rush)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushrush'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };  
            class GOL_SCRIPTS_SPAWN_LAMBSGROUP_AMBUSHHUNT {
                text = "LAMBS SpawnGroup (Ambush Hunt)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushhunt'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };  

            class GOL_SCRIPTS_GEAR {
                text = "GEAR";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_GEAR_EXTRACT"
                };
            };

            class GOL_SCRIPTS_GEAR_EXTRACT {
                text = "Extract Gear from selected AI";
                action = "[] call OKS_fnc_EdenExtractGearFromAI;";
                conditionShow = "1";
            };      

            class GOL_SCRIPTS_TASK {
                text = "TASK";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TASK_DESTROYTASK",
                    "GOL_SCRIPTS_TASK_HOSTAGETASK"
                };
            };
            class GOL_SCRIPTS_TASK_DESTROYTASK {
                text = "Destroy Task";
                action = "[] call OKS_fnc_EdenDestroyTask;";
                conditionShow = "1";
            };      
            class GOL_SCRIPTS_TASK_HOSTAGETASK {
                text = "Hostage Task";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenHostageTask;";
                conditionShow = "1";
            }; 

            class GOL_SCRIPTS_AMBIENCE {
                text = "AMBIENCE";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_AMBIENCE_COPYANDELEVATE"
                };
            };

            class GOL_SCRIPTS_AMBIENCE_COPYANDELEVATE {
                text = "Copy & Elevate Objects";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_CopyAndElevateObjectsMenu;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER {
                text = "MARKER";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH"
                };
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH {
                text = "Mark Organisation Strength";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG"
                };
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG {
                text = "With Flag";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP"
                };
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR {
                text = "BLUFOR";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_FIRETEAM",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_SQUAD",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_SECTION",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_PLATOON",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_COMPANY",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_BATTALION",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_REGIMENT",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_BRIGADE",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_DIVISION",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_CORPS",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_ARMY",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_ARMYGROUP"
                };
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR {
                text = "OPFOR";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_FIRETEAM",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_SQUAD",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_SECTION",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_PLATOON",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_COMPANY",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_BATTALION",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_REGIMENT",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_BRIGADE",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_DIVISION",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_CORPS",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_ARMY",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_ARMYGROUP"
                };
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP {
                text = "INDEPENDENT";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_FIRETEAM",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_SQUAD",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_SECTION",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_PLATOON",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_COMPANY",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_BATTALION",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_REGIMENT",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_BRIGADE",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_DIVISION",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_CORPS",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_ARMY",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_ARMYGROUP"
                };
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG {
                text = "Without Flag";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_FIRETEAM",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_SQUAD",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_SECTION",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_PLATOON",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_COMPANY",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_BATTALION",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_REGIMENT",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_BRIGADE",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_DIVISION",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_CORPS",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_ARMY",
                    "GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_ARMYGROUP"
                };
            };

            // WITH FLAG BLUFOR OPTIONS
            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_FIRETEAM {
                text = "Fire Team";
                action = "[""group_0"", true, ""BLUFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_SQUAD {
                text = "Squad";
                action = "[""group_1"", true, ""BLUFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_SECTION {
                text = "Section";
                action = "[""group_2"", true, ""BLUFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_PLATOON {
                text = "Platoon";
                action = "[""group_3"", true, ""BLUFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_COMPANY {
                text = "Company";
                action = "[""group_4"", true, ""BLUFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_BATTALION {
                text = "Battalion";
                action = "[""group_5"", true, ""BLUFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_REGIMENT {
                text = "Regiment";
                action = "[""group_6"", true, ""BLUFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_BRIGADE {
                text = "Brigade";
                action = "[""group_7"", true, ""BLUFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_DIVISION {
                text = "Division";
                action = "[""group_8"", true, ""BLUFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_CORPS {
                text = "Corps";
                action = "[""group_9"", true, ""BLUFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_ARMY {
                text = "Army";
                action = "[""group_10"", true, ""BLUFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_BLUFOR_ARMYGROUP {
                text = "Army Group";
                action = "[""group_11"", true, ""BLUFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            // WITH FLAG OPFOR OPTIONS
            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_FIRETEAM {
                text = "Fire Team";
                action = "[""group_0"", true, ""OPFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_SQUAD {
                text = "Squad";
                action = "[""group_1"", true, ""OPFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_SECTION {
                text = "Section";
                action = "[""group_2"", true, ""OPFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_PLATOON {
                text = "Platoon";
                action = "[""group_3"", true, ""OPFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_COMPANY {
                text = "Company";
                action = "[""group_4"", true, ""OPFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_BATTALION {
                text = "Battalion";
                action = "[""group_5"", true, ""OPFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_REGIMENT {
                text = "Regiment";
                action = "[""group_6"", true, ""OPFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_BRIGADE {
                text = "Brigade";
                action = "[""group_7"", true, ""OPFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_DIVISION {
                text = "Division";
                action = "[""group_8"", true, ""OPFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_CORPS {
                text = "Corps";
                action = "[""group_9"", true, ""OPFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_ARMY {
                text = "Army";
                action = "[""group_10"", true, ""OPFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_OPFOR_ARMYGROUP {
                text = "Army Group";
                action = "[""group_11"", true, ""OPFOR""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            // WITH FLAG INDEP OPTIONS
            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_FIRETEAM {
                text = "Fire Team";
                action = "[""group_0"", true, ""INDEP""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_SQUAD {
                text = "Squad";
                action = "[""group_1"", true, ""INDEP""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_SECTION {
                text = "Section";
                action = "[""group_2"", true, ""INDEP""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_PLATOON {
                text = "Platoon";
                action = "[""group_3"", true, ""INDEP""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_COMPANY {
                text = "Company";
                action = "[""group_4"", true, ""INDEP""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_BATTALION {
                text = "Battalion";
                action = "[""group_5"", true, ""INDEP""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_REGIMENT {
                text = "Regiment";
                action = "[""group_6"", true, ""INDEP""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_BRIGADE {
                text = "Brigade";
                action = "[""group_7"", true, ""INDEP""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_DIVISION {
                text = "Division";
                action = "[""group_8"", true, ""INDEP""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_CORPS {
                text = "Corps";
                action = "[""group_9"", true, ""INDEP""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_ARMY {
                text = "Army";
                action = "[""group_10"", true, ""INDEP""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHFLAG_INDEP_ARMYGROUP {
                text = "Army Group";
                action = "[""group_11"", true, ""INDEP""] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            // WITHOUT FLAG OPTIONS
            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_FIRETEAM {
                text = "Fire Team";
                action = "[""group_0"", false] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_SQUAD {
                text = "Squad";
                action = "[""group_1"", false] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_SECTION {
                text = "Section";
                action = "[""group_2"", false] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_PLATOON {
                text = "Platoon";
                action = "[""group_3"", false] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_COMPANY {
                text = "Company";
                action = "[""group_4"", false] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_BATTALION {
                text = "Battalion";
                action = "[""group_5"", false] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_REGIMENT {
                text = "Regiment";
                action = "[""group_6"", false] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_BRIGADE {
                text = "Brigade";
                action = "[""group_7"", false] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_DIVISION {
                text = "Division";
                action = "[""group_8"", false] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_CORPS {
                text = "Corps";
                action = "[""group_9"", false] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_ARMY {
                text = "Army";
                action = "[""group_10"", false] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MARKER_ORGSTRENGTH_WITHOUTFLAG_ARMYGROUP {
                text = "Army Group";
                action = "[""group_11"", false] call OKS_fnc_EdenMarkOrgStrength;";
                conditionShow = "1";
            };

        };
    };
};