/**
 * Removes all screen rendering other than the HUD
 */
/mob/proc/ResetRendering()
	if(!client)
		return
	// planes
	plane_holder?.RemoveFromClient(client)
	// huds - not until they refactored, just like /datum/hud

	// clickcatcher
	client.screen -= clickcatcher

	// fullscreen
	hide_fullscreens()

	// parallax
	client.parallax_holder.Hide()

	// wipe everything
	client.images = list()
	client.screen = list()

/**
 * Adds all screen rendering other than the HUD
 */
/mob/proc/ConstructRendering()
	// planes
	if(!plane_holder)
		plane_holder = new
	plane_holder.ApplyToClient(client)
	// huds
	reload_huds()
	// clickcatcher
	client.update_clickcatcher()
	// fullscreen
	reload_fullscreen()
	// parallax
	client.parallax_holder.Reset()
