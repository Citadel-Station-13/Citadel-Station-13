/mob/living/ComponentInitialize()
	. = ..()
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_SPRINT_LOCKED), .proc/update_sprint_lock)

/mob/living/proc/update_sprint_icon()
	var/obj/screen/sprintbutton/S = locate() in hud_used?.static_inventory
	S?.update_icon_state()

/mob/living/proc/update_hud_sprint_bar()
	hud_used?.sprint_buffer?.update_to_mob(src)

/mob/living/proc/update_sprint_lock()
	var/locked = IS_SPRINT_LOCKED(src)
	var/current = IS_SPRINTING(src)
	var/desired = IS_SPRINT_TOGGLED(src)
	if(locked)
		if(current)
			disable_sprint_mode(FALSE)
	else
		if(current)
			if(!desired)
				disable_sprint_mode(FALSE)
		else
			if(desired)
				enable_sprint_mode(FALSE)
	update_sprint_icon()

/mob/living/proc/enable_sprint_mode(update_icon = TRUE)
	if(IS_SPRINTING(src))
		return
	ENABLE_BITFIELD(combat_flags, COMBAT_FLAG_SPRINT_ACTIVE)
	if(update_icon)
		update_sprint_icon()

/mob/living/proc/disable_sprint_mode(update_icon = TRUE)
	if(!IS_SPRINTING(src))
		return
	DISABLE_BITFIELD(combat_flags, COMBAT_FLAG_SPRINT_ACTIVE)
	if(update_icon)
		update_sprint_icon()

/mob/living/proc/enable_intentional_sprint_mode()
	if(IS_SPRINT_TOGGLED(src) && IS_SPRINTING(src))
		return
	ENABLE_BITFIELD(combat_flags, COMBAT_FLAG_SPRINT_TOGGLED)
	if(!IS_SPRINT_LOCKED(src) && !IS_SPRINTING(src))
		enable_sprint_mode(FALSE)
	update_sprint_icon()
	return TRUE

/mob/living/proc/disable_intentional_sprint_mode()
	if(!IS_SPRINT_TOGGLED(src) && !IS_SPRINTING(src))
		return
	DISABLE_BITFIELD(combat_flags, COMBAT_FLAG_SPRINT_TOGGLED)
	if(IS_SPRINTING(src))
		disable_sprint_mode(FALSE)
	update_sprint_icon()

/mob/living/proc/user_toggle_intentional_sprint_mode()
	var/old = IS_SPRINT_TOGGLED(src)
	if(old)
		disable_intentional_sprint_mode()
		if((m_intent == MOVE_INTENT_RUN) && CHECK_ALL_MOBILITY(src, MOBILITY_STAND|MOBILITY_MOVE))
			playsound_local(src, 'sound/misc/sprintdeactivate.ogg', 50, FALSE, pressure_affected = FALSE)
	else
		enable_intentional_sprint_mode()
		if((m_intent == MOVE_INTENT_RUN) && CHECK_ALL_MOBILITY(src, MOBILITY_STAND|MOBILITY_MOVE))
			playsound_local(src, 'sound/misc/sprintactivate.ogg', 50, FALSE, pressure_affected = FALSE)

/mob/living/proc/sprint_hotkey(targetstatus)
	if(targetstatus != IS_SPRINTING(src))
		default_toggle_sprint()

/mob/living/proc/doSprintLossTiles(amount)
	return

// Silicons have snowflake behavior.
/mob/living/proc/default_toggle_sprint()
	return user_toggle_intentional_sprint_mode()
