/mob/living/carbon
	var/combatmode = FALSE //literally lifeweb

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
	SendSignal(COMSIG_COMBAT_TOGGLED, src, combatmode)
	return TRUE
