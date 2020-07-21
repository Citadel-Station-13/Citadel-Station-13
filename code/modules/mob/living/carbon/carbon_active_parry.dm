/mob/living/carbon/check_unarmed_parry_activation_special()
	return ..() && length(get_empty_held_indexes())
