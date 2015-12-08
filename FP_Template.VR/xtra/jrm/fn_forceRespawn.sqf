/*
	Function: FP_JRM_fnc_forceRespawn

	Description:
		Force respawns of all current dead units
		Should be called on all computers if it is a global respawn
		Can also be used to respawn a single unit when called locally

	Parameters:
	_posOrCode - A marker, object, position,  or code (can also be string code) (_this select 0 will be the unit for code)
		If position, will be teleported there after exiting spectator
		If nil, ace spectator will teleport the unti back to where he was when entering spectator (respawn pos)
	_reset - Clear all previous dead units [Default: false]

	Author:
	Cuel 2015-05-15
*/

params ["_posOrCode", ["_reset", false]];

if (_reset) then {
	FP_JRM_lives = FP_JRM_respawns;
	if (isServer) then {
		FP_JRM_savedState = [];
		publicVariable "FP_JRM_savedState";
	};
};

if (!hasInterface || {!ACE_spectator_isSet}) exitWith {};

// Figure out if a marker or code was passed, or a position
private ["_function", "_pos"];
if (!isNil "_posOrCode") then {
	if (typeName _posOrCode == typeName {}) then {
		_function = _posOrCode;
	} else {
		if (typeName _posOrCode == typeName "") then {
			_function = missionNamespace getVariable _posOrCode;
			if (isNil "_function") then {
				_pos = markerPos _posOrCode;
			};
		} else {
			_pos = _posOrCode call CBA_fnc_getPos;
		};
	};
};

[_pos, _function] spawn {
	params ["_pos", "_function"];

	// For some reason the game crashes when using call instead of spawn here.. no idea why
	private _sc1 = [false] spawn ace_spectator_fnc_setSpectator;
	private _sc2 = [player, false] spawn ace_spectator_fnc_stageSpectator;
	waitUntil {scriptDone _sc1 && scriptDone _sc2};

	if (!isNil "_pos" && {_pos distance [0,0] > 5}) then {
		player setPos _pos;
	} else {
		if (!isNil "_function") then {
			[player] call _function;
		};
	};
};
