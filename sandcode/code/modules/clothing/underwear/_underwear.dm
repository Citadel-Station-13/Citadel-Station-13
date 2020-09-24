//Fuck it we making underwear actual items
/obj/item/clothing/underwear
	name = "Underwear"
	desc = "If you're reading this, something went wrong."
	icon = 'sandcode/icons/mob/clothing/underwear.dmi' //if someone is willing to make proper inventory sprites that'd be very cash money
	mob_overlay_icon = 'sandcode/icons/mob/clothing/underwear.dmi'
	anthro_mob_worn_overlay = 'sandcode/icons/mob/clothing/underwear_digi.dmi'
	body_parts_covered = GROIN
	permeability_coefficient = 0.9
	block_priority = BLOCK_PRIORITY_UNDERWEAR
	slot_flags = ITEM_SLOT_UNDERWEAR
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	mutantrace_variation = NONE
	hide_underwear_examine = FALSE
	var/under_type = /obj/item/clothing/underwear //i don't know what i'm gonna use this for
	var/fitted = FEMALE_UNIFORM_TOP
	var/has_colors = TRUE

//Proc to check if underwear is hidden
/mob/living/carbon/human/proc/underwear_hidden()
	for(var/obj/item/I in list(w_uniform, wear_suit, shoes))
		if(istype(I) && ((I.hide_underwear_examine) || (I.flags_inv & HIDEUNDERWEAR)))
			return TRUE
	return FALSE
