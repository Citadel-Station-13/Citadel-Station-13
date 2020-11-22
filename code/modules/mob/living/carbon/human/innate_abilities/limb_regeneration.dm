
/datum/action/innate/ability/limb_regrowth
	name = "Regenerate Limbs"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "slimeheal"
	icon_icon = 'icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"
	required_mobility_flags = NONE

/datum/action/innate/ability/limb_regrowth/IsAvailable(silent = FALSE)
	if(..())
		var/mob/living/carbon/human/H = owner
		var/list/limbs_to_heal = H.get_missing_limbs()
		if(limbs_to_heal.len < 1)
			return 0
		var/mode = H.get_ability_property(INNATE_ABILITY_LIMB_REGROWTH, PROPERTY_LIMB_REGROWTH_USAGE_TYPE)
		switch(mode)
			if(REGROWTH_USES_BLOOD)
				if(H.blood_volume >= (BLOOD_VOLUME_OKAY*H.blood_ratio)+40)
					return TRUE
				else
					return FALSE
		return 0

/datum/action/innate/ability/limb_regrowth/Activate()
	var/mob/living/carbon/human/H = owner
	var/list/limbs_to_heal = H.get_missing_limbs()
	if(limbs_to_heal.len < 1)
		to_chat(H, "<span class='notice'>You feel intact enough as it is.</span>")
		return
	to_chat(H, "<span class='notice'>You focus intently on your missing [limbs_to_heal.len >= 2 ? "limbs" : "limb"]...</span>")
	var/mode = H.get_ability_property(INNATE_ABILITY_LIMB_REGROWTH, PROPERTY_LIMB_REGROWTH_USAGE_TYPE)
	switch(mode)
		if(REGROWTH_USES_BLOOD)
			if(H.blood_volume >= 40*limbs_to_heal.len+(BLOOD_VOLUME_OKAY*H.blood_ratio))
				H.regenerate_limbs()
				H.blood_volume -= 40*limbs_to_heal.len
				to_chat(H, "<span class='notice'>...and after a moment you finish reforming!</span>")
				return
			else if(H.blood_volume >= 40)//We can partially heal some limbs
				while(H.blood_volume >= (BLOOD_VOLUME_OKAY*H.blood_ratio)+40)
					var/healed_limb = pick(limbs_to_heal)
					H.regenerate_limb(healed_limb)
					limbs_to_heal -= healed_limb
					H.blood_volume -= 40
				to_chat(H, "<span class='warning'>...but there is not enough of you to fix everything! You must attain more mass to heal completely!</span>")
				return
			to_chat(H, "<span class='warning'>...but there is not enough of you to go around! You must attain more mass to heal!</span>")

