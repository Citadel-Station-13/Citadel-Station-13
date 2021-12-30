/mob/Logout()
	SHOULD_CALL_PARENT(TRUE)

	// clean up screen/rendering

	// clickcatcher
	// doesn't need to be removed because it'll just be readded on login

	// huds
	CleanupAtomHUDs()

	// fullscreen
	#warn impl

	// plane masters
	plane_holder.RemoveFromClient(client)

	// parallax
	#warn impl


	SEND_SIGNAL(src, COMSIG_MOB_CLIENT_LOGOUT, client)
	log_message("[key_name(src)] is no longer owning mob [src]([src.type])", LOG_OWNERSHIP)
	SStgui.on_logout(src)
	unset_machine()
	remove_from_player_list()

	..()

	if(loc)
		loc.on_log(FALSE)

	if(client)
		for(var/foo in client.player_details.post_logout_callbacks)
			var/datum/callback/CB = foo
			CB.Invoke()

	return TRUE
