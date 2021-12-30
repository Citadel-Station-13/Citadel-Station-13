/**
 * Resets all aspects of screen rendering.
 */
/mob/proc/ResetRendering(construct = TRUE)
	if(!client)
		return
	#warn impl fullscreen, parallax
	// planes
	plane_holder?.RemoveFromClient(client)
	// huds
	CleanupAtomHUDs()
	// clickcatcher - unnecessary, will be wiped anyways

	// fullscreen

	client.images = list()
	client.screen = list()

	if(construct)
		// planes
		if(!plane_holder)
			plane_holder = new
		plane_holder.ApplyToClient(client)
		// huds
		ReloadAtomHUDs()
		// clickcatcher
		client.update_clickcatcher()
		// fullscreen

		// parallax
		parallax_holder.Reset()
