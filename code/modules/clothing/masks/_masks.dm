/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi'
	body_parts_covered = HEAD
	slot_flags = ITEM_SLOT_MASK
	strip_delay = 40
	equip_delay_other = 40
	var/mask_adjusted = 0
	var/adjusted_flags = null
	var/muzzle_var = NORMAL_STYLE
	mutantrace_variation = NO_MUTANTRACE_VARIATION //most masks have overrides, but not all probably.


/obj/item/clothing/mask/worn_overlays(isinhands = FALSE)
	. = list()
	if(!isinhands)
		if(body_parts_covered & HEAD)
			if(damaged_clothes)
				. += mutable_appearance('icons/effects/item_damage.dmi', "damagedmask")
			IF_HAS_BLOOD_DNA(src)
				. += mutable_appearance('icons/effects/blood.dmi', "maskblood")

/obj/item/clothing/mask/equipped(mob/user, slot)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/datum/species/pref_species = H.dna.species

		if(mutantrace_variation)
			if("mam_snouts" in pref_species.default_features)
				if(H.dna.features["mam_snouts"] != "None")
					muzzle_var = ALT_STYLE

			else if("snout" in pref_species.default_features)
				if(H.dna.features["snout"] != "None")
					muzzle_var = ALT_STYLE
			else
				muzzle_var = NORMAL_STYLE

			H.update_inv_wear_mask()


/obj/item/clothing/mask/update_clothes_damaged_state(damaging = TRUE)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_wear_mask()

//Proc that moves gas/breath masks out of the way, disabling them and allowing pill/food consumption
/obj/item/clothing/mask/proc/adjustmask(mob/living/user)
	if(user && user.incapacitated())
		return
	mask_adjusted = !mask_adjusted
	if(!mask_adjusted)
		src.icon_state = initial(icon_state)
		gas_transfer_coefficient = initial(gas_transfer_coefficient)
		permeability_coefficient = initial(permeability_coefficient)
		clothing_flags |= visor_flags
		flags_inv |= visor_flags_inv
		flags_cover |= visor_flags_cover
		to_chat(user, "<span class='notice'>You push \the [src] back into place.</span>")
		slot_flags = initial(slot_flags)
	else
		icon_state += "_up"
		to_chat(user, "<span class='notice'>You push \the [src] out of the way.</span>")
		gas_transfer_coefficient = null
		permeability_coefficient = null
		clothing_flags &= ~visor_flags
		flags_inv &= ~visor_flags_inv
		flags_cover &= ~visor_flags_cover
		if(adjusted_flags)
			slot_flags = adjusted_flags
	if(user)
		user.wear_mask_update(src, toggle_off = mask_adjusted)
		user.update_action_buttons_icon() //when mask is adjusted out, we update all buttons icon so the user's potential internal tank correctly shows as off.
