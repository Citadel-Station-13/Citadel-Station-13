/datum/surgery/bone_repair
	name = "bone repair"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/prep_bone, /datum/surgery_step/set_bone, /datum/surgery_step/mend_bone, /datum/surgery_step/close)
	possible_locs = list("chest", "l_arm", "r_arm", "r_leg", "l_leg", "head")

datum/surgery/bone_repair/monkey
	name = "bone repair"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/prep_bone, /datum/surgery_step/set_bone, /datum/surgery_step/mend_bone, /datum/surgery_step/close)
	possible_locs = list("chest", "l_arm", "r_arm", "r_leg", "l_leg", "head")

/datum/surgery/bone_repair/can_start(mob/user, mob/living/carbon/target)
	if(istype(target,/mob/living/carbon))
		var/mob/living/carbon/H = target
		var/obj/item/bodypart/affected = H.get_bodypart(user.zone_selected)
		if(affected && affected.broken)
			return TRUE
		return FALSE

/datum/surgery/bone_repair/can_start(mob/user, mob/living/carbon/target)
	if(istype(target,/mob/living/carbon/monkey))
		var/mob/living/carbon/monkey/H = target
		var/obj/item/bodypart/affected = H.get_bodypart(user.zone_selected)
		if(affected && affected.broken)
			return TRUE
		return FALSE
