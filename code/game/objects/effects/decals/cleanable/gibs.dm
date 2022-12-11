/obj/effect/decal/cleanable/blood/gibs
	name = "gibs"
	desc = "They look bloody and gruesome."
	icon_state = "gibbl5"
	layer = LOW_OBJ_LAYER
	blend_mode = BLEND_DEFAULT
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")
	mergeable_decal = FALSE
	bloodiness = 0				//This isn't supposed to be bloody.
	persistent = TRUE
	var/body_colors = "#e3ba84"	//a default color just in case.
	var/gibs_reagent_id = /datum/reagent/liquidgibs
	var/gibs_bloodtype = "A+"
	turf_loc_check = FALSE

/obj/effect/decal/cleanable/blood/gibs/Initialize(mapload, list/datum/disease/diseases, list/blood_data)
	. = ..()
	if(random_icon_states && (icon_state == initial(icon_state)) && length(random_icon_states) > 0)
		icon_state = pick(random_icon_states)
	if(gibs_reagent_id)
		reagents.add_reagent(gibs_reagent_id, 5, blood_data)
	if(gibs_bloodtype)
		add_blood_DNA(list("Non-human DNA" = gibs_bloodtype), diseases)
	update_icon()

/obj/effect/decal/cleanable/blood/gibs/replace_decal(obj/effect/decal/cleanable/C)
	return FALSE //Never fail to place us

/obj/effect/decal/cleanable/blood/gibs/update_icon()
	add_atom_colour(blood_DNA_to_color(), FIXED_COLOUR_PRIORITY)
	cut_overlays()
	var/mutable_appearance/guts = mutable_appearance(icon, "[icon_state]_guts")
	guts.appearance_flags = RESET_COLOR
	add_overlay(guts)
	var/mutable_appearance/flesh = mutable_appearance(icon, "[icon_state]_flesh")
	flesh.appearance_flags = RESET_COLOR
	flesh.color = body_colors
	add_overlay(flesh)

/obj/effect/decal/cleanable/blood/gibs/PersistenceSave(list/data)
	. = ..()
	return /obj/effect/decal/cleanable/blood/gibs/old

/obj/effect/decal/cleanable/blood/gibs/ex_act(severity, target, origin)
	return

/obj/effect/decal/cleanable/blood/gibs/Crossed(mob/living/L)
	if(istype(L) && has_gravity(loc))
		playsound(loc, 'sound/effects/gib_step.ogg', !HAS_TRAIT(L,TRAIT_LIGHT_STEP) ? 20 : 50, 1)
	. = ..()

/obj/effect/decal/cleanable/blood/gibs/proc/streak(list/directions)
	set waitfor = FALSE
	var/list/diseases = list()
	SEND_SIGNAL(src, COMSIG_GIBS_STREAK, directions, diseases)
	var/direction = pick(directions)
	var/dist = 0
	if(prob(50))		//yes this and the one below are different for a reason.
		if(prob(25))
			dist = 2
		else
			dist = 1
	if(dist)
		for(var/i in 1 to dist)
			var/obj/effect/decal/cleanable/blood/splatter/splat = new /obj/effect/decal/cleanable/blood/splatter(loc, diseases)
			splat.transfer_blood_dna(blood_DNA, diseases)
			if(!step_to(src, get_step(src, direction), 0))
				break

/obj/effect/decal/cleanable/blood/gibs/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/gibs/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/torso
	random_icon_states = list("gibtorso")

/obj/effect/decal/cleanable/blood/gibs/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")

/obj/effect/decal/cleanable/blood/gibs/old
	name = "old rotting gibs"
	desc = "Space Jesus, why didn't anyone clean this up?  It smells terrible."
	bloodiness = 0

/obj/effect/decal/cleanable/blood/gibs/old/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	setDir(pick(GLOB.cardinals))
	icon_state += "-old"
	update_icon()

