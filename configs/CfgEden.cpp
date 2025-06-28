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
                items[] = {"GOL_SCRIPTS_SPAWN","GOL_SCRIPTS_TASK"};
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
                conditionShow = "hoverGround"; // Only show when right-clicking terrain
            };            
            class GOL_SCRIPTS_SPAWN_HELICOPTERBASE {
                text = "Helicopter Base";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenAirBase;";
                conditionShow = "hoverGround"; // Only show when right-clicking terrain
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
                conditionShow = "hoverGround"; // Only show when right-clicking terrain
            };  
            class GOL_SCRIPTS_SPAWN_LAMBSGROUP_HUNT {
                text = "LAMBS SpawnGroup (Hunt)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'hunt'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "hoverGround"; // Only show when right-clicking terrain
            };  
            class GOL_SCRIPTS_SPAWN_LAMBSGROUP_AMBUSHRUSH {
                text = "LAMBS SpawnGroup (Ambush Rush)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushrush'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "hoverGround"; // Only show when right-clicking terrain
            };  
            class GOL_SCRIPTS_SPAWN_LAMBSGROUP_AMBUSHHUNT {
                text = "LAMBS SpawnGroup (Ambush Hunt)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushhunt'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "hoverGround"; // Only show when right-clicking terrain
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
                conditionShow = "hoverObject"; // Only show when right-clicking terrain
            };      
            class GOL_SCRIPTS_TASK_HOSTAGETASK {
                text = "Hostage Task";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenHostageTask;";
                conditionShow = "hoverGround"; // Only show when right-clicking terrain
            }; 

        };
    };
};