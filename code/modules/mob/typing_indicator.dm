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

/// Generates the mutable appearance for typing indicator. Should prevent stuck overlays.
/mob/proc/generate_typing_indicator()
	var/state = get_typing_indicator_icon_state()
	if(ispath(state))
		var/atom/thing = new state(null)
		var/mutable_appearance/generated = new(thing)
		return generated
	else
		CRASH("Unsupported typing indicator state: [state]")

/**
  * Displays typing indicator.
  * @param timeout_override - Sets how long until this will disappear on its own without the user finishing their message or logging out. Defaults to src.typing_indicator_timeout
  * @param state_override - Sets the state that we will fetch. Defaults to src.get_typing_indicator_icon_state()
  * @param force - shows even if src.typing_indcator_enabled is FALSE.
  */
/mob/proc/display_typing_indicator(timeout_override = TYPING_INDICATOR_TIMEOUT, state_override = generate_typing_indicator(), force = FALSE)
	if(((!typing_indicator_enabled || (stat != CONSCIOUS)) && !force) || typing_indicator_current)
		return
	typing_indicator_current = state_override
	add_overlay(state_override)
	typing_indicator_timerid = addtimer(CALLBACK(src, .proc/clear_typing_indicator), timeout_override, TIMER_STOPPABLE)

/**
  * Removes typing indicator.
  */
/mob/proc/clear_typing_indicator()
	cut_overlay(typing_indicator_current)
	typing_indicator_current = null
	if(typing_indicator_timerid)
		deltimer(typing_indicator_timerid)
		typing_indicator_timerid = null

/// Default typing indicator
/obj/effect/overlay/typing_indicator
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/mob/talk.dmi'
	icon_state = "normal_typing"
	appearance_flags = RESET_COLOR | TILE_BOUND | PIXEL_SCALE
	layer = ABOVE_FLY_LAYER

/obj/effect/overlay/typing_indicator/machine
	icon_state = "machine_typing"

/obj/effect/overlay/typing_indicator/machine/dogborg
	icon = 'icons/mob/talk_64x64.dmi'

/obj/effect/overlay/typing_indicator/slime
	icon_state = "slime_typing"
