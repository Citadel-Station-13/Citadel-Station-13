/mob/living/silicon/proc/attempt_set_custom_holoform()
	if(!client.prefs)
		to_chat(src, "<span class='boldwarning'>No preferences datum on your client, contact an admin/coder!</span>")
		return
	var/icon/new_holoform = user_interface_custom_holoform(client)
	client.prefs.last_custom_holoform = world.time
	if(new_holoform)
		client.prefs.custom_holoform_icon = new_holoform
		client.prefs.cached_holoform_icons = null
		to_chat(src, "<span class='boldnotice'>Holoform set.</span>")
		return TRUE
	return FALSE
