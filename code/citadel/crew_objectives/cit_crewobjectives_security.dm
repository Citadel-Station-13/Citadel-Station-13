/*				SECURITY OBJECTIVES				*/

/datum/objective/crew/headofsecurity/

/datum/objective/crew/headofsecurity/justicecrew
	explanation_text = "Ensure there are no innocent crew members in the brig when the shift ends."

/datum/objective/crew/headofsecurity/justicecrew/check_completion()
	if(owner.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !M.assigned_role == "Security Officer" && !M.assigned_role == "Detective" && !M.assigned_role == "Head of Security" && !M.assigned_role == "Lawyer" && !M.assigned_role == "Warden" && get_area(M.current) != typesof(/area/security))
					return 0
		return 1

/datum/objective/crew/headofsecurity/datfukkendisk //Ported from old Hippie
	explanation_text = "Defend the nuclear authentication disk at all costs, and be the one to personally deliver it to Centcom."

/datum/objective/crew/headofsecurity/datfukkendisk/check_completion()
	if(owner.current && owner.current.check_contents_for(/obj/item/disk/nuclear) && SSshuttle.emergency.shuttle_areas[get_area(owner.current)])
		return 1
	else
		return 0

/datum/objective/crew/securityofficer/

/datum/objective/crew/securityofficer/justicecrew
	explanation_text = "Ensure there are no innocent crew members in the brig when the shift ends."

/datum/objective/crew/securityofficer/justicecrew/check_completion()
	if(owner.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !M.assigned_role == "Security Officer" && !M.assigned_role == "Detective" && !M.assigned_role == "Head of Security" && !M.assigned_role == "Lawyer" && !M.assigned_role == "Warden" && get_area(M.current) != typesof(/area/security))
					return 0
		return 1

/datum/objective/crew/warden/

/datum/objective/crew/warden/justicecrew
	explanation_text = "Ensure there are no innocent crew members in the brig when the shift ends."

/datum/objective/crew/warden/justicecrew/check_completion()
	if(owner.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !M.assigned_role == "Security Officer" && !M.assigned_role == "Detective" && !M.assigned_role == "Head of Security" && !M.assigned_role == "Lawyer" && !M.assigned_role == "Warden" && get_area(M.current) != typesof(/area/security))
					return 0
		return 1

/datum/objective/crew/detective/

/datum/objective/crew/detective/justicecrew
	explanation_text = "Ensure there are no innocent crew members in the brig when the shift ends."

/datum/objective/crew/detective/justicecrew/check_completion()
	if(owner.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !M.assigned_role == "Security Officer" && !M.assigned_role == "Detective" && !M.assigned_role == "Head of Security" && !M.assigned_role == "Lawyer" && !M.assigned_role == "Warden" && get_area(M.current) != typesof(/area/security))
					return 0
		return 1

/datum/objective/crew/lawyer/

/datum/objective/crew/lawyer/justicecrew
	explanation_text = "Ensure there are no innocent crew members in the brig when the shift ends."

/datum/objective/crew/lawyer/justicecrew/check_completion()
	if(owner.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !M.assigned_role == "Security Officer" && !M.assigned_role == "Detective" && !M.assigned_role == "Head of Security" && !M.assigned_role == "Lawyer" && !M.assigned_role == "Warden" && get_area(M.current) != typesof(/area/security))
					return 0
		return 1
