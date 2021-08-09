// each piece of data in render_data specifies an image to be rendered
// any extra metadata can be handled by a subtype of /datum/appearance for that specific object type

/datum/appearance
	var/list/render_data
	var/mob/owner

/datum/appearance/proc/render()
	if(owner)
		owner.add_overlay(render_data)