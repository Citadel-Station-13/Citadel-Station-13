/mob/living/silicon/robot/Move(NewLoc, direct)
	. = ..()
	if(. && sprinting && !(movement_type & FLYING) && CHECK_MULTIPLE_BITFIELDS(mobility_flags, MOBILITY_STAND | MOBILITY_MOVE))
		if(!(cell?.use(25)))
			togglesprint(TRUE)

/mob/living/silicon/robot/movement_delay()
	. = ..()
	if(!resting && !sprinting)
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
	if(targetstatus ? !sprinting : sprinting)
		togglesprint()
