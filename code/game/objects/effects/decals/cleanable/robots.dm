// Note: BYOND is object oriented. There is no reason for this to be copy/pasted blood code.

/obj/effect/decal/cleanable/blood/gibs/robot
	name = "robot debris"
	desc = "It's a useless heap of junk... <i>or is it?</i>"
	icon = 'icons/mob/robots.dmi'
	icon_state = "gib1"
	layer = LOW_OBJ_LAYER
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6", "gib7")
	basecolor = BLOOD_COLOR_OIL

/obj/effect/decal/cleanable/blood/gibs/robot/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	reagents.add_reagent("liquidoilgibs", 5)

/obj/effect/decal/cleanable/blood/gibs/robot/dry()	//pieces of robots do not dry up like blood
	return

/obj/effect/decal/cleanable/blood/gibs/robot/streak(var/list/directions)
	spawn (0)
		var/direction = pick(directions)
		for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
			sleep(3)
			if (i > 0)
				if (prob(40))
					var/obj/effect/decal/cleanable/blood/oil/streak = new(src.loc)
					streak.update_icon()
				else if (prob(10))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(3, 1, src)
					s.start()
			if (step_to(src, get_step(src, direction), 0))
				break

/obj/effect/decal/cleanable/blood/gibs/robot/ex_act()
	return

/obj/effect/decal/cleanable/blood/gibs/robot/limb
	random_icon_states = list("gibarm", "gibleg")

/obj/effect/decal/cleanable/blood/gibs/robot/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6", "gib7","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/robot/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6", "gib7","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/oil
	name = "motor oil"
	desc = "It's black and greasy. Looks like Beepsky made another mess."
	basecolor = BLOOD_COLOR_OIL

/obj/effect/decal/cleanable/blood/oil/Initialize()
	. = ..()
	reagents.add_reagent("oil", 30)
	reagents.add_reagent("liquidoilgibs", 5)

/obj/effect/decal/cleanable/blood/oil/dry()
	return

/obj/effect/decal/cleanable/blood/oil/streak
	amount = 2

/obj/effect/decal/cleanable/blood/oil/slippery

/obj/effect/decal/cleanable/blood/oil/slippery/Initialize()
	AddComponent(/datum/component/slippery, 80, (NO_SLIP_WHEN_WALKING | SLIDE))
