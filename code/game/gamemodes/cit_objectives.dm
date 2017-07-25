/datum/objective/assassinate/late
	martyr_compatible = 0


/datum/objective/assassinate/late/find_target()
	if(!GLOB.latejoiners)
		update_explanation_text()
		return
	var/list/possible_targets = list()
	for(var/mob/M in GLOB.latejoiners)
		var/datum/mind/possible_target = M.mind
		if(possible_target != owner && ishuman(possible_target.current) && (possible_target.current.stat != 2) && is_unique_objective(possible_target))
			possible_targets += possible_target
	if(possible_targets.len > 0)
		target = pick(possible_targets)
		martyr_compatible = 1 //Might never matter, but I guess if an admin gives another random objective, this should now be compatible
		update_explanation_text()
		return target
	else
		update_explanation_text()
		return null

/datum/objective/assassinate/late/find_target_by_role(role, role_type=0, invert=0)
	if(!GLOB.latejoiners) //No latejoiners, no targets needed
		update_explanation_text()
		return
	var/list/possible_targets = list()
	for(var/mob/M in GLOB.latejoiners)
		var/datum/mind/possible_target = M.mind
		if((possible_target != owner) && ishuman(possible_target.current))
			var/is_role = 0
			if(role_type)
				if(possible_target.special_role == role)
					is_role++
			else
				if(possible_target.assigned_role == role)
					is_role++

			if(invert)
				if(is_role)
					continue
				possible_targets += possible_target
				//break
			else if(is_role)
				possible_targets += possible_target
				//break
	if(possible_targets)
		target = pick(possible_targets)
	update_explanation_text()



/datum/objective/assassinate/late/check_completion()
	if(target && target.current) //If target WAS assigned
		if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current) || target.current.z > 6 || !target.current.ckey) //Borgs/brains/AIs count as dead for traitor objectives. --NeoFite
			return 1
		return 0
	else //If no target was ever given
		if(!owner.current || owner.current.stat == DEAD || isbrain(owner.current))
			return 0
		if(!is_special_character(owner.current))
			return 0
		return 1

/datum/objective/assassinate/late/update_explanation_text()
	//..()
	if(target && target.current)
		explanation_text = "Assassinate [target.name], the [!target_role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Stay alive until your target arrives on the station."
