/datum/appearance
	// each piece of data in render_data specifies an image to be rendered
	// any extra metadata can be handled by a subtype of /datum/appearance for that specific object type
	var/list/render_data = list()
	var/mob/owner

/datum/appearance/New(var/mob/user)
	owner = user

// renders every overlay in render_data after first attempting to remove it if necessary
/datum/appearance/proc/render(attempt_cut = TRUE)
	if(attempt_cut)
		owner.cut_overlay(render_data)
	owner.add_overlay(render_data)

// adds a single item to render_data, adds its overlay if necessary
/datum/appearance/proc/add_data(var/data_to_add, var/index, attempt_add = TRUE)
	render_data[index] = data_to_add
	if(attempt_add)
		owner.add_overlay(data_to_add)
	if(istype(owner, /mob/living/carbon/human/dummy))
		message_admins("dummy found adding [data_to_add]")

// removes a single item from render_data, removes its overlay if necessary
/datum/appearance/proc/remove_data(var/index, attempt_remove = TRUE)
	if(render_data[index])
		if(attempt_remove)
			owner.cut_overlay(render_data[index])
		. = render_data.Remove(index)
