/datum/team/gang
	name = "gang" // The team name is set on creation by the leader.
	member_name = "syndicate agent"
	var/hud_entry_num // A number holding the hud's index inside 'huds' global list. Gets set on hud update, if a hud doesn't exist already. Must be a number, otherwise BYOND shits up with assoc lists and everything goes to hell.

/datum/team/gang/Destroy()
	var/datum/atom_hud/antag/overthrowhud = GLOB.huds[hud_entry_num]
	GLOB.huds -= GLOB.huds[hud_entry_num]
	qdel(overthrowhud)
	. = ..()

/datum/team/gang/proc/create_objectives()
	// Heads objective
	var/datum/objective/gang/heads/heads = new()
	heads.team = src
	heads.find_target()
	objectives += heads
	// AI objective
	var/datum/objective/gang/AI/AI = new()
	AI.team = src
	AI.update_explanation_text()
	objectives += AI
	// Target objective
	var/datum/objective/gang/target/target = new()
	target.team = src
	target.find_target()
	objectives += target
	addtimer(CALLBACK(src,.proc/update_objectives),OBJECTIVE_UPDATING_TIME,TIMER_UNIQUE)

/datum/team/gang/proc/update_objectives()
	var/datum/objective/gang/heads/heads_obj = locate() in objectives
	if(!heads_obj)
		heads_obj = new()
		heads_obj.team = src
		objectives += heads_obj
		for(var/i in members)
			var/datum/mind/M = i
			M.objectives += heads_obj
	heads_obj.find_targets()

	addtimer(CALLBACK(src,.proc/update_objectives),OBJECTIVE_UPDATING_TIME,TIMER_UNIQUE)
