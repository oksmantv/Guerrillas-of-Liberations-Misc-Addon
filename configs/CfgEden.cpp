/*
================================================================================
Eden Editor Context Menu Entry: Hunt Base (Right-click Terrain)
================================================================================
- Right-click terrain in Eden Editor
- Select "GOL Spawns" / "GOL Tools" for actions
- Calls your SQF handler to place the base, spawn, and trigger objects
================================================================================
*/

class ctrlMenu;

class Display3DEN {
    class ContextMenu: ctrlMenu {
        class Items {
            items[] += {"GOL_SPAWNS","GOL_TOOLS"};

            class GOL_SPAWNS {
                text = "GOL Spawns";
				picture = "\OKS_GOL_Misc\data\images\logo.paa";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_LAMBS",
                    "GOL_SCRIPTS_FIRESUPPORT",
                    "GOL_SCRIPTS_QRF_BASES",
					"GOL_SCRIPTS_BEACH_LANDING",
                    "GOL_SCRIPTS_MECHANIZED_SPAWN",
                    "GOL_SCRIPTS_VEHICLE_ON_RAILS",
                    "GOL_SCRIPTS_CONVOY",
                    "GOL_SCRIPTS_ATTACK_SPAWNGROUP",
                    "GOL_SCRIPTS_AI_BATTLE",
                    "GOL_SCRIPTS_ADD_VEHICLE_CREW"
                };
            };

            class GOL_TOOLS {
                text = "GOL Tools";
				picture = "\OKS_GOL_Misc\data\images\logo.paa";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TASK",
                    "GOL_SCRIPTS_GEAR",
                    "GOL_SCRIPTS_TRIGGER",
                    "GOL_SCRIPTS_AMBIENCE"
                };
            };

