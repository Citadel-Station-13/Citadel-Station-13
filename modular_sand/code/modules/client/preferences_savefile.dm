/datum/preferences/update_character(current_version, savefile/S)
	. = ..()
	if(current_version < 48.5) 	//need to rewrite languages into a list, not being a list or null
		var/tmp = language		//causes it to block preferences panel to be blocked and constant runtimes
		language = list(tmp)
