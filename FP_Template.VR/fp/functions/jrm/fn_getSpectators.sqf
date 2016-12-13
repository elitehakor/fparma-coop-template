/*
	Function: FP_JRM_fnc_getSpectators

	Description:
        Returns (alive and connected) spectators as player objects

    Parameter:
        _amount - Max ammount to return (default: all)

    Returns:
        Array

	Author:
	Cuel 2015-12-10
*/

params [["_maxReturnAmount", -1]];
private _plrs = [] call CBA_fnc_players;
private _uids = _plrs apply {getPlayerUID _x};
private _aliveUids = [];

[fp_jrm_state, {
  _value params [["_remainingRespawns", -1]];
  if (_remainingRespawns isEqualTo 0) then {
    if (_key in _uids && {_maxReturnAmount < count _aliveUids}) then {_aliveUids pushBackUnique _key};
  };
}] call CBA_fnc_hashEachPair;

(_plrs select {(getPlayerUID _x) in _aliveUids})
