// carbon appearance, has helper procs that calculate appearances for things carbons have, specifically: limbs
/mob/living/carbon/proc/get_limb_appearance()
	var/list/limb_appearances = list()
	for(var/obj/item/bodypart/bodypart in bodyparts)
		// get_limb_icon returns a list of images for the limb and its markings if applicable
		// the argument is for if the limb is dismembered or not
		limb_appearances[bodypart.body_zone] = bodypart.get_limb_icon(FALSE)

	return limb_appearances

// should be ran upon the carbon being initialized
/mob/living/carbon/proc/init_full_appearance()
	full_appearance = new /datum/appearance/full(src)
	var/datum/appearance/limbs_appearance = new(src)
	limbs_appearance.render_data = get_limb_appearance()
	full_appearance.appearance_list += list(BODYPART_APPEARANCE = limbs_appearance)
	full_appearance.render()

// update a specific limb from its zone by removing it and adding it
/mob/living/carbon/proc/update_limb(var/body_zone)
	var/datum/appearance/bodypart_appearance = full_appearance.appearance_list[BODYPART_APPEARANCE]
	bodypart_appearance.remove_data(body_zone)
	// doesn't exist? don't bother trying to add it
	var/obj/item/bodypart/part = get_bodypart(body_zone)
	if(part)
		bodypart_appearance.add_data(part.get_limb_icon(FALSE), body_zone)

// update all limbs
/mob/living/carbon/proc/update_limbs(var/list/zones)
	for(var/zone in zones)
		update_limb(zone)
