//Augmented Eyesight: Gives you X-ray vision or protection from flashes. Also, high DNA cost because of how powerful it is.
//Possible todo: make a custom message for directing a penlight/flashlight at the eyes - not sure what would display though.

/datum/action/changeling/augmented_eyesight
	name = "Augmented Eyesight"
	desc = "Creates heat receptors in our eyes and dramatically increases light sensing ability, or protects your vision from flashes."
	helptext = "Grants us thermal vision or flash protection. We will become a lot more vulnerable to flash-based devices while thermal vision is active."
	button_icon_state = "augmented_eyesight"
	dna_cost = 2 //Would be 1 without thermal vision
	active = FALSE

/datum/action/changeling/augmented_eyesight/on_purchase(mob/user) //The ability starts inactive, so we should be protected from flashes.
	..()
	var/obj/item/organ/eyes/E = user.getorganslot(ORGAN_SLOT_EYES)
	if (E)
		E.flash_protect = 2 //Adjust the user's eyes' flash protection
		to_chat(user, "We adjust our eyes to protect them from bright lights.")
	else
		to_chat(user, "We can't adjust our eyes if we don't have any!")

/datum/action/changeling/augmented_eyesight/sting_action(mob/living/carbon/human/user)
	if(!istype(user))
		return
	var/obj/item/organ/eyes/E = user.getorganslot(ORGAN_SLOT_EYES)
	if(E)
		if(!active)
			ADD_TRAIT(user, TRAIT_THERMAL_VISION, CHANGELING_TRAIT)
			E.flash_protect = -1 //Adjust the user's eyes' flash protection
			to_chat(user, "We adjust our eyes to sense prey through walls.")
			active = TRUE //Defined in code/modules/spells/spell.dm
		else
			REMOVE_TRAIT(user, TRAIT_THERMAL_VISION, CHANGELING_TRAIT)
			E.flash_protect = 2 //Adjust the user's eyes' flash protection
			to_chat(user, "We adjust our eyes to protect them from bright lights.")
			active = FALSE
		user.update_sight()
	else
		to_chat(user, "We can't adjust our eyes if we don't have any!")
	return TRUE


/datum/action/changeling/augmented_eyesight/Remove(mob/user) //Get rid of x-ray vision and flash protection when the user refunds this ability
	REMOVE_TRAIT(user, TRAIT_THERMAL_VISION, CHANGELING_TRAIT)
	var/obj/item/organ/eyes/E = user.getorganslot(ORGAN_SLOT_EYES)
	if(E)
		E.flash_protect = initial(E.flash_protect)
	user.update_sight()
	..()
