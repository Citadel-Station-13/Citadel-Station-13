/datum/species/mush //mush mush codecuck
	name = "Anthropomorphic Mushroom"
	id = SPECIES_MUSHROOM
	mutant_bodyparts = list("caps" = "Round")

	fixed_mut_color = "DBBF92"
	hair_color = "FF4B19" //cap color, spot color uses eye color
	nojumpsuit = TRUE

	say_mod = "poofs" //what does a mushroom sound like
	species_traits = list(MUTCOLORS, NOEYES, NO_UNDERWEAR,NOGENITALS,NOAROUSAL,HAS_FLESH,HAS_BONE)
	inherent_traits = list(TRAIT_NOBREATH)
	speedmod = 1.5 //faster than golems but not by much

	punchdamagelow = 2
	punchdamagehigh = 12 //still better than humans
	punchstunthreshold = 10

	no_equip = list(ITEM_SLOT_MASK, ITEM_SLOT_OCLOTHING, ITEM_SLOT_GLOVES, ITEM_SLOT_FEET, ITEM_SLOT_ICLOTHING)

	burnmod = 1.25
	heatmod = 1.5

	species_category = SPECIES_CATEGORY_PLANT

	mutanteyes = /obj/item/organ/eyes/night_vision/mushroom
	var/datum/martial_art/mushpunch/mush
	species_language_holder = /datum/language_holder/mushroom

/datum/species/mush/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	if(!ishuman(C))
		return
	var/mob/living/carbon/human/H = C
	if(!H.dna.features["caps"])
		H.dna.features["caps"] = "Round"
		handle_mutant_bodyparts(H)
	H.faction |= "mushroom"
	mush = new()
	mush.teach(H, TRUE)
	RegisterSignal(C, COMSIG_MOB_ON_NEW_MIND, PROC_REF(on_new_mind))

/datum/species/mush/proc/on_new_mind(mob/owner)
	mush.teach(owner, TRUE) //make_temporary TRUE as it shouldn't carry over to other mobs on mind transfer_to.

/datum/species/mush/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_ON_NEW_MIND)
	C.faction -= "mushroom"
	mush.remove(C)
	QDEL_NULL(mush)

/datum/species/mush/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.type == /datum/reagent/toxin/plantbgone/weedkiller)
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM)
		return TRUE
	return ..()

/datum/species/mush/handle_mutant_bodyparts(mob/living/carbon/human/H, forced_colour)
	forced_colour = FALSE
	..()
