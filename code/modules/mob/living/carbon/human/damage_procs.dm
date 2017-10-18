

/mob/living/carbon/human/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = FALSE, break_modifier = 1)
	// depending on the species, it will run the corresponding apply_damage code there
	return dna.species.apply_damage(damage, damagetype, def_zone, blocked, src, break_modifier)
