/datum/round_event_control/spontaneous_guardian_spirit
	name = "Spontaneous Guardian Spirit"
	typepath = /datum/round_event/ghost_role/spontaneous_guardian_spirit
	weight = 2
	max_occurrences = 8
	earliest_start = 10 MINUTES
	min_players = 5

/datum/round_event/ghost_role/spontaneous_guardian_spirit
	role_name = "guardian spirit"

/datum/round_event/ghost_role/spontaneous_guardian_spirit/spawn_role()
	var/list/candidates = get_candidates(ROLE_PAI, null, FALSE)
	if(length(candidates))
		for(var/mob/living/L in shuffle(GLOB.alive_mob_list))
			if(!L.client)
				continue
			if(L.stat == DEAD)
				continue
			if (HAS_TRAIT(L,TRAIT_EXEMPT_HEALTH_EVENTS))
				continue
			if(iscyborg(L))
				var/mob/living/silicon/robot/R = L
				if(R.shell)
					continue
			var/list/guardians = L.hasparasites()
			if(length(guardians))
				continue
			var/obj/item/guardiancreator/spontaneous/I = new
			var/mob/C = pick(candidates)
			I.spawn_guardian(L, C.key)
			control.weight *= 2 //they attract each other, after all
			qdel(I)
			return SUCCESSFUL_SPAWN
	return NOT_ENOUGH_PLAYERS
