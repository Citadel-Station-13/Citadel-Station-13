/*				COMMAND OBJECTIVES				*/

/datum/objective/crew/captain/

/datum/objective/crew/captain/hat //Ported from Goon
	explanation_text = "Don't lose your hat."

/datum/objective/crew/captain/hat/check_completion()
	if(owner.current && owner.current.check_contents_for(/obj/item/clothing/head/caphat))
		return TRUE
	else
		return FALSE

/datum/objective/crew/captain/datfukkendisk //Ported from old Hippie
	explanation_text = "Defend the nuclear authentication disk at all costs, and be the one to personally deliver it to Centcom."

/datum/objective/crew/captain/datfukkendisk/check_completion()
	if(owner.current && owner.current.check_contents_for(/obj/item/disk/nuclear) && SSshuttle.emergency.shuttle_areas[get_area(owner.current)])
		return TRUE
	else
		return FALSE

/datum/objective/crew/headofpersonnel/

/datum/objective/crew/headofpersonnel/ian //Ported from old Hippie
	explanation_text = "Defend Ian at all costs, and ensure he gets delivered to Centcom at the end of the shift."

/datum/objective/crew/headofpersonnel/ian/check_completion()
	if(owner.current)
		for(var/mob/living/simple_animal/pet/dog/corgi/Ian/goodboy in GLOB.mob_list)
			if(goodboy.stat != DEAD && SSshuttle.emergency.shuttle_areas[get_area(goodboy)])
				return TRUE
		return FALSE
	return FALSE
