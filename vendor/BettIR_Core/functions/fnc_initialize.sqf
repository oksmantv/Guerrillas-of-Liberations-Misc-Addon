/*
    Initializes the embedded GOL IR illuminator runtime state.
    This is idempotent so manual keybinds and the OX3000 controller can safely
    call it before the post-init scheduler has completed.
*/

if (missionNamespace getVariable ["GOL_IRLLM_Initialized", false]) exitWith { true };

if (isNil "GOL_IRLLM_fnc_getCompatibleNVGs" || isNil "GOL_IRLLM_fnc_getCompatibleWeaponAttachments") exitWith { false };

BettIR_CompatibleNVGsData = [] call GOL_IRLLM_fnc_getCompatibleNVGs;
BettIR_CompatibleNVGs = BettIR_CompatibleNVGsData select 0;
BettIR_CompatibleNVGsOffsets = BettIR_CompatibleNVGsData select 1;

BettIR_CompatibleAttachmentsData = [] call GOL_IRLLM_fnc_getCompatibleWeaponAttachments;
BettIR_CompatibleAttachments = BettIR_CompatibleAttachmentsData select 0;
BettIR_CompatibleAttachmentsOffsets = BettIR_CompatibleAttachmentsData select 1;

BettIR_UnitList = [];
BettIR_UnitList_LastUpdate = time;
BettIR_UnitList_UpdateInterval = 0.5;
BettIR_EachFrameHandlerId = -1;

missionNamespace setVariable ["GOL_IRLLM_Initialized", true];
diag_log format ["[GOL_IRLLM] Initialized: %1 compatible weapon attachments.", count BettIR_CompatibleAttachments];
true;
