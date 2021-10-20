// carbon appearance, has helper procs that calculate appearances for things carbons have, specifically: limbs
/mob/living/carbon/proc/get_limb_appearance()
	var/list/limb_appearances = list()

	// handles taur leg hiding
	var/static/list/leg_day = typecacheof(list(/obj/item/bodypart/r_leg, /obj/item/bodypart/l_leg))
	var/is_taur = FALSE
	if(dna?.species.mutant_bodyparts["taur"])
		var/datum/sprite_accessory/taur/T = GLOB.taur_list[dna.features["taur"]]
		if(T?.hide_legs)
			is_taur = TRUE

	for(var/obj/item/bodypart/bodypart in bodyparts)
		// hide legs if applicable
		if(is_taur && leg_day[bodypart.type])
			continue
		// get_limb_icon returns a list of images for the limb and its markings if applicable
		// the argument is for if the limb is dismembered or not
		limb_appearances[bodypart.body_zone] = bodypart.get_limb_icon(FALSE)

	return limb_appearances

// should be ran upon the carbon being initialized
/mob/living/carbon/proc/init_full_appearance()
	full_appearance = new /datum/appearance/full(src)
	full_appearance.appearance_list[BODYPART_APPEARANCE] = new /datum/appearance(src)
	full_appearance.appearance_list[CLOTHING_APPEARANCE] = new /datum/appearance(src)
	full_appearance.appearance_list[MISC_APPEARANCE] = new /datum/appearance(src)
	update_limbs(list(BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_ARM, BODY_ZONE_R_LEG))

// update a specific limb from its zone by removing it and adding it
/mob/living/carbon/proc/update_limb(var/body_zone)
	var/datum/appearance/bodypart_appearance = full_appearance.appearance_list[BODYPART_APPEARANCE]
	bodypart_appearance.remove_data(body_zone)
	// doesn't exist? don't bother trying to add it
	var/obj/item/bodypart/part = get_bodypart(body_zone)
	if(part)
		part.update_limb(FALSE)
		bodypart_appearance.add_data(part.get_limb_icon(FALSE), body_zone)

// update all limbs
/mob/living/carbon/proc/update_limbs(var/list/zones)
	for(var/zone in zones)
		update_limb(zone)
	update_damage_overlays()
