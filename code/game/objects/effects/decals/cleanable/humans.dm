/obj/effect/decal/cleanable/blood
	name = "blood"
	desc = "It's gooey. Perhaps it's the chef's cooking?"
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	blood_state = BLOOD_STATE_BLOOD
	color = BLOOD_COLOR_HUMAN //default so we don't have white splotches everywhere.
	bloodiness = BLOOD_AMOUNT_PER_DECAL

/obj/effect/decal/cleanable/blood/old/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	update_icon()

/obj/effect/decal/cleanable/blood/replace_decal(obj/effect/decal/cleanable/blood/C)
	if(bloodiness)
		if(C.bloodiness < MAX_SHOE_BLOODINESS)
			C.bloodiness += bloodiness
	update_icon()
	return ..()

obj/effect/decal/cleanable/blood/add_blood_DNA(list/blood_dna)
	return TRUE

/obj/effect/decal/cleanable/blood/transfer_mob_blood_dna()
	. = ..()
	update_icon()

/obj/effect/decal/cleanable/blood/update_icon()
	GET_COMPONENT(D, /datum/component/forensics)
	if(!blood_color)
		blood_color = D.blood_mix_color
	color = blood_color

/obj/effect/decal/cleanable/blood/old
	name = "dried blood"
	desc = "Looks like it's been here a while. Eew."
	bloodiness = 0
	color = "#3a0505"

/obj/effect/decal/cleanable/blood/old/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	add_blood_DNA(list("blood_type"= "A+"))

/obj/effect/decal/cleanable/blood/splatter
	random_icon_states = list("gibbl1", "gibbl2", "gibbl3", "gibbl4", "gibbl5")

/obj/effect/decal/cleanable/trail_holder //not a child of blood on purpose so that it shows up even on regular splatters
	name = "blood"
	icon_state = "ltrails_1"
	desc = "Your instincts say you shouldn't be following these."
	random_icon_states = null
	var/list/existing_dirs = list()
	color = BLOOD_COLOR_HUMAN
	bloodiness = BLOOD_AMOUNT_PER_DECAL

/obj/effect/decal/cleanable/trail_holder/update_icon()
	GET_COMPONENT(D, /datum/component/forensics)
	color = D.blood_mix_color

/obj/effect/cleanable/trail_holder/Initialize()
	. = ..()
	update_icon()

/obj/effect/decal/cleanable/trail_holder/can_bloodcrawl_in()
	return TRUE

/obj/effect/decal/cleanable/trail_holder/transfer_mob_blood_dna()
	. = ..()
	update_icon()

//BLOODY FOOTPRINTS
/obj/effect/decal/cleanable/blood/footprints/tracks
	name = "tracks"
	icon = 'icons/effects/fluidtracks.dmi'
	icon_state = "nothingwhatsoever"
	desc = "WHOSE FOOTPRINTS ARE THESE?"
	random_icon_states = null
	var/entered_dirs = 0
	var/exited_dirs = 0
	var/print_state = FOOTPRINT_SHOE //the icon state to load images from
	var/list/shoe_types = list()

/obj/effect/decal/cleanable/blood/footprints/tracks/Crossed(atom/movable/O)
	..()
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		var/obj/item/clothing/shoes/S = H.shoes
		if(S && S.blood_smear[blood_state])
			S.blood_smear[blood_state] = max(S.blood_smear[blood_state] - BLOOD_LOSS_PER_STEP, 0)
			shoe_types |= S.type
			if (!(entered_dirs & H.dir))
				entered_dirs |= H.dir
				update_icon()

		else if(!H.bloodiness)
			H.blood_smear[blood_state] = max(S.blood_smear[blood_state] - BLOOD_LOSS_PER_STEP, 0)
			H.bloodiness = max(H.bloodiness - BLOOD_LOSS_IN_SPREAD, 0)
			if (!(entered_dirs & H.dir))
				entered_dirs |= H.dir
				update_icon()


