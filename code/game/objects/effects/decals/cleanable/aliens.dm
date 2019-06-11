
/obj/effect/decal/cleanable/blood/xeno
	name = "xeno blood"
	desc = "It's green and acidic. It looks like... <i>blood?</i>"
	color = BLOOD_COLOR_XENO
	blood_DNA = list("UNKNOWN DNA" = "X*")

/obj/effect/decal/cleanable/blood/splatter/xeno
	color = BLOOD_COLOR_XENO

/obj/effect/decal/cleanable/blood/gibs/xeno
	color = BLOOD_COLOR_XENO

/obj/effect/decal/cleanable/blood/gibs/xeno/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	reagents.add_reagent("liquidxenogibs", 5)

/obj/effect/decal/cleanable/blood/gibs/xeno/update_icon()
	if(gib_overlay)
		var/icon/blood = new(icon,"[icon_state]",dir)
		var/image/gibz = new(icon, icon_state + "x-overlay")
		blood.Blend(blood_DNA_to_color(),ICON_MULTIPLY)
		gibz.appearance_flags = RESET_COLOR
		add_overlay(gibz)

/obj/effect/decal/cleanable/blood/gibs/xeno/streak(list/directions)
	set waitfor = 0
	var/direction = pick(directions)
	for(var/i = 0, i < pick(1, 200; 2, 150; 3, 50), i++)
		sleep(2)
		if(i > 0)
			var/list/datum/disease/diseases
			GET_COMPONENT(infective, /datum/component/infective)
			if(infective)
				diseases = infective.diseases
			var/obj/effect/decal/cleanable/blood/splatter/xeno/splat = new /obj/effect/decal/cleanable/blood/splatter/xeno(loc, diseases)
			splat.transfer_blood_dna(blood_DNA)
		if(!step_to(src, get_step(src, direction), 0))
			break

/obj/effect/decal/cleanable/blood/gibs/xeno/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/xeno/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/xeno/body
	random_icon_states = list("gibhead", "gibtorso")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/xeno/torso
	random_icon_states = list("gibtorso")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/xeno/limb
	random_icon_states = list("gibleg", "gibarm")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/xeno/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/xeno/larva
	random_icon_states = list("xgiblarva1", "xgiblarva2")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/gibs/xeno/larva/body
	random_icon_states = list("xgiblarvahead", "xgiblarvatorso")
	gib_overlay = TRUE

/obj/effect/decal/cleanable/blood/xtracks
	icon_state = "tracks"
	random_icon_states = null

/obj/effect/decal/cleanable/blood/xtracks/Initialize()
	add_blood(list("UNKNOWN DNA" = "X*"))
	. = ..()