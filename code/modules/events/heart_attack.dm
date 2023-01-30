/datum/round_event_control/heart_attack
	name = "Random Heart Attack"
	typepath = /datum/round_event/heart_attack
	weight = 10
	max_occurrences = 2
	min_players = 10 // To avoid shafting lowpop
	category = EVENT_CATEGORY_HEALTH
	description = "A random crewmember's heart gives out."

/datum/round_event_control/heart_attack/canSpawnEvent(var/players_amt, var/gamemode)
	if(!..()) return FALSE
	var/list/enemy_roles = list("Medical Doctor","Chief Medical Officer","Paramedic","Chemist")
	for (var/mob/M in GLOB.alive_mob_list)
		if(M.stat != DEAD && (M.mind?.assigned_role in enemy_roles))
			return TRUE
	return FALSE

/datum/round_event/heart_attack/start()
	var/list/heart_attack_contestants = list()
	for(var/mob/living/carbon/human/H in shuffle(GLOB.player_list))
		if(!H.client || H.stat == DEAD || H.InCritical() || !H.can_heartattack() || H.has_status_effect(STATUS_EFFECT_EXERCISED) || (/datum/disease/heart_failure in H.diseases) || H.undergoing_cardiac_arrest() || HAS_TRAIT(H,TRAIT_EXEMPT_HEALTH_EVENTS))
			continue
		if(H.satiety <= -60) //Multiple junk food items recently
			heart_attack_contestants[H] = 3
		else
			heart_attack_contestants[H] = 1

	if(LAZYLEN(heart_attack_contestants))
		var/mob/living/carbon/human/winner = pickweight(heart_attack_contestants)
		var/datum/disease/D = new /datum/disease/heart_failure()
		winner.ForceContractDisease(D, FALSE, TRUE)
		announce_to_ghosts(winner)
