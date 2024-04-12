/mob/living/carbon/alien/humanoid
	name = "alien"
	icon_state = "alien"
	pass_flags = PASSTABLE
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab/xeno = 5, /obj/item/stack/sheet/animalhide/xeno = 1)
	possible_a_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, INTENT_HARM)
	limb_destroyer = 1
	hud_type = /datum/hud/alien
	var/caste = ""
	var/alt_icon = 'icons/mob/alienleap.dmi' //used to switch between the two alien icon files.
	var/leap_on_click = 0
	var/pounce_cooldown = 0
	var/pounce_cooldown_time = 30
	var/custom_pixel_x_offset = 0 //for admin fuckery.
	var/custom_pixel_y_offset = 0
	var/sneaking = 0 //For sneaky-sneaky mode and appropriate slowdown
	var/drooling = 0 //For Neruotoxic spit overlays
	bodyparts = list(/obj/item/bodypart/chest/alien, /obj/item/bodypart/head/alien, /obj/item/bodypart/l_arm/alien,
					 /obj/item/bodypart/r_arm/alien, /obj/item/bodypart/r_leg/alien, /obj/item/bodypart/l_leg/alien)

	can_ventcrawl = TRUE

GLOBAL_LIST_INIT(strippable_alien_humanoid_items, create_strippable_list(list(
	/datum/strippable_item/hand/left,
	/datum/strippable_item/hand/right,
	/datum/strippable_item/mob_item_slot/handcuffs,
	/datum/strippable_item/mob_item_slot/legcuffs,
)))

//This is fine right now, if we're adding organ specific damage this needs to be updated
/mob/living/carbon/alien/humanoid/Initialize(mapload)
	AddAbility(new/obj/effect/proc_holder/alien/regurgitate(null))
	. = ..()

/mob/living/carbon/alien/humanoid/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/footstep, FOOTSTEP_MOB_CLAW, 0.5, -3)
	AddElement(/datum/element/strippable, GLOB.strippable_alien_humanoid_items)

/mob/living/carbon/alien/humanoid/restrained(ignore_grab)
	return handcuffed

/mob/living/carbon/alien/humanoid/Topic(href, href_list)
	..()
	//strip panel & embeds
	if(usr.canUseTopic(src, BE_CLOSE, NO_DEXTERY))
		if(href_list["embedded_object"])
			var/obj/item/bodypart/L = locate(href_list["embedded_limb"]) in bodyparts
			if(!L)
				return
			var/obj/item/I = locate(href_list["embedded_object"]) in L.embedded_objects
			if(!I || I.loc != src) //no item, no limb, or item is not in limb or in the alien anymore
				return
			SEND_SIGNAL(src, COMSIG_CARBON_EMBED_RIP, I, L)
			return

/mob/living/carbon/alien/humanoid/cuff_resist(obj/item/I)
	playsound(src, 'sound/voice/hiss5.ogg', 40, 1, 1)  //Alien roars when starting to break free
	..(I, cuff_break = INSTANT_CUFFBREAK)

/mob/living/carbon/alien/humanoid/do_resist_grab(moving_resist, forced, silent = FALSE)
	if(pulledby.grab_state && !silent)
		visible_message("<span class='danger'>[src] has broken free of [pulledby]'s grip!</span>")
	pulledby.stop_pulling()
	return TRUE

/mob/living/carbon/alien/humanoid/get_standard_pixel_y_offset(lying = 0)
	. = ..()
	if(leaping)
		. -= 32
	if(custom_pixel_y_offset)
		. += custom_pixel_y_offset

/mob/living/carbon/alien/humanoid/get_standard_pixel_x_offset(lying = 0)
	. = ..()
	if(leaping)
		. -= 32
	if(custom_pixel_x_offset)
		. += custom_pixel_x_offset

/mob/living/carbon/alien/humanoid/get_permeability_protection(list/target_zones)
	return 0.8

/mob/living/carbon/alien/humanoid/alien_evolve(mob/living/carbon/alien/humanoid/new_xeno)
	drop_all_held_items()
	for(var/atom/movable/A in stomach_contents)
		stomach_contents.Remove(A)
		new_xeno.stomach_contents.Add(A)
		A.forceMove(new_xeno)
	..()

//For alien evolution/promotion/queen finder procs. Checks for an active alien of that type
/proc/get_alien_type(var/alienpath)
	for(var/mob/living/carbon/alien/humanoid/A in GLOB.alive_mob_list)
		if(!istype(A, alienpath))
			continue
		if(!A.key || A.stat == DEAD) //Only living aliens with a ckey are valid.
			continue
		return A
	return FALSE

/mob/living/carbon/alien/humanoid/check_breath(datum/gas_mixture/breath)
	if(breath && breath.total_moles() > 0 && !sneaking)
		playsound(get_turf(src), pick('sound/voice/lowHiss2.ogg', 'sound/voice/lowHiss3.ogg', 'sound/voice/lowHiss4.ogg'), 50, 0, -5)
	..()
