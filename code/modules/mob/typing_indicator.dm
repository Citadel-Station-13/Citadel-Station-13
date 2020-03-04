/// state = overlay/image/object/type/whatever add_overlay will accept
GLOBAL_LIST_EMPTY(typing_indicator_overlays)

/// Fetches the typing indicator we'll use from GLOB.typing_indicator_overlays
/mob/proc/get_indicator_overlay(state)
	. = GLOB.typing_indicator_overlays[state]
	if(.)
		return
	// doesn't exist, make it and cache it
	if(ispath(state))
		. = GLOB.typing_indicator_overlays[state] = state
	// We only support paths for now because anything else isn't necessary yet.

/// Gets the state we will use for typing indicators. Defaults to src.typing_indicator_state
/mob/proc/get_typing_indicator_icon_state()
	return typing_indicator_state

/**
  * Displays typing indicator.
  * @param timeout_override - Sets how long until this will disappear on its own without the user finishing their message or logging out. Defaults to src.typing_indicator_timeout
  * @param state_override - Sets the state that we will fetch. Defaults to src.get_typing_indicator_icon_state()
  * @param force - shows even if src.typing_indcator_enabled is FALSE.
  */
/mob/proc/display_typing_indicator(timeout_override = TYPING_INDICATOR_TIMEOUT, state_override = get_typing_indicator_icon_state(), force = FALSE)
	if((!typing_indicator_enabled && !force) || typing_indicator_timerid)
		return
	typing_indicator_timerid = addtimer(CALLBACK(src, .proc/clear_typing_indicator, state_override), timeout_override, TIMER_STOPPABLE)
	var/overlay = get_indicator_overlay(state_override)
	add_overlay(get_indicator_overlay(state_override))

/**
  * Removes typing indicator.
  * @param state_override Sets the state that we will remove. Defaults to src.get_typing_indicator_icon_state()
  */
/mob/proc/clear_typing_indicator(state_override = get_typing_indicator_icon_state())
	deltimer(typing_indicator_timerid)
	typing_indicator_timerid = null
	cut_overlay(get_indicator_overlay(state_override))

/// Default typing indicator
/obj/effect/overlay/typing_indicator
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/mob/talk.dmi'
	icon_state = "normal_typing"
	appearance_flags = RESET_COLOR | TILE_BOUND | PIXEL_SCALE
	layer = LARGE_MOB_LAYER
