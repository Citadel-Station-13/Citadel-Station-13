/datum/team/ashwalkers
	name = "Ashwalkers"
	show_roundend_report = FALSE
	var/list/players_spawned = new

/datum/antagonist/ashwalker
	name = "\improper Ash Walker"
	job_rank = ROLE_LAVALAND
	show_in_antagpanel = FALSE
	show_to_ghosts = TRUE
	antagpanel_category = "Ash Walkers"
	var/datum/team/ashwalkers/ashie_team

/datum/antagonist/ashwalker/create_team(datum/team/team)
	if(team)
		ashie_team = team
		objectives |= ashie_team.objectives
	else
		ashie_team = new

/datum/antagonist/ashwalker/get_team()
	return ashie_team

/datum/antagonist/ashwalker/on_body_transfer(mob/living/old_body, mob/living/new_body)
	. = ..()
	RegisterSignal(new_body, COMSIG_MOB_EXAMINATE, .proc/on_examinate)

/datum/antagonist/ashwalker/on_gain()
	. = ..()
	RegisterSignal(owner.current, COMSIG_MOB_EXAMINATE, .proc/on_examinate)

/datum/antagonist/ashwalker/on_removal()
	. = ..()
	UnregisterSignal(owner.current, COMSIG_MOB_EXAMINATE)

/datum/antagonist/ashwalker/proc/on_examinate(datum/source, atom/A)
	SIGNAL_HANDLER

	if(istype(A, /obj/structure/headpike))
		SEND_SIGNAL(owner.current, COMSIG_ADD_MOOD_EVENT, "headspear", /datum/mood_event/sacrifice_good)
