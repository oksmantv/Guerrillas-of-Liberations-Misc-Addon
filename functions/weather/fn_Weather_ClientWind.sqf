if (!hasInterface) exitWith {};

while {missionNamespace getVariable ["GOL_Weather_SnowstormActive", false]} do {
    playSound "GOL_Weather_Wind";
    sleep 42;
};