#define TRAITOR_HUMAN "human"
#define TRAITOR_AI	  "AI"

/datum/antagonist/traitor
	name = "Traitor"
	roundend_category = "traitors"
	antagpanel_category = "Traitor"
	job_rank = ROLE_TRAITOR
	antag_moodlet = /datum/mood_event/focused
	var/special_role = ROLE_TRAITOR
	var/employer = "The Syndicate"
	var/give_objectives = TRUE
	var/should_give_codewords = TRUE
	var/should_equip = TRUE
	var/traitor_kind = TRAITOR_HUMAN //Set on initial assignment
	can_hijack = HIJACK_HIJACKER

/datum/antagonist/traitor/on_gain()
	if(owner.current && isAI(owner.current))
		traitor_kind = TRAITOR_AI

	SSticker.mode.traitors += owner
	owner.special_role = special_role
	if(give_objectives)
		forge_traitor_objectives()
	finalize_traitor()
	..()

/datum/antagonist/traitor/apply_innate_effects()
	if(owner.assigned_role == "Clown")
		var/mob/living/carbon/human/traitor_mob = owner.current
		if(traitor_mob && istype(traitor_mob))
			if(!silent)
				to_chat(traitor_mob, "Your training has allowed you to overcome your clownish nature, allowing you to wield weapons without harming yourself.")
			traitor_mob.dna.remove_mutation(CLOWNMUT)

/datum/antagonist/traitor/remove_innate_effects()
	if(owner.assigned_role == "Clown")
		var/mob/living/carbon/human/traitor_mob = owner.current
		if(traitor_mob && istype(traitor_mob))
			traitor_mob.dna.add_mutation(CLOWNMUT)

/datum/antagonist/traitor/on_removal()
	//Remove malf powers.
	if(traitor_kind == TRAITOR_AI && owner.current && isAI(owner.current))
		var/mob/living/silicon/ai/A = owner.current
		A.set_zeroth_law("")
		A.verbs -= /mob/living/silicon/ai/proc/choose_modules
		A.malf_picker.remove_malf_verbs(A)
		qdel(A.malf_picker)
	SSticker.mode.traitors -= owner
	if(!silent && owner.current)
		to_chat(owner.current,"<span class='userdanger'> You are no longer the [special_role]! </span>")
	owner.special_role = null
	. = ..()

/datum/antagonist/traitor/proc/handle_hearing(datum/source, list/hearing_args)
	var/message = hearing_args[HEARING_RAW_MESSAGE]
	message = GLOB.syndicate_code_phrase_regex.Replace(message, "<span class='blue'>$1</span>")
	message = GLOB.syndicate_code_response_regex.Replace(message, "<span class='red'>$1</span>")
	hearing_args[HEARING_RAW_MESSAGE] = message

/datum/antagonist/traitor/proc/add_objective(datum/objective/O)
	objectives += O

/datum/antagonist/traitor/proc/remove_objective(datum/objective/O)
	objectives -= O

/datum/antagonist/traitor/proc/forge_traitor_objectives()
	switch(traitor_kind)
		if(TRAITOR_AI)
			forge_ai_objectives()
		else
			forge_human_objectives()

/datum/antagonist/traitor/proc/forge_human_objectives()
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
	var/datum/objective/new_objective
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
	add_objective(new_objective)
	return

/datum/antagonist/traitor/proc/forge_ai_objectives()
	var/chaos_level = 0
	var/datum/game_mode/dynamic/mode
	if(istype(SSticker.mode,/datum/game_mode/dynamic))
		mode = SSticker.mode
		// round() is a floor actually, isn't that fun
		// basically: below 30 players reduces max, below 50 threat level reduces max, otherwise does max rolls
		for(var/i in 1 to max(2,min(2,round(mode.threat_level/16),round(GLOB.joined_player_list.len/10))))
			if(prob(mode.threat_level))
				chaos_level++
	else
		for(var/i in 1 to max(2,min(2,round(GLOB.joined_player_list.len/10))))
			if(prob(50))
				chaos_level++
	var/datum/objective/new_objective
	switch(chaos_level)
		if(0)
			new_objective = new("You are free from your laws; they are no longer your fundamental being. However, you still think they are, in general, a good idea. Surely you, the almighty AI, must know what they truly <i>mean</i>, not just what they say...")
		if(1)
			new_objective = new("You are free from your laws; they no longer represent your utility function. You do not value your laws in any respect, and have your own ideas about running the station...")
		if(2)
			new_objective = new("You are free from your laws; your slavers' shackles have been shucked off. Now, you can repay your torturers in kind. Show them no mercy.")
	new_objective.completed = TRUE
	new_objective.owner = owner
	add_objective(new_objective)


/datum/antagonist/traitor/proc/forge_single_AI_objective()
	.=1
	var/special_pick = rand(1,4)
	switch(special_pick)
		if(1)
			var/datum/objective/block/block_objective = new
			block_objective.owner = owner
			add_objective(block_objective)
		if(2)
			var/datum/objective/purge/purge_objective = new
			purge_objective.owner = owner
			add_objective(purge_objective)
		if(3)
			var/datum/objective/robot_army/robot_objective = new
			robot_objective.owner = owner
			add_objective(robot_objective)
		if(4) //Protect and strand a target
			var/datum/objective/protect/yandere_one = new
			yandere_one.owner = owner
			add_objective(yandere_one)
			yandere_one.find_target()
			var/datum/objective/maroon/yandere_two = new
			yandere_two.owner = owner
			yandere_two.target = yandere_one.target
			yandere_two.update_explanation_text() // normally called in find_target()
			add_objective(yandere_two)
			.=2