            class GOL_SCRIPTS_TEMPLATES {
                text = "Create Units";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\map_ca.paa";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TEMPLATES_STATIC",
                    "GOL_SCRIPTS_TEMPLATES_GARRISON",
                    "GOL_SCRIPTS_TEMPLATES_PATROL"
                };
            };

            class GOL_SCRIPTS_TEMPLATES_STATIC {
                text = "Static Units";
                picture = "\a3\ui_f\data\Map\Markers\NATO\b_inf.paa";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TEMPLATES_STATIC_WEST",
                    "GOL_SCRIPTS_TEMPLATES_STATIC_EAST",
                    "GOL_SCRIPTS_TEMPLATES_STATIC_INDEP"
                };
            };
            class GOL_SCRIPTS_TEMPLATES_STATIC_WEST {
                text = "WEST";
                picture = "\a3\ui_f\data\Map\Markers\NATO\b_inf.paa";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TEMPLATES_STATIC_WEST_2",
                    "GOL_SCRIPTS_TEMPLATES_STATIC_WEST_6",
                    "GOL_SCRIPTS_TEMPLATES_STATIC_WEST_10"
                };
            };
            class GOL_SCRIPTS_TEMPLATES_STATIC_WEST_2 {
                text = "2 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\private_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), west, 2] call OKS_fnc_EdenTemplateStaticUnits;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_STATIC_WEST_6 {
                text = "6 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\corporal_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), west, 6] call OKS_fnc_EdenTemplateStaticUnits;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_STATIC_WEST_10 {
                text = "10 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), west, 10] call OKS_fnc_EdenTemplateStaticUnits;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_STATIC_EAST {
                text = "EAST";
                picture = "\a3\ui_f\data\Map\Markers\NATO\o_inf.paa";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TEMPLATES_STATIC_EAST_2",
                    "GOL_SCRIPTS_TEMPLATES_STATIC_EAST_6",
                    "GOL_SCRIPTS_TEMPLATES_STATIC_EAST_10"
                };
            };
            class GOL_SCRIPTS_TEMPLATES_STATIC_EAST_2 {
                text = "2 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\private_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), east, 2] call OKS_fnc_EdenTemplateStaticUnits;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_STATIC_EAST_6 {
                text = "6 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\corporal_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), east, 6] call OKS_fnc_EdenTemplateStaticUnits;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_STATIC_EAST_10 {
                text = "10 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), east, 10] call OKS_fnc_EdenTemplateStaticUnits;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_STATIC_INDEP {
                text = "INDEPENDENT";
                picture = "\a3\ui_f\data\Map\Markers\NATO\n_inf.paa";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TEMPLATES_STATIC_INDEP_2",
                    "GOL_SCRIPTS_TEMPLATES_STATIC_INDEP_6",
                    "GOL_SCRIPTS_TEMPLATES_STATIC_INDEP_10"
                };
            };
            class GOL_SCRIPTS_TEMPLATES_STATIC_INDEP_2 {
                text = "2 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\private_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), independent, 2] call OKS_fnc_EdenTemplateStaticUnits;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_STATIC_INDEP_6 {
                text = "6 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\corporal_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), independent, 6] call OKS_fnc_EdenTemplateStaticUnits;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_STATIC_INDEP_10 {
                text = "10 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), independent, 10] call OKS_fnc_EdenTemplateStaticUnits;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_TEMPLATES_GARRISON {
                text = "Static Garrison";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\defend_ca.paa";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TEMPLATES_GARRISON_WEST",
                    "GOL_SCRIPTS_TEMPLATES_GARRISON_EAST",
                    "GOL_SCRIPTS_TEMPLATES_GARRISON_INDEP"
                };
            };
            class GOL_SCRIPTS_TEMPLATES_GARRISON_WEST {
                text = "WEST";
                picture = "\a3\ui_f\data\Map\Markers\NATO\b_inf.paa";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TEMPLATES_GARRISON_WEST_2",
                    "GOL_SCRIPTS_TEMPLATES_GARRISON_WEST_6",
                    "GOL_SCRIPTS_TEMPLATES_GARRISON_WEST_10"
                };
            };
            class GOL_SCRIPTS_TEMPLATES_GARRISON_WEST_2 {
                text = "2 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\private_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), west, 2] call OKS_fnc_EdenTemplateStaticGarrison;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_GARRISON_WEST_6 {
                text = "6 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\corporal_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), west, 6] call OKS_fnc_EdenTemplateStaticGarrison;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_GARRISON_WEST_10 {
                text = "10 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), west, 10] call OKS_fnc_EdenTemplateStaticGarrison;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_GARRISON_EAST {
                text = "EAST";
                picture = "\a3\ui_f\data\Map\Markers\NATO\o_inf.paa";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TEMPLATES_GARRISON_EAST_2",
                    "GOL_SCRIPTS_TEMPLATES_GARRISON_EAST_6",
                    "GOL_SCRIPTS_TEMPLATES_GARRISON_EAST_10"
                };
            };
            class GOL_SCRIPTS_TEMPLATES_GARRISON_EAST_2 {
                text = "2 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\private_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), east, 2] call OKS_fnc_EdenTemplateStaticGarrison;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_GARRISON_EAST_6 {
                text = "6 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\corporal_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), east, 6] call OKS_fnc_EdenTemplateStaticGarrison;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_GARRISON_EAST_10 {
                text = "10 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), east, 10] call OKS_fnc_EdenTemplateStaticGarrison;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_GARRISON_INDEP {
                text = "INDEPENDENT";
                picture = "\a3\ui_f\data\Map\Markers\NATO\n_inf.paa";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TEMPLATES_GARRISON_INDEP_2",
                    "GOL_SCRIPTS_TEMPLATES_GARRISON_INDEP_6",
                    "GOL_SCRIPTS_TEMPLATES_GARRISON_INDEP_10"
                };
            };
            class GOL_SCRIPTS_TEMPLATES_GARRISON_INDEP_2 {
                text = "2 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\private_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), independent, 2] call OKS_fnc_EdenTemplateStaticGarrison;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_GARRISON_INDEP_6 {
                text = "6 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\corporal_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), independent, 6] call OKS_fnc_EdenTemplateStaticGarrison;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_GARRISON_INDEP_10 {
                text = "10 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), independent, 10] call OKS_fnc_EdenTemplateStaticGarrison;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_TEMPLATES_PATROL {
                text = "Patrol";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\move_ca.paa";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TEMPLATES_PATROL_WEST",
                    "GOL_SCRIPTS_TEMPLATES_PATROL_EAST",
                    "GOL_SCRIPTS_TEMPLATES_PATROL_INDEP"
                };
            };
            class GOL_SCRIPTS_TEMPLATES_PATROL_WEST {
                text = "WEST";
                picture = "\a3\ui_f\data\Map\Markers\NATO\b_inf.paa";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TEMPLATES_PATROL_WEST_2",
                    "GOL_SCRIPTS_TEMPLATES_PATROL_WEST_6",
                    "GOL_SCRIPTS_TEMPLATES_PATROL_WEST_10"
                };
            };
            class GOL_SCRIPTS_TEMPLATES_PATROL_WEST_2 {
                text = "2 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\private_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), west, 2] call OKS_fnc_EdenTemplatePatrol;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_PATROL_WEST_6 {
                text = "6 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\corporal_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), west, 6] call OKS_fnc_EdenTemplatePatrol;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_PATROL_WEST_10 {
                text = "10 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), west, 10] call OKS_fnc_EdenTemplatePatrol;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_PATROL_EAST {
                text = "EAST";
                picture = "\a3\ui_f\data\Map\Markers\NATO\o_inf.paa";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TEMPLATES_PATROL_EAST_2",
                    "GOL_SCRIPTS_TEMPLATES_PATROL_EAST_6",
                    "GOL_SCRIPTS_TEMPLATES_PATROL_EAST_10"
                };
            };
            class GOL_SCRIPTS_TEMPLATES_PATROL_EAST_2 {
                text = "2 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\private_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), east, 2] call OKS_fnc_EdenTemplatePatrol;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_PATROL_EAST_6 {
                text = "6 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\corporal_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), east, 6] call OKS_fnc_EdenTemplatePatrol;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_PATROL_EAST_10 {
                text = "10 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), east, 10] call OKS_fnc_EdenTemplatePatrol;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_PATROL_INDEP {
                text = "INDEPENDENT";
                picture = "\a3\ui_f\data\Map\Markers\NATO\n_inf.paa";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TEMPLATES_PATROL_INDEP_2",
                    "GOL_SCRIPTS_TEMPLATES_PATROL_INDEP_6",
                    "GOL_SCRIPTS_TEMPLATES_PATROL_INDEP_10"
                };
            };
            class GOL_SCRIPTS_TEMPLATES_PATROL_INDEP_2 {
                text = "2 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\private_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), independent, 2] call OKS_fnc_EdenTemplatePatrol;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_PATROL_INDEP_6 {
                text = "6 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\corporal_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), independent, 6] call OKS_fnc_EdenTemplatePatrol;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TEMPLATES_PATROL_INDEP_10 {
                text = "10 MAN";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), independent, 10] call OKS_fnc_EdenTemplatePatrol;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_AI_BATTLE {
                text = "AI Battle";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_AI_BATTLE_CREATE",
                    "GOL_SCRIPTS_AI_BATTLE_OPENFUNC"
                };
            };
            class GOL_SCRIPTS_AI_BATTLE_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_AI_Battle'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_AI_BATTLE_CREATE {
                text = "Create";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenAIBattle;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_BEACH_LANDING {
                text = "Beach Landing";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_BEACH_LANDING_CREATE",
                    "GOL_SCRIPTS_BEACH_LANDING_OPENFUNC"
                };
            };
            class GOL_SCRIPTS_BEACH_LANDING_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_BeachLanding'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_BEACH_LANDING_CREATE {
                text = "Create";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenBeachLanding;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_ATTACK_SPAWNGROUP {
                text = "Attack SpawnGroup";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_ATTACK_SPAWNGROUP_INFANTRY",
                    "GOL_SCRIPTS_ATTACK_SPAWNGROUP_VEHICLE",
                    "GOL_SCRIPTS_ATTACK_SPAWNGROUP_OPENFUNC"
                };
            };
            class GOL_SCRIPTS_ATTACK_SPAWNGROUP_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_Attack_SpawnGroup'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_ATTACK_SPAWNGROUP_INFANTRY {
                text = "INFANTRY";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'infantry'] call OKS_fnc_EdenAttackSpawnGroup;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_ATTACK_SPAWNGROUP_VEHICLE {
                text = "VEHICLE";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'vehicle'] call OKS_fnc_EdenAttackSpawnGroup;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_MECHANIZED_SPAWN {
                text = "Mechanized Spawn";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_MECHANIZED_SPAWN_CREATE",
                    "GOL_SCRIPTS_MECHANIZED_SPAWN_OPENFUNC"
                };
            };
            class GOL_SCRIPTS_MECHANIZED_SPAWN_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_Mechanized_Spawn'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_MECHANIZED_SPAWN_CREATE {
                text = "Create";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenMechanizedSpawn;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_VEHICLE_ON_RAILS {
                text = "Vehicle on Rails";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_VEHICLE_ON_RAILS_CREATE",
                    "GOL_SCRIPTS_VEHICLE_ON_RAILS_OPENFUNC"
                };
            };
            class GOL_SCRIPTS_VEHICLE_ON_RAILS_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_RailVehicle_Spawn'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_VEHICLE_ON_RAILS_CREATE {
                text = "Create";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenVehicleOnRails;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_CONVOY {
                text = "Convoy Spawn";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_CONVOY_CREATE",
                    "GOL_SCRIPTS_CONVOY_OPENFUNC"
                };
            };
            class GOL_SCRIPTS_CONVOY_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_Convoy_Spawn'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_CONVOY_CREATE {
                text = "Create";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenConvoySpawn;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_FIRESUPPORT {
                text = "FIRE SUPPORT";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_FIRESUPPORT_MORTARS",
                    "GOL_SCRIPTS_FIRESUPPORT_AAA",
                    "GOL_SCRIPTS_FIRESUPPORT_RADAR",
                    "GOL_SCRIPTS_FIRESUPPORT_ARTYFIRE",
                    "GOL_SCRIPTS_FIRESUPPORT_BALLISTICMISSILE",
                    "GOL_SCRIPTS_FIRESUPPORT_DRONEHUNTZONE",
                    "GOL_SCRIPTS_FIRESUPPORT_AIRSPAWN",
                    "GOL_SCRIPTS_FIRESUPPORT_AIRSCOUT"
                };
            };

            class GOL_SCRIPTS_FIRESUPPORT_DRONEHUNTZONE {
                text = "Drone Hunt Zone";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_FIRESUPPORT_DRONEHUNTZONE_CREATE",
                    "GOL_SCRIPTS_FIRESUPPORT_DRONEHUNTZONE_OPENFUNC"
                };
            };

            class GOL_SCRIPTS_FIRESUPPORT_DRONEHUNTZONE_CREATE {
                text = "Create";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenDroneHuntZone;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_FIRESUPPORT_DRONEHUNTZONE_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_DroneHuntZone'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_FIRESUPPORT_BALLISTICMISSILE {
                text = "Ballistic Missile";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_FIRESUPPORT_BALLISTICMISSILE_SCUD",
                    "GOL_SCRIPTS_FIRESUPPORT_BALLISTICMISSILE_CRUISE",
                    "GOL_SCRIPTS_FIRESUPPORT_BALLISTICMISSILE_OPENFUNC"
                };
            };

            class GOL_SCRIPTS_FIRESUPPORT_BALLISTICMISSILE_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_ScudIntercept_LaunchAI'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_FIRESUPPORT_BALLISTICMISSILE_SCUD {
                text = "SCUD";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), 'rhs_9k79'] call OKS_fnc_EdenBallisticMissile;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_FIRESUPPORT_BALLISTICMISSILE_CRUISE {
                text = "Cruise Missile";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), 'B_Ship_MRLS_01_F'] call OKS_fnc_EdenBallisticMissile;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_FIRESUPPORT_AIRSCOUT {
                text = "Air Scout";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_FIRESUPPORT_AIRSCOUT_MORTARS_ON",
                    "GOL_SCRIPTS_FIRESUPPORT_AIRSCOUT_MORTARS_OFF",
                    "GOL_SCRIPTS_FIRESUPPORT_AIRSCOUT_OPENFUNC"
                };
            };

            class GOL_SCRIPTS_FIRESUPPORT_AIRSCOUT_MORTARS_ON {
                text = "Create (On-call Mortars: ON)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), sideUnknown, true] call OKS_fnc_EdenAirScout;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_FIRESUPPORT_AIRSCOUT_MORTARS_OFF {
                text = "Create (On-call Mortars: OFF)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'), sideUnknown, false] call OKS_fnc_EdenAirScout;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_FIRESUPPORT_AIRSCOUT_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_AirScout'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_FIRESUPPORT_MORTARS {
                text = "Mortars";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_FIRESUPPORT_MORTARS_OFFMAP_DESIGNATED",
                    "GOL_SCRIPTS_FIRESUPPORT_MORTARS_MANNED_DESIGNATED",
                    "GOL_SCRIPTS_FIRESUPPORT_MORTARS_MANNED_AUTO",
                    "GOL_SCRIPTS_FIRESUPPORT_MORTARS_OPENFUNC"
                };
            };

            class GOL_SCRIPTS_FIRESUPPORT_MORTARS_OFFMAP_DESIGNATED {
                text = "OFFMAP (Designated Target)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'offmap','designated','precise','light'] call OKS_fnc_EdenMortars;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_FIRESUPPORT_MORTARS_MANNED_DESIGNATED {
                text = "MANNED (Designated Target)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'manned','designated','precise','light'] call OKS_fnc_EdenMortars;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_FIRESUPPORT_MORTARS_MANNED_AUTO {
                text = "MANNED (Dynamic Support / AUTO)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'manned','auto','precise','light'] call OKS_fnc_EdenMortars;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_FIRESUPPORT_MORTARS_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_Mortars'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_FIRESUPPORT_AAA {
                text = "Ambient AAA";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_FIRESUPPORT_AAA_RADAR_ON",
                    "GOL_SCRIPTS_FIRESUPPORT_AAA_RADAR_OFF",
                    "GOL_SCRIPTS_FIRESUPPORT_AAA_HMG_RADAR_ON",
                    "GOL_SCRIPTS_FIRESUPPORT_AAA_OPENFUNC"
                };
            };

            class GOL_SCRIPTS_FIRESUPPORT_AAA_RADAR_ON {
                text = "Dynamic Support (Radar ON)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),true,false,1500] call OKS_fnc_EdenAmbientAAA;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_FIRESUPPORT_AAA_RADAR_OFF {
                text = "Dynamic Support (Radar OFF)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),false,false,1500] call OKS_fnc_EdenAmbientAAA;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_FIRESUPPORT_AAA_HMG_RADAR_ON {
                text = "Dynamic Support (isHMG=true, Radar ON)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),true,true,1500] call OKS_fnc_EdenAmbientAAA;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_FIRESUPPORT_AAA_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_Ambient_AAA'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_FIRESUPPORT_RADAR {
                text = "Radar Share";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_FIRESUPPORT_RADAR_RANGE_1500",
                    "GOL_SCRIPTS_FIRESUPPORT_RADAR_RANGE_2500",
                    "GOL_SCRIPTS_FIRESUPPORT_RADAR_RANGE_3500",
                    "GOL_SCRIPTS_FIRESUPPORT_RADAR_OPENFUNC"
                };
            };

            class GOL_SCRIPTS_FIRESUPPORT_RADAR_RANGE_1500 {
                text = "Dynamic Support (Range 1500m)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),1500,1500,100] call OKS_fnc_EdenRadar;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_FIRESUPPORT_RADAR_RANGE_2500 {
                text = "Dynamic Support (Range 2500m)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),2500,2500,100] call OKS_fnc_EdenRadar;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_FIRESUPPORT_RADAR_RANGE_3500 {
                text = "Dynamic Support (Range 3500m)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),3500,3500,100] call OKS_fnc_EdenRadar;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_FIRESUPPORT_RADAR_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_Radar'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_FIRESUPPORT_ARTYFIRE {
                text = "ArtyFire (Ambience)";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_FIRESUPPORT_ARTYFIRE_DEFAULT",
                    "GOL_SCRIPTS_FIRESUPPORT_ARTYFIRE_OPENFUNC"
                };
            };
            class GOL_SCRIPTS_FIRESUPPORT_ARTYFIRE_DEFAULT {
                text = "Create (Default)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),7,300,30,false] call OKS_fnc_EdenArtyFire;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_FIRESUPPORT_ARTYFIRE_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_ArtyFire'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_FIRESUPPORT_AIRSPAWN {
                text = "Air Spawn";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_FIRESUPPORT_AIRSPAWN_COPY",
                    "GOL_SCRIPTS_FIRESUPPORT_AIRSPAWN_OPENFUNC"
                };
            };
            class GOL_SCRIPTS_FIRESUPPORT_AIRSPAWN_COPY {
                text = "Copy (Selection → Templates + Target)";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data')] call OKS_fnc_EdenAirSpawn;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_FIRESUPPORT_AIRSPAWN_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_AirSpawn'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_QRF_BASES {
                text = "QRF BASES";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_SPAWN_HUNTERBASE",
                    "GOL_SCRIPTS_SPAWN_HELICOPTERBASE"
                };
            };
            class GOL_SCRIPTS_SPAWN_HUNTERBASE {
                text = "Hunter Base";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_SPAWN_HUNTERBASE_CREATE",
                    "GOL_SCRIPTS_SPAWN_HUNTERBASE_OPENFUNC"
                };
            };
            class GOL_SCRIPTS_SPAWN_HUNTERBASE_CREATE {
                text = "Create";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenHuntBase;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_SPAWN_HUNTERBASE_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_HuntBase'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_SPAWN_HELICOPTERBASE {
                text = "Helicopter Base";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_SPAWN_HELICOPTERBASE_CREATE",
                    "GOL_SCRIPTS_SPAWN_HELICOPTERBASE_OPENFUNC"
                };
            };
            class GOL_SCRIPTS_SPAWN_HELICOPTERBASE_CREATE {
                text = "Create";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenAirBase;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_SPAWN_HELICOPTERBASE_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_Airbase'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_LAMBS {
                text = "LAMBS";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_LAMBSGROUP",
                    "GOL_SCRIPTS_LAMBSWAVESPAWN"
                };
            };

            class GOL_SCRIPTS_LAMBSWAVESPAWN {
                text = "LAMBS WaveSpawn";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_SINGLE",
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_TRIPLE",
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_OPENFUNC"
                };
            };

            class GOL_SCRIPTS_LAMBSWAVESPAWN_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_Lambs_Wavespawn'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_LAMBSWAVESPAWN_SINGLE {
                text = "SINGLE";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_SINGLE_RUSH",
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_SINGLE_HUNT",
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_SINGLE_CREEP",
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_SINGLE_AMBUSHATTACK",
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_SINGLE_AMBUSHRUSH",
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_SINGLE_AMBUSHHUNT",
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_SINGLE_AMBUSHCQB"
                };
            };

            class GOL_SCRIPTS_LAMBSWAVESPAWN_TRIPLE {
                text = "TRIPLE (3 spawnpoints)";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_TRIPLE_RUSH",
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_TRIPLE_HUNT",
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_TRIPLE_CREEP",
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_TRIPLE_AMBUSHATTACK",
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_TRIPLE_AMBUSHRUSH",
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_TRIPLE_AMBUSHHUNT",
                    "GOL_SCRIPTS_LAMBSWAVESPAWN_TRIPLE_AMBUSHCQB"
                };
            };

            // WaveSpawn SINGLE
            class GOL_SCRIPTS_LAMBSWAVESPAWN_SINGLE_RUSH {
                text = "Rush";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'rush','single'] call OKS_fnc_EdenLambsWaveSpawn;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSWAVESPAWN_SINGLE_HUNT {
                text = "Hunt";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'hunt','single'] call OKS_fnc_EdenLambsWaveSpawn;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSWAVESPAWN_SINGLE_CREEP {
                text = "Creep";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'creep','single'] call OKS_fnc_EdenLambsWaveSpawn;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSWAVESPAWN_SINGLE_AMBUSHATTACK {
                text = "Ambush Attack";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushattack','single'] call OKS_fnc_EdenLambsWaveSpawn;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSWAVESPAWN_SINGLE_AMBUSHRUSH {
                text = "Ambush Rush";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushrush','single'] call OKS_fnc_EdenLambsWaveSpawn;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSWAVESPAWN_SINGLE_AMBUSHHUNT {
                text = "Ambush Hunt";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushhunt','single'] call OKS_fnc_EdenLambsWaveSpawn;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSWAVESPAWN_SINGLE_AMBUSHCQB {
                text = "Ambush CQB";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushcqb','single'] call OKS_fnc_EdenLambsWaveSpawn;";
                conditionShow = "1";
            };

            // WaveSpawn TRIPLE
            class GOL_SCRIPTS_LAMBSWAVESPAWN_TRIPLE_RUSH {
                text = "Rush";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'rush','triple'] call OKS_fnc_EdenLambsWaveSpawn;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSWAVESPAWN_TRIPLE_HUNT {
                text = "Hunt";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'hunt','triple'] call OKS_fnc_EdenLambsWaveSpawn;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSWAVESPAWN_TRIPLE_CREEP {
                text = "Creep";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'creep','triple'] call OKS_fnc_EdenLambsWaveSpawn;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSWAVESPAWN_TRIPLE_AMBUSHATTACK {
                text = "Ambush Attack";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushattack','triple'] call OKS_fnc_EdenLambsWaveSpawn;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSWAVESPAWN_TRIPLE_AMBUSHRUSH {
                text = "Ambush Rush";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushrush','triple'] call OKS_fnc_EdenLambsWaveSpawn;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSWAVESPAWN_TRIPLE_AMBUSHHUNT {
                text = "Ambush Hunt";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushhunt','triple'] call OKS_fnc_EdenLambsWaveSpawn;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSWAVESPAWN_TRIPLE_AMBUSHCQB {
                text = "Ambush CQB";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushcqb','triple'] call OKS_fnc_EdenLambsWaveSpawn;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSGROUP {
                text = "LAMBS SpawnGroup";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_LAMBSGROUP_INFANTRY",
                    "GOL_SCRIPTS_LAMBSGROUP_VEHICLE",
                    "GOL_SCRIPTS_LAMBSGROUP_OPENFUNC"
                };
            };                     

            class GOL_SCRIPTS_LAMBSGROUP_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_Lambs_SpawnGroup'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_LAMBSGROUP_INFANTRY {
                text = "INFANTRY";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_LAMBSGROUP_INFANTRY_RUSH",
                    "GOL_SCRIPTS_LAMBSGROUP_INFANTRY_HUNT",
                    "GOL_SCRIPTS_LAMBSGROUP_INFANTRY_CREEP",
                    "GOL_SCRIPTS_LAMBSGROUP_INFANTRY_AMBUSHATTACK",
                    "GOL_SCRIPTS_LAMBSGROUP_INFANTRY_AMBUSHRUSH",
                    "GOL_SCRIPTS_LAMBSGROUP_INFANTRY_AMBUSHHUNT",
                    "GOL_SCRIPTS_LAMBSGROUP_INFANTRY_AMBUSHCQB"
                };
            };

            class GOL_SCRIPTS_LAMBSGROUP_VEHICLE {
                text = "VEHICLE";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_LAMBSGROUP_VEHICLE_RUSH",
                    "GOL_SCRIPTS_LAMBSGROUP_VEHICLE_HUNT",
                    "GOL_SCRIPTS_LAMBSGROUP_VEHICLE_CREEP",
                    "GOL_SCRIPTS_LAMBSGROUP_VEHICLE_AMBUSHATTACK",
                    "GOL_SCRIPTS_LAMBSGROUP_VEHICLE_AMBUSHRUSH",
                    "GOL_SCRIPTS_LAMBSGROUP_VEHICLE_AMBUSHHUNT",
                    "GOL_SCRIPTS_LAMBSGROUP_VEHICLE_AMBUSHCQB"
                };
            };

            // INFANTRY variants
            class GOL_SCRIPTS_LAMBSGROUP_INFANTRY_RUSH {
                text = "Rush";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'rush','infantry'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSGROUP_INFANTRY_HUNT {
                text = "Hunt";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'hunt','infantry'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSGROUP_INFANTRY_CREEP {
                text = "Creep";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'creep','infantry'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSGROUP_INFANTRY_AMBUSHATTACK {
                text = "Ambush Attack";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushattack','infantry'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSGROUP_INFANTRY_AMBUSHRUSH {
                text = "Ambush Rush";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushrush','infantry'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSGROUP_INFANTRY_AMBUSHHUNT {
                text = "Ambush Hunt";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushhunt','infantry'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSGROUP_INFANTRY_AMBUSHCQB {
                text = "Ambush CQB";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushcqb','infantry'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };

            // VEHICLE variants
            class GOL_SCRIPTS_LAMBSGROUP_VEHICLE_RUSH {
                text = "Rush";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'rush','vehicle'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSGROUP_VEHICLE_HUNT {
                text = "Hunt";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'hunt','vehicle'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSGROUP_VEHICLE_CREEP {
                text = "Creep";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'creep','vehicle'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSGROUP_VEHICLE_AMBUSHATTACK {
                text = "Ambush Attack";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushattack','vehicle'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSGROUP_VEHICLE_AMBUSHRUSH {
                text = "Ambush Rush";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushrush','vehicle'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSGROUP_VEHICLE_AMBUSHHUNT {
                text = "Ambush Hunt";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushhunt','vehicle'] call OKS_fnc_EdenLambsGroup;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_LAMBSGROUP_VEHICLE_AMBUSHCQB {
                text = "Ambush CQB";
                action = "[(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data'),'ambushcqb','vehicle'] call OKS_fnc_EdenLambsGroup;";
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

            class GOL_SCRIPTS_TRIGGER {
                text = "TRIGGER";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TRIGGER_IGNORE_AAC"
                };
            };

            class GOL_SCRIPTS_TRIGGER_IGNORE_AAC {
                text = "Set Trigger Ignore AAC";
                action = "[] call OKS_fnc_EdenSetTriggerIgnoreAAC;";
                conditionShow = "selectedTrigger";
            };

            class GOL_SCRIPTS_TASK {
                text = "TASK";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TASK_DESTROYTASK",
                    "GOL_SCRIPTS_TASK_DELIVERSUPPLIES",
                    "GOL_SCRIPTS_TASK_INSERTTASK",
                    "GOL_SCRIPTS_TASK_HOSTAGETASK",
                    "GOL_SCRIPTS_TASK_EVACUATEHVT",
                    "GOL_SCRIPTS_TASK_SETUPINTEL"
                };
            };

            class GOL_SCRIPTS_TASK_DELIVERSUPPLIES {
                text = "Deliver Supplies";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TASK_DELIVERSUPPLIES_CREATE",
                    "GOL_SCRIPTS_TASK_DELIVERSUPPLIES_OPENFUNC"
                };
            };
            class GOL_SCRIPTS_TASK_DELIVERSUPPLIES_CREATE {
                text = "Create";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenDeliverSupplies;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TASK_DELIVERSUPPLIES_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_Deliver_Supplies'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_TASK_INSERTTASK {
                text = "Insert Task";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TASK_INSERTTASK_CREATE",
                    "GOL_SCRIPTS_TASK_INSERTTASK_OPENFUNC"
                };
            };
            class GOL_SCRIPTS_TASK_INSERTTASK_CREATE {
                text = "Create";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenInsertTask;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TASK_INSERTTASK_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_Insert_Task'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TASK_DESTROYTASK {
                text = "Destroy Task";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TASK_DESTROYTASK_CREATE",
                    "GOL_SCRIPTS_TASK_DESTROYTASK_OPENFUNC"
                };
            };
            class GOL_SCRIPTS_TASK_DESTROYTASK_CREATE {
                text = "Create";
                action = "[] call OKS_fnc_EdenDestroyTask;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TASK_DESTROYTASK_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_Destroy_Task'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TASK_HOSTAGETASK {
                text = "Hostage Task";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TASK_HOSTAGETASK_CREATE",
                    "GOL_SCRIPTS_TASK_HOSTAGETASK_OPENFUNC"
                };
            };
            class GOL_SCRIPTS_TASK_HOSTAGETASK_CREATE {
                text = "Create";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenHostageTask;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TASK_HOSTAGETASK_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_Hostage'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_TASK_EVACUATEHVT {
                text = "Evacuate HVT";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TASK_EVACUATEHVT_CREATE",
                    "GOL_SCRIPTS_TASK_EVACUATEHVT_OPENFUNC"
                };
            };
            class GOL_SCRIPTS_TASK_EVACUATEHVT_CREATE {
                text = "Create";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenEvacuateHVT;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TASK_EVACUATEHVT_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_Evacuate_HVT'] call OKS_fnc_EdenOpenDocs;";
                conditionShow = "1";
            };

            class GOL_SCRIPTS_TASK_SETUPINTEL {
                text = "Setup Intel";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_TASK_SETUPINTEL_CREATE",
                    "GOL_SCRIPTS_TASK_SETUPINTEL_OPENFUNC"
                };
            };
            class GOL_SCRIPTS_TASK_SETUPINTEL_CREATE {
                text = "Create";
                action = "(uiNamespace getVariable 'BIS_fnc_3DENEntityMenu_data') call OKS_fnc_EdenSetupIntel;";
                conditionShow = "1";
            };
            class GOL_SCRIPTS_TASK_SETUPINTEL_OPENFUNC {
                text = "Open Function";
                picture = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
                action = "['OKS_fnc_SetupIntel'] call OKS_fnc_EdenOpenDocs;";
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

            // ── Add Vehicle Crew (selected vehicle) ──────────────────────────
            class GOL_SCRIPTS_ADD_VEHICLE_CREW {
                text = "Add Vehicle Crew";
                picture = "\a3\ui_f\data\Map\Markers\NATO\b_motor_inf.paa";
                value = 0;
                items[] = {
                    "GOL_SCRIPTS_ADD_VEHICLE_CREW_FULL",
                    "GOL_SCRIPTS_ADD_VEHICLE_CREW_DRIVER",
                    "GOL_SCRIPTS_ADD_VEHICLE_CREW_GUNNER",
                    "GOL_SCRIPTS_ADD_VEHICLE_CREW_COMMANDER"
                };
            };
            class GOL_SCRIPTS_ADD_VEHICLE_CREW_FULL {
                text = "Full Crew";
                picture = "\a3\ui_f\data\Map\Markers\NATO\b_mech_inf.paa";
                action = "[0] call OKS_fnc_EdenAddVehicleCrew;";
                conditionShow = "selectedObject";
            };
            class GOL_SCRIPTS_ADD_VEHICLE_CREW_DRIVER {
                text = "Driver Only";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\private_gs.paa";
                action = "[1] call OKS_fnc_EdenAddVehicleCrew;";
                conditionShow = "selectedObject";
            };
            class GOL_SCRIPTS_ADD_VEHICLE_CREW_GUNNER {
                text = "Gunner Only";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\corporal_gs.paa";
                action = "[2] call OKS_fnc_EdenAddVehicleCrew;";
                conditionShow = "selectedObject";
            };
            class GOL_SCRIPTS_ADD_VEHICLE_CREW_COMMANDER {
                text = "Commander Only";
                picture = "\a3\ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa";
                action = "[3] call OKS_fnc_EdenAddVehicleCrew;";
                conditionShow = "selectedObject";
            };

        };
    };
};