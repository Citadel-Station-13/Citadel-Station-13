/obj/effect/decal/cleanable/blood
	name = "blood"
	desc = "It's gooey. Perhaps it's the chef's cooking?"
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	blend_mode = BLEND_MULTIPLY
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	blood_state = BLOOD_STATE_BLOOD
	bloodiness = BLOOD_AMOUNT_PER_DECAL
	color = BLOOD_COLOR_HUMAN //default so we don't have white splotches everywhere.
	beauty = -100
	persistent = TRUE
	var/fixed_color = FALSE

/obj/effect/decal/cleanable/blood/replace_decal(obj/effect/decal/cleanable/blood/C)
	if(C.fixed_color)
		qdel(C)
		return FALSE
	if (C.blood_DNA)
		blood_DNA |= C.blood_DNA
	qdel(C)
	update_icon()
	return FALSE

/obj/effect/decal/cleanable/blood/transfer_blood_dna()
	..()
	update_icon()

/obj/effect/decal/cleanable/blood/transfer_mob_blood_dna()
	. = ..()
	update_icon()

/obj/effect/decal/cleanable/blood/update_icon()
	. = ..()
	if(!fixed_color)
		add_atom_colour(blood_DNA_to_color(), FIXED_COLOUR_PRIORITY)
		blend_mode = blood_DNA_to_blend()

/obj/effect/decal/cleanable/blood/PersistenceSave(list/data)
	. = ..()
	data["color"] = color
	data["blendmode"] = blend_mode

/obj/effect/decal/cleanable/blood/PersistenceLoad(list/data)
	. = ..()
	if(data["color"])
		fixed_color = TRUE
		add_atom_colour(data["color"], FIXED_COLOUR_PRIORITY)
	if(data["blendmode"])
		blend_mode = data["blendmode"]
	name = "dried blood"
	desc = "Looks like it's been here a while. Eew"
	bloodiness = 0

/obj/effect/decal/cleanable/blood/old
	name = "dried blood"
	desc = "Looks like it's been here a while. Eew."
	bloodiness = 0

/obj/effect/decal/cleanable/blood/old/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	icon_state += "-old"
	add_blood_DNA(list("Non-human DNA" = "A+"))

/obj/effect/decal/cleanable/blood/splats
	random_icon_states = list("gibbl1", "gibbl2", "gibbl3", "gibbl4", "gibbl5")
	persistence_allow_stacking = TRUE

/obj/effect/decal/cleanable/blood/splatter
	random_icon_states = list("splatter1", "splatter2", "splatter3", "splatter4", "splatter5")

/obj/effect/decal/cleanable/blood/tracks
	icon_state = "tracks"
	desc = "They look like tracks left by wheels."
	random_icon_states = null
	beauty = -50

/obj/effect/decal/cleanable/blood/tracks/PersistenceSave(list/data)
	. = ..()
	data["dir"] = dir

/obj/effect/decal/cleanable/blood/tracks/PersistenceLoad(list/data)
	. = ..()
	if(data["dir"])
		setDir(text2num(data["dir"]))

/obj/effect/decal/cleanable/trail_holder //not a child of blood on purpose
	name = "blood"
	icon = 'icons/effects/blood.dmi'
	desc = "Your instincts say you shouldn't be following these."
	blend_mode = BLEND_MULTIPLY
	random_icon_states = null
	beauty = -50
	persistent = TRUE
	persistence_allow_stacking = TRUE
	var/list/existing_dirs = list()
	var/fixed_color = FALSE

/obj/effect/decal/cleanable/trail_holder/PersistenceSave(list/data)
	. = ..()
	data["dir"] = dir
	data["color"] = color
	data["blendmode"] = blend_mode

/obj/effect/decal/cleanable/trail_holder/PersistenceLoad(list/data)
	. = ..()
	if(data["dir"])
		setDir(text2num(data["dir"]))
	if(data["color"])
		fixed_color = TRUE
		add_atom_colour(data["color"], FIXED_COLOUR_PRIORITY)
	if(data["blendmode"])
		blend_mode = data["blendmode"]

/obj/effect/decal/cleanable/trail_holder/update_icon()
	. = ..()
	if(!fixed_color)
		add_atom_colour(blood_DNA_to_color(), FIXED_COLOUR_PRIORITY)
		blend_mode = blood_DNA_to_blend()

/obj/effect/cleanable/trail_holder/Initialize(mapload)
	. = ..()
	update_icon()

/obj/effect/decal/cleanable/trail_holder/can_bloodcrawl_in()
	return TRUE

/obj/effect/decal/cleanable/trail_holder/transfer_blood_dna()
	..()
	update_icon()

/obj/effect/decal/cleanable/trail_holder/transfer_mob_blood_dna()
	. = ..()
	update_icon()

