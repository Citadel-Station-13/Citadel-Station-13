/datum/antagonist/ninja
	name = "Ninja"
	antagpanel_category = "Ninja"
	job_rank = ROLE_NINJA
	show_name_in_check_antagonists = TRUE
	antag_moodlet = /datum/mood_event/focused
	var/helping_station = FALSE
	var/give_objectives = TRUE
	var/give_equipment = TRUE

/datum/antagonist/ninja/New()
	if(helping_station)
		can_hijack = HIJACK_PREVENT
	. = ..()

/datum/antagonist/ninja/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	update_ninja_icons_added(M)

/datum/antagonist/ninja/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	update_ninja_icons_removed(M)

/datum/antagonist/ninja/proc/equip_space_ninja(mob/living/carbon/human/H = owner.current)
	return H.equipOutfit(/datum/outfit/ninja)

/datum/antagonist/ninja/proc/addMemories()
	antag_memory += "I am an elite mercenary assassin of the mighty Spider Clan. A <font color='red'><B>SPACE NINJA</B></font>!<br>"
	antag_memory += "Surprise is my weapon. Shadows are my armor. Without them, I am nothing. (//initialize your suit by clicking the initialize UI button, to use abilities like stealth)!<br>"
	antag_memory += "Officially, [helping_station?"Nanotrasen":"The Syndicate"] are my employer.<br>"

/datum/antagonist/ninja/proc/addObjectives(quantity = 6)
	var/datum/objective/new_objective
	var/chaos_level = 0
	var/datum/game_mode/dynamic/mode
	if(istype(SSticker.mode,/datum/game_mode/dynamic))
		mode = SSticker.mode
		// round() is a floor actually, isn't that fun
		// basically: below 30 players reduces max, below 50 threat level reduces max, otherwise does max rolls
		for(var/i in 1 to max(2,min(5,round(mode.threat_level/10),round(GLOB.joined_player_list.len/6))))
			if(prob(mode.threat_level))
				chaos_level++
	else
		for(var/i in 1 to max(2,min(5,round(GLOB.joined_player_list.len/6))))
			if(prob(50))
				chaos_level++
	if(helping_station)
		switch(chaos_level)
			if(0)
				new_objective = new("Nanotrasen has hired you to assist the station. Stick to the shadows and look out for trouble.")
			if(1)
				new_objective = new("Nanotrasen has hired you to assist the station. You are to defend R&D; you answer to the research director, head of security and captain only.")
			if(2)
				new_objective = new("Nanotrasen has hired you to assist the station. You are security and serve the head of security.")
			if(3)
				new_objective = new("Nanotrasen has hired you to assist the station. You serve directly under the captain.")
			if(4)
				new_objective = new("Nanotrasen has hired you to assist the station. You answer only to centcom.")
			if(5)
				new_objective = new("Nanotrasen has hired you to assist the station. You answer only to yourself; take action unilaterally.")
	else
		switch(chaos_level)
			if(0)
				new_objective = new("Cybersun Industries has selected you to find and steal an important heirloom or valuable technology belonging to Nanotrasen. Ensure your actions are covert and avoid leaving a body count if possible.")
			if(1)
				new_objective = new("You have been chosen by the Tiger Cooperative to perform acts of sabotage throughout the station you have been planted on. Terrorize the station, but leave enough intact to embarass Nanotrasen, not anger them.")
			if(2)
				new_objective = new("The Waffle Corporation has given you the task to create the biggest prank the station's security force has seen! Harass security, and don't stop while you can still honk!")
			if(3)
				new_objective = new("The Donk Corporation has hired you with the task to maim the crew in whatever way you can. Strain the resources of medical staff, and create a hostile working enviroment for human resources.")
			if(4)
				new_objective = new("You are under contract by the Animal Rights Consortium to disrupt the station's crew structure. Assassinate all the crew of a choice department, or if you're feeling brave, all the heads of staff.")
			if(5)
				new_objective = new("The Gorlex Marauders have deployed you personally, with only one order: destroy the station, and leave none alive. [pick(list("Ensure none can escape total destruction by hijacking the escape shuttle, if it ever comes.","Die a glorious death, and take everyone else with you."))]")
	new_objective.completed = TRUE
	new_objective.owner = owner
	objectives += new_objective
	var/datum/objective/O = new /datum/objective/survive()
	O.owner = owner
	objectives += O

/proc/remove_ninja(mob/living/L)
	if(!L || !L.mind)
		return FALSE
	var/datum/antagonist/datum = L.mind.has_antag_datum(/datum/antagonist/ninja)
	datum.on_removal()
	return TRUE

/proc/is_ninja(mob/living/M)
	return M && M.mind && M.mind.has_antag_datum(/datum/antagonist/ninja)


/datum/antagonist/ninja/greet()
	SEND_SOUND(owner.current, sound('sound/effects/ninja_greeting.ogg'))
	to_chat(owner.current, "I am an elite mercenary assassin of the mighty Spider Clan. A <font color='red'><B>SPACE NINJA</B></font>!")
	to_chat(owner.current, "Surprise is my weapon. Shadows are my armor. Without them, I am nothing. (//initialize your suit by right clicking on it, to use abilities like stealth)!")
	to_chat(owner.current, "Officially, [helping_station?"Nanotrasen":"The Syndicate"] are my employer.")
	owner.announce_objectives()
	return

/datum/antagonist/ninja/on_gain()
	if(give_objectives)
		addObjectives()
	addMemories()
	if(give_equipment)
		equip_space_ninja(owner.current)
	. = ..()

/datum/antagonist/ninja/admin_add(datum/mind/new_owner,mob/admin)
	var/adj
	switch(input("What kind of ninja?", "Ninja") as null|anything in list("Random","Syndicate","Nanotrasen","No objectives"))
		if("Random")
			helping_station = pick(TRUE,FALSE)
			adj = ""
		if("Syndicate")
			helping_station = FALSE
			adj = "syndie"
		if("Nanotrasen")
			helping_station = TRUE
			adj = "friendly"
		if("No objectives")
			give_objectives = FALSE
			adj = "objectiveless"
		else
			return
	if(helping_station)
		can_hijack = HIJACK_PREVENT
	new_owner.assigned_role = ROLE_NINJA
	new_owner.special_role = ROLE_NINJA
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)] has [adj] ninja'ed [new_owner.current].")
	log_admin("[key_name(admin)] has [adj] ninja'ed [new_owner.current].")

/datum/antagonist/ninja/proc/update_ninja_icons_added(var/mob/living/carbon/human/ninja)
	var/datum/atom_hud/antag/ninjahud = GLOB.huds[ANTAG_HUD_NINJA]
	ninjahud.join_hud(ninja)
	set_antag_hud(ninja, "ninja")

/datum/antagonist/ninja/proc/update_ninja_icons_removed(var/mob/living/carbon/human/ninja)
	var/datum/atom_hud/antag/ninjahud = GLOB.huds[ANTAG_HUD_NINJA]
	ninjahud.leave_hud(ninja)
	set_antag_hud(ninja, null)
