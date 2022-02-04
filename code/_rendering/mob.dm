/**
 * initializes screen rendering. call on mob new
 */
/mob/proc/init_rendering()

/**
 * loads screen rendering. call on mob login
 */
/mob/proc/reload_rendering()
	if(!client.parallax_holder)
		client.CreateParallax()
	else
		client.parallax_holder.Reset(force = TRUE)
	client.update_clickcatcher()
	reload_fullscreen()

/**
 * destroys screen rendering. call on mob del
 */
/mob/proc/dispose_rendering()
	wipe_fullscreens()
