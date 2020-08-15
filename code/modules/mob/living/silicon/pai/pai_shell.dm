
/mob/living/silicon/pai/proc/fold_out(force = FALSE)
	if(emitterhealth < 0)
		to_chat(src, "<span class='warning'>Your holochassis emitters are still too unstable! Please wait for automatic repair.</span>")
		return FALSE

	if(!canholo && !force)
		to_chat(src, "<span class='warning'>Your master or another force has disabled your holochassis emitters!</span>")
		return FALSE

	if(holoform)
		. = fold_in(force)
		return

	if(world.time < emitter_next_use)
		to_chat(src, "<span class='warning'>Error: Holochassis emitters recycling. Please try again later.</span>")
		return FALSE

	emitter_next_use = world.time + emittercd
	density = TRUE
	if(istype(card.loc, /obj/item/pda))
		var/obj/item/pda/P = card.loc
		P.pai = null
		P.visible_message("<span class='notice'>[src] ejects itself from [P]!</span>")
	if(isliving(card.loc))
		var/mob/living/L = card.loc
		if(!L.temporarilyRemoveItemFromInventory(card))
			to_chat(src, "<span class='warning'>Error: Unable to expand to mobile form. Chassis is restrained by some device or person.</span>")
			return FALSE
	if(istype(card.loc, /obj/item/integrated_circuit/input/pAI_connector))
		var/obj/item/integrated_circuit/input/pAI_connector/C = card.loc
		C.RemovepAI()
		C.visible_message("<span class='notice'>[src] ejects itself from [C]!</span>")
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
		C.installed_pai = null
		C.push_data()
	forceMove(get_turf(card))
	card.forceMove(src)
	update_mobility()
	if(client)
		client.perspective = EYE_PERSPECTIVE
		client.eye = src
	set_light(0)
	icon_state = "[chassis]"
	visible_message("<span class='boldnotice'>[src] folds out its holochassis emitter and forms a holoshell around itself!</span>")
	holoform = TRUE

/mob/living/silicon/pai/proc/fold_in(force = FALSE)
	emitter_next_use = world.time + (force? emitteroverloadcd : emittercd)
	icon_state = "[chassis]"
	if(!holoform)
		. = fold_out(force)
		return
	if(force)
		short_radio()
		visible_message("<span class='warning'>[src] shorts out, collapsing back into their storage card, sparks emitted from their radio antenna!</span>")
	else
		visible_message("<span class='notice'>[src] deactivates its holochassis emitter and folds back into a compact card!</span>")
	stop_pulling()
	if(client)
		client.perspective = EYE_PERSPECTIVE
		client.eye = card
	var/turf/T = drop_location()
	release_vore_contents()
	card.forceMove(T)
	forceMove(card)
	density = FALSE
	set_light(0)
	holoform = FALSE
	set_resting(FALSE, TRUE, FALSE)
	update_mobility()

/mob/living/silicon/pai/proc/choose_chassis()
	if(!isturf(loc) && loc != card)
		to_chat(src, "<span class='boldwarning'>You can not change your holochassis composite while not on the ground or in your card!</span>")
		return FALSE
	var/list/choices = list("Preset - Basic", "Preset - Dynamic")
	if(CONFIG_GET(flag/pai_custom_holoforms))
		choices += "Custom"
	var/old_chassis = chassis
	var/choicetype = input(src, "What type of chassis do you want to use?") as null|anything in choices
	if(!choicetype)
		return FALSE
	switch(choicetype)
		if("Custom")
			chassis = "custom"
		if("Preset - Basic")
			var/choice = input(src, "What would you like to use for your holochassis composite?") as null|anything in possible_chassis
			if(!choice)
				return FALSE
			chassis = choice
		if("Preset - Dynamic")
			var/choice = input(src, "What would you like to use for your holochassis composite?") as null|anything in dynamic_chassis_icons
			if(!choice)
				return FALSE
			chassis = "dynamic"
			dynamic_chassis = choice
	resist_a_rest(FALSE, TRUE)
	update_icon()
	if(possible_chassis[old_chassis])
		RemoveElement(/datum/element/mob_holder, old_chassis, 'icons/mob/pai_item_head.dmi', 'icons/mob/pai_item_rh.dmi', 'icons/mob/pai_item_lh.dmi', ITEM_SLOT_HEAD)
	if(possible_chassis[chassis])
		AddElement(/datum/element/mob_holder, chassis, 'icons/mob/pai_item_head.dmi', 'icons/mob/pai_item_rh.dmi', 'icons/mob/pai_item_lh.dmi', ITEM_SLOT_HEAD)
	to_chat(src, "<span class='boldnotice'>You switch your holochassis projection composite to [chassis]</span>")

/mob/living/silicon/pai/lay_down()
	. = ..()
	if(loc != card)
		visible_message("<span class='notice'>[src] [resting? "lays down for a moment..." : "perks up from the ground"]</span>")
	update_icon()

/mob/living/silicon/pai/start_pulling(atom/movable/AM, state, force = move_force, supress_message = FALSE)
	if(ispAI(AM))
		return ..()
	return FALSE

/mob/living/silicon/pai/proc/toggle_integrated_light()
	if(!light_range)
		set_light(brightness_power)
		to_chat(src, "<span class='notice'>You enable your integrated light.</span>")
	else
		set_light(0)
		to_chat(src, "<span class='notice'>You disable your integrated light.</span>")

/mob/living/silicon/pai/verb/toggle_chassis_sit()
	set name = "Toggle Chassis Sit"
	set category = "IC"
	set desc = "Whether or not to try to use a sitting icon versus a resting icon. Takes priority over belly-up resting."
	dynamic_chassis_sit = !dynamic_chassis_sit
	to_chat(usr, "<span class='boldnotice'>You are now [dynamic_chassis_sit? "sitting" : "lying down"].</span>")
	update_icon()

/mob/living/silicon/pai/verb/toggle_chassis_bellyup()
	set name = "Toggle Chassis Belly Up"
	set category = "IC"
	set desc = "Whether or not to try to use a belly up icon while resting. Overridden by sitting."
	dynamic_chassis_bellyup = !dynamic_chassis_bellyup
	to_chat(usr, "<span class='boldnotice'>You are now lying on your [dynamic_chassis_bellyup? "back" : "front"].</span>")
	update_icon()

/mob/living/silicon/pai/can_buckle_others(mob/living/target, atom/buckle_to)
	return ispAI(target) && ..()
