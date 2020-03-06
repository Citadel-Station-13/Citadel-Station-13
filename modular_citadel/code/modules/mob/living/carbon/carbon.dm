/mob/living/carbon
	var/combatmode = FALSE //literally lifeweb
	var/lastmousedir
	var/wrongdirmovedelay
	var/lastdirchange
	var/combatmessagecooldown

	//oh no vore time
	var/voremode = FALSE

/mob/living/carbon/proc/toggle_combat_mode(forced, silent)
	if(!forced)
		if(recoveringstam || stat != CONSCIOUS)
			return TRUE
		for(var/i in status_effects)
			var/datum/status_effect/S = i
			if(S.blocks_combatmode)
				return TRUE
	combatmode = !combatmode
	if(voremode)
		toggle_vore_mode()
	if(!silent)
		if(combatmode)
			if(world.time >= combatmessagecooldown)
				if(a_intent != INTENT_HELP)
					visible_message("<span class='warning'>[src] [resting ? "tenses up" : (prob(95)? "drops into a combative stance" : (prob(95)? "poses aggressively" : "asserts dominance with their pose"))].</span>")
				else
					visible_message("<span class='notice'>[src] [pick("looks","seems","goes")] [pick("alert","attentive","vigilant")].</span>")
			playsound_local(src, 'sound/misc/ui_toggle.ogg', 50, FALSE, pressure_affected = FALSE) //Sound from interbay!
		else
			playsound_local(src, 'sound/misc/ui_toggleoff.ogg', 50, FALSE, pressure_affected = FALSE) //Slightly modified version of the above!
	if(client)
		client.show_popup_menus = !combatmode // So we can right-click for alternate actions and all that other good shit. Also moves examine to shift+rightclick to make it possible to attack while sprinting
	var/obj/screen/combattoggle/T = locate() in hud_used?.static_inventory
	T?.update_icon_state()
	combatmessagecooldown = 10 SECONDS + world.time //This is set 100% of the time to make sure squeezing regen out of process cycles doesn't result in the combat mode message getting spammed
	SEND_SIGNAL(src, COMSIG_COMBAT_TOGGLED, src, combatmode)
	return TRUE

mob/living/carbon/proc/toggle_vore_mode()
	voremode = !voremode
	var/obj/screen/voretoggle/T = locate() in hud_used?.static_inventory
	T?.update_icon_state()
	if(combatmode)
		return FALSE //let's not override the main draw of the game these days
	SEND_SIGNAL(src, COMSIG_VORE_TOGGLED, src, voremode)
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
