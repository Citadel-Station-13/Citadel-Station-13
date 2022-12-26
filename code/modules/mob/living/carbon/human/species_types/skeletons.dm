/datum/species/skeleton
	name = "Skeleton"
	id = SPECIES_SKELETON
	say_mod = "rattles"
	blacklisted = 0
	sexes = 0
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/skeleton
	species_traits = list(NOBLOOD,NOGENITALS,NOAROUSAL,HAS_BONE,NOTRANSSTING)
	inherent_traits = list(TRAIT_EASYDISMEMBER,TRAIT_LIMBATTACHMENT,TRAIT_CALCIUM_HEALER)
	inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID
	mutanttongue = /obj/item/organ/tongue/bone
	damage_overlay_type = ""//let's not show bloody wounds or burns over bones.
	disliked_food = NONE
	liked_food = GROSS | MEAT | RAW | DAIRY
	brutemod = 1.25
	burnmod = 1.25

	species_category = SPECIES_CATEGORY_SKELETON //they have their own category that's disassociated from undead, paired with plasmapeople
	wings_icons = SPECIES_WINGS_SKELETAL
	balance_point_values = TRUE
	blacklisted_quirks = list(/datum/quirk/paper_skin)

/datum/species/skeleton/New()
	if(SSevents.holidays && SSevents.holidays[HALLOWEEN]) //skeletons are stronger during the spooky season!
		inherent_traits |= list(TRAIT_RESISTHEAT, TRAIT_NOBREATH, TRAIT_PIERCEIMMUNE, TRAIT_FAKEDEATH, TRAIT_RESISTCOLD, TRAIT_RADIMMUNE)
		brutemod = 1
		burnmod = 1
	..()

/datum/species/skeleton/check_roundstart_eligible()
	if(SSevents.holidays && SSevents.holidays[HALLOWEEN])
		return TRUE
	return ..()

/datum/species/skeleton/space
	name = "Spooky Spacey Skeleton"
	id = SPECIES_SKELETON_SPACE
	limbs_id = SPECIES_SKELETON
	blacklisted = 1
	balance_point_values = FALSE
	inherent_traits = list(TRAIT_RESISTHEAT,TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_RADIMMUNE,TRAIT_PIERCEIMMUNE,TRAIT_NOHUNGER,TRAIT_EASYDISMEMBER,TRAIT_LIMBATTACHMENT, TRAIT_FAKEDEATH, TRAIT_CALCIUM_HEALER)

/datum/species/skeleton/space/check_roundstart_eligible()
	return FALSE
