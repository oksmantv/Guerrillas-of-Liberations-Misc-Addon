class CfgFunctions // Defines a function
{	
	class OKS {
		class OKS_Packing {
			file = "\OKS_GOL_Misc\functions\staticWeapons";
			class Unpack_60mm_HE_Code {};
			class Unpack_60mm_HEAB_Code {};
			class Unpack_60mm_Smoke_Code {};
			class Unpack_60mm_Flare_Code {};
			class Deploy_AP_Drone_Code {};
			class Deploy_AT_Drone_Code {};
			class Deploy_Recon_Drone_Code {};
			class Deploy_Supply_Drone_Code {};			
			class Deploy_HMG_Code {};			
			class Deploy_GMG_Code {};			
			class Deploy_AT_Code {};			
			class Deploy_Mortar_Code {};			
			class Packing_code {};			
		};

		class OKS_Tasks {
			file = "\OKS_GOL_Misc\functions\tasks";
			class AddAction {};
			class AttachTo {};
			class ClearImmediateArea {};
			class Defuse_Explosive {};
			class Destroy_Barricade {};
			class Destroy_Barricade_Action {};
			class Destroy_Task {};
			class Evacuate_HVT {};
			class Fallback_Artillery {};			
			class RandomArtillery {};			
			class Hostage {};			
			class Task_Settings {};
			class TaskRun {};
			class NekyTasks {};
		};	

		class OKS_Logic {
			file = "\OKS_GOL_Misc\functions\logic";
			class GetClientId {};
			class LogDebug {};
			class FlagTeleport {};
			class SetMissionComplete {};
			class AddKilledScore {};	
			class AddCivilianKilled {};				
			class IncreaseMultiplier {};				
			class DecreaseMultiplier {};				
			class Ranks {};				
			class RespawnHandler {};				
			class DisableAPS {};				
		};			

		class OKS_Supply {
			file = "\OKS_GOL_Misc\functions\supply";
			class Ace_MHQDrop {};
			class Ace_Resupply {};
			class Ace_VehicleDrop {};
			class MapClose {};
			class MHQDrop {};
			class MHQDropMapClick {};
			class SpawnCrate {};
			class SetupMobileServiceStation {};
			class Supply {};
			class SupplyMapClick {};
			class VehicleDrop {};
			class VehicleDropMapClick {};
			class VehicleDropSetup {};
		};		

		class OKS_Tasks_Functions {
			file = "\OKS_GOL_Misc\functions\tasks\functions";
			class AvoidCasualties {};
			class AvoidCasualtiesKilled {};
			class AvoidDeaths {};
			class AvoidDeathsKilled {};
			class SetTaskState {};
		};	

		class NEKY_ServiceStation {
			file = "\OKS_GOL_Misc\functions\serviceStation";
			class MobileSS {};
			class Service_Settings {};
			class ServiceStation {};
		};

		class NEKY_ServiceStation_Functions {
			file = "\OKS_GOL_Misc\functions\serviceStation\functions";
			class Available {};
			class Busy {};
			class ExitLoop {};
			class Hints {};
			class Lights {};
			class Repair {};
			class ServiceAddActions {};
		};

		class OKS_Eden {
			file = "\OKS_GOL_Misc\functions\eden";
			class EdenHuntBase {};
			class EdenAirBase {};
			class EdenDestroyTask {};
			class EdenHostageTask {};
			class EdenLambsGroup {};
			class next3DENName {};
		};

		class OKS_Enemy {
			file = "\OKS_GOL_Misc\functions\enemy";
			class EnablePath {};
			class SetStatic {};
			class AbandonVehicle {};
			class AdjustDamage {};
			class ForceVehicleSpeed {};	
			class RemoveVehicleHE {};					
			class FaceSwap {};
			class Suppressed {};
			class Surrender {};			
			class SurrenderHandle {};			
			class ThrowWeaponsOnGround {};		
			class GetEthnicity {};
			class KilledCaptiveEvent {};
			class SetSurrendered {};
			class Has_Sight {};
			class AddVehicleCrew {};	
			class CreateVehicleWithCrew {};
			class HandleChance {};
			class CheckCooldown {};
			class Adjust_Shot {};
			class Adjust_NearFriendlies {};
			class Adjust_Unarmed {};
			class Adjust_Suppressed {};
			class Adjust_Flashbang {};	
		};		

		class OKS_Vehicles {
			file = "\OKS_GOL_Misc\functions\vehicles";
			class Mechanized {};				
			class Retexture {};
		};	
		
		class OKS_Helicopters {
			file = "\OKS_GOL_Misc\functions\vehicles\helicopters";
			class DAP_Config {};
			class HeliActions {};
			class Helicopter {};
			class Helicopter_Protection {};
			class Helicopter_Code {};
			class Interact_Apply {};
			class Interact_Copilot {};
			class Interact_DoorGunner {};
			class Interact_Pilot {};
			class SetPylonsToTurret {};
		};

		class OKS_RescueFriendly {
			file = "\OKS_GOL_Misc\functions\tasks\rescuefriendly";
			class MedicalCheck {};
			class MedicalDamage {};
			class MoveAI {};
			class Rescue_Friendly {};
			class Treat_Casualty {};
		};

		class OKS_PlayerSetup {
			file = "\OKS_GOL_Misc\functions\playersetup";
			class ACE_MoveMHQ {};
			class BLU_SetChannel {};
			class CheckFrameworkObjects {};
			class TFAR_RadioSetup {};
		};

		class OKS_PlayerSetup_ORBAT {
			file = "\OKS_GOL_Misc\functions\playersetup\orbat";
			class Orbat {};
			class Orbat_Action {};
			class Orbat_SetGroupInactive {};
			class Orbat_SetGroupParams {};
			class Orbat_Setup {};
		};		

		class OKS_PlayerSetup_ORBAT_Units {
			file = "\OKS_GOL_Misc\functions\playersetup\orbat\units";
			class Orbat_1stSquad {};
			class Orbat_1stSquad_Alpha {};
			class Orbat_1stSquad_Bravo {};
			class Orbat_2ndSquad {};
			class Orbat_2ndSquad_Alpha {};
			class Orbat_2ndSquad_Bravo {};
			class Orbat_Echo1 {};
			class Orbat_Echo2 {};
			class Orbat_Echo3 {};
			class Orbat_Hammer {};
			class Orbat_Platoon {};
		};				

		class OKS_Ambience {
			file = "\OKS_GOL_Misc\functions\ambience";
			class Chat {};
			class DeleteDeadAndObjects {};
			class Destroy_Houses {};
			class PowerGenerator {};
			class AddGeneratorAction {};
		};	

		class OKS_Dynamic {
			file = "\OKS_GOL_Misc\functions\dynamic";
			class Dynamic_Settings {};
			class Check_Waypoints {};
			class CheckIfTarmac {};
			class CheckRoadConnections {};
			class Civilians {};
			class CreateMarker {};
			class CreateObjectives {};
			class CreateTrigger {};
			class CreateUnitMarker {};
			class CreateZone {};
			class Dynamic_Hunt_Settings {};
			class Finale {};
			class Find_HuntBase {};
			class Find_Mortars {};
			class Find_Roadblocks {};
			class Garrison {};
			class Garrison_Compound {};
			class Garrison_Rooftops {};
			class Patrol_Spawn {};
			class Populate_Bunkers {};
			class Populate_Sandbag {};
			class Populate_StaticWeapons {};
			class Populate_Strongpoints {};
			class RoadConnected {};
			class Vehicle_Patrol {};
			class Vehicle_Waypoints {};
		};	

		class OKS_Hunt {
			file = "\OKS_GOL_Misc\functions\hunt";
			class hunt_settings {};
			class huntbase {};
			class huntrun {};
		};	

		class OKS_Hunt_Function {
			file = "\OKS_GOL_Misc\functions\hunt\functions";
			class hunting {};
			class repeat {};
			class scanzone {};
			class selectplayer {};
			class setSkill {};
			class huntspawn {};
		};

		class OKS_Spawn {
			file = "\OKS_GOL_Misc\functions\spawn";
			class AI_Battle {};
			class Attack_SpawnGroup {};
			class Civilian_Vehicle {};
			class Hold_Waypoint {};
			class Mechanized_Spawn {};
			class Follow_Squad {};
			class Scout {};
			class SpawnPatrol {};
			class SpawnStatic {};
			class AirSpawn {};
		};	

		class OKS_Spawn_Lambs {
			file = "\OKS_GOL_Misc\functions\spawn\lambs";
			class Lambs_Spawner {};
			class Lambs_SpawnGroup {};
			class Lambs_Wavespawn {};
			class Lambs_Wavespawn_Code {};
		};	

		class OKS_Spawn_Convoy {
			file = "\OKS_GOL_Misc\functions\spawn\convoy";
			class Convoy_Reinforce {};
			class Convoy_Spawn {};
		};	
					
		class OKS_Spawn_AntiAir_IR {
			file = "\OKS_GOL_Misc\functions\spawn\antiair_ir";
			class Forced_Reload {};
			class IR_AA {};
			class Remove_InfantryWeapons {};
			class Spawn_AntiAir_Soldier {};
			class Target_Finder {};
		};			

		class OKS_Spawn_Radar {
			file = "\OKS_GOL_Misc\functions\spawn\radar";
			class Ambient_AAA {};
			class Radar {};
			class SAM {};
			class SAM_Fired {};
		};	

		class OKS_Spawn_Arty {
			file = "\OKS_GOL_Misc\functions\spawn\arty";
			class ArtyFire {};
			class Check_Travel {};
			class ArtySuppression {};
		};		

		class OKS_Spawn_InfantryPincer {
			file = "\OKS_GOL_Misc\functions\spawn\infantrypincer";
			class FlankingMovement {};
			class SpawnInfantryPincer {};
			class SpawnInfantrySquad {};
			class SuppressiveFireMovement {};
		};		

		class OKS_JBOY_Talk {
			file = "\OKS_GOL_Misc\functions\ambience\Talk";
			class JBOY_Speak {};
		};
					
		class NEKY_Mortars {
			file = "\OKS_GOL_Misc\functions\mortars";
			class Mortars {};
			class Mortar_Settings {};
			class MortarAIReset {};
			class MortarAISequence {};
			class MortarMark {};
			class MortarShell {};
		};

		class NEKY_Airdrop {
			file = "\OKS_GOL_Misc\functions\airdrop";
			class Airbase {};
			class AirLoadout {};
			class AirDrop {};
			class AirDrop_Settings {};
			class AirDropAISkill {};
		};		

		class BLU_Medical {
			file = "\OKS_GOL_Misc\functions\medical";
			class displayText {};
			class medicalMessage {};
		};		

		class Radio_Channel_Init
		{
			file = "\OKS_GOL_Misc\functions\playersetup";
			preInit = 1;
			class BLU_SetChannel {};
		};	

		class OKS_Player_Setup
		{
			file = "\OKS_GOL_Misc\functions\playersetup";
			class SetupUnconsciousCamera {};
			class InventoryHandler {};
			class WarningSpeakerHandler {};
			class ORBATHandler {};
		};
	};
};
