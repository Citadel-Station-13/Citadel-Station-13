/mob/living/carbon/human/init_full_appearance()
	..()
	update_eyes()

//update eyes
/mob/living/carbon/human/proc/update_eyes()
	if(!dna.species)
		return
	full_appearance.appearance_list[BODYPART_APPEARANCE].remove_data(EYES_APPEARANCE)
	var/eye_overlays
	if(!(NOEYES in dna.species.species_traits))
		var/has_eyes = getorganslot(ORGAN_SLOT_EYES)
		if(!has_eyes)
			eye_overlays = mutable_appearance('icons/mob/eyes.dmi', "eyes_missing", -BODY_LAYER)
		else
			var/left_state = DEFAULT_LEFT_EYE_STATE
			var/right_state = DEFAULT_RIGHT_EYE_STATE
			var/eye_type = dna.species.eye_type
			if(eye_type in GLOB.eye_types)
				left_state = eye_type + "_left_eye"
				right_state = eye_type + "_right_eye"
			var/mutable_appearance/left_eye = mutable_appearance('icons/mob/eyes.dmi', left_state, -BODY_LAYER)
			var/mutable_appearance/right_eye = mutable_appearance('icons/mob/eyes.dmi', right_state, -BODY_LAYER)
			if((EYECOLOR in dna.species.species_traits) && has_eyes)
				left_eye.color = "#" + left_eye_color
				right_eye.color = "#" + right_eye_color
			var/list/offset_features = dna.species.offset_features
			if(OFFSET_EYES in offset_features)
				left_eye.pixel_x += offset_features[OFFSET_EYES][1]
				left_eye.pixel_y += offset_features[OFFSET_EYES][2]
				right_eye.pixel_x += offset_features[OFFSET_EYES][1]
				right_eye.pixel_y += offset_features[OFFSET_EYES][2]
			eye_overlays = list(left_eye, right_eye)
			full_appearance.appearance_list[BODYPART_APPEARANCE].add_data(eye_overlays, EYES_APPEARANCE)
