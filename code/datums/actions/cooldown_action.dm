#define COOLDOWN_NO_DISPLAY_TIME (180 SECONDS)

/// Preset for an action with a cooldown
/datum/action/cooldown
	check_flags = 0
	transparent_when_unavailable = FALSE
	/// The default cooldown applied when StartCooldown() is called
	var/cooldown_time = 0
	/// The actual next time this ability can be used
	var/next_use_time = 0
	/// Whether or not you want the cooldown for the ability to display in text form
	var/text_cooldown = TRUE
	/// Significant figures to round cooldown to
	var/cooldown_rounding = 0.1
	/// Setting for intercepting clicks before activating the ability
	var/click_to_activate = FALSE
	/// Shares cooldowns with other cooldown abilities of the same value, not active if null
	var/shared_cooldown
	/// The base icon_state of this action's background
	var/base_background_icon_state
	/// The icon state the background uses when active
	var/active_background_icon_state
	/// The base icon_state of the overlay we apply
	var/base_overlay_icon_state
	/// The active icon_state of the overlay we apply
	var/active_overlay_icon_state
	/// The base icon state of the spell's button icon, used for editing the icon "off"
	var/base_icon_state
	/// The active icon state of the spell's button icon, used for editing the icon "on"
	var/active_icon_state

/datum/action/cooldown/create_button()
	var/atom/movable/screen/movable/action_button/button = ..()
	button.maptext = ""
	button.maptext_x = 8
	button.maptext_y = 0
	button.maptext_width = 24
	button.maptext_height = 12
	return button

/datum/action/cooldown/update_button_status(atom/movable/screen/movable/action_button/button, force = FALSE)
	. = ..()
	var/time_left = max(next_use_time - world.time, 0)
	if(!text_cooldown || !owner || time_left == 0 || time_left >= COOLDOWN_NO_DISPLAY_TIME)
		button.maptext = ""
	else
		if (cooldown_rounding > 0)
			button.maptext = MAPTEXT_TINY_UNICODE("[round(time_left/10, cooldown_rounding)]")
		else
			button.maptext = MAPTEXT_TINY_UNICODE("[round(time_left/10)]")

	if(!IsAvailable() || !is_action_active(button))
		return
	// If we don't change the icon state, or don't apply a special overlay,
	if(active_background_icon_state || active_icon_state || active_overlay_icon_state)
		return
	// ...we need to show it's active somehow. So, make it greeeen
	button.color = COLOR_GREEN

/datum/action/cooldown/apply_button_background(atom/movable/screen/movable/action_button/current_button, force)
	if(active_background_icon_state)
		background_icon_state = is_action_active(current_button) ? active_background_icon_state : base_background_icon_state
	return ..()

/datum/action/cooldown/apply_button_icon(atom/movable/screen/movable/action_button/current_button, force)
	if(active_icon_state)
		button_icon_state = is_action_active(current_button) ? active_icon_state : base_icon_state
	return ..()

/datum/action/cooldown/apply_button_overlay(atom/movable/screen/movable/action_button/current_button, force)
	if(active_overlay_icon_state)
		overlay_icon_state = is_action_active(current_button) ? active_overlay_icon_state : base_overlay_icon_state
	return ..()

/datum/action/cooldown/is_action_active(atom/movable/screen/movable/action_button/current_button)
	return click_to_activate && current_button.our_hud?.mymob?.click_intercept == src

/datum/action/cooldown/IsAvailable(feedback = FALSE)
	return ..() && (next_use_time <= world.time)

/// Starts a cooldown time to be shared with similar abilities, will use default cooldown time if an override is not specified
/datum/action/cooldown/proc/StartCooldown(override_cooldown_time)
	if(shared_cooldown)
		for(var/datum/action/cooldown/shared_ability in owner.actions - src)
			if(shared_cooldown == shared_ability.shared_cooldown)
				if(isnum(override_cooldown_time))
					shared_ability.StartCooldownSelf(override_cooldown_time)
				else
					shared_ability.StartCooldownSelf(cooldown_time)
	StartCooldownSelf(override_cooldown_time)

/// Starts a cooldown time for this ability only, will use default cooldown time if an override is not specified
/datum/action/cooldown/proc/StartCooldownSelf(override_cooldown_time)
	if(isnum(override_cooldown_time))
		next_use_time = world.time + override_cooldown_time
	else
		next_use_time = world.time + cooldown_time
	build_all_button_icons()
	START_PROCESSING(SSfastprocess, src)

/datum/action/cooldown/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	if(!owner)
		return FALSE
	if(click_to_activate)
		if(target)
			// For automatic / mob handling
			return InterceptClickOn(owner, null, target)
		if(owner.click_intercept == src)
			owner.click_intercept = null
		else
			owner.click_intercept = src
		for(var/datum/action/cooldown/ability in owner.actions)
			ability.build_all_button_icons()
		return TRUE
	return PreActivate(owner)

/// Intercepts client owner clicks to activate the ability
/datum/action/cooldown/proc/InterceptClickOn(mob/living/caller, params, atom/target)
	if(!IsAvailable())
		return FALSE
	if(!target)
		return FALSE
	PreActivate(target)
	caller.click_intercept = null
	return TRUE

/// For signal calling
/datum/action/cooldown/proc/PreActivate(atom/target)
	if(SEND_SIGNAL(owner, COMSIG_MOB_ABILITY_STARTED, src) & COMPONENT_BLOCK_ABILITY_START)
		return
	. = Activate(target)
	SEND_SIGNAL(owner, COMSIG_MOB_ABILITY_FINISHED, src)

/// To be implemented by subtypes
/datum/action/cooldown/proc/Activate(atom/target)
	return

/datum/action/cooldown/process()
	var/time_left = max(next_use_time - world.time, 0)
	if(!owner || time_left == 0)
		STOP_PROCESSING(SSfastprocess, src)
	build_all_button_icons()

/datum/action/cooldown/Grant(mob/M)
	..()
	if(!owner)
		return
	build_all_button_icons()
	if(next_use_time > world.time)
		START_PROCESSING(SSfastprocess, src)
