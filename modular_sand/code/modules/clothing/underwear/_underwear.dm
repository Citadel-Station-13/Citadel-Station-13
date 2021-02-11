//Fuck it we making underwear actual items
/obj/item/clothing/underwear
	name = "Underwear"
	desc = "If you're reading this, something went wrong."
	icon = 'modular_sand/icons/mob/clothing/underwear.dmi' //if someone is willing to make proper inventory sprites that'd be very cash money
	mob_overlay_icon = 'modular_sand/icons/mob/clothing/underwear.dmi'
	anthro_mob_worn_overlay = 'modular_sand/icons/mob/clothing/underwear_digi.dmi'
	body_parts_covered = GROIN
	permeability_coefficient = 0.9
	block_priority = BLOCK_PRIORITY_UNDERWEAR
	slot_flags = ITEM_SLOT_UNDERWEAR
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	mutantrace_variation = NONE
	var/under_type = /obj/item/clothing/underwear //i don't know what i'm gonna use this for
	var/fitted = FEMALE_UNIFORM_TOP

//Proc to check if underwear is hidden, removed socks to make separate proc.
/mob/living/carbon/human/proc/underwear_hidden()
	for(var/obj/item/I in list(w_uniform, wear_suit))
		if(istype(I) && ((I.body_parts_covered & CHEST) || (I.body_parts_covered & GROIN) || (I.flags_inv & HIDEUNDERWEAR))) //Using body_parts_covered because obviously there was a better way to do it
			return TRUE
	return FALSE

//Only the shoes and feet covering suits can hide socks, the above proc was stupid.
/mob/living/carbon/human/proc/socks_hidden()
	for(var/obj/item/I in list(shoes, wear_suit))
		if(istype(I) && ((I.body_parts_covered & FEET) || (I.flags_inv & HIDEUNDERWEAR)))  //Using body_parts_covered because obviously there was a better way to do it
			return TRUE
	return FALSE
