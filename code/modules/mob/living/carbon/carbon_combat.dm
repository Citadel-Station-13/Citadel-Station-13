/mob/living/carbon/enable_intentional_combat_mode()
	. = ..()
	if(.)
		if(voremode)
			toggle_vore_mode()

