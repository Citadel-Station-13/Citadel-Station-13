/*				SECURITY OBJECTIVES				*/

/datum/objective/crew/headofsecurity/

/datum/objective/crew/headofsecurity/datfukkendisk //Ported from old Hippie
	explanation_text = "Defend the nuclear authentication disk at all costs, and be the one to personally deliver it to Centcom."

/datum/objective/crew/headofsecurity/datfukkendisk/check_completion()
	if(owner.current && owner.current.check_contents_for(/obj/item/disk/nuclear) && SSshuttle.emergency.shuttle_areas[get_area(owner.current)])
		return TRUE
	else
		return FALSE

/datum/objective/crew/headofsecurity/enjoyyourstay
	explanation_text = "Welcome to Space Station 13. Enjoy your stay."

/datum/objective/crew/headofsecurity/enjoyyourstay/New()
	. = ..()
	update_explanation_text()

/datum/objective/crew/headofsecurity/enjoyyourstay/update_explanation_text()
	. = ..()
	var/list/edglines = list("Welcome to Space Station 13. Enjoy your stay.", "You signed up for this.", "Abandon hope.", "The tide's gonna stop eventually.", "Hey, someone's gotta do it.", "No, you can't resign.", "Security is a mission, not an intermission.")
	explanation_text = pick(edglines)

/datum/objective/crew/headofsecurity/enjoyyourstay/check_completion()
	explanation_text = "Enforce Space Law to the best of your ability."
	return TRUE

/datum/objective/crew/securityofficer/

/datum/objective/crew/securityofficer/enjoyyourstay
	explanation_text = "Welcome to Space Station 13. Enjoy your stay."

/datum/objective/crew/securityofficer/enjoyyourstay/New()
	. = ..()
	update_explanation_text()

/datum/objective/crew/securityofficer/enjoyyourstay/update_explanation_text()
	. = ..()
	var/list/edglines = list("Welcome to Space Station 13. Enjoy your stay.", "You signed up for this.", "Abandon hope.", "The tide's gonna stop eventually.", "Hey, someone's gotta do it.", "No, you can't resign.", "Security is a mission, not an intermission.")
	explanation_text = pick(edglines)

/datum/objective/crew/securityofficer/enjoyyourstay/check_completion()
	explanation_text = "Enforce Space Law to the best of your ability."
	return TRUE

/datum/objective/crew/warden/

/datum/objective/crew/warden/enjoyyourstay
	explanation_text = "Welcome to Space Station 13. Enjoy your stay."

/datum/objective/crew/warden/enjoyyourstay/New()
	. = ..()
	update_explanation_text()

/datum/objective/crew/warden/enjoyyourstay/update_explanation_text()
	. = ..()
	var/list/edglines = list("Welcome to Space Station 13. Enjoy your stay.", "You signed up for this.", "Abandon hope.", "The tide's gonna stop eventually.", "Hey, someone's gotta do it.", "No, you can't resign.", "Security is a mission, not an intermission.")
	explanation_text = pick(edglines)

/datum/objective/crew/warden/enjoyyourstay/check_completion()
	explanation_text = "Enforce Space Law to the best of your ability."
	return TRUE

/datum/objective/crew/detective/

/datum/objective/crew/detective/enjoyyourstay
	explanation_text = "Welcome to Space Station 13. Enjoy your stay."

/datum/objective/crew/detective/enjoyyourstay/New()
	. = ..()
	update_explanation_text()

/datum/objective/crew/detective/enjoyyourstay/update_explanation_text()
	. = ..()
	var/list/edglines = list("Welcome to Space Station 13. Enjoy your stay.", "You signed up for this.", "Abandon hope.", "The tide's gonna stop eventually.", "Hey, someone's gotta do it.", "No, you can't resign.", "Security is a mission, not an intermission.", "Well, at least you know fashion.")
	explanation_text = pick(edglines)

/datum/objective/crew/detective/enjoyyourstay/check_completion()
	explanation_text = "Enforce Space Law to the best of your ability."
	return TRUE

/datum/objective/crew/lawyer/

/datum/objective/crew/lawyer/justicecrew
	explanation_text = "Ensure there are no innocent crew members in the brig when the shift ends."

/datum/objective/crew/lawyer/justicecrew/check_completion()
	if(owner.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !M.assigned_role == "Security Officer" && !M.assigned_role == "Detective" && !M.assigned_role == "Head of Security" && !M.assigned_role == "Lawyer" && !M.assigned_role == "Warden" && get_area(M.current) != typesof(/area/security))
					return FALSE
		return TRUE
