/obj/effect/decal/cleanable/blood/gibs
	name = "gibs"
	desc = "They look bloody and gruesome."
	icon_state = "gibbl5"
	layer = LOW_OBJ_LAYER
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")
	mergeable_decal = FALSE
	var/gib_overlay = FALSE
	var/slimy_gibs = FALSE
	var/body_colors

/obj/effect/decal/cleanable/blood/gibs/proc/guts()
	if(gib_overlay)
		var/mutable_appearance/gibz = mutable_appearance(icon, icon_state + "-overlay", color = blood_color, layer = (LOW_OBJ_LAYER + 0.1))
		var/mutable_appearance/gibz2 = mutable_appearance(icon, icon_state + "c-overlay", color = body_colors, layer = (LOW_OBJ_LAYER + 0.1))
		if(!slimy_gibs)
			gibz.appearance_flags = RESET_COLOR
			add_overlay(gibz)
		else
			gibz.appearance_flags = RESET_COLOR
			add_overlay(gibz)
			add_overlay(gibz2)

/obj/effect/decal/cleanable/blood/gibs/ex_act(severity, target)
	return

/obj/effect/decal/cleanable/blood/gibs/Crossed(mob/living/L)
	if(istype(L) && has_gravity(loc))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.mind.assigned_role == "Detective") //Gumshoe perks yo
				playsound(loc, 'sound/effects/gib_step.ogg', 10, 1)
			else
				playsound(loc, 'sound/effects/gib_step.ogg', H.has_trait(TRAIT_LIGHT_STEP) ? 20 : 50, 1)
		else
			playsound(loc, 'sound/effects/gib_step.ogg', L.has_trait(TRAIT_LIGHT_STEP) ? 20 : 50, 1)
	. = ..()

/obj/effect/decal/cleanable/blood/gibs/proc/streak(list/directions)
	set waitfor = 0
	var/direction = pick(directions)
	for(var/i = 0, i < pick(1, 200; 2, 150; 3, 50), i++)
		sleep(2)
		if(i > 0)
			var/list/datum/disease/diseases
			GET_COMPONENT(infective, /datum/component/infective)
			if(infective)
				diseases = infective.diseases
			var/obj/effect/decal/cleanable/blood/splatter/splat = new /obj/effect/decal/cleanable/blood/splatter(loc, diseases)
			splat.transfer_blood_dna(blood_DNA)

		if(!step_to(src, get_step(src, direction), 0))
			break

/obj/effect/decal/cleanable/blood/gibs/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/body
	random_icon_states = list("gibhead", "gibtorso")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/torso
	random_icon_states = list("gibtorso")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/limb
	random_icon_states = list("gibleg", "gibarm")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/old
	name = "old rotting gibs"
	desc = "Space Jesus, why didn't anyone clean this up?  It smells terrible."
	bloodiness = 0

/obj/effect/decal/cleanable/blood/gibs/old/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	setDir(pick(1,2,4,8))
	icon_state += "-old"
	add_blood(list("Non-human DNA" = "A+"))

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
	reagents.add_reagent("liquidgibs", 5)
	guts()
	update_icon()

/obj/effect/decal/cleanable/blood/gibs/human/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/human/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/human/body
	random_icon_states = list("gibhead", "gibtorso")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/human/torso
	random_icon_states = list("gibtorso")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/human/limb
	random_icon_states = list("gibleg", "gibarm")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/human/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")
	gib_overlay = TRUE
	slimy_gibs = TRUE

// Slime Gibs
/obj/effect/decal/cleanable/blood/gibs/slime
	desc = "They look gooey and gruesome."

/obj/effect/decal/cleanable/blood/gibs/slime/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	reagents.add_reagent("liquidslimegibs", 5)
	update_icon()
	guts()

/obj/effect/decal/cleanable/blood/gibs/slime/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/slime/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/slime/body
	random_icon_states = list("gibhead", "gibtorso")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/slime/torso
	random_icon_states = list("gibtorso")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/slime/limb
	random_icon_states = list("gibleg", "gibarm")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/slime/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/synth
	desc = "They look sludgy and disgusting."

/obj/effect/decal/cleanable/blood/gibs/synth/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	reagents.add_reagent("liquidsyntheticgibs", 5)
	update_icon()
	guts()

//IPCs
/obj/effect/decal/cleanable/blood/gibs/ipc
	desc = "They look sharp yet oozing."

/obj/effect/decal/cleanable/blood/gibs/ipc/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	reagents.add_reagent("liquidoilgibs", 5)
	update_icon()
	guts()

/obj/effect/decal/cleanable/blood/gibs/ipc/guts()
	if(gib_overlay)
		var/mutable_appearance/gibz = mutable_appearance(icon, icon_state + "-ipcoverlay", color = blood_color, layer = -LOW_OBJ_LAYER)
		var/mutable_appearance/gibz2 = mutable_appearance(icon, icon_state + "c-ipcoverlay", color = body_colors, layer = -LOW_OBJ_LAYER)
		if(!slimy_gibs)
			gibz.appearance_flags = RESET_COLOR
			add_overlay(gibz)
		else
			gibz.appearance_flags = RESET_COLOR
			add_overlay(gibz)
			add_overlay(gibz2)

/obj/effect/decal/cleanable/blood/gibs/ipc/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/ipc/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/ipc/body
	random_icon_states = list("gibhead", "gibtorso")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/ipc/torso
	random_icon_states = list("gibtorso")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/ipc/limb
	random_icon_states = list("gibleg", "gibarm")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/ipc/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")
	gib_overlay = TRUE
	slimy_gibs = TRUE

/obj/effect/decal/cleanable/blood/gibs/synth
	desc = "They look sludgy and disgusting."

/obj/effect/decal/cleanable/blood/gibs/synth/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	reagents.add_reagent("liquidsyntheticgibs", 5)
	update_icon()
	guts()