/obj/effect/decal/cleanable/blood/footprints/tracks/Uncrossed(atom/movable/O)
	..()
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		var/obj/item/clothing/shoes/S = H.shoes
		if(S && S.blood_smear[blood_state])
			S.blood_smear[blood_state] = max(S.blood_smear[blood_state] - BLOOD_LOSS_PER_STEP, 0)
			shoe_types  |= S.type
			if (!(exited_dirs & H.dir))
				exited_dirs |= H.dir
				update_icon()

		else if(!H.bloodiness)
			H.blood_smear[blood_state] = max(H.blood_smear[blood_state] - BLOOD_LOSS_PER_STEP, 0)
			H.bloodiness = max(H.bloodiness - BLOOD_LOSS_IN_SPREAD, 0)
			if (!(exited_dirs & H.dir))
				exited_dirs |= H.dir
				update_icon()

/obj/effect/decal/cleanable/blood/footprints/tracks/update_icon()
	..()
	cut_overlays()

	for(var/Ddir in GLOB.cardinals)
		GET_COMPONENT(B, /datum/component/forensics)
		if(entered_dirs & Ddir)
			var/image/bloodstep_overlay = GLOB.bloody_footprints_cache["entered-[print_state]-[Ddir]-[color]"]
			if(!bloodstep_overlay)
				GLOB.bloody_footprints_cache["entered-[print_state]-[Ddir]-[color]"] = bloodstep_overlay = image(icon, "[print_state]1", dir = Ddir, color = B.blood_mix_color)
			add_overlay(bloodstep_overlay)
		if(exited_dirs & Ddir)
			var/image/bloodstep_overlay = GLOB.bloody_footprints_cache["exited-[print_state]-[Ddir]-[color]"]
			if(!bloodstep_overlay)
				GLOB.bloody_footprints_cache["exited-[print_state]-[Ddir]-[color]"] = bloodstep_overlay = image(icon, "[print_state]2", dir = Ddir, color = B.blood_mix_color)
			add_overlay(bloodstep_overlay)

	alpha = BLOODY_FOOTPRINT_BASE_ALPHA + bloodiness

/obj/effect/decal/cleanable/blood/footprints/tracks/examine(mob/user)
	. = ..()
	if(shoe_types.len && ishuman(user) && user.mind.assigned_role == "Detective") //gumshoe does the detective thing, not every fucking assistant
		. += "You recognise the footprints as belonging to:\n"
		for(var/shoe in shoe_types)
			var/obj/item/clothing/shoes/S = shoe
			. += "some <B>[initial(S.name)]</B> [icon2html(initial(S.icon), user)]\n"

	to_chat(user, .)

/obj/effect/decal/cleanable/blood/footprints/tracks/replace_decal(obj/effect/decal/cleanable/C)
	if(blood_state != C.blood_state) //We only replace footprints of the same type as us
		return
	if(color != C.color)
		return
	..()

/obj/effect/decal/cleanable/blood/footprints/tracks/can_bloodcrawl_in()
	if((blood_state != BLOOD_STATE_OIL) && (blood_state != BLOOD_STATE_NOT_BLOODY))
		return TRUE
	return FALSE

/obj/effect/decal/cleanable/blood/footprints/tracks/footprints
	name = "footprints"
	desc = "They look like tracks left by footwear."
	icon_state = FOOTPRINT_SHOE
	print_state = FOOTPRINT_SHOE

/obj/effect/decal/cleanable/blood/footprints/tracks/snake
	name = "tracks"
	desc = "They look like tracks left by a giant snake."
	icon_state = FOOTPRINT_SNAKE
	print_state = FOOTPRINT_SNAKE

/obj/effect/decal/cleanable/blood/footprints/tracks/paw
	name = "tracks"
	desc = "They look like tracks left by mammalian paws."
	icon_state = FOOTPRINT_PAW
	print_state = FOOTPRINT_PAW

/obj/effect/decal/cleanable/blood/footprints/tracks/claw
	name = "tracks"
	desc = "They look like tracks left by reptilian claws."
	icon_state = FOOTPRINT_CLAW
	print_state = FOOTPRINT_CLAW

/obj/effect/decal/cleanable/blood/footprints/tracks/wheels
	name = "tracks"
	desc = "They look like tracks left by wheels."
	gender = PLURAL
	icon_state = FOOTPRINT_WHEEL
	print_state = FOOTPRINT_WHEEL

/obj/effect/decal/cleanable/blood/footprints/tracks/body
	name = "trails"
	desc = "A trail left by something being dragged."
	icon_state = FOOTPRINT_DRAG
	print_state = FOOTPRINT_DRAG
