// Note: tails only work in humans. They use human-specific parameters and rely on human code for displaying.

/obj/item/organ/tail
	name = "tail"
	desc = "A severed tail. What did you cut this off of?"
	icon_state = "severedtail"
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_TAIL
	var/tail_type = "None"

/obj/item/organ/tail/Remove(special = FALSE)
	if(owner?.dna?.species)
		owner.dna.species.stop_wagging_tail(owner)
	return ..()

/obj/item/organ/tail/on_life()
	return

/obj/item/organ/tail/cat
	name = "cat tail"
	desc = "A severed cat tail. Who's wagging now?"
	tail_type = "Cat"

/obj/item/organ/tail/cat/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
	if(istype(H))
		if(!H.dna.species.mutant_bodyparts["mam_tail"])
			H.dna.species.mutant_bodyparts["mam_tail"] = tail_type
			H.dna.features["mam_tail"] = tail_type
			H.update_body()

/obj/item/organ/tail/cat/Remove(special = FALSE)
	if(!QDELETED(owner) && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.dna.features["mam_tail"] = "None"
		H.dna.species.mutant_bodyparts -= "mam_tail"
		color = H.hair_color
		H.update_body()
	return ..()

/obj/item/organ/tail/lizard
	name = "lizard tail"
	desc = "A severed lizard tail. Somewhere, no doubt, a lizard hater is very pleased with themselves."
	color = "#116611"
	tail_type = "Smooth"
	var/spines = "None"

/obj/item/organ/tail/lizard/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
	if(istype(H))
		// Checks here are necessary so it wouldn't overwrite the tail of a lizard it spawned in //yes, the if checks may cause snowflakes so that you can't insert another person's tail (haven't actually tested it but I assume that's the result of my addition) but it makes it so never again will lizards break their spine if set_species is called twice in a row (hopefully)
		if(!H.dna.species.mutant_bodyparts["tail_lizard"])
			if (!H.dna.features["tail_lizard"])
				H.dna.features["tail_lizard"] = tail_type
				H.dna.species.mutant_bodyparts["tail_lizard"] = tail_type
			else
				H.dna.species.mutant_bodyparts["tail_lizard"] = H.dna.features["tail_lizard"]

		if(!H.dna.species.mutant_bodyparts["spines"])
			if (!H.dna.features["spines"])
				H.dna.features["spines"] = spines
				H.dna.species.mutant_bodyparts["spines"] = spines
			else
				H.dna.species.mutant_bodyparts["spines"] = H.dna.features["spines"]
		H.update_body()

/obj/item/organ/tail/lizard/Remove(special = FALSE)
	if(!QDELETED(owner) && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.dna.species.mutant_bodyparts -= "tail_lizard"
		H.dna.species.mutant_bodyparts -= "spines"
		color = "#" + H.dna.features["mcolor"]
		tail_type = H.dna.features["tail_lizard"]
		spines = H.dna.features["spines"]
		H.update_body()
	return ..()
