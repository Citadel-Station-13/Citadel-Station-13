/mob/living/carbon
	var/combatmode = FALSE //literally lifeweb
	var/lastmousedir
	var/wrongdirmovedelay
	var/lastdirchange
	var/combatmessagecooldown

/mob/living/carbon/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(.)
		var/mob/living/mobdude = mover
		if(istype(mobdude))
			if(!resting && mobdude.resting)
				if(!(mobdude.pass_flags & PASSMOB))
					return FALSE
	return .

/mob/living/carbon/proc/toggle_combat_mode()
	if(recoveringstam)
		return TRUE
	combatmode = !combatmode
	if(combatmode)
		playsound_local(src, 'modular_citadel/sound/misc/ui_toggle.ogg', 50, FALSE, pressure_affected = FALSE) //Sound from interbay!
	else
		playsound_local(src, 'modular_citadel/sound/misc/ui_toggleoff.ogg', 50, FALSE, pressure_affected = FALSE) //Slightly modified version of the above!
	if(client)
		client.show_popup_menus = !combatmode // So we can right-click for alternate actions and all that other good shit. Also moves examine to shift+rightclick to make it possible to attack while sprinting
	if(hud_used && hud_used.static_inventory)
		for(var/obj/screen/combattoggle/selector in hud_used.static_inventory)
			selector.rebasetointerbay(src)
	if(world.time >= combatmessagecooldown && combatmode)
		visible_message("<span class='warning'>[src] [resting ? "tenses up" : (prob(95)? "drops into a combative stance" : (prob(95)? "poses aggressively" : "asserts dominance with their pose"))].</span>")
	combatmessagecooldown = 10 SECONDS + world.time //This is set 100% of the time to make sure squeezing regen out of process cycles doesn't result in the combat mode message getting spammed
	SEND_SIGNAL(src, COMSIG_COMBAT_TOGGLED, src, combatmode)
	return TRUE

/mob/living/carbon/Move(atom/newloc, direct = 0)
	var/currentdirection = dir
	. = ..()
	wrongdirmovedelay = FALSE
	if(combatmode && client && lastmousedir)
		if(lastmousedir != dir)
			wrongdirmovedelay = TRUE
			setDir(lastmousedir, ismousemovement = TRUE)
	if(currentdirection != dir)
		lastdirchange = world.time


/mob/living/carbon/onMouseMove(object, location, control, params)
	if(!combatmode)
		return
	mouse_face_atom(object)
	lastmousedir = dir

/mob/living/carbon/setDir(newdir, ismousemovement = FALSE)
	if(!combatmode || ismousemovement)
		if(dir != newdir)
			lastdirchange = world.time
		. = ..()
	else
		return
