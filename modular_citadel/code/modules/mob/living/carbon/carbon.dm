/mob/living/carbon
	//oh no vore time
	var/voremode = FALSE

/mob/living/carbon/proc/toggle_vore_mode()
	if(combat_flags & COMBAT_FLAG_COMBAT_TOGGLED)
		return FALSE //let's not override the main draw of the game these days
	voremode = !voremode
	var/obj/screen/voretoggle/T = locate() in hud_used?.static_inventory
	T?.update_icon_state()
	return TRUE

/mob/living/carbon/proc/disable_vore_mode()
	voremode = FALSE
	var/obj/screen/voretoggle/T = locate() in hud_used?.static_inventory
	T?.update_icon_state()
