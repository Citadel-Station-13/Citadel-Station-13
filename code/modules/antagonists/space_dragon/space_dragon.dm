/datum/antagonist/space_dragon
	name = "Space Dragon"
	roundend_category = "space dragons"
	antagpanel_category = "Space Dragon"
	job_rank = ROLE_SPACE_DRAGON
	show_in_antagpanel = TRUE
	show_name_in_check_antagonists = TRUE
	var/list/datum/mind/carp = list()
	
/datum/antagonist/space_dragon/greet()
	to_chat(owner, "<b>Endless time and space we have moved through.  We do not remember from where we came, we do not know where we will go.  All space belongs to us.\n\
					Space is an empty void, of which our kind is the apex predator, and there was little to rival our claim to this title.\n\
					But now, we find intruders spread out amongst our claim, willing to fight our teeth with magics unimaginable, their dens like lights flicking in the depths of space.\n\
					Today, we will snuff out one of those lights.</b>")
	to_chat(owner, "<span class='boldwarning'>You have five minutes to find a safe location to place down the first rift.  If you take longer than five minutes to place a rift, you will be returned from whence you came.\n\
					Alt click to cause a gust around you!</span>")
	owner.announce_objectives()
	SEND_SOUND(owner.current, sound('sound/magic/demon_attack1.ogg'))
	
/datum/antagonist/space_dragon/proc/forge_objectives()
	var/datum/objective/summon_carp/summon = new()
	summon.dragon = src
	objectives += summon
	
/datum/antagonist/space_dragon/on_gain()
	forge_objectives()
	. = ..()

/datum/objective/summon_carp
	var/datum/antagonist/space_dragon/dragon
	explanation_text = "Summon and protect the rifts to flood the station with carp."

/datum/antagonist/space_dragon/roundend_report()
	var/list/parts = list()
	var/datum/objective/summon_carp/S = locate() in objectives
	if(S.check_completion())
		parts += "<span class='redtext big'>The [name] has succeeded!  Station space has been reclaimed by the space carp!</span>"
	parts += printplayer(owner)
	var/objectives_complete = TRUE
	if(objectives.len)
		parts += printobjectives(objectives)
		for(var/datum/objective/objective in objectives)
			if(!objective.check_completion())
				objectives_complete = FALSE
				break
	if(objectives_complete)
		parts += "<span class='greentext big'>The [name] was successful!</span>"
	else
		parts += "<span class='redtext big'>The [name] has failed!</span>"
	parts += "<span class='header'>The [name] was assisted by:</span>"
	parts += printplayerlist(carp)
	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"

/datum/antagonist/space_dragon/admin_add(datum/mind/new_owner, mob/admin)
	// pick the spawn loc
	var/list/spawn_locs = list()
	for(var/obj/effect/landmark/carpspawn/carp_spawn in GLOB.landmarks_list)
		if(!isturf(carp_spawn.loc))
			stack_trace("Carp spawn found not on a turf: [carp_spawn.type] on [isnull(carp_spawn.loc) ? "null" : carp_spawn.loc.type]")
			continue
		spawn_locs += carp_spawn.loc
	if(!spawn_locs.len)
		message_admins("No valid spawn locations found, aborting...")
		return MAP_ERROR

	// spawn our dragon
	var/mob/living/simple_animal/hostile/space_dragon/S = new(pick(spawn_locs))
	// gib or delete the old mob here
	new_owner.current.gib()
	// alternativelly, isntead of using the code above to pick a location, we can gib the mob, then spawn the dragon where it died for a goresome transformation

	//mind transfer and role setup
	new_owner.transfer_to(S)
	new_owner.assigned_role = "Space Dragon"
	new_owner.special_role = "Space Dragon"

	playsound(S, 'sound/magic/ethereal_exit.ogg', 50, TRUE, -1)
	. = ..()
	return SUCCESSFUL_SPAWN
