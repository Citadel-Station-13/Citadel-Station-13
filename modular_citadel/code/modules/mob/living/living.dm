/mob/living

/atom
	var/pseudo_z_axis

/atom/proc/get_fake_z()
	return pseudo_z_axis

/obj/structure/table
	pseudo_z_axis = 8

/turf/open/get_fake_z()
	var/objschecked
	for(var/obj/structure/structurestocheck in contents)
		objschecked++
		if(structurestocheck.pseudo_z_axis)
			return structurestocheck.pseudo_z_axis
		if(objschecked >= 25)
			break
	return pseudo_z_axis

/mob/living/Move(atom/newloc, direct)
	. = ..()
	if(.)
		pseudo_z_axis = newloc.get_fake_z()
		pixel_z = pseudo_z_axis

/mob/living/carbon/update_stamina()
	var/total_health = getStaminaLoss()
	if(total_health)
		if(!recoveringstam && total_health >= STAMINA_CRIT && !stat)
			to_chat(src, "<span class='notice'>You're too exhausted to keep going...</span>")
			set_resting(TRUE, FALSE, FALSE)
			if(combatmode)
				toggle_combat_mode(TRUE)
			recoveringstam = TRUE
			filters += CIT_FILTER_STAMINACRIT
			update_mobility()
	if(recoveringstam && total_health <= STAMINA_SOFTCRIT)
		to_chat(src, "<span class='notice'>You don't feel nearly as exhausted anymore.</span>")
		recoveringstam = FALSE
		filters -= CIT_FILTER_STAMINACRIT
		update_mobility()
	update_health_hud()