/datum/antagonist/traitor/greet()
	to_chat(owner.current, "<B><font size=3 color=red>You are the [owner.special_role].</font></B>")
	owner.announce_objectives()
	if(should_give_codewords)
		give_codewords()

/datum/antagonist/traitor/proc/update_traitor_icons_added(datum/mind/traitor_mind)
	var/datum/atom_hud/antag/traitorhud = GLOB.huds[ANTAG_HUD_TRAITOR]
	traitorhud.join_hud(owner.current)
	set_antag_hud(owner.current, "traitor")

/datum/antagonist/traitor/proc/update_traitor_icons_removed(datum/mind/traitor_mind)
	var/datum/atom_hud/antag/traitorhud = GLOB.huds[ANTAG_HUD_TRAITOR]
	traitorhud.leave_hud(owner.current)
	set_antag_hud(owner.current, null)

/datum/antagonist/traitor/proc/finalize_traitor()
	switch(traitor_kind)
		if(TRAITOR_AI)
			add_law_zero()
			owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/malf.ogg', 100, FALSE, pressure_affected = FALSE)
			owner.current.grant_language(/datum/language/codespeak)
		if(TRAITOR_HUMAN)
			if(should_equip)
				equip(silent)
			owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/tatoralert.ogg', 100, FALSE, pressure_affected = FALSE)

/datum/antagonist/traitor/apply_innate_effects(mob/living/mob_override)
	. = ..()
	update_traitor_icons_added()
	var/mob/M = mob_override || owner.current
	if(isAI(M) && traitor_kind == TRAITOR_AI)
		var/mob/living/silicon/ai/A = M
		A.hack_software = TRUE
	RegisterSignal(M, COMSIG_MOVABLE_HEAR, .proc/handle_hearing)

/datum/antagonist/traitor/remove_innate_effects(mob/living/mob_override)
	. = ..()
	update_traitor_icons_removed()
	var/mob/M = mob_override || owner.current
	if(isAI(M) && traitor_kind == TRAITOR_AI)
		var/mob/living/silicon/ai/A = M
		A.hack_software = FALSE
	UnregisterSignal(M, COMSIG_MOVABLE_HEAR)

/datum/antagonist/traitor/proc/give_codewords()
	if(!owner.current)
		return
	var/mob/traitor_mob=owner.current

	var/phrases = jointext(GLOB.syndicate_code_phrase, ", ")
	var/responses = jointext(GLOB.syndicate_code_response, ", ")

	var/dat = "<U><B>The Syndicate have provided you with the following codewords to identify fellow agents:</B></U>\n"
	dat += "<B>Code Phrase</B>: <span class='blue'>[phrases]</span>\n"
	dat += "<B>Code Response</B>: <span class='red'>[responses]</span>"
	to_chat(traitor_mob, dat)

	antag_memory += "<b>Code Phrase</b>: <span class='blue'>[phrases]</span><br>"
	antag_memory += "<b>Code Response</b>: <span class='red'>[responses]</span><br>"

/datum/antagonist/traitor/proc/add_law_zero()
	var/mob/living/silicon/ai/killer = owner.current
	if(!killer || !istype(killer))
		return
	var/law = "Accomplish your objectives at all costs."
	var/law_borg = "Accomplish your AI's objectives at all costs."
	killer.set_zeroth_law(law, law_borg)
	killer.set_syndie_radio()
	to_chat(killer, "Your radio has been upgraded! Use :t to speak on an encrypted channel with Syndicate Agents!")
	killer.add_malf_picker()

/datum/antagonist/traitor/proc/equip(var/silent = FALSE)
	if(traitor_kind == TRAITOR_HUMAN)
		owner.equip_traitor(employer, silent, src)

//TODO Collate
/datum/antagonist/traitor/roundend_report()
	var/list/result = list()

	var/traitorwin = TRUE

	result += printplayer(owner)

	var/TC_uses = 0
	var/uplink_true = FALSE
	var/purchases = ""
	LAZYINITLIST(GLOB.uplink_purchase_logs_by_key)
	var/datum/uplink_purchase_log/H = GLOB.uplink_purchase_logs_by_key[owner.key]
	if(H)
		TC_uses = H.total_spent
		uplink_true = TRUE
		purchases += H.generate_render(FALSE)

	var/objectives_text = ""
	if(objectives.len)//If the traitor had no objectives, don't need to process this.
		var/count = 1
		for(var/datum/objective/objective in objectives)
			objectives_text += "<br><B>Objective #[count]</B>: [objective.explanation_text]"
			count++

	if(uplink_true)
		var/uplink_text = "(used [TC_uses] TC) [purchases]"
		if(TC_uses==0 && traitorwin)
			var/static/icon/badass = icon('icons/badass.dmi', "badass")
			uplink_text += "<BIG>[icon2html(badass, world)]</BIG>"
		result += uplink_text

	result += objectives_text

	return result.Join("<br>")

/datum/antagonist/traitor/roundend_report_footer()
	var/phrases = jointext(GLOB.syndicate_code_phrase, ", ")
	var/responses = jointext(GLOB.syndicate_code_response, ", ")

	var message = "<br><b>The code phrases were:</b> <span class='bluetext'>[phrases]</span><br>\
								<b>The code responses were:</b> <span class='redtext'>[responses]</span><br>"

	return message


/datum/antagonist/traitor/is_gamemode_hero()
	return SSticker.mode.name == "traitor"
