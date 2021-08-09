// essentially this represents the true appearance of a mob, made up of several smaller appearances such as limbs, items, effects, clothing, etc
/datum/appearance/full
	var/list/datum/appearance/appearance_list // all the appearances that make up this full appearance

/datum/appearance/full/render()
	owner.cut_overlays()
	for(var/datum/appearance/appearance in appearance_list)
		appearance.render() // technically a full appearance can be made from other full appearances but this shouldn't be done out of good practice
