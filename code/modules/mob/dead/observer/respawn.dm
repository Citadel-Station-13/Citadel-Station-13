// ADMIN VERBS BEGIN
/**
 * Fully returns a player to lobby, allowing them to bypass all respawn restrictions
 * Works on ghosts or new players (lobby players)
 * If a lobby player is selected, their restrictions are removed.
 */
/client/proc/admin_cmd_respawn_return_to_lobby()
	set name = "Respawn Player (Unrestricted)"
	set desc = "Gives a player an unrestricted respawn, resetting all respawn restrictions for them."
	set category = "Admin"

	var/list/mob/valid = list()
	for(var/mob/dead/observer/I in GLOB.dead_mob_list)
		if(!I.client)
			continue
		valid["[I.ckey] - Observing: [I]"] = I.ckey
	for(var/mob/dead/new_player/I in GLOB.dead_mob_list)
		if(!I.client || !I.client.prefs.respawn_restrictions_active)
			continue
		valid["[I.ckey] - IN LOBBY"] = I.ckey
	if(!valid.len)
		to_chat(src, "<span class='warning'>No player found that is either a ghost or is in lobby with restrictions active.</span>")
		return
	var/ckey = valid[input(src, "Choose a player (only showing logged in players who have restrictions)", "Unrestricted Respawn") as null|anything in valid]
	var/client/player = GLOB.directory[ckey]
	if(!player)
		to_chat(src, "<span class='warning'>Client not found.</span>")
		return
	var/mob/M = player.mob
	if(istype(M, /mob/dead/observer))
		var/mob/dead/observer/O = M
		var/confirm = alert(src, "Send [O]([ckey]) back to the lobby without respawn restrictions?", "Send to Lobby", "Yes", "No")
		if(confirm != "Yes")
			return
		message_admins("[key_name_admin(src)] gave [key_name_admin(O)] a full respawn and sent them back to the lobby.")
		log_admin("[key_name(src)] gave [key_name(O)] a full respawn and sent them back to the lobby.")
		to_chat(O, "<span class='userdanger'>You have been given a full respawn.</span>")
		if(O.do_respawn(FALSE))
			player.prefs.dnr_triggered = FALSE
	else if(istype(M, /mob/dead/new_player))
		var/mob/dead/new_player/NP = M
		var/confirm = alert(src, "Remove [NP]'s respawn restrictions?", "Remove Restrictions", "Yes", "No")
		if(confirm != "Yes")
			return
		message_admins("[key_name_admin(src)] removed [ckey]'s respawn restrictions.")
		log_admin("[key_name(src)] removed [ckey]'s respawn restrictions")
		NP.client.prefs.respawn_restrictions_active = FALSE
		NP.client.prefs.dnr_triggered = FALSE
		to_chat(NP, "<span class='boldnotie'>Your respawn restrictions have been removed.")
	else
		CRASH("Invalid mobtype")

/**
 * Allows a ghost to bypass respawn delay without lifting respawn restrictions
 */
/client/proc/admin_cmd_remove_ghost_respawn_timer()
	set name = "Remove Respawn Timer for Player"
	set desc = "Removes a player's respawn timer without removing their respawning restrictions."
	set category = "Admin"

	var/list/mob/dead/observer/valid = list()
	for(var/mob/dead/observer/I in GLOB.dead_mob_list)
		if(!I.client)
			continue
		valid["[I.ckey] - [I.name]"] = I

	if(!valid.len)
		to_chat(src, "<span class='warning'>No logged in ghosts found.</span>")
		return
	var/mob/dead/observer/O = valid[input(src, "Choose a player (only showing logged in)", "Remove Respawn Timer") as null|anything in valid]

	if(!O.client)
		to_chat(src, "<span class='warning'>[O] has no client.</span>")
		return
	var/timeleft = O.time_left_to_respawn()
	if(!timeleft)
		to_chat(src, "<span class='warning'>[O] can already respawn.")
		return
	message_admins("[key_name_admin(src)] removed [key_name_admin(O)]'s respawn timer.")
	log_admin("[key_name(src)] removed [key_name(O)]'s respawn timer.")
	O.client.prefs.respawn_time_of_death = -INFINITY
	to_chat(O, "<span class='boldnotice'>Your respawn timer has been removed.")

// ADMIN VERBS END

/**
 * Checks if we can latejoin on the currently selected slot, taking into account respawn status.
 */
