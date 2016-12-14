/*
	Function: FP_JRM_fnc_init

	Description:
        Initializes the jip and respawn manager.
        This function is called automatically.
*/

#include "script_macros.hpp"

// hash of uids with remanining respawns. format [respawns, msTime on respawn]. read only on clients
if (isNil "fp_jrm_state") then {fp_jrm_state = [] call CBA_fnc_hashCreate};

if (isServer) then {
  ["fp_jrm_onDeath", fp_jrm_fnc_update] call CBA_fnc_addEventHandler;

  addMissionEventHandler ["HandleDisconnect", {
    params ["_unit", "", ["_uid", ""]];
    if (_uid != "" && {_unit getVariable ["ACE_isUnconscious", false]}) then {
      [_uid, side group _unit] call fp_jrm_fnc_update;
    };
    false
  }];
};

if (hasInterface) then {
  player addEventHandler ["Respawn", {
    // ignore zeus
    if (!isNull (getAssignedCuratorLogic player)) exitWith {};

    private _uid = getPlayerUID player;
    private _default = [fp_jrm_respawns, side group player] call CBA_fnc_hashGet;
    GET_UID_DATA(_uid) params [["_remainingRespawns", _default];
    if (_remainingRespawns isEqualTo 0) then {
      [true] call FP_fnc_spectate;
      private _msg = format ["%1 is spectating. (%2 total)", name player, count (call FP_jrm_fnc_getSpectators)];
      [objNull, _msg] remoteExecCall ["bis_fnc_showCuratorFeedbackMessage", 0];
    };
    ["fp_jrm_onDeath", [_uid, side group player]] call CBA_fnc_serverEvent;
  }];

  GET_UID_DATA(getPlayerUID player) params [["_remainingRespawns", -1]];
  // check if player was dead and has reconnented
  if (_remainingRespawns isEqualTo 0) then {
    // use spawn here to ensure briefing screen is gone
    // it seems to also work for ace spect camera at [0 ,0] bug
    [] spawn {
      sleep 1;
      {[true] call FP_fnc_spectate} call CBA_fnc_directCall;
      private _msg = format ["%1 is spectating. (%2 total)", name player, count (call FP_jrm_fnc_getSpectators)];
      [objNull, _msg] remoteExecCall ["bis_fnc_showCuratorFeedbackMessage", 0];
    };
  };
};

// Add ARES respawn functionality
if (!isNil "Ares_fnc_RegisterCustomModule" && isNil "FP_ares_jrm") then {
  FP_ares_jrm = compile preprocessFileLineNumbers "fp\functions\jrm\ares_respawn_functions.sqf";
  private _text = "FP - Respawn";
  // Respawns and moves all players (that can fit) inside the cargo of a specific vehicle
  [_text, "Single unit at position", {["SINGLE", _this select 0] call FP_ares_jrm}] call Ares_fnc_RegisterCustomModule;
  // Respawns and moves all dead players to a position
  [_text, "All units at position", {["POSITION", _this select 0] call FP_ares_jrm}] call Ares_fnc_RegisterCustomModule;
  // Respawns and moves all players (that can fit) inside the cargo of a specific vehicle
  [_text, "Fill vehicle cargo", {["CARGO", _this select 1] call FP_ares_jrm}] call Ares_fnc_RegisterCustomModule;
};
