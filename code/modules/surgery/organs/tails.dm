/obj/item/organ/tail
	name = "tail"
	desc = "What did you cut this off of?"
	zone = "groin"
	slot = ORGAN_SLOT_TAIL

/obj/item/organ/tail/cat
	name = "cat tail"
	desc = "Who's wagging now?"
	icon_state = "severedtail"

/obj/item/organ/tail/cat/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
<<<<<<< HEAD
	color = H.hair_color
	H.dna.features["tail_human"] = "Cat"
	H.update_body()
=======
	if(istype(H))
		if(!("tail_human" in H.dna.species.mutant_bodyparts))
			H.dna.species.mutant_bodyparts |= "tail_human"
			H.dna.features["tail_human"] = tail_type
			H.update_body()

/obj/item/organ/tail/cat/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	if(istype(H))
		H.dna.species.mutant_bodyparts -= "tail_human"
		tail_type = H.dna.features["tail_human"]
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
		if(!("tail_lizard" in H.dna.species.mutant_bodyparts))
			H.dna.features["tail_lizard"] = tail_type
			H.dna.species.mutant_bodyparts |= "tail_lizard"

		if(!("spines" in H.dna.species.mutant_bodyparts))
			H.dna.features["spines"] = spines
			H.dna.species.mutant_bodyparts |= "spines"
		H.update_body()
>>>>>>> aaefa67... Merge pull request #32438 from ACCount12/snowflake_tail_fix

/obj/item/organ/ears/cat/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	H.endTailWag()
	H.dna.features["tail_human"] = "None"
	color = H.hair_color
	H.update_body()
