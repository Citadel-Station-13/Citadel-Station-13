/mob/living/ComponentInitialize()
	. = ..()
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_SPRINT_LOCKED), .proc/update_sprint_lock)

/mob/living/carbon/human/proc/togglesprint() // If you call this proc outside of hotkeys or clicking the HUD button, I'll be disappointed in you.
	sprinting = !sprinting
	if((m_intent == MOVE_INTENT_RUN) && CHECK_ALL_MOBILITY(src, MOBILITY_STAND|MOBILITY_MOVE))
		if(sprinting)
			playsound_local(src, 'sound/misc/sprintactivate.ogg', 50, FALSE, pressure_affected = FALSE)
		else
			playsound_local(src, 'sound/misc/sprintdeactivate.ogg', 50, FALSE, pressure_affected = FALSE)
	var/obj/screen/sprintbutton/S = locate() in hud_used?.static_inventory
	S?.update_icon_state()
	return TRUE

/mob/living/carbon/human/proc/sprint_hotkey(targetstatus)
	if(targetstatus != sprinting)
		togglesprint()
/mob/living/carbon/human/Move(NewLoc, direct)
	var/oldpseudoheight = pseudo_z_axis
	. = ..()
	if(. && IS_SPRINTING(src) && !(movement_type & FLYING) && CHECK_ALL_MOBILITY(src, MOBILITY_MOVE|MOBILITY_STAND) && m_intent == MOVE_INTENT_RUN && has_gravity(loc) && !pulledby)
		if(!HAS_TRAIT(src, TRAIT_FREESPRINT))
			doSprintLossTiles(1)
		if((oldpseudoheight - pseudo_z_axis) >= 8)
			to_chat(src, "<span class='warning'>You trip off of the elevated surface!</span>")
			for(var/obj/item/I in held_items)
				accident(I)
			DefaultCombatKnockdown(80)

/mob/living/carbon/human/movement_delay()
	. = 0
	if(CHECK_MOBILITY(src, MOBILITY_STAND) && m_intent == MOVE_INTENT_RUN && IS_SPRINTING(src))
		var/static/datum/config_entry/number/movedelay/sprint_speed_increase/SSI
		if(!SSI)
			SSI = CONFIG_GET_ENTRY(number/movedelay/sprint_speed_increase)
		. -= SSI.config_entry_value
	if(wrongdirmovedelay)
		. += 1
	. += ..()

/mob/living/carbon/doSprintLossTiles(tiles)
	doSprintBufferRegen(FALSE)		//first regen.
	if(sprint_buffer)
		var/use = min(tiles, sprint_buffer)
		sprint_buffer -= use
		tiles -= use
	update_hud_sprint_bar()
	if(!tiles)		//we had enough, we're done!
		return
	adjustStaminaLoss(tiles * sprint_stamina_cost)		//use stamina to cover deficit.

/mob/living/carbon/proc/doSprintBufferRegen(updating = TRUE)
	var/diff = world.time - sprint_buffer_regen_last
	sprint_buffer_regen_last = world.time
	sprint_buffer = min(sprint_buffer_max, sprint_buffer + sprint_buffer_regen_ds * diff)
	if(updating)
		update_hud_sprint_bar()


/mob/living/proc/update_hud_sprint_bar()
	if(hud_used && hud_used.sprint_buffer)
		hud_used.sprint_buffer.update_to_mob(src)

/mob/living/update_config_movespeed()
	. = ..()
	sprint_buffer_max = CONFIG_GET(number/movedelay/sprint_buffer_max)
	sprint_buffer_regen_ds = CONFIG_GET(number/movedelay/sprint_buffer_regen_per_ds)
	sprint_stamina_cost = CONFIG_GET(number/movedelay/sprint_stamina_cost)

/mob/living/movement_delay(ignorewalk = 0)
	. = ..()
	if(!CHECK_MOBILITY(src, MOBILITY_STAND))
		. += 6

/mob/living/silicon/robot/Move(NewLoc, direct)
	. = ..()
	if(. && IS_SPRINTING(src) && !(movement_type & FLYING) && CHECK_ALL_MOBILITY(src, MOBILITY_STAND | MOBILITY_MOVE))
		if(!(cell?.use(25)))
			togglesprint(TRUE)

/mob/living/silicon/robot/movement_delay()
	. = ..()
	if(!resting && !IS_SPRINTING(src))
		. += 1
	. += speed

/mob/living/silicon/robot/proc/togglesprint(shutdown = FALSE) //Basically a copypaste of the proc from /mob/living/carbon/human
	if(!shutdown && (!cell || cell.charge < 25) || !cansprint)
		return FALSE
	sprinting = shutdown ? FALSE : !sprinting
	if(CHECK_MULTIPLE_BITFIELDS(mobility_flags, MOBILITY_STAND|MOBILITY_MOVE))
		if(sprinting)
			playsound_local(src, 'sound/misc/sprintactivate.ogg', 50, FALSE, pressure_affected = FALSE)
		else
			if(shutdown)
				playsound_local(src, 'sound/effects/light_flicker.ogg', 50, FALSE, pressure_affected = FALSE)
			playsound_local(src, 'sound/misc/sprintdeactivate.ogg', 50, FALSE, pressure_affected = FALSE)
	var/obj/screen/sprintbutton/S = locate() in hud_used?.static_inventory
	S?.update_icon_state()
	return TRUE

/mob/living/silicon/robot/proc/sprint_hotkey(targetstatus)
	if(targetstatus != sprinting)
		togglesprint()