//BLOODY FOOTPRINTS
/obj/effect/decal/cleanable/blood/footprints
	name = "footprints"
	icon = 'icons/effects/footprints.dmi'
	icon_state = "nothingwhatsoever"
	desc = "WHOSE FOOTPRINTS ARE THESE?"
	random_icon_states = null
	var/entered_dirs = 0
	var/exited_dirs = 0
	blood_state = BLOOD_STATE_BLOOD //the icon state to load images from
	persistent = TRUE
	persistence_allow_stacking = TRUE
	var/list/shoe_types = list()

/obj/effect/decal/cleanable/blood/footprints/PersistenceSave(list/data)
	. = ..()
	data["dir"] = dir

/obj/effect/decal/cleanable/blood/footprints/PersistenceLoad(list/data)
	. = ..()
	if(data["dir"])
		setDir(text2num(data["dir"]))

/obj/effect/decal/cleanable/blood/footprints/Crossed(atom/movable/O)
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		var/obj/item/clothing/shoes/S = H.shoes
		if(S && S.bloody_shoes[blood_state])
			if(color != S.last_blood_color)
				return
			S.bloody_shoes[blood_state] = max(S.bloody_shoes[blood_state] - BLOOD_LOSS_PER_STEP, 0)
			shoe_types |= S.type
			if (!(entered_dirs & H.dir))
				entered_dirs |= H.dir
				update_icon()

/obj/effect/decal/cleanable/blood/footprints/Uncrossed(atom/movable/O)
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		var/obj/item/clothing/shoes/S = H.shoes
		if(S && S.bloody_shoes[blood_state])
			if(color != S.last_blood_color)//last entry - we check its color
				return
			S.bloody_shoes[blood_state] = max(S.bloody_shoes[blood_state] - BLOOD_LOSS_PER_STEP, 0)
			shoe_types  |= S.type
			if (!(exited_dirs & H.dir))
				exited_dirs |= H.dir
				update_icon()

/obj/effect/decal/cleanable/blood/footprints/update_icon()
	..()
	cut_overlays()
	for(var/Ddir in GLOB.cardinals)
		if(entered_dirs & Ddir)
			var/image/bloodstep_overlay = GLOB.bloody_footprints_cache["entered-[blood_state]-[Ddir]"]
			if(!bloodstep_overlay)
				GLOB.bloody_footprints_cache["entered-[blood_state]-[Ddir]"] = bloodstep_overlay = image(icon, "[blood_state]1", dir = Ddir)
			add_overlay(bloodstep_overlay)
		if(exited_dirs & Ddir)
			var/image/bloodstep_overlay = GLOB.bloody_footprints_cache["exited-[blood_state]-[Ddir]"]
			if(!bloodstep_overlay)
				GLOB.bloody_footprints_cache["exited-[blood_state]-[Ddir]"] = bloodstep_overlay = image(icon, "[blood_state]2", dir = Ddir)
			add_overlay(bloodstep_overlay)

	alpha = BLOODY_FOOTPRINT_BASE_ALPHA + bloodiness


/obj/effect/decal/cleanable/blood/footprints/examine(mob/user)
	. = ..()
	if(shoe_types.len)
		. += "You recognise the footprints as belonging to:"
		for(var/shoe in shoe_types)
			var/obj/item/clothing/shoes/S = shoe
			. += "some <B>[initial(S.name)]</B> [icon2html(initial(S.icon), user)]"

/obj/effect/decal/cleanable/blood/footprints/replace_decal(obj/effect/decal/cleanable/C)
	if(blood_state != C.blood_state) //We only replace footprints of the same type as us
		return
	if(color != C.color)
		return
	return ..()

/obj/effect/decal/cleanable/blood/footprints/can_bloodcrawl_in()
	if((blood_state != BLOOD_STATE_OIL) && (blood_state != BLOOD_STATE_NOT_BLOODY))
		return TRUE
	return FALSE

/* Eventually TODO: make snowflake trails like baycode's
/obj/effect/decal/cleanable/blood/footprints/tracks/shoe
	name = "footprints"
	desc = "They look like tracks left by footwear."
	icon_state = FOOTPRINT_SHOE
	print_state = FOOTPRINT_SHOE

/obj/effect/decal/cleanable/blood/footprints/tracks/foot
	name = "footprints"
	desc = "They look like tracks left by a bare foot."
	icon_state = FOOTPRINT_FOOT
	print_state = FOOTPRINT_FOOT

/obj/effect/decal/cleanable/blood/footprints/tracks/snake
	name = "tracks"
	desc = "They look like tracks left by a giant snake."
	icon_state = FOOTPRINT_SNAKE
	print_state = FOOTPRINT_SNAKE

/obj/effect/decal/cleanable/blood/footprints/tracks/paw
	name = "footprints"
	desc = "They look like tracks left by paws."
	icon_state = FOOTPRINT_PAW
	print_state = FOOTPRINT_PAW

/obj/effect/decal/cleanable/blood/footprints/tracks/claw
	name = "footprints"
	desc = "They look like tracks left by claws."
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
	print_state = FOOTPRINT_DRAG */
