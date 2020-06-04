
/obj/effect/decal/cleanable/blood/xeno
	name = "xeno blood"
	desc = "It's green and acidic. It looks like... <i>blood?</i>"
	color = BLOOD_COLOR_XENO
	beauty = -250

/obj/effect/decal/cleanable/blood/splatter/xeno
	color = BLOOD_COLOR_XENO

/obj/effect/decal/cleanable/blood/gibs/xeno
	color = BLOOD_COLOR_XENO
	gibs_reagent_id = /datum/reagent/liquidgibs/xeno
	gibs_bloodtype = "X*"

/obj/effect/decal/cleanable/blood/gibs/xeno/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	update_icon()

/obj/effect/decal/cleanable/blood/gibs/xeno/update_icon()
	add_atom_colour(blood_DNA_to_color(), FIXED_COLOUR_PRIORITY)
	cut_overlays()
	var/mutable_appearance/flesh = mutable_appearance(icon, "[icon_state]x_flesh")
	flesh.appearance_flags = RESET_COLOR
	flesh.color = body_colors
	add_overlay(flesh)

/obj/effect/decal/cleanable/blood/gibs/xeno/streak(list/directions)
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
			sleep(2)
			var/obj/effect/decal/cleanable/blood/splatter/xeno/splat = new /obj/effect/decal/cleanable/blood/splatter/xeno(loc, diseases)
			splat.transfer_blood_dna(blood_DNA, diseases)
			if(!step_to(src, get_step(src, direction), 0))
				break

/obj/effect/decal/cleanable/blood/gibs/xeno/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/xeno/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/gibs/xeno/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/xeno/torso
	random_icon_states = list("gibtorso")

/obj/effect/decal/cleanable/blood/gibs/xeno/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/xeno/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")

/obj/effect/decal/cleanable/blood/gibs/xeno/larva
	random_icon_states = list("xgiblarva1", "xgiblarva2")

/obj/effect/decal/cleanable/blood/gibs/xeno/larva/body
	random_icon_states = list("xgiblarvahead", "xgiblarvatorso")

/obj/effect/decal/cleanable/blood/xtracks
	icon_state = "tracks"
	random_icon_states = null

/obj/effect/decal/cleanable/blood/xtracks/Initialize()
	add_blood_DNA(list("UNKNOWN DNA" = "X*"))
	. = ..()