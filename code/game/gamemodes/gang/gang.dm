/datum/game_mode/gang
	name = "Families"
	config_tag = "families"
	antag_flag = ROLE_TRAITOR
	false_report_weight = 5
	required_players = 0
	required_enemies = 1
	recommended_enemies = 4
	announce_span = "danger"
	announce_text = "Grove For Lyfe!"
	reroll_friendly = FALSE
	restricted_jobs = list("Cyborg", "AI", "Prisoner","Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel")//N O
	protected_jobs = list()

	/// A reference to the handler that is used to run pre_setup(), post_setup(), etc..
	var/datum/gang_handler/handler

/datum/game_mode/gang/warriors
	name = "Warriors"
	config_tag = "warriors"
	announce_text = "Can you survive this onslaught?"

/datum/game_mode/gang/warriors/pre_setup()
	handler = new /datum/gang_handler(antag_candidates,restricted_jobs)
	var/list/datum/antagonist/gang/gangs_to_generate = subtypesof(/datum/antagonist/gang)
	handler.gangs_to_generate = gangs_to_generate.len
	handler.gang_balance_cap = 3
	return handler.pre_setup_analogue()

/datum/game_mode/gang/pre_setup()
	handler = new /datum/gang_handler(antag_candidates,restricted_jobs)
	return handler.pre_setup_analogue()

/datum/game_mode/gang/Destroy()
	QDEL_NULL(handler)
	return ..()

/datum/game_mode/gang/post_setup()
	handler.post_setup_analogue(FALSE)
	gamemode_ready = TRUE
	return ..()

/datum/game_mode/gang/process()
	handler.process_analogue()

/datum/game_mode/gang/set_round_result()
	return handler.set_round_result_analogue()

/datum/game_mode/gang/generate_report()
	return "Something something grove street home at least until I fucked everything up idk nobody reads these reports."
