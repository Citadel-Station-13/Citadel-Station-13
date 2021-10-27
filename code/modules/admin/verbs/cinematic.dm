/client/proc/cinematic()
	set name = "cinematic"
	set category = "Admin.Fun"
	set desc = "Shows a cinematic."	// Intended for testing but I thought it might be nice for events on the rare occasion Feel free to comment it out if it's not wanted.
	set hidden = 1
	if(!SSticker)
		return

	var/datum/cinematic/choice = tgui_input_list(src,"Cinematic","Choose", subtypesof(/datum/cinematic))
	if(choice)
		Cinematic(initial(choice.id),world,null)
