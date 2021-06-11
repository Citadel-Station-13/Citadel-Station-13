/obj/item/clothing/under/cluwne
	name = "clown suit"
	desc = "<i>'HONK!'</i>"
	icon_state = "greenclown"
	item_state = "greenclown"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	item_flags = DROPDEL
	can_adjust = 0
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/under/cluwne/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, CLOTHING_TRAIT)
	ADD_TRAIT(src, CURSED_ITEM_TRAIT, CLOTHING_TRAIT)

/obj/item/clothing/under/cluwne/equipped(mob/living/carbon/user, slot)
	if(!ishuman(user))
		return
	if(slot == SLOT_W_UNIFORM)
		var/mob/living/carbon/human/H = user
		H.dna.add_mutation(CLUWNEMUT)
	return ..()
