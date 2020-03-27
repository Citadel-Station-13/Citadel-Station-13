/mob/living/ComponentInitialize()
	. = ..()
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_COMBAT_MODE_LOCKED), .proc/update_combat_lock)

/mob/living/proc/update_combat_lock()
	var/locked = HAS_TRAIT(src, TRAIT_COMBAT_MODE_LOCKED)
	var/desired = (combat_flags & COMBAT_FLAG_COMBAT_TOGGLED)
	var/actual = (combat_flags & COMBAT_FLAG_COMBAT_ACTIVE)
	if(actual)
		if(locked)
			disable_combat_mode(FALSE, TRUE, FALSE, FALSE)
		else if(!desired)
			disable_combat_mode(TRUE, TRUE, FALSE, FALSE)
	else
		if(desired && !locked)
			enable_combat_mode(FALSE, TRUE, FALSE, FALSE)
	update_combat_mode_icon()

/mob/living/proc/disable_combat_mode(silent = TRUE, was_forced = FALSE, visible = FALSE, update_icon = TRUE)
	if(!(combat_flags & COMBAT_FLAG_COMBAT_ACTIVE))
		return
	DISABLE_BITFIELD(combat_flags, COMBAT_FLAG_COMBAT_ACTIVE)
	SEND_SIGNAL(src, COMSIG_LIVING_COMBAT_DISABLED, was_forced)
	if(visible)
		visible_message("<span class='warning'>[src] goes limp.</span>", "<span class='warning'>Your muscles are forcibly relaxed!</span>")
	else if(!silent)
		to_chat(src, was_forced? "<span class='warning'>Your muscles are forcibly relaxed!</span>" : "<span class='warning'>You relax your muscles.</span>")
	if(update_icon)
		update_combat_mode_icon()

/mob/living/proc/enable_combat_mode(silent = TRUE, was_forced = FALSE, visible = FALSE, update_icon = TRUE)
	if(combat_flags & COMBAT_FLAG_COMBAT_ACTIVE)
		return
	ENABLE_BITFIELD(combat_flags, COMBAT_FLAG_COMBAT_ACTIVE)
	SEND_SIGNAL(src, COMSIG_LIVING_COMBAT_ENABLED, was_forced)
	if(visible)
		visible_message("<span class='warning'>[src] drops into a combative stance!</span>", "<span class='warning'>You drop into a combative stance!</span>")
	else if(!silent)
		to_chat(src, was_forced? "<span class='warning'>Your muscles reflexively tighten!</span>" : "<span class='warning'>You tighten your muscles.</span>")
	if(update_icon)
		update_combat_mode_icon()

/// Updates the combat mode HUD icon.
/mob/living/proc/update_combat_mode_icon()
	var/obj/screen/combattoggle/T = locate() in hud_used?.static_inventory
	T?.update_icon()

/// Enables intentionally being in combat mode. Please try not to use this proc for feedback whenever possible.
/mob/living/proc/enable_intentional_combat_mode(silent = TRUE, visible = FALSE)
	if((combat_flags & COMBAT_FLAG_COMBAT_TOGGLED) && (combat_flags & COMBAT_FLAG_COMBAT_ACTIVE))
		return
	ENABLE_BITFIELD(combat_flags, COMBAT_FLAG_COMBAT_TOGGLED)
	if(!HAS_TRAIT(src, TRAIT_COMBAT_MODE_LOCKED) && !(combat_flags & COMBAT_FLAG_COMBAT_ACTIVE))
		enable_combat_mode(silent, FALSE, visible, FALSE)
	update_combat_mode_icon()
	client?.show_popup_menus = FALSE
	return TRUE

/// Disables intentionally being in combat mode. Please try not to use this proc for feedback whenever possible.
/mob/living/proc/disable_intentional_combat_mode(silent = TRUE, visible = FALSE)
	if(!(combat_flags & COMBAT_FLAG_COMBAT_TOGGLED) && !(combat_flags & COMBAT_FLAG_COMBAT_ACTIVE))
		return
	DISABLE_BITFIELD(combat_flags, COMBAT_FLAG_COMBAT_TOGGLED)
	if(combat_flags & COMBAT_FLAG_COMBAT_ACTIVE)
		disable_combat_mode(silent, FALSE, visible, FALSE)
	update_combat_mode_icon()
	client?.show_popup_menus = TRUE
	return TRUE

/// Toggles whether the user is intentionally in combat mode. THIS should be the proc you generally use! Has built in visual/to other player feedback, as well as an audible cue to ourselves.
/mob/living/proc/user_toggle_intentional_combat_mode(visible = TRUE)
	var/old = (combat_flags & COMBAT_FLAG_COMBAT_TOGGLED)
	if(old)
		disable_intentional_combat_mode()
		playsound_local(src, 'sound/misc/ui_toggleoff.ogg', 50, FALSE, pressure_affected = FALSE) //Slightly modified version of the above!
	else if(CAN_TOGGLE_COMBAT_MODE(src))
		enable_intentional_combat_mode()
	var/current = (combat_flags & COMBAT_FLAG_COMBAT_ACTIVE)		//because we could be locked
	if(current != old)		//only sound effect if you succeeded. Could have the feedback system be better but shrug, someone else can do it.
		if(current)
			playsound_local(src, 'sound/misc/ui_toggle.ogg', 50, FALSE, pressure_affected = FALSE) //Sound from interbay!
			if(visible)
				if(world.time >= combatmessagecooldown)
					combatmessagecooldown = world.time + 10 SECONDS
					if(a_intent != INTENT_HELP)
						visible_message("<span class='warning'>[src] [resting ? "tenses up" : (prob(95)? "drops into a combative stance" : (prob(95)? "poses aggressively" : "asserts dominance with their pose"))].</span>")
					else
						visible_message("<span class='notice'>[src] [pick("looks","seems","goes")] [pick("alert","attentive","vigilant")].</span>")