/obj/effect/decal/cleanable/blood/drip
	name = "drips of blood"
	desc = "It's gooey."
	icon_state = "1"
	random_icon_states = list("drip1","drip2","drip3","drip4","drip5")
	bloodiness = 0
	var/drips = 1

/obj/effect/decal/cleanable/blood/drip/can_bloodcrawl_in()
	return TRUE

/obj/effect/decal/cleanable/blood/gibs/human

/obj/effect/decal/cleanable/blood/gibs/human/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	update_icon()

/obj/effect/decal/cleanable/blood/gibs/human/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/human/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/gibs/human/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/human/torso
	random_icon_states = list("gibtorso")

/obj/effect/decal/cleanable/blood/gibs/human/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/human/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")


//Lizards
/obj/effect/decal/cleanable/blood/gibs/human/lizard
	body_colors = "117720"
	gibs_bloodtype = "L"

/obj/effect/decal/cleanable/blood/gibs/human/lizard/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	update_icon()

/obj/effect/decal/cleanable/blood/gibs/human/lizard/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/human/lizard/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/gibs/human/lizard/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/human/lizard/torso
	random_icon_states = list("gibtorso")

/obj/effect/decal/cleanable/blood/gibs/human/lizard/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/human/lizard/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")

// Slime Gibs
/obj/effect/decal/cleanable/blood/gibs/slime
	desc = "They look gooey and gruesome."
	gibs_reagent_id = /datum/reagent/liquidgibs/slime
	gibs_bloodtype = "GEL"

/obj/effect/decal/cleanable/blood/gibs/slime/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	update_icon()

/obj/effect/decal/cleanable/blood/gibs/slime/PersistenceSave(list/data)
	. = ..()
	return type

/obj/effect/decal/cleanable/blood/gibs/slime/update_icon()
	add_atom_colour(body_colors, FIXED_COLOUR_PRIORITY)
	cut_overlays()
	var/mutable_appearance/guts = mutable_appearance(icon, "[icon_state]s_guts")
	guts.appearance_flags = RESET_COLOR
	guts.color = body_colors
	add_overlay(guts)
	var/mutable_appearance/flesh = mutable_appearance(icon, "[icon_state]_flesh")
	flesh.appearance_flags = RESET_COLOR
	flesh.color = body_colors
	add_overlay(flesh)

/obj/effect/decal/cleanable/blood/gibs/slime/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/slime/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/gibs/slime/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/slime/torso
	random_icon_states = list("gibtorso")

/obj/effect/decal/cleanable/blood/gibs/slime/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/slime/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")

/obj/effect/decal/cleanable/blood/gibs/synth
	desc = "They look sludgy and disgusting."
	gibs_reagent_id = /datum/reagent/liquidgibs/synth
	gibs_bloodtype = "SY"

/obj/effect/decal/cleanable/blood/gibs/synth/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	update_icon()

/obj/effect/decal/cleanable/blood/gibs/synth/PersistenceSave(list/data)
	. = ..()
	return type

//IPCs
/obj/effect/decal/cleanable/blood/gibs/ipc
	desc = "They look sharp yet oozing."
	body_colors = "00ff00"
	gibs_reagent_id = /datum/reagent/liquidgibs/oil
	gibs_bloodtype = "HF"

/obj/effect/decal/cleanable/blood/gibs/ipc/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	update_icon()

/obj/effect/decal/cleanable/blood/gibs/ipc/PersistenceSave(list/data)
	. = ..()
	return type

/obj/effect/decal/cleanable/blood/gibs/ipc/update_icon()
	add_atom_colour(blood_DNA_to_color(), FIXED_COLOUR_PRIORITY)
	cut_overlays()
	var/mutable_appearance/guts = mutable_appearance(icon, "[icon_state]r-overlay")
	guts.appearance_flags = RESET_COLOR
	add_overlay(guts)

/obj/effect/decal/cleanable/blood/gibs/ipc/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/ipc/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/gibs/ipc/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/ipc/torso
	random_icon_states = list("gibtorso")

/obj/effect/decal/cleanable/blood/gibs/ipc/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/ipc/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")
