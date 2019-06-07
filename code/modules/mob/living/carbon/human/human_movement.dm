/mob/living/carbon/human/get_movespeed_modifiers()
	var/list/considering = ..()
	. = considering
	if(has_trait(TRAIT_IGNORESLOWDOWN))
		for(var/id in .)
			var/list/data = .[id]
			if(data[MOVESPEED_DATA_INDEX_FLAGS] & IGNORE_NOSLOW)
				.[id] = data

/mob/living/carbon/human/movement_delay()
	. = ..()
	if(dna && dna.species)
		. += dna.species.movement_delay(src)

/mob/living/carbon/human/slip(knockdown_amount, obj/O, lube)
	if(has_trait(TRAIT_NOSLIPALL))
		return 0
	if (!(lube&GALOSHES_DONT_HELP))
		if(has_trait(TRAIT_NOSLIPWATER))
			return 0
		if(shoes && istype(shoes, /obj/item/clothing))
			var/obj/item/clothing/CS = shoes
			if (CS.clothing_flags & NOSLIP)
				return 0
	return ..()

/mob/living/carbon/human/experience_pressure_difference()
	playsound(src, 'sound/effects/space_wind.ogg', 50, 1)
	if(shoes && istype(shoes, /obj/item/clothing))
		var/obj/item/clothing/S = shoes
		if (S.clothing_flags & NOSLIP)
			return 0
	return ..()

/mob/living/carbon/human/mob_has_gravity()
	. = ..()
	if(!.)
		if(mob_negates_gravity())
			. = 1

/mob/living/carbon/human/mob_negates_gravity()
	return ((shoes && shoes.negates_gravity()) || (dna.species.negates_gravity(src)))

/mob/living/carbon/human/Move(NewLoc, direct)
	. = ..()
	for(var/datum/mutation/human/HM in dna.mutations)
		HM.on_move(src, NewLoc)

	if(shoes)
		if(!lying && !buckled)
			if(loc == NewLoc)
				if(!has_gravity(loc))
					return
				var/obj/item/clothing/shoes/S = shoes
				var/step_print = dna.species.get_move_trail(src)
				//Bloody footprints
				var/turf/T = get_turf(src)
				var/obj/effect/decal/cleanable/blood/footprints/oldFP = locate(step_print) in T
				if(S.bloody_shoes && S.bloody_shoes[S.blood_state])
					for(oldFP)
						if(oldFP && (oldFP.blood_state == S.blood_state && oldFP.color == bloodtype_to_color(last_bloodtype)))
							return
					//No oldFP or they're all a different kind of blood
					S.bloody_shoes[S.blood_state] = max(0, S.bloody_shoes[S.blood_state] - BLOOD_LOSS_PER_STEP)
					if (S.bloody_shoes[S.blood_state] > BLOOD_LOSS_IN_SPREAD)
						var/obj/effect/decal/cleanable/blood/footprints/tracks/FP = new step_print(T)
						FP.blood_state = S.blood_state
						FP.entered_dirs |= dir
						FP.bloodiness = S.bloody_shoes[S.blood_state] - BLOOD_LOSS_IN_SPREAD
						if(S.last_blood_DNA && S.last_bloodtype)
							FP.blood_DNA += list(last_blood_DNA = last_bloodtype)
							//hacky as heck; we need to move the LAST entry to there, otherwise we mix all the blood
						FP.update_icon()
					update_inv_shoes()
				//End bloody footprints
				S.step_action()

	else if(!shoes)
		if(!buckled)
			if(loc == NewLoc)
				if(!has_gravity(loc))
					return
				var/step_print = dna.species.get_move_trail(src)
				var/mob/living/carbon/human/H = src
				//Bloody footprints without shoes
				var/turf/T = get_turf(src)
				var/obj/effect/decal/cleanable/blood/footprints/oldFP = locate(step_print) in T
				if(H.blood_smear && H.blood_smear[H.blood_state])
					for(oldFP)
						if(oldFP && (oldFP.blood_state == H.blood_state && oldFP.color == bloodtype_to_color(last_bloodtype)))
							return
					//No oldFP or they're all a different kind of blood
					H.blood_smear[H.blood_state] = max(0, H.blood_smear[H.blood_state] - BLOOD_LOSS_PER_STEP)
					if (H.blood_smear[H.blood_state] > BLOOD_LOSS_IN_SPREAD)
						var/obj/effect/decal/cleanable/blood/footprints/tracks/FP = new step_print(T)
						FP.blood_state = H.blood_state
						FP.entered_dirs |= dir
						FP.bloodiness = H.blood_smear[H.blood_state] - BLOOD_LOSS_IN_SPREAD
						if(H.last_blood_DNA && H.last_bloodtype)
							FP.blood_DNA += list(H.last_blood_DNA = H.last_bloodtype)
							//hacky as heck; we need to move the LAST entry to there, otherwise we mix all the blood
						FP.update_icon()
					H.update_inv_shoes()

/mob/living/carbon/human/Process_Spacemove(movement_dir = 0) //Temporary laziness thing. Will change to handles by species reee.
	if(dna.species.space_move(src))
		return TRUE
	return ..()
