/**
* Update single uid state
*/

#include "script_macros.hpp"

params [["_uidOrCmd", "", [""]], "_side"]
if (!isServer || {_uidOrCmd == ""}) exitWith {};

if (_uidOrCmd == "reset") exitWith {
  fp_jrm_state = [] call CBA_fnc_hashCreate;
  publicVariable "fp_jrm_state";
};

private _respawns = [fp_jrm_respawns, _side] call CBA_fnc_hashGet;
if (_respawns > -1) then {
  GET_UID_DATA(_uidOrCmd) params [["_remainingRespawns", _respawns]];
  [fp_jrm_state, _uidOrCmd, [(_remainingRespawns - 1) max 0, CBA_missionTime]] call CBA_fnc_hashSet;
  publicVariable "fp_jrm_state";
};
