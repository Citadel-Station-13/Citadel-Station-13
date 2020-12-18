GLOBAL_LIST_EMPTY(persistent_client_variables)

/proc/get_persistent_client_variables_for(ckey)
	if(GLOB.persistent_client_variables[ckey])
		return GLOB.persistent_client_variables[ckey]
	var/datum/persistent_client_variables/PCV = new(ckey)
	GLOB.persistent_client_variables[ckey] = PCV
	return PCV

/**
  * Holds persistent client variabless that don't wipe on reconnect
  *
  * Used to be held in preferences datums
  * Meant for direct variable access.
  */
/datum/persistent_client_variables
	/// Owner's ckey
	var/ckey
	/// Bitflags for admin muting
	var/muted = NONE
	/// Last IP of user
	var/last_ip
	/// Last CID of user
	var/last_id
	/// Should we log all mouseclicks from them?
	var/log_clicks = FALSE

/datum/persistent_client_variables/New(_ckey)
	ckey = _ckey
