/*				SECURITY OBJECTIVES				*/

/datum/objective/crew/enjoyyourstay
	explanation_text = "Welcome to Space Station 13. Enjoy your stay."
	jobs = "headofsecurity,securityofficer,warden,detective"
	var/list/edglines = list("Welcome to Space Station 13. Enjoy your stay.", "You signed up for this.", "Abandon hope.", "The tide's gonna stop eventually.", "Hey, someone's gotta do it.", "No, you can't resign.", "Security is a mission, not an intermission.")

/datum/objective/crew/enjoyyourstay/New()
	. = ..()
	update_explanation_text()

/datum/objective/crew/enjoyyourstay/update_explanation_text()
	. = ..()
	explanation_text = pick(edglines)

/datum/objective/crew/enjoyyourstay/check_completion()
	explanation_text = "Enforce Space Law to the best of your ability."
	if(owner && owner.current)
		if(owner.current.stat != DEAD)
			return TRUE
	return FALSE

/datum/objective/crew/justicecrew
	explanation_text = "Ensure there are no innocent crew members in the brig when the shift ends."
	jobs = "lawyer"

/datum/objective/crew/justicecrew/check_completion()
	if(owner && owner.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !(M.assigned_role == "Security Officer") && !(M.assigned_role == "Detective") && !(M.assigned_role == "Head of Security") && !(M.assigned_role == "Lawyer") && !(M.assigned_role == "Warden") && get_area(M.current) != typesof(/area/security))
					return FALSE
		return TRUE
