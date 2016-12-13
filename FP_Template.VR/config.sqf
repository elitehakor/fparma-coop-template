FP_VD = 2000; // Regular view distance
FP_OVD = 1800; // Regular object view distance
FP_VD_AIR = 5000; // View distance when piloting or gunning air vehicles
FP_OVD_AIR = 4500;  // Object view distance when piloting or gunning air vehicles

// The amount of allowed respawns per side
// if -1 = infinite respawn. 0 = zero respawn. can be higher
fp_jrm_respawns = [[
  [blufor, -1],
  [opfor, -1],
  [independent, -1],
  [civilian, -1]
], -1] call CBA_fnc_hashCreate;
