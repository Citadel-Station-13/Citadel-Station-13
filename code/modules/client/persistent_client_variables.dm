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
	/// Characters they have joined the round under - Lazylist of names
	var/list/characters_joined_as
	/// Slots they have joined the round under - Lazylist of numbers
	var/list/slots_joined_as
	/// Are we currently subject to respawn restrictions? Usually set by us using the "respawn" verb, but can be lifted by admins.
	var/respawn_restrictions_active = FALSE
	/// time of death we consider for respawns
	var/respawn_time_of_death = -INFINITY
	/// did they DNR? used to prevent respawns.
	var/dnr_triggered = FALSE
	/// did they cryo on their last ghost?
	var/respawn_did_cryo = FALSE

	// PAI stuff
	var/icon/custom_holoform_icon
	var/list/cached_holoform_icons
	var/last_custom_holoform = 0

#warn comment these and put these in
	var/db_flags
	var/list/exp = list()


/datum/persistent_client_variables/New(_ckey)
	ckey = _ckey

#warn put generation in here
/datum/preferences/proc/get_filtered_holoform(filter_type)
	if(!custom_holoform_icon)
		return
	LAZYINITLIST(cached_holoform_icons)
	if(!cached_holoform_icons[filter_type])
		cached_holoform_icons[filter_type] = process_holoform_icon_filter(custom_holoform_icon, filter_type)
	return cached_holoform_icons[filter_type]