/mob/dead/new_player/proc/respawn_latejoin_check(notify = FALSE)
	if(!client.prefs.respawn_restrictions_active)
		return TRUE
	var/can_same_person = CONFIG_GET(flag/allow_same_character_respawn)
	if(can_same_person)
		return TRUE
	var/nameless = client.prefs.nameless
	var/randomname = client.prefs.be_random_name
	var/randombody = client.prefs.be_random_body
	if(randombody && (nameless || randomname))
		return TRUE			// somewhat unrecognizable
	if(client.prefs.slots_joined_as && (client.prefs.default_slot in client.prefs.slots_joined_as))
		if(notify)
			to_chat(src, "<span class='userdanger'>You cannot respawn on the same slot. Joined slots: [english_list(client.prefs.slots_joined_as)].")
		return FALSE
	if((!nameless && !randomname) && (client.prefs.characters_joined_as && (client.prefs.real_name in client.prefs.characters_joined_as)))
		if(notify)
			to_chat(src, "<span class='userdanger'>You cannot respawn on the same character. Joined slots: [english_list(client.prefs.characters_joined_as)].")
		return FALSE
	return TRUE

/**
 * Attempts to respawn.
 */
/mob/dead/observer/verb/respawn()
	set name = "Respawn"
	set category = "OOC"

	if(!CONFIG_GET(flag/respawns_enabled))
		to_chat(src, "<span class='warning'>Respawns are disabled in configuration.</span>")
		return

	if(client.prefs.dnr_triggered)
		to_chat(src, "<span class='danger'>You cannot respawn as you have enabled DNR.</span>")
		return

	var/roundstart_timeleft = (SSticker.round_start_time + (CONFIG_GET(number/respawn_minimum_delay_roundstart) * 600)) - world.time
	if(roundstart_timeleft > 0)
		to_chat(src, "<span class='warning'>It's been too short of a time since the round started! Please wait [CEILING(roundstart_timeleft / 600, 0.1)] more minutes.</span>")
		return

	var/list/banned_modes = CONFIG_GET(keyed_list/respawn_chaos_gamemodes)
	if(SSticker.mode && banned_modes[lowertext(SSticker.mode.config_tag)])
		to_chat(src, "<span class='warning'>The current mode tag, [SSticker.mode.config_tag], is not eligible for respawn.</span>")
		return

	var/timeleft = time_left_to_respawn()
	if(timeleft)
		to_chat(src, "<span class='warning'>It's been too short of a time since you died/observed! Please wait [round(timeleft / 600, 0.1)] more minutes.</span>")
		return
	do_respawn(TRUE)

/**
 * Gets time left until we can respawn. Returns 0 if we can respawn now.
 */
/mob/dead/observer/verb/time_left_to_respawn()
	ASSERT(client)
	return max(0, ((client.prefs.respawn_did_cryo? CONFIG_GET(number/respawn_delay_cryo) : CONFIG_GET(number/respawn_delay)) MINUTES + client.prefs.respawn_time_of_death) - world.time)

/**
 * Handles respawning
 */
/mob/dead/observer/proc/do_respawn(penalize)
	if(!client)
		return FALSE
	if(isnull(penalize))
		penalize = client.prefs.respawn_restrictions_active
	client.prefs.respawn_restrictions_active = penalize

	message_admins("[key_name_admin(src)] was respawned to lobby [penalize? "with" : "without"] restrictions.")
	log_game("[key_name(src)] was respawned to lobby [penalize? "with" : "without"] restrictions.")
	var/mob/dead/new_player/N = transfer_to_lobby()

	to_chat(N, "<span class='userdanger'>You have been respawned to the lobby. \
	Remember to take heed of rules regarding round knowledge - notably, that ALL past lives are forgotten. \
	Any character you join as has NO knowledge of round events unless specified otherwise by an admin.</span>")
	return TRUE

/**
 * Actual proc that removes us and puts us back on lobby
 *
 * Returns the new mob.
 */
/mob/dead/observer/proc/transfer_to_lobby()
	if(!client)		// if no one's in us we can just be deleted
		qdel(src)
		return
	client.screen.Cut()
	client.view_size.resetToDefault()
	client.update_clickcatcher()
	client.view_size.setDefault(getScreenSize(client.prefs.widescreenpref))
	client.view_size.resetToDefault()

	var/mob/dead/new_player/M = new /mob/dead/new_player
	M.key = key
	return M
