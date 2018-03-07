#define MIN_LATE_TARGET_TIME 600 //lower bound of re-rolled timer, 1 min
#define MAX_LATE_TARGET_TIME 6000 //upper bound of re-rolled timer, 10 min
#define LATE_TARGET_HIT_CHANCE 70 //How often would the find_target succeed, otherwise it re-rolls later and tries again.
//Hit chance is here to avoid people checking github and then hovering around new arrivals within the max minute range every round.

/datum/objective/assassinate/late
	martyr_compatible = FALSE


/datum/objective/assassinate/late/find_target()
	var/list/possible_targets = list()
	for(var/mob/M in GLOB.latejoiners)
		var/datum/mind/possible_target = M.mind
		if(possible_target != owner && ishuman(possible_target.current) && (possible_target.current.stat != 2) && is_unique_objective(possible_target))
			possible_targets += possible_target
	if(possible_targets.len > 0 && prob(LATE_TARGET_HIT_CHANCE))
		target = pick(possible_targets)
		martyr_compatible = TRUE	//Might never matter, but I guess if an admin gives another random objective, this should now be compatible
		update_explanation_text()

		message_admins("[target] has been selected as the assassination target of [owner].")
		log_game("[target] has been selected as the assassination target of [owner].")

		to_chat(owner, "<span class='italics'>You hear a crackling noise in your ears, as a one-way syndicate message plays:</span>")
		to_chat(owner, "<span class='userdanger'><font size=5>You target has been located. To succeed, find and eliminate [target], the [!target_role_type ? target.assigned_role : target.special_role].</font></span>")
		return target
	else
		update_explanation_text()
		addtimer(CALLBACK(src, .proc/find_target),rand(MIN_LATE_TARGET_TIME, MAX_LATE_TARGET_TIME))
		return null

/datum/objective/assassinate/late/find_target_by_role(role, role_type=0, invert=0)
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
	if(possible_targets && prob(LATE_TARGET_HIT_CHANCE))
		target = pick(possible_targets)
		update_explanation_text()

		message_admins("[target] has been selected as the assassination target of [owner].")
		log_game("[target] has been selected as the assassination target of [owner].")

		to_chat(owner, "<span class='italics'>You hear a crackling noise in your ears, as a one-way syndicate message plays:</span>")
		to_chat(owner, "<span class='userdanger'><font size=5>You target has been located. To succeed, find and eliminate [target], the [!target_role_type ? target.assigned_role : target.special_role].</font></span>")
	else
		update_explanation_text()
		addtimer(CALLBACK(src, .proc/find_target_by_role, role, role_type, invert),rand(MIN_LATE_TARGET_TIME, MAX_LATE_TARGET_TIME))



/datum/objective/assassinate/late/check_completion()
	if(target && target.current) //If target WAS assigned
		if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current) || target.current.z > 6 || !target.current.ckey) //Borgs/brains/AIs count as dead for traitor objectives. --NeoFite
			return TRUE
		return FALSE
	else //If no target was ever given
		if(!owner.current || owner.current.stat == DEAD || isbrain(owner.current))
			return FALSE
		if(!is_special_character(owner.current))
			return FALSE
		return TRUE

/datum/objective/assassinate/late/update_explanation_text()
	//..()
	if(target && target.current)
		explanation_text = "Assassinate [target.name], the [!target_role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Stay alive until your target arrives on the station, you will be notified when the target has been identified."



//BORER STUFF
//Because borers didn't use to have objectives
/datum/objective/normal_borer //Default objective, should technically never be used unmodified but CAN work unmodified.
	explanation_text = "You must escape with at least one borer with host on the shuttle."
	target_amount = 1
	martyr_compatible = 0

/datum/objective/normal_borer/check_completion()
	var/total_borer_hosts = 0
	for(var/mob/living/carbon/C in GLOB.mob_list)
		var/mob/living/simple_animal/borer/D = C.has_brain_worms()
		var/turf/location = get_turf(C)
		if(is_centcom_level(location.z) && D && D.stat != DEAD)
			total_borer_hosts++
	if(target_amount <= total_borer_hosts)
		return TRUE
	else
		return FALSE
