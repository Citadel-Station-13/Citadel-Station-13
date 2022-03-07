/datum/job/cyborg
	title = "Cyborg"
	desc = "Stationbound platforms tasked with assisting the crew, and the governing AI with their day to day tasks."
//	auto_deadmin_role_flags = DEADMIN_POSITION_SILICON
	faction = JOB_FACTION_STATION
	total_positions = 0
	roundstart_positions = 3
	supervisor_text_override = "your laws and the AI"
	selection_color = "#ddffdd"
	minimal_player_age = 21
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	considered_combat_role = TRUE

	starting_modifiers = list(/datum/skill_modifier/job/level/wiring/basic)

/datum/job/cyborg/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE, latejoin = FALSE, datum/outfit/outfit_override = null, datum/preferences/prefs)
	if(visualsOnly)
		CRASH("dynamic preview is unsupported")
	return H.Robotize(FALSE, latejoin)

/datum/job/cyborg/after_spawn(mob/living/silicon/robot/M, latejoin, client/C)
	. = ..()
	M.updatename(C)
	M.gender = NEUTER

/datum/job/cyborg/radio_help_message(mob/M)
	to_chat(M, "<b>Prefix your message with :b to speak with other cyborgs and AI.</b>")
