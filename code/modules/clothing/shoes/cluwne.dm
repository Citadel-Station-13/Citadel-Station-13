/obj/item/clothing/shoes/clown_shoes/cluwne
	desc = "The prankster's standard-issue clowning shoes. Damn, they're huge!"
	name = "clown shoes"
	icon_state = "cluwne"
	item_state = "cluwne"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	item_flags = DROPDEL
	var/footstep = 1

/obj/item/clothing/shoes/clown_shoes/cluwne/Initialize(mapload)
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
	ADD_TRAIT(src, CURSED_ITEM_TRAIT, CLOTHING_TRAIT)

/obj/item/clothing/shoes/clown_shoes/cluwne/step_action()
	if(footstep > 1)
		playsound(src, "clownstep", 50, 1)
		footstep = 0
	else
		footstep++

/obj/item/clothing/shoes/clown_shoes/cluwne/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot == ITEM_SLOT_FEET)
		var/mob/living/carbon/human/H = user
		H.dna.add_mutation(CLUWNEMUT)
	return
