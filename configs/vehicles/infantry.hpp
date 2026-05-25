	class Man;
	class CAManBase: Man {
		class ACE_SelfActions {
			class ACE_Equipment {
				class Drones {
					displayName = "Drones";
					condition = "vehicle _player == _player";
					statement = "";
					exceptions[] = {};
					icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";

					class Deploy_Drone_AP {
						displayName = "Deploy Drone (AP)";
						condition = "('GOL_Packed_Drone_AP' in (itemsWithMagazines _player)) && vehicle _player == _player";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_Deploy_AP_Drone_Code;";
						icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
					};

					class Convert_Drone_AP_To_Throwable {
						displayName = "Convert Drone (AP) to Throwable";
						condition = "('GOL_Packed_Drone_AP' in (itemsWithMagazines _player)) && vehicle _player == _player";
						exceptions[] = {};
						statement = "[0.5, [_player], { [_this select 0,'AP'] call OKS_fnc_Convert_Packed_Drone_To_Throwable; }, {}, 'Converting...'] call ace_common_fnc_progressBar;";
						icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
					};

					class Deploy_Drone_AT {
						displayName = "Deploy Drone (AT)";
						condition = "('GOL_Packed_Drone_AT' in (itemsWithMagazines _player)) && vehicle _player == _player";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_Deploy_AT_Drone_Code;";
						icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
					};

					class Convert_Drone_AT_To_Throwable {
						displayName = "Convert Drone (AT) to Throwable";
						condition = "('GOL_Packed_Drone_AT' in (itemsWithMagazines _player)) && vehicle _player == _player";
						exceptions[] = {};
						statement = "[0.5, [_player], { [_this select 0,'AT'] call OKS_fnc_Convert_Packed_Drone_To_Throwable; }, {}, 'Converting...'] call ace_common_fnc_progressBar;";
						icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
					};

					class Deploy_Drone_Recon {
						displayName = "Deploy Drone (Recon)";
						condition = "('GOL_Packed_Drone_Recon' in (itemsWithMagazines _player)) && vehicle _player == _player";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_Deploy_Recon_Drone_Code;";
						icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
					};

					class Deploy_Drone_Supply {
						displayName = "Deploy Drone (Supply)";
						condition = "('GOL_Packed_Drone_Supply' in (itemsWithMagazines _player)) && vehicle _player == _player";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_Deploy_Supply_Drone_Code;";
						icon = "\OKS_GOL_Misc\Data\UI\GOL_Drone_Packed.paa";
					};
				};

				class Unpack_60mm_HE {
					displayName = "Unpack 60mm HE";
					condition = "('GOL_Packed_60mm_HE' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Unpack_60mm_HE_Code";
					icon = "\OKS_GOL_Misc\Data\UI\60mm_HE.paa";
				};
				
				class Unpack_60mm_HEAB {
					displayName = "Unpack 60mm HEAB";
					condition = "('GOL_Packed_60mm_HEAB' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Unpack_60mm_HEAB_Code";
					icon = "\OKS_GOL_Misc\Data\UI\60mm_HEAB.paa";
				};

				class Unpack_60mm_Smoke {
					displayName = "Unpack 60mm Smoke";
					condition = "('GOL_Packed_60mm_Smoke' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Unpack_60mm_Smoke_Code";
					icon = "\OKS_GOL_Misc\Data\UI\60mm_Smoke.paa";
				};

				class Unpack_60mm_Flare {
					displayName = "Unpack 60mm Flare";
					condition = "('GOL_Packed_60mm_Flare' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Unpack_60mm_Flare_Code";
					icon = "\OKS_GOL_Misc\Data\UI\60mm_Flare.paa";
				};

				class Deploy_Static_HMG {
					displayName = "Deploy Static HMG";
					condition = "('GOL_Packed_HMG' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Deploy_HMG_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_HMG_Packed.paa";
				};

				class Deploy_Static_GMG {
					displayName = "Deploy Static GMG";
					condition = "('GOL_Packed_GMG' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Deploy_GMG_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_GMG_Packed.paa";
				};

				class Deploy_Static_AT {
					displayName = "Deploy Static AT";
					condition = "('GOL_Packed_AT' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Deploy_AT_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_AT_Packed.paa";
				};

				class Deploy_Static_Mortar {
					displayName = "Deploy Static Mortar";
					condition = "('GOL_Packed_Mortar' in (itemsWithMagazines _player)) && vehicle _player == _player";
					exceptions[] = {};
					statement = "[_player] call OKS_fnc_Deploy_Mortar_Code";
					icon = "\OKS_GOL_Misc\Data\UI\GOL_Mortar_Packed.paa";
				};

				class DroneJammer {
					displayName = "Drone Jammer";
					condition = "('OKS_DroneJammer' in (items _player))";
					statement = "";
					exceptions[] = {};
					icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\radio_ca.paa";

					class ActivateJammer {
						displayName = "Activate Jammer";
						condition = "!(_player getVariable ['OKS_JammerActive', false]) && ('OKS_DroneJammer' in (items _player)) && !((vehicle _player) getVariable ['OKS_VehicleJammerActive', false])";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_DroneJammer_Init;";
						icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\radio_ca.paa";
					};

					class DeactivateJammer {
						displayName = "Deactivate Jammer";
						condition = "(_player getVariable ['OKS_JammerActive', false])";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_DroneJammer_Cleanup;";
						icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\radio_ca.paa";
					};
				};

				class DroneDetector {
					displayName = "Drone Detector";
					condition = "('OKS_DroneDetector' in (items _player))";
					statement = "";
					exceptions[] = {};
					icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";

					class ActivateDetector {
						displayName = "Activate Detector";
						condition = "!(_player getVariable ['OKS_DetectorActive', false]) && ('OKS_DroneDetector' in (items _player))";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_DroneDetector_Init;";
						icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";
					};

					class DeactivateDetector {
						displayName = "Deactivate Detector";
						condition = "(_player getVariable ['OKS_DetectorActive', false])";
						exceptions[] = {};
						statement = "[_player] call OKS_fnc_DroneDetector_Cleanup;";
						icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\search_ca.paa";
					};
				};					
			};
		};
	};

