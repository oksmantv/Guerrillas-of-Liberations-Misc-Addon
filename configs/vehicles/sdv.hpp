// Custom SDV variants preserve the vanilla vehicles while making the GOL
// low-observability and intercom upgrades independently selectable.
class B_SDV_01_F;
class GOL_B_SDV_01_F: B_SDV_01_F {
	scope = 2;
	scopeCurator = 2;
	forceInGarage = 1;
	displayName = "SDV [GOL]";
	camouflage = 0.5;
	audible = 0.1;
	radarTargetSize = 0.1;
	visualTargetSize = 0.1;
	irTarget = 0;
	TFAR_hasIntercom = 1;

	class ACE_SelfActions {
		class TFAR_IntercomChannel {
			displayName = "Intercom Channel";
			condition = "true";
			statement = "";
			icon = "";

			class TFAR_IntercomChannel_disabled {
				displayName = "Disabled";
				condition = "[_target, _player, -1] call TFAR_fnc_canSetIntercomChannel";
				statement = "[_target, _player, -1] call TFAR_fnc_setIntercomChannel";
			};
			class TFAR_IntercomChannel_1 {
				displayName = "Channel 1";
				condition = "[_target, _player, 0] call TFAR_fnc_canSetIntercomChannel";
				statement = "[_target, _player, 0] call TFAR_fnc_setIntercomChannel";
			};
			class TFAR_IntercomChannel_2 {
				displayName = "Channel 2";
				condition = "[_target, _player, 1] call TFAR_fnc_canSetIntercomChannel";
				statement = "[_target, _player, 1] call TFAR_fnc_setIntercomChannel";
			};
		};
	};
};

class O_SDV_01_F;
class GOL_O_SDV_01_F: O_SDV_01_F {
	scope = 2;
	scopeCurator = 2;
	forceInGarage = 1;
	displayName = "SDV [GOL]";
	camouflage = 0.5;
	audible = 0.1;
	radarTargetSize = 0.1;
	visualTargetSize = 0.1;
	irTarget = 0;
	TFAR_hasIntercom = 1;

	class ACE_SelfActions {
		class TFAR_IntercomChannel {
			displayName = "Intercom Channel";
			condition = "true";
			statement = "";
			icon = "";

			class TFAR_IntercomChannel_disabled {
				displayName = "Disabled";
				condition = "[_target, _player, -1] call TFAR_fnc_canSetIntercomChannel";
				statement = "[_target, _player, -1] call TFAR_fnc_setIntercomChannel";
			};
			class TFAR_IntercomChannel_1 {
				displayName = "Channel 1";
				condition = "[_target, _player, 0] call TFAR_fnc_canSetIntercomChannel";
				statement = "[_target, _player, 0] call TFAR_fnc_setIntercomChannel";
			};
			class TFAR_IntercomChannel_2 {
				displayName = "Channel 2";
				condition = "[_target, _player, 1] call TFAR_fnc_canSetIntercomChannel";
				statement = "[_target, _player, 1] call TFAR_fnc_setIntercomChannel";
			};
		};
	};
};

class I_SDV_01_F;
class GOL_I_SDV_01_F: I_SDV_01_F {
	scope = 2;
	scopeCurator = 2;
	forceInGarage = 1;
	displayName = "SDV [GOL]";
	camouflage = 0.5;
	audible = 0.1;
	radarTargetSize = 0.1;
	visualTargetSize = 0.1;
	irTarget = 0;
	TFAR_hasIntercom = 1;

	class ACE_SelfActions {
		class TFAR_IntercomChannel {
			displayName = "Intercom Channel";
			condition = "true";
			statement = "";
			icon = "";

			class TFAR_IntercomChannel_disabled {
				displayName = "Disabled";
				condition = "[_target, _player, -1] call TFAR_fnc_canSetIntercomChannel";
				statement = "[_target, _player, -1] call TFAR_fnc_setIntercomChannel";
			};
			class TFAR_IntercomChannel_1 {
				displayName = "Channel 1";
				condition = "[_target, _player, 0] call TFAR_fnc_canSetIntercomChannel";
				statement = "[_target, _player, 0] call TFAR_fnc_setIntercomChannel";
			};
			class TFAR_IntercomChannel_2 {
				displayName = "Channel 2";
				condition = "[_target, _player, 1] call TFAR_fnc_canSetIntercomChannel";
				statement = "[_target, _player, 1] call TFAR_fnc_setIntercomChannel";
			};
		};
	};
};