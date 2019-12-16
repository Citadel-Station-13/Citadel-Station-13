/client/verb/clear_custom_holoform()
	set name = "Clear Custom Holoform"
	set desc = "Clear your current custom holoform"

	prefs?.custom_holoform_icon = null
	prefs?.cached_holoform_icons = null
	to_chat(src, "<span class='boldnotice'>Holoform removed.</span>")

/client/verb/set_custom_holoform()
	set name = "Set Custom Holoform"
	set desc = "Set your custom holoform using your current preferences slot and a specified set of gear."

	if(prefs.last_custom_holoform > world.time - CUSTOM_HOLOFORM_DELAY)
		to_chat(src, "<span class='warning'>You are attempting to change custom holoforms too fast!</span>")
	var/icon/new_holoform = user_interface_custom_holoform(src)
	if(new_holoform)
		prefs.custom_holoform_icon = new_holoform
		prefs.cached_holoform_icons = null
		prefs.last_custom_holoform = world.time
		to_chat(src, "<span class='boldnotice'>Holoform set.</span>")
