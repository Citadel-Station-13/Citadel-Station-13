/obj/item/clothing/head
	name = BODY_ZONE_HEAD
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "top_hat"
	item_state = "that"
	body_parts_covered = HEAD
	slot_flags = ITEM_SLOT_HEAD
	var/blockTracking = 0 //For AI tracking
	var/can_toggle = null
	dynamic_hair_suffix = "+generic"
	var/muzzle_var = NORMAL_STYLE
	mutantrace_variation = NO_MUTANTRACE_VARIATION //not all hats have muzzles

/obj/item/clothing/head/Initialize()
	. = ..()
	if(ishuman(loc) && dynamic_hair_suffix)
		var/mob/living/carbon/human/H = loc
		H.update_hair()

/obj/item/clothing/head/equipped(mob/user, slot)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/datum/species/pref_species = H.dna.species

		if(mutantrace_variation)
			if("mam_snouts" in pref_species.default_features)
				if(H.dna.features["mam_snouts"] != "None")
					muzzle_var = ALT_STYLE
				else
					muzzle_var = NORMAL_STYLE

			else if("snout" in pref_species.default_features)
				if(H.dna.features["snout"] != "None")
					muzzle_var = ALT_STYLE
				else
					muzzle_var = NORMAL_STYLE

			else
				muzzle_var = NORMAL_STYLE

			H.update_inv_head()

/obj/item/clothing/head/worn_overlays(isinhands = FALSE)
	. = list()
	if(!isinhands)
		if(damaged_clothes)
			. += mutable_appearance('icons/effects/item_damage.dmi', "damagedhelmet")
		if(blood_DNA)
			. += mutable_appearance('icons/effects/blood.dmi', "helmetblood", color = blood_DNA_to_color())

/obj/item/clothing/head/update_clothes_damaged_state(damaging = TRUE)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_head()