// Note: BYOND is object oriented. There is no reason for this to be copy/pasted blood code.

/obj/effect/decal/cleanable/blood/xenoblood
	name = "xeno blood"
	desc = "It's green and acidic. It looks like... <i>blood?</i>"
	icon = 'icons/effects/blood.dmi'
	blood_state = BLOOD_STATE_XENO
	color = BLOOD_COLOR_XENO

/obj/effect/decal/cleanable/blood/xenoblood/Initialize()
	. = ..()
	add_blood_DNA(list("UNKNOWN DNA" = "X*"))

/obj/effect/decal/cleanable/blood/xenoblood/gibs
	name = "xeno gibs"
	desc = "Gnarly..."

/obj/effect/decal/cleanable/blood/xenoblood/xgibs/proc/streak(list/directions)
	set waitfor = 0
	var/direction = pick(directions)
	for(var/i = 0, i < pick(1, 200; 2, 150; 3, 50), i++)
		sleep(2)
		if(i > 0)
			new /obj/effect/decal/cleanable/xenoblood/xsplatter(loc)
		if(!step_to(src, get_step(src, direction), 0))
			break

/obj/effect/decal/cleanable/blood/xenoblood/xgibs/ex_act()
	return

/obj/effect/decal/cleanable/blood/xenoblood/gibs/up
	random_icon_states = list("xgib1", "xgib2", "xgib3", "xgib4", "xgib5", "xgib6","xgibup1","xgibup1","xgibup1")

/obj/effect/decal/cleanable/blood/xenoblood/gibs/down
	random_icon_states = list("xgib1", "xgib2", "xgib3", "xgib4", "xgib5", "xgib6","xgibdown1","xgibdown1","xgibdown1")

/obj/effect/decal/cleanable/blood/xenoblood/gibs/body
	random_icon_states = list("xgibhead", "xgibtorso")

/obj/effect/decal/cleanable/blood/xenoblood/gibs/torso
	random_icon_states = list("xgibtorso")

/obj/effect/decal/cleanable/blood/xenoblood/gibs/limb
	random_icon_states = list("xgibleg", "xgibarm")

/obj/effect/decal/cleanable/blood/xenoblood/gibs/core
	random_icon_states = list("xgibmid1", "xgibmid2", "xgibmid3")

/obj/effect/decal/cleanable/blood/xenoblood/gibs/larva
	random_icon_states = list("xgiblarva1", "xgiblarva2")

/obj/effect/decal/cleanable/blood/xenoblood/gibs/larva/body
	random_icon_states = list("xgiblarvahead", "xgiblarvatorso")

/obj/effect/decal/cleanable/blood/xenoblood/tracks
	color = BLOOD_COLOR_XENO

/obj/effect/decal/cleanable/blood/xenoblood/tracks/Initialize()
	. = ..()
	add_blood_DNA(list("Unknown DNA" = "X*"))
