// Note: tails only work in humans. They use human-specific parameters and rely on human code for displaying.

/obj/item/organ/tail
	name = "tail"
	desc = "A severed tail. What did you cut this off of?"
	icon_state = "severedtail"
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_TAIL
	var/tail_type = "None"

/obj/item/organ/tail/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	if(H && H.dna && H.dna.species)
		H.dna.species.stop_wagging_tail(H)

/obj/item/organ/tail/cat
	name = "cat tail"
	desc = "A severed cat tail. Who's wagging now?"
	tail_type = "Cat"

/obj/item/organ/tail/cat/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
	if(istype(H))
		if(!(FEAT_TAIL_HUMAN in H.dna.species.mutant_bodyparts))
			H.dna.species.mutant_bodyparts |= FEAT_TAIL_HUMAN
			H.dna.features[FEAT_TAIL_HUMAN] = tail_type
			H.update_body()

/obj/item/organ/tail/cat/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	if(istype(H))
		H.dna.features[FEAT_TAIL_HUMAN] = "None"
		H.dna.species.mutant_bodyparts -= FEAT_TAIL_HUMAN
		color = H.hair_color
		H.update_body()

/obj/item/organ/tail/lizard
	name = "lizard tail"
	desc = "A severed lizard tail. Somewhere, no doubt, a lizard hater is very pleased with themselves."
	color = "#116611"
	tail_type = "Smooth"
	var/spines = "None"

/obj/item/organ/tail/lizard/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
	if(istype(H))
		// Checks here are necessary so it wouldn't overwrite the tail of a lizard it spawned in
		if(!(FEAT_TAIL_LIZARD in H.dna.species.mutant_bodyparts))
			H.dna.features[FEAT_TAIL_LIZARD] = tail_type
			H.dna.species.mutant_bodyparts |= FEAT_TAIL_LIZARD

		if(!(FEAT_SPINES in H.dna.species.mutant_bodyparts))
			H.dna.features[FEAT_SPINES] = spines
			H.dna.species.mutant_bodyparts |= FEAT_SPINES
		H.update_body()

/obj/item/organ/tail/lizard/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	if(istype(H))
		H.dna.species.mutant_bodyparts -= FEAT_TAIL_LIZARD
		H.dna.species.mutant_bodyparts -= FEAT_SPINES
		color = "#" + H.dna.features[FEAT_MUTCOLOR]
		tail_type = H.dna.features[FEAT_TAIL_LIZARD]
		spines = H.dna.features[FEAT_SPINES]
		H.update_body()
