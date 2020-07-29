/obj/mecha/working/ripley/buzz
	name = "\proper Buzz"
	desc = "To infinity... and BYOND!"
	icon_state = "buzz"
	max_temperature = 15000 //not resistant to heat
	max_integrity = 250 //we're a bit tough yes
	step_in = 1.5
	fast_pressure_step_in = 1.5
	slow_pressure_step_in = 1.5 //differently from the ripley, pressure doesn't affect (most of) our functions.
	resistance_flags = FIRE_PROOF | ACID_PROOF
	lights = TRUE
	lights_power = 16 //shiny shiny lights
	deflect_chance = 10
	step_energy_drain = 6
	normal_step_energy_drain = 6
	armor = list("melee" = 55, "bullet" = 15, "laser" = 30, "energy" = 30, "bomb" = 15, "bio" = 40, "rad" = 20, "fire" = 20, "acid" = 90) //Decent armor, since it can't be upgraded
	max_equip = 4 //It's an exploration mech. They won't be needing much equipment.
	wreckage = /obj/structure/mecha_wreckage/buzz
	occupant_sight_flags = 0 //we don't use this because it doesn't make you able to see in the dark and stuff, and we want that
	var/storedsight
	var/storedsee_in_dark
	cargo_capacity = 20 //more storage for space looting ~~and greytiding~~

/obj/mecha/working/ripley/buzz/collect_ore()
	return FALSE //we're not actually a mining mech

/obj/mecha/working/ripley/buzz/Initialize()
	..()
	var/datum/component/armor_plate/C = src.GetComponent(/datum/component/armor_plate) //funny ripley inheritance gave us the ability to get goliath armoring. we don't want that.
	C.Destroy()

/obj/mecha/working/ripley/buzz/update_pressure()
	var/turf/T = get_turf(loc)

	if(lavaland_equipment_pressure_check(T))
		for(var/obj/item/mecha_parts/mecha_equipment/funny in equipment)
			funny.equip_cooldown = initial(funny.equip_cooldown)/2 // Even our clamp and other stuff is better in space! ...or lavaland. Or depressurized rooms. You get it.
	else
		for(var/obj/item/mecha_parts/mecha_equipment/funny in equipment)
			funny.equip_cooldown = initial(funny.equip_cooldown)*2 //And worse in usual pressure

/obj/mecha/working/ripley/buzz/moved_inside(mob/living/carbon/human/H)
	. = ..()
	if(.)
		var/mob/living/B = occupant
		storedsight = B.sight
		storedsee_in_dark = B.see_in_dark
		B.sight |= SEE_TURFS
		B.see_in_dark = 7

/obj/mecha/working/ripley/buzz/go_out()
	if(isliving(occupant))
		var/mob/living/B = occupant
		B.sight = storedsight
		B.see_in_dark = storedsee_in_dark
		storedsight = null //just to be sure there won't be problems.
		storedsee_in_dark = null // :)

	return ..()

/obj/mecha/working/ripley/buzz/mmi_moved_inside(obj/item/mmi/M, mob/user)
	. = ..()
	if(.)
		var/mob/living/brain/B = M.brainmob
		storedsight = B.sight
		storedsee_in_dark = B.see_in_dark
		B.sight |= SEE_TURFS
		B.see_in_dark = 7