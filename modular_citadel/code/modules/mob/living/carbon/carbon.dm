/mob/living/carbon
	var/lastmousedir
	var/wrongdirmovedelay

	//oh no vore time
	var/voremode = FALSE

/mob/living/carbon/proc/toggle_vore_mode()
	voremode = !voremode
	var/obj/screen/voretoggle/T = locate() in hud_used?.static_inventory
	T?.update_icon_state()
	if(combat_flags & COMBAT_FLAG_COMBAT_TOGGLED)
		return FALSE //let's not override the main draw of the game these days
	SEND_SIGNAL(src, COMSIG_VORE_TOGGLED, src, voremode)
	return TRUE

/mob/living/carbon/Move(atom/newloc, direct = 0)
	. = ..()
	wrongdirmovedelay = FALSE
	if((combat_flags & COMBAT_FLAG_COMBAT_ACTIVE) && client && lastmousedir)
		if(lastmousedir != dir)
			wrongdirmovedelay = TRUE
			setDir(lastmousedir, ismousemovement = TRUE)

/mob/living/carbon/onMouseMove(object, location, control, params)
	if(!(combat_flags & COMBAT_FLAG_COMBAT_ACTIVE))
		return
	face_atom(object, TRUE)
	lastmousedir = dir
