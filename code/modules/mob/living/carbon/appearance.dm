// carbon appearance, has helper procs that calculate appearances for things carbons have, specifically: limbs
/mob/living/carbon/proc/get_limb_appearance()
	var/list/limb_appearances = list()
	for(var/obj/item/bodypart/bodypart in bodyparts)
		// get_limb_icon returns a list of images for the limb and its markings if applicable
		// the argument is for if the limb is dismembered or not
		limb_appearances += bodypart.get_limb_icon(FALSE)

	return limb_appearances

// should be ran upon the carbon being initialized
/mob/living/carbon/proc/init_full_appearance()
	full_appearance = new /datum/appearance/full
	full_appearance.owner = src
	var/datum/appearance/limbs_appearance = new
	limbs_appearance.owner = src
	limbs_appearance.render_data = get_limb_appearance()
	full_appearance.appearance_list = list(limbs_appearance)
	full_appearance.render()
