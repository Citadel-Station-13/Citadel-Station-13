/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/crates.dmi'
	icon_state = "crate"
	req_access = null
	can_weld_shut = FALSE
	horizontal = TRUE
	allow_objects = TRUE
	allow_dense = TRUE
	dense_when_open = TRUE
	climbable = TRUE
	climb_time = 10 //real fast, because let's be honest stepping into or onto a crate is easy
	climb_stun = 0 //climbing onto crates isn't hard, guys
	delivery_icon = "deliverycrate"
	material_drop = /obj/item/stack/sheet/plasteel
	material_drop_amount = 5
	var/obj/item/paper/fluff/jobs/cargo/manifest/manifest

/obj/structure/closet/crate/Initialize(mapload)
	. = ..()
	if(icon_state == "[initial(icon_state)]open")
		opened = TRUE
	// 	AddElement(/datum/element/climbable, climb_time = crate_climb_time * 0.5, climb_stun = 0)
	// else
	// 	AddElement(/datum/element/climbable, climb_time = crate_climb_time, climb_stun = 0)
	update_icon()

/obj/structure/closet/crate/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(!istype(mover, /obj/structure/closet))
		var/obj/structure/closet/crate/locatedcrate = locate(/obj/structure/closet/crate) in get_turf(mover)
		if(locatedcrate) //you can walk on it like tables, if you're not in an open crate trying to move to a closed crate
			if(opened) //if we're open, allow entering regardless of located crate openness
				return TRUE
			if(!locatedcrate.opened) //otherwise, if the located crate is closed, allow entering
				return TRUE

/obj/structure/closet/crate/update_icon_state()
	icon_state = "[initial(icon_state)][opened ? "open" : ""]"

/obj/structure/closet/crate/closet_update_overlays(list/new_overlays)
	. = new_overlays
	if(manifest)
		. += "manifest"

/obj/structure/closet/crate/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	. = ..()
	if(manifest)
		tear_manifest(user)

/obj/structure/closet/crate/open(mob/living/user, force = FALSE)
	. = ..()
	if(. && manifest)
		to_chat(user, "<span class='notice'>The manifest is torn off [src].</span>")
		playsound(src, 'sound/items/poster_ripped.ogg', 75, TRUE)
		manifest.forceMove(get_turf(src))
		manifest = null
		update_icon()

// cit specific
/obj/structure/closet/crate/handle_lock_addition()
	return

/obj/structure/closet/crate/handle_lock_removal()
	return

/obj/structure/closet/crate/proc/tear_manifest(mob/user)
	to_chat(user, "<span class='notice'>You tear the manifest off of [src].</span>")
	playsound(src, 'sound/items/poster_ripped.ogg', 75, TRUE)

	manifest.forceMove(loc)
	if(ishuman(user))
		user.put_in_hands(manifest)
	manifest = null
	update_icon()

/obj/structure/closet/crate/coffin
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon_state = "coffin"
	resistance_flags = FLAMMABLE
	can_weld_shut = FALSE
	breakout_time = 200
	max_integrity = 70
	material_drop = /obj/item/stack/sheet/mineral/wood
	material_drop_amount = 5
	var/pryLidTimer = 250

/obj/structure/closet/crate/coffin/examine(mob/user)
	. = ..()
	if(user.mind?.has_antag_datum(ANTAG_DATUM_BLOODSUCKER))
		. += {"<span class='cult'>This is a coffin which you can use to regenerate your burns and other wounds faster.</span>"}
		. += {"<span class='cult'>You can also thicken your blood if you survive the day, and hide from the sun safely while inside.</span>"}
	/*	if(user.mind.has_antag_datum(ANTAG_DATUM_VASSAL)
			. += {"<span class='cult'>This is a coffin which your master can use to shield himself from the unforgiving sun.\n
			You yourself are still human and dont need it. Yet.</span>"} */

/obj/structure/closet/crate/internals
	desc = "An internals crate."
	name = "internals crate"
	icon_state = "o2crate"

/obj/structure/closet/crate/trashcart
	desc = "A heavy, metal trashcart with wheels."
	name = "trash cart"
	icon_state = "trashcart"

/obj/structure/closet/crate/trashcart/Moved()
	. = ..()
	if(has_gravity())
		playsound(src, 'sound/effects/roll.ogg', 100, TRUE)

/obj/structure/closet/crate/trashcart/laundry
	name = "laundry cart"
	desc = "A large cart for hauling around large amounts of laundry."
	icon_state = "laundry"

/obj/structure/closet/crate/medical
	desc = "A medical crate."
	name = "medical crate"
	icon_state = "medicalcrate"

