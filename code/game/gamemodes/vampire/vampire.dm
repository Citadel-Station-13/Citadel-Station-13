/datum/game_mode
	var/list/datum/mind/vampires = list()


/mob/living/carbon/human/Life()
	. = ..()
	if(is_vampire(src))
		var/datum/antagonist/vampire/vamp = mind.has_antag_datum(/datum/antagonist/vampire)
		vamp.vampire_life()


/datum/game_mode/vampire
	name = "vampire"
	config_tag = "vampire"
	antag_flag = ROLE_VAMPIRE
	false_report_weight = 1
	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list("Head of Security", "Captain", "Security Officer", "Chaplain", "Detective", "Warden", "Head of Personnel","Quartermaster")
	required_players = 15
	required_enemies = 1
	recommended_enemies = 3
	enemy_minimum_age = 0

	announce_text = "There are vampires onboard the station!\n\
		+	<span class='danger'>Vampires</span>: Suck the blood of the crew and complete your objectives!\n\
		+	<span class='notice'>Crew</span>: Kill the unholy vampires!"

	var/vampires_possible = 4 //hard limit on vampires if scaling is turned off
	var/num_modifier = 0
	var/list/datum/mind/pre_vamps = list()

/datum/game_mode/vampire/generate_report()
	return "We have received some fuzzy reports about the Syndicate cooperating with a bluespace demon.\
			Keep a watch out for syndicate agents, and have your Chaplain on standby."

/datum/game_mode/vampire/pre_setup()

	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		restricted_jobs += "Assistant"

	var/num_vamps = 1

	var/tsc = CONFIG_GET(number/traitor_scaling_coeff)
	if(tsc)
		num_vamps = max(1, min(round(num_players() / (tsc * 2)) + 2 + num_modifier, round(num_players() / tsc) + num_modifier))
	else
		num_vamps = max(1, min(num_players(), vampires_possible))

	for(var/j in 1 to num_vamps)
		if (!antag_candidates.len)
			break
		var/datum/mind/vamp = pick_n_take(antag_candidates)
		pre_vamps += vamp
		vamp.special_role = "Vampire"
		vamp.restricted_roles = restricted_jobs
		log_game("[vamp.key] (ckey) has been selected as a Vampire")

	return pre_vamps.len > 0


/datum/game_mode/vampire/post_setup()
	for(var/a in pre_vamps)
		var/datum/mind/vamp = a
		vamp.add_antag_datum(/datum/antagonist/vampire)
	..()
	return TRUE

/proc/add_vampire(mob/living/L)
	if(!L || !L.mind || is_vampire(L))
		return FALSE
	var/datum/antagonist/vampire/vamp = L.mind.add_antag_datum(/datum/antagonist/vampire)
	return vamp

/proc/remove_vampire(mob/living/L)
	var/datum/antagonist/vamp = is_vampire(L)
	if(!vamp)
		return FALSE
	vamp.on_removal()
	return TRUE

/proc/is_vampire(mob/living/M)
	return M?.mind?.has_antag_datum(/datum/antagonist/vampire)

/datum/game_mode/proc/update_vampire_icons_added(datum/mind/traitor_mind)
	var/datum/atom_hud/antag/vamphud = GLOB.huds[ANTAG_HUD_VAMPIRE]
	vamphud.join_hud(traitor_mind.current)
	set_antag_hud(traitor_mind.current, "vampire")

/datum/game_mode/proc/update_vampire_icons_removed(datum/mind/traitor_mind)
	var/datum/atom_hud/antag/vamphud = GLOB.huds[ANTAG_HUD_VAMPIRE]
	vamphud.leave_hud(traitor_mind.current)
	set_antag_hud(traitor_mind.current, null)
