// ADMIN VERBS BEGIN
/**
 * Fully returns a player to lobby, allowing them to bypass all respawn restrictions
 * Works on ghosts or new players (lobby players)
 * If a lobby player is selected, their restrictions are removed.
 */
/client/proc/admin_cmd_respawn_return_to_lobby()

/**
 * Allows a ghost to bypass respawn delay without lifting respawn restrictions
 */
/client/proc/admin_cmd_remove_ghost_respawn_timer()

// ADMIN VERBS END

/**
 * Checks if we can latejoin on the currently selected slot, taking into account respawn status.
 */
/mob/dead/new_player/proc/respawn_latejoin_check(notify = FALSE)

/**
 * Attempts to respawn.
 */
/mob/dead/observer/verb/respawn()
	set name = "Respawn"
	set category = "OOC"


/mob/verb/abandon_mob()
	set name = "Respawn"
	set category = "OOC"

	if (CONFIG_GET(flag/norespawn))
		return
	if ((stat != DEAD || !( SSticker )))
		to_chat(usr, "<span class='boldnotice'>You must be dead to use this!</span>")
		return

	log_game("[key_name(usr)] used abandon mob.")

	to_chat(usr, "<span class='boldnotice'>Please roleplay correctly!</span>")

	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		return
	client.screen.Cut()
	client.screen += client.void
	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		return

	var/mob/dead/new_player/M = new /mob/dead/new_player()
	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		qdel(M)
		return

	M.key = key
//	M.Login()	//wat
	return
