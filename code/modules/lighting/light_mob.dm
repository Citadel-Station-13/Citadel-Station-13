/mob/living/carbon/human/update_contained_lights(var/list/specific_contents)
	. = ..(contents-(internal_organs))
