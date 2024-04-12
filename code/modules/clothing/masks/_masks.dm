/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi'
	body_parts_covered = HEAD
	slot_flags = ITEM_SLOT_MASK
	strip_delay = 40
	equip_delay_other = 40
	var/modifies_speech = FALSE
	var/mask_adjusted = 0
	var/adjusted_flags = null
	var/datum/beepsky_fashion/beepsky_fashion //the associated datum for applying this to a secbot

/obj/item/clothing/mask/attack_self(mob/user)
	if((clothing_flags & VOICEBOX_TOGGLABLE))
		(clothing_flags ^= VOICEBOX_DISABLED)
		var/status = !(clothing_flags & VOICEBOX_DISABLED)
		to_chat(user, "<span class='notice'>You turn the voice box in [src] [status ? "on" : "off"].</span>")

/obj/item/clothing/mask/equipped(mob/M, slot)
	. = ..()
	if (slot == ITEM_SLOT_MASK && modifies_speech)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	else
		UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/clothing/mask/dropped(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/clothing/mask/proc/handle_speech()

/obj/item/clothing/mask/worn_overlays(isinhands = FALSE, icon_file, used_state, style_flags = NONE)
	. = ..()
	if(!isinhands)
		if(body_parts_covered & HEAD)
			if(damaged_clothes)
				. += mutable_appearance('icons/effects/item_damage.dmi', "damagedmask")
			if(blood_DNA)
				. += mutable_appearance('icons/effects/blood.dmi', "maskblood", color = blood_DNA_to_color(), blend_mode = blood_DNA_to_blend())

/obj/item/clothing/mask/update_clothes_damaged_state()
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_wear_mask()

/**
  * Proc that moves gas/breath masks out of the way, disabling them and allowing pill/food consumption
  * The flavor_details variable is for masks that use this function only to toggle HIDEFACE for identity.
  */
/obj/item/clothing/mask/proc/adjustmask(mob/living/user, just_flavor = FALSE)
	if(user && user.incapacitated())
		return FALSE
	mask_adjusted = !mask_adjusted
	if(!mask_adjusted)
		if(!just_flavor)
			src.icon_state = initial(icon_state)
			gas_transfer_coefficient = initial(gas_transfer_coefficient)
			permeability_coefficient = initial(permeability_coefficient)
			slot_flags = initial(slot_flags)
			flags_cover |= visor_flags_cover
			clothing_flags |= visor_flags
		flags_inv |= visor_flags_inv
	else
		if(!just_flavor)
			icon_state += "_up"
			gas_transfer_coefficient = null
			permeability_coefficient = null
			clothing_flags &= ~visor_flags
			flags_cover &= ~visor_flags_cover
			if(adjusted_flags)
				slot_flags = adjusted_flags
		flags_inv &= ~visor_flags_inv
	if(user)
		if(!just_flavor)
			to_chat(user, "<span class='notice'>You push \the [src] [mask_adjusted ? "out of the way" : "back into place"].</span>")
			user.wear_mask_update(src, toggle_off = mask_adjusted)
			user.update_action_buttons_icon() //when mask is adjusted out, we update all buttons icon so the user's potential internal tank correctly shows as off.
		else
			to_chat(usr, "<span class='notice'>You adjust [src], it will now [mask_adjusted ? "not" : ""] obscure your identity while worn.</span>")
	return TRUE
