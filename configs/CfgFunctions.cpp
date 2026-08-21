class CfgFunctions // Defines a function
{	
	class OKS {
		class OKS_Packing {
			file = "\OKS_GOL_Misc\functions\staticWeapons";
			class FPV_Deploy_Override {};
			class FPV_Connect_Client {};
			class Unpack_60mm_HE_Code {};
			class Unpack_60mm_HEAB_Code {};
			class Unpack_60mm_Smoke_Code {};
			class Unpack_60mm_Flare_Code {};
			class Deploy_AP_Drone_Code {};
			class Deploy_AT_Drone_Code {};
			class Deploy_Recon_Drone_Code {};
			class Deploy_Supply_Drone_Code {};			
			class Convert_Packed_Drone_To_Throwable {};
			class Deploy_HMG_Code {};			
			class Deploy_GMG_Code {};			
			class Deploy_AT_Code {};			
			class Deploy_Mortar_Code {};			
			class Packing_code {};		
			class M6_Fired_Combined_Handler {};			
			class M6_Auto_Reload_Handler {};
			class M6_Add_Unpack_Actions {};
			class M6_Flare_Altitude_Deploy {};
			class ProxRound_Init {};
			class ProxRound_FiredHandler {};
			class ProxRound_TrackRound {};
		};

		class OKS_Tasks {
			file = "\OKS_GOL_Misc\functions\tasks";
			class AddAction {};
			class AddSearchIntelAction {};
			class AddMultipleSearchIntelActions {};
			class AttachTo {};
			class ClaimIntel {};
			class ClearImmediateArea {};
			class Defuse_Explosive {};
			class Destroy_Barricade {};
			class Destroy_Barricade_Action {};
			class Destroy_Task {};
			class Deliver_Supplies {};
			class Insert_Task {};
			class Evacuate_HVT {};
			class Fallback_Artillery {};			
			class RandomArtillery {};			
			class Hostage {};			
			class Request_Intel {};
			class Task_Settings {};
			class TaskRun {};
			class NekyTasks {};
			class SetupIntel {};
			class GiveIntelToNearestPlayer {};
		};	

		class OKS_Tasks_InterceptHVT {
			file = "\OKS_GOL_Misc\functions\tasks\InterceptHVT";
			class InterceptHvtTask {};
			class InterceptHvt_SelectVehicle {};
			class InterceptHvt_MountGroup {};
			class InterceptHvt_StartEscortTrail {};
			class InterceptHvt_HandleDisabledVehicle {};
			class InterceptHvt_GarrisonEnd {};
			class InterceptHvt_HandleMountedSurrender {};
			class InterceptHvt_SetHvtSurrendered {};
			class InterceptHvt_UpdateTrackedTaskPos {};
		};

		class OKS_Tasks_RescueSurvivor {
			file = "\OKS_GOL_Misc\functions\tasks\RescueSurvivor";
			class RescueSurvivorTask {};
			class RescueSurvivor_MedCheck {};
			class RescueSurvivor_ExtractMonitor {};
		};

		class OKS_Logic {
			file = "\OKS_GOL_Misc\functions\logic";
			class GetClientId {};
			class LogDebug {};
			class TrimLeadingAndTrailingWhitespaceFromString {};
			class SteerVehicleToTarget {};
			class FlagTeleport {};
			class SetMissionComplete {};
			//class AddKilledScore {};
			//class AddCivilianKilled {};
			class IncreaseMultiplier {};
			class DecreaseMultiplier {};
			class Ranks {};
			class RespawnHandler {};
			class DisableAPS {};
			class SelectRandomPosition {};
			class GlobalKilledEventHandler {};
		};

		class OKS_Supply {
			file = "\OKS_GOL_Misc\functions\supply";
			class Ace_MHQDrop {};
			class Ace_Resupply {};
			class Ace_VehicleDrop {};
			class AddMSSRearm3CBAction {};
			class AI_ResupplyDrop {};
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

		class OKS_Eden {
			file = "\OKS_GOL_Misc\functions\eden";
			class EdenPosFromArray {};
			class EdenSanitizePos {};
			class EdenGetOrCreateLayer {};
			class EdenSetLayerSafe {};
			class EdenRememberLastAction {};
			class EdenRepeatLastAction {};
			class EdenClipboardCacheAdd {};
			class EdenClipboardCacheExportClear {};
			class EdenFindPosIn {};
			class EdenTemplateStaticUnits {};
			class EdenTemplateStaticGarrison {};
			class EdenTemplatePatrol {};
			class EdenAirScout {};
			class EdenAirSpawn {};
			class EdenBeachLanding {};
			class EdenMortars {};
			class EdenAmbientAAA {};
			class EdenRadar {};
			class EdenSAM {};
			class EdenSHORAD {};
			class EdenArtyFire {};
			class EdenBallisticMissile {};
			class EdenDroneHuntZone {};
			class EdenHuntBase {};
			class EdenAirBase {};
			class EdenDestroyTask {};
			class EdenInsertTask {};
			class EdenHostageTask {};
			class EdenDeliverSupplies {};
			class EdenEvacuateHVT {};
			class EdenSetupIntel {};
			class EdenLambsGroup {};
			class EdenLambsWaveSpawn {};
			class EdenAIBattle {};
			class EdenConvoySpawn {};
			class EdenAttackSpawnGroup {};
			class EdenMechanizedSpawn {};
			class EdenVehicleOnRails {};
			class EdenSearchLight {};
			class EdenOpenDocs {};
			class EdenExtractGearFromAI {};
			class EdenCopyAircraftLoadout {};
			class EdenSetTriggerIgnoreAAC {};
			class next3DENName {};
			class EdenMarkOrgStrength {};
			class EdenMarkFrontlineDoubleRect {};
			class EdenFrontlineNodePlace {};
			class EdenFrontlineCreateFromNodes {};
			class EdenFrontlineNodeOnPasteRenumber {};
			class CopyAndElevateObjects {};
			class CopyAndElevateObjectsMenu {};
			class EdenAddVehicleCrew {};
			class EdenBuildingRestCamp {};
			class EdenChat {};
		};

		class OKS_Zeus {
			file = "\OKS_GOL_Misc\functions\zeus";
			class ApplyUnitGear {};
			class SetupMechanized {};				
			class SetupHelicopter {};				
			class SetupMHQ {};							
		};

		class OKS_Modules {
			file = "\OKS_GOL_Misc\functions\modules";
			class ModuleMortars {};
			class ModuleRadar {};
			class ModuleArtyFire {};
			class ModuleArtySuppression {};
			class ModuleLambsSpawnGroup {};
			class ModuleConvoy {};
			class ModuleAmbientAAA {};
			class ModuleSAM {};
			class ModuleSHORAD {};
			class ModuleHuntBase {};
			class ModuleAirBase {};
		};				

		class OKS_Enemy {
			file = "\OKS_GOL_Misc\functions\enemy";
			class ReplaceUnitGear {};
			class EnablePath {};
			class SetStatic {};
			class AbandonVehicle {};
			class SearchLight {};
			class AdjustDamage {};
			class ForceVehicleSpeed {};	
			class RemoveVehicleHE {};					
			class FaceSwap {};
			class GetEthnicity {};
			class GetEthnicityFromFace {};
			class Has_Sight {};
			class AddVehicleCrew {};
			class ActivateHiddenVehicle {};
			class CreateVehicleWithCrew {};
			class UndercoverAI {};	
			class UndercoverAI_Activate {};	
			class RestCamp {};
			class RestCamp_WakeUp {};
			class GarrisonBuildingsInArea {};
		};	

		class OKS_Stealth_Core {
			file = "\OKS_GOL_Misc\functions\stealth\core";
			class Stealth_Init {};
			class Stealth_AutoEnable {};
			class Stealth_PlayerVisibility {};
			class Stealth_GetLightingServer {};
			class Stealth_ReceiveLighting {};
			class Stealth_EnemyRadio {};
			class Stealth_EnemyTalk {};
			class Stealth_FindNearRadioMen {};
			class Stealth_CallRadioHelp {};
			class Stealth_SentryAlert {};
		};

		class OKS_Stealth_Sentry {
			file = "\OKS_GOL_Misc\functions\stealth\sentry";
			class Stealth_EnemySentry {};
			class Stealth_EnemySentry_CreateUnit {};
			class Stealth_EnemySentry_SetupUnit {};
			class Stealth_EnemySentry_Yell {};
			class Stealth_EnemySentry_IgnoreAir {};
			class Stealth_EnemySentry_Call_Hunters {};
			class Stealth_EnemySentry_Call_Hunters_Lambs {};
		};

		class OKS_Stealth_Tracking {
			file = "\OKS_GOL_Misc\functions\stealth\tracking";
			class Stealth_SendDetectionFlare {};
			class Stealth_InitiateHunterResponse {};
			class Stealth_FindNearestRadioAndCallForHelp {};
			class Stealth_Hunted {};
			class Stealth_Tracker {};
		};
		
		class OKS_IRIlluminator {
			file = "\OKS_GOL_Misc\functions\irilluminator";
			class IRIlluminator_Monitor {};
			class IRIlluminator_InitSettings {};
			class IRIlluminator_AdjustStrength {};
			class IRIlluminator_DebugTest {};
			class IRIlluminator_WeaponIlluminatorOn {};
		};
		
		class OKS_Suppression {
			file = "\OKS_GOL_Misc\functions\enemy\suppression";
			class Suppressed {};
			class SuppressedHandler {};
		};	
		
		class OKS_Surrender {
			file = "\OKS_GOL_Misc\functions\enemy\surrender";
			class Adjust_Shot {};
			class Adjust_NearFriendlies {};
			class Adjust_Unarmed {};
			class Adjust_Suppressed {};
			class Adjust_Flashbang {};	
			class CheckCooldown {};
			class HandleChance {};					
			class Surrender {};			
			class SurrenderHandle {};			
			class SetSurrendered {};
			class ThrowWeaponsOnGround {};	
			class WaitUntilCaptiveAtBase {};
		};			

		class OKS_Camera {
			file = "\OKS_GOL_Misc\functions\helpers\camera";
			class SatCamPipStart {};
			class SatCamPipStop {};
			class SatCamPipStartForVehicleCargo {};
			class SatCamPipStartFollowUnitView {};
			class SatCamPipStartFollowVehicleCommanderView {};
			class SatCamPipStartVehicleDriverReverse {};
			class SatCamPipStartForVehicleCargoCommanderView {};
			class SatCamPipToggleCommanderView {};
			class SatCamPipCommanderZoomIn {};
			class SatCamPipCommanderZoomOut {};
			class SatCamPipCycleVisionMode {};
			class SatCamPipDebugVehicle {};
			class SatCamPipRearCamTestAnchor {};
		};

		class OKS_Vehicles {
			file = "\OKS_GOL_Misc\functions\vehicles";
			class Retexture {};
		};

		class OKS_Vehicles_GroundVehicles {
			file = "\OKS_GOL_Misc\functions\vehicles\groundVehicles";
			class Mechanized {};				
			class RailMove {};
			class VehicleEmpty {};
			class AmphibiousBoostInit {};
			class Rearm3CBVehicle {};
			class SetupServiceStation {};
			class SetupCargoItems {};
			class Setup3CBVehicleAmmo {};
			class SetupVehicleInventory {};
			class SetupCargoSpace {};
			class AdjustPlayerVehicleDamage {};
			class DebugVehicleDamage {};
			class ToggleATGM {};
		};

		class OKS_Vehicles_MissileWarning {
			file = "\OKS_GOL_Misc\functions\vehicles\missileWarning";
			class MissileWarning {};
			class MissileDeflect {};
			class SetupMissileWarning {};				
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
			class M230_SwapAmmo {};
			class M230_SetPylon {};
		};

		class OKS_Jets {
			file = "\OKS_GOL_Misc\functions\vehicles\jets";
			class Jet {};
			class JetAWSInit {};
			class AircraftFlareSupportInit {};
			class AWSNoop {};
			class VisibleFlareOnFired {};
			class VisibleFlareAttachLight {};
		};		

		class OKS_RescueFriendly {
			file = "\OKS_GOL_Misc\functions\tasks\rescuefriendly";
			class MedicalCheck {};
			class MedicalDamage {};
			class MoveAI {};
			class Rescue_Friendly {};
			class Treat_Casualty {};
		};

		class OKS_Paradrop {
			file = "\OKS_GOL_Misc\functions\paradrop";
			class SetupParadrop {};
			class ParadropActions {};
			class StaticJump_Hook {};
			class StaticJump_Action {};
			class StaticJump_Code {};
			class StaticJump_EventCode {};
		};

		class OKS_ScudIntercept {
			file = "\OKS_GOL_Misc\functions\scudIntercept";
			class ScudIntercept_RegisterLauncher {};
			class ScudIntercept_OnFired {};
			class ScudIntercept_PickTargetPos {};
			class ScudIntercept_LaunchAI {};
			class VLS_SimpleLaunchAndDelete {};
		};

		class OKS_PlayerSetup {
			file = "\OKS_GOL_Misc\functions\playersetup";
			class SetupUnconsciousCamera {};
			class InventoryHandler {};
			class WarningSpeakerHandler {};
			class ORBATHandler {};
			class ACE_MoveMHQ {};
			class BLU_SetChannel {};
			class TFAR_RadioSetup {};
			class FastropeDamageProtection {};
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
			class aaAmbient {};
			class AddGeneratorAction {};
			class AlarmSound {};
			class Chat {};
			class ChatGlobal {};
			class CreateExplosion {};
			class DeleteDeadAndObjects {};
			class Destroy_Houses {};
			class Fire {};
			class IncomingAlarm {};
			class MortarZone {};
			class PowerGenerator {};
			class SignalFlare {};
			class AddExplosiveEffect {};
		};	

		class OKS_Dynamic {
			file = "\OKS_GOL_Misc\functions\dynamic";
			class Dynamic_Settings {};
			class Check_Waypoints {};
			class CheckIfTarmac {};
			class CheckRoadConnections {};
			class Civilians {};
			class ClearCivilians {};
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
			class AI_ArtilleryBattle {};
			class AI_HelicopterFlyBy {};
			class AmphibiousAssault {};
			class BeachLanding {};
			class BeachLandingPostDismountTasking {};
			class BeachLandingInstallNoRemount {};
			class Attack_SpawnGroup {};
			class Civilian_Vehicle {};
			class Hold_Waypoint {};
			class Mechanized_Spawn {};
			class RailVehicle_Spawn {};
			class Follow_Squad {};
			class Scout {};
			class AirScout {};
			class SpawnStatic {};
			class AirCargoDrop {};
			class AirStrike {};
			class AirSpawn {};
			class DroneHuntZone {};
			class Helicopter_Attack {};
			class BuildingRestCamp {};
			class Inactive_VehicleSpawn {};
		};

		class OKS_Jammer {
			file = "\OKS_GOL_Misc\functions\jammer";
			class DroneJammer_Init {};
			class DroneJammer_Cleanup {};
			class DroneJammer_GetNearbyCarriers {};
			class DroneJammer_UpdateHUD {};
			class DroneDetector_Init {};
			class DroneDetector_Cleanup {};
			class DirectionToText {};
		};
		
		class OKS_Disruptor {
			file = "\OKS_GOL_Misc\functions\disruptor";
			class DroneDisruptor_Fired {};
		};

		class OKS_Drones {
			file = "\OKS_GOL_Misc\functions\drones";
			class DroneHuntZone_Patrol {};
			class DroneHuntZone_Attack {};
			class DroneHuntZone_Terminal {};
			class DroneHuntZone_Detonate {};
		};

		class OKS_Helpers {
			file = "\OKS_GOL_Misc\functions\helpers";
			class ClearWaypoints {};
			class DroneHelper_NormalizePos {};
			class DroneHelper_GetZoneInfo {};
			class DroneHelper_SelectTarget {};
			class DroneHelper_GetAimPoint {};
		};
	
		class OKS_Spawn_Lambs {
			file = "\OKS_GOL_Misc\functions\spawn\lambs";
			class Lambs_Spawner {};
			class Lambs_SpawnGroup {};
			class Lambs_Wavespawn {};
			class Lambs_Wavespawn_Code {};
			class LambsChargeSpawn {};
		};	

		class OKS_Spawn_Convoy {
			file = "\OKS_GOL_Misc\functions\spawn\convoy";
			class Convoy_Reinforce {};
			class Convoy_Spawn {};
			class Convoy_SpawnBody {};

		};

		class OKS_Spawn_Convoy_ConvoyHelper {
			file = "\OKS_GOL_Misc\functions\spawn\convoy\helper";
			class Convoy_AssignParkingAtEnd {};
			class Convoy_AssignReserveWaypoint {};
			class Convoy_CheckAndAdjustSpeeds {};
			class Convoy_EndParking_AssignIndices {};
			class Convoy_InitIntendedSlots {};
			class Convoy_IsBlocked {};
			class Convoy_LeadArrivalMonitor {};
			class Convoy_MakeSlot {};
			class Convoy_MonitorReserveActivation {};
			class Convoy_NearestRoadTowardsOrigin {};
			class Convoy_PlaceDebugObject {};
			class Convoy_ProximityCombatFill {};
			class Convoy_PullOffHelper {};
			class Convoy_SetupHerringBone {};
			class Convoy_FindClearSlot {};
			class Convoy_WaitUntilCasualties {};
			class Convoy_WaitUntilCombat {};
			class Convoy_WaitUntilTargets {};
			class Convoy_DeleteAllWaypoints {};
			class Convoy_DismountAndTaskCode {};
			class Convoy_TaskTracker {};
			class VehicleAttachSquad {};
		};
		
		class OKS_Spawn_Convoy_AirDefence {
			file = "\OKS_GOL_Misc\functions\spawn\convoy\airdefence";
			class Convoy_AAMergeGapHandler {};
			class Convoy_CheckDedicatedAAAvailable {};
			class Convoy_EnsureMinRoadDistance {};
			class Convoy_FindEnemyAirTargets {};
			class Convoy_IsEnemySide {};
			class Convoy_IsOffRoad {};
			class Convoy_IsFlatTerrain {};
			class Convoy_SelectAAVehicle {};
			class Convoy_WaitUntilAirTarget {};
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

		class OKS_Spawn_SHORAD {
			file = "\OKS_GOL_Misc\functions\spawn\shorad";
			class SHORAD {};
			class SHORAD_Fired {};
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

		class OKS_Intercom {
			file = "\OKS_GOL_Misc\functions\playersetup";
			class CollectIntercomHeadgear {};
		};

		class OKS_Mortar {
			file = "\OKS_GOL_Misc\functions\mortar";
			class OpenM6RangeCard {};
			class M6RangeCardOnLoad {};
			class M6RangeCardStep {};
			class M6_BallisticsFix {};
		};

		class ace_irlight {
			file = "\OKS_GOL_Misc\functions\compat\ace_irlight";
			class initItemContextMenu {};
		};

		class compat {
				file = "\OKS_GOL_Misc\functions\compat";
				class BettIR_AutoWeaponIlluminator {};		};
        };
};