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

				//Bloody footprints
				var/turf/T = get_turf(src)
				if(S.blood_smear && S.blood_smear[S.blood_state])
					var/obj/effect/decal/cleanable/blood/footprints/tracks/oldFP = locate(/obj/effect/decal/cleanable/blood/footprints/tracks) in T
					if(oldFP && (oldFP.blood_state == S.blood_state && oldFP.color == color))
						return
					S.blood_smear[S.blood_state] = max(0, S.blood_smear[S.blood_state]-BLOOD_LOSS_PER_STEP)
					var/obj/effect/decal/cleanable/blood/footprints/tracks/footprints/FP = new /obj/effect/decal/cleanable/blood/footprints/tracks/footprints(T)
					FP.icon_state = FOOTPRINT_SHOE
					FP.print_state = FOOTPRINT_SHOE
					FP.blood_state = S.blood_state
					FP.entered_dirs |= dir
					FP.bloodiness = S.blood_smear[S.blood_state]
					FP.update_icon()
					update_inv_shoes()
				//End bloody footprints

				S.step_action()

	else
		if(!buckled)
			if(!lying)
				if(loc == NewLoc)
					if(!has_gravity(loc))
						return
					var/turf/T = get_turf(src)
					if(bloodiness)
						var/obj/effect/decal/cleanable/blood/footprints/tracks/oldFP = locate(/obj/effect/decal/cleanable/blood/footprints/tracks) in T
						if(oldFP && (oldFP.blood_state == blood_state && oldFP.color == color))
							return
						else
							var/obj/effect/decal/cleanable/blood/footprints/tracks/FP = new /obj/effect/decal/cleanable/blood/footprints/tracks(T)
							if(DIGITIGRADE in dna.species.species_traits)
								if(dna.species.id == ("lizard" || "ashwalker" || "xeno"))
									FP.icon_state = FOOTPRINT_CLAW
									FP.print_state = FOOTPRINT_CLAW
								else if(dna.species.id == "Mammal")
									FP.icon_state = FOOTPRINT_PAW
									FP.print_state = FOOTPRINT_PAW
								else
									FP.icon_state = FOOTPRINT_SHOE
									FP.print_state = FOOTPRINT_SHOE
							else if(("taur" in dna.species.mutant_bodyparts) && (dna.features["taur"] != "None"))
								if(dna.features["taur"] in GLOB.noodle_taurs)
									FP.icon_state = FOOTPRINT_SNAKE
									FP.print_state = FOOTPRINT_SNAKE
								else if(dna.features["taur"] in GLOB.paw_taurs)
									FP.icon_state = FOOTPRINT_PAW
									FP.print_state = FOOTPRINT_PAW
							else
								FP.icon_state = FOOTPRINT_SHOE
								FP.print_state = FOOTPRINT_SHOE
							FP.add_blood_DNA(return_blood_DNA())
							FP.update_icon()
							var/newdir = get_dir(T, loc)
							if(newdir == dir)
								FP.setDir(newdir)
							else
								newdir = newdir | dir
								if(newdir == 3)
									newdir = 1
								else if(newdir == 12)
									newdir = 4
							FP.setDir(newdir)
							bloodiness--

			else //we're on the floor, smear some stuff around
				if(loc == NewLoc)
					if(!has_gravity(loc))
						return
					var/turf/T = get_turf(src)
					if(bloodiness)
						var/obj/effect/decal/cleanable/blood/footprints/tracks/oldFP = locate(/obj/effect/decal/cleanable/blood/footprints/tracks) in T
						if(oldFP && (oldFP.blood_state == blood_state && oldFP.color == color))
							return
						else
							var/obj/effect/decal/cleanable/blood/footprints/tracks/FP = new /obj/effect/decal/cleanable/blood/footprints/tracks/body(T)
							FP.icon_state = FOOTPRINT_DRAG
							FP.print_state = FOOTPRINT_DRAG
							FP.add_blood_DNA(return_blood_DNA())
							FP.update_icon()
							var/newdir = get_dir(T, loc)
							if(newdir == dir)
								FP.setDir(newdir)
							else
								newdir = newdir | dir
								if(newdir == 3)
									newdir = 1
								else if(newdir == 12)
									newdir = 4
							FP.setDir(newdir)
							bloodiness--

/mob/living/carbon/human/Process_Spacemove(movement_dir = 0) //Temporary laziness thing. Will change to handles by species reee.
	if(dna.species.space_move(src))
		return TRUE
	return ..()
