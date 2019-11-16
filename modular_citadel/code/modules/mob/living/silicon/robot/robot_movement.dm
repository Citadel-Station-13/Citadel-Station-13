/mob/living/silicon/robot
	var/sprinting = FALSE

/mob/living/silicon/robot/Move(NewLoc, direct)
	. = ..()
	if(. && sprinting && !(movement_type & FLYING) && canmove && !resting)
		if(!(cell?.use(25)))
			togglesprint(TRUE)

/mob/living/silicon/robot/movement_delay()
	. = ..()
	if(!resting && !sprinting)
		. += 1

/mob/living/silicon/robot/proc/togglesprint(shutdown = FALSE) //Basically a copypaste of the proc from /mob/living/carbon/human
	if(!shutdown && (!cell || cell.charge < 25))
		return FALSE
	sprinting = shutdown ? FALSE : !sprinting
	if(!resting && canmove)
		if(sprinting)
			playsound_local(src, 'modular_citadel/sound/misc/sprintactivate.ogg', 50, FALSE, pressure_affected = FALSE)
		else
			if(shutdown)
				playsound_local(src, 'sound/effects/light_flicker.ogg', 50, FALSE, pressure_affected = FALSE)
			playsound_local(src, 'modular_citadel/sound/misc/sprintdeactivate.ogg', 50, FALSE, pressure_affected = FALSE)
	if(hud_used && hud_used.static_inventory)
		for(var/obj/screen/sprintbutton/selector in hud_used.static_inventory)
			selector.insert_witty_toggle_joke_here(src)
	return TRUE

/mob/living/silicon/robot/proc/sprint_hotkey(targetstatus)
	if(targetstatus ? !sprinting : sprinting)
		togglesprint()