/obj/structure/closet/crate/freezer
	desc = "A freezer."
	name = "freezer"
	icon_state = "freezer"

//Snowflake organ freezer code
//Order is important, since we check source, we need to do the check whenever we have all the organs in the crate

/obj/structure/closet/crate/freezer/open()
	recursive_organ_check(src)
	..()

/obj/structure/closet/crate/freezer/close()
	..()
	recursive_organ_check(src)

/obj/structure/closet/crate/freezer/Destroy()
	recursive_organ_check(src)
	return ..()

/obj/structure/closet/crate/freezer/Initialize(mapload)
	. = ..()
	recursive_organ_check(src)

/obj/structure/closet/crate/freezer/blood
	name = "blood freezer"
	desc = "A freezer containing packs of blood."
	icon_state = "surgery"

/obj/structure/closet/crate/freezer/blood/fake
	should_populate_contents = FALSE

/obj/structure/closet/crate/freezer/blood/PopulateContents()
	. = ..()
	new /obj/item/reagent_containers/blood(src)
	new /obj/item/reagent_containers/blood(src)
	new /obj/item/reagent_containers/blood/AMinus(src)
	new /obj/item/reagent_containers/blood/BMinus(src)
	new /obj/item/reagent_containers/blood/BPlus(src)
	new /obj/item/reagent_containers/blood/OMinus(src)
	new /obj/item/reagent_containers/blood/OPlus(src)
	new /obj/item/reagent_containers/blood/lizard(src)
	new /obj/item/reagent_containers/blood/jellyblood(src)
	new /obj/item/reagent_containers/blood/insect(src)
	new /obj/item/reagent_containers/blood/synthetics(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/blood/random(src)

/obj/structure/closet/crate/freezer/surplus_limbs
	name = "surplus prosthetic limbs"
	desc = "A crate containing an assortment of cheap prosthetic limbs."

/obj/structure/closet/crate/freezer/surplus_limbs/fake
	should_populate_contents = FALSE

/obj/structure/closet/crate/freezer/surplus_limbs/PopulateContents()
	. = ..()
	new /obj/item/bodypart/l_arm/robot/surplus(src)
	new /obj/item/bodypart/l_arm/robot/surplus(src)
	new /obj/item/bodypart/r_arm/robot/surplus(src)
	new /obj/item/bodypart/r_arm/robot/surplus(src)
	new /obj/item/bodypart/l_leg/robot/surplus(src)
	new /obj/item/bodypart/l_leg/robot/surplus(src)
	new /obj/item/bodypart/r_leg/robot/surplus(src)
	new /obj/item/bodypart/r_leg/robot/surplus(src)

/obj/structure/closet/crate/radiation
	desc = "A crate with a radiation sign on it."
	name = "radiation crate"
	icon_state = "radiation"
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE

/obj/structure/closet/crate/hydroponics
	name = "hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	icon_state = "hydrocrate"

/obj/structure/closet/crate/engineering
	name = "engineering crate"
	icon_state = "engi_crate"

/obj/structure/closet/crate/engineering/electrical
	icon_state = "engi_e_crate"

/obj/structure/closet/crate/rcd
	desc = "A crate for the storage of an RCD."
	name = "\improper RCD crate"
	icon_state = "engi_crate"

/obj/structure/closet/crate/rcd/fake
	should_populate_contents = FALSE

/obj/structure/closet/crate/rcd/PopulateContents()
	..()
	for(var/i in 1 to 4)
		new /obj/item/rcd_ammo(src)
	new /obj/item/construction/rcd(src)

/obj/structure/closet/crate/science
	name = "science crate"
	desc = "A science crate."
	icon_state = "scicrate"

/obj/structure/closet/crate/solarpanel_small
	name = "budget solar panel crate"
	icon_state = "engi_e_crate"

/obj/structure/closet/crate/solarpanel_small/PopulateContents()
	..()
	for(var/i in 1 to 13)
		new /obj/item/solar_assembly(src)
	new /obj/item/circuitboard/computer/solar_control(src)
	new /obj/item/paper/guides/jobs/engi/solars(src)
	new /obj/item/electronics/tracker(src)

/obj/structure/closet/crate/goldcrate
	name = "gold crate"

/obj/structure/closet/crate/goldcrate/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/stack/sheet/mineral/gold(src, 1, FALSE)
	new /obj/item/storage/belt/champion(src)

/obj/structure/closet/crate/silvercrate
	name = "silver crate"

/obj/structure/closet/crate/silvercrate/PopulateContents()
	..()
	for(var/i in 1 to 5)
		new /obj/item/coin/silver(src)
