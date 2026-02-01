/*
    OKS_SatCamPiP vehicle camera profiles

    Returns a HashMap keyed by lowercase vehicle classname.

    Each profile is a HashMap with optional keys:
      commander_anchor: [anchorType, anchorData, offsetModel]
      driverRear_anchor: [anchorType, anchorData, offsetModel]
      driverRear_distance: distance behind rear bbox face (meters)
      driverRear_bboxInset: pushes the rear reference point forward from the bbox rear face (model +Y, meters)
      driverRear_heightAGL: OPTIONAL clamp camera height above terrain (meters); 0 = disabled
      driverRear_alignToDriverOptics: OPTIONAL bool; aligns rear cam X/Z to driver optics (can be too high)
      driverRear_useGeomRear: OPTIONAL bool; raycasts vehicle GEOM to find true rear surface (helps small vehicles)

    anchorType:
      "bboxTop"       - top-center of bounding box
      "bboxRearTop"   - rear-top-center of bounding box
      "bboxRearMid"   - rear-middle (half height) of bounding box
      "bboxRearLow"   - rear-low (25% height) of bounding box
      "mem"          - model selection/memory point name (anchorData is STRING)
      "model"        - explicit model-space position (anchorData is ARRAY [x,y,z])

    offsetModel: model-space offset added to the anchor before converting to world (ARRAY [x,y,z])

    Notes:
    - Defaults (when no profile exists):
      commander_anchor  -> bboxTop
      driverRear_anchor -> bboxRearLow
*/

private _profiles = createHashMap;

// Example overrides (add more as needed):
// _profiles set ["b_apc_wheeled_01_cannon_f", createHashMapFromArray [
//     ["commander_anchor", ["mem", "commanderview", [0,0,0]]],
//     ["driverRear_anchor", ["bboxRearTop", [], [0,0,0.2]]],
//     ["driverRear_bboxInset", 0.25],
//     ["driverRear_distance", 0.05]
//     ["driverRear_heightAGL", 0.5]
// ]];

_profiles
