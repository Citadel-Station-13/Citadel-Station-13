/mob/living/carbon/human/Move(NewLoc, direct)
	var/oldpseudoheight = pseudo_z_axis
	. = ..()
	if(. && sprinting && !(movement_type & FLYING) && CHECK_MULTIPLE_BITFIELDS(mobility_flags, MOBILITY_MOVE|MOBILITY_STAND) && m_intent == MOVE_INTENT_RUN && has_gravity(loc) && !pulledby)
		if(!HAS_TRAIT(src, TRAIT_FREESPRINT))
			doSprintLossTiles(1)
		if((oldpseudoheight - pseudo_z_axis) >= 8)
			to_chat(src, "<span class='warning'>You trip off of the elevated surface!</span>")
			for(var/obj/item/I in held_items)
				accident(I)
			DefaultCombatKnockdown(80)

/mob/living/carbon/human/movement_delay()
	. = 0
	if((mobility_flags & MOBILITY_STAND) && m_intent == MOVE_INTENT_RUN && sprinting)
		var/static/datum/config_entry/number/movedelay/sprint_speed_increase/SSI
		if(!SSI)
			SSI = CONFIG_GET_ENTRY(number/movedelay/sprint_speed_increase)
		. -= SSI.config_entry_value
	if(wrongdirmovedelay)
		. += 1
	. += ..()

/mob/living/carbon/human/proc/togglesprint() // If you call this proc outside of hotkeys or clicking the HUD button, I'll be disappointed in you.
	sprinting = !sprinting
	if((m_intent == MOVE_INTENT_RUN) && CHECK_MULTIPLE_BITFIELDS(mobility_flags, MOBILITY_STAND|MOBILITY_MOVE))
		if(sprinting)
			playsound_local(src, 'sound/misc/sprintactivate.ogg', 50, FALSE, pressure_affected = FALSE)
		else
			playsound_local(src, 'sound/misc/sprintdeactivate.ogg', 50, FALSE, pressure_affected = FALSE)
	var/obj/screen/sprintbutton/S = locate() in hud_used?.static_inventory
	S?.update_icon_state()
	return TRUE

/mob/living/carbon/human/proc/sprint_hotkey(targetstatus)
	if(targetstatus ? !sprinting : sprinting)
		togglesprint()
