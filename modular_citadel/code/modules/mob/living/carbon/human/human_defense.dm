/mob/living/carbon/human/alt_attack_hand(mob/user)
	if(..())
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!dna.species.alt_spec_attack_hand(H, src))
			dna.species.spec_attack_hand(H, src)
		return TRUE
