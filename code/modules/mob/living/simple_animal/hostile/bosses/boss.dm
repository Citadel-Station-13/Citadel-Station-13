/mob/living/simple_animal/hostile/boss
	name = "A Perfectly Generic Boss Placeholder"
	desc = ""
	robust_searching = TRUE
	stat_attack = UNCONSCIOUS
	status_flags = NONE
	a_intent = INTENT_HARM
	gender = NEUTER
	has_field_of_vision = FALSE //You are a frikkin boss
	var/list/boss_abilities = list() //list of /datum/action/boss
	var/datum/boss_active_timed_battle/atb
	var/point_regen_delay = 20
	var/point_regen_amount = 1
	sentience_type = SENTIENCE_BOSS

/mob/living/simple_animal/hostile/boss/Initialize()
	. = ..()

	atb = new()
	atb.point_regen_delay = point_regen_delay
	atb.point_regen_amount = point_regen_amount
	atb.boss = src

	for(var/ab in boss_abilities)
		boss_abilities -= ab
		var/datum/action/boss/AB = new ab()
		AB.Grant(src)
		boss_abilities += AB

	atb.assign_abilities(boss_abilities)

/mob/living/simple_animal/hostile/boss/Destroy()
	QDEL_NULL(atb)
	QDEL_LIST(boss_abilities)
	return ..()

//Action datum for bosses
//Override Trigger() as shown below to do things
/datum/action/boss
	check_flags = AB_CHECK_CONSCIOUS //Incase the boss is given a player
	required_mobility_flags = NONE
	var/boss_cost = 100 //Cost of usage for the boss' AI 1-100
	var/usage_probability = 100
	var/list/req_statuses //If set, will only trigger if the mob AI status is present in this list.
	var/mob/living/simple_animal/hostile/boss/boss
	var/boss_type = /mob/living/simple_animal/hostile/boss
	var/needs_target = TRUE //Does the boss need to have a target? (Only matters for the AI)
	var/say_when_triggered = "" //What does the boss Say() when the ability triggers?

/datum/action/boss/Destroy()
	boss = null
	return ..()

/datum/action/boss/Grant(mob/M)
	. = ..()
	boss = owner

/datum/action/boss/Remove(mob/M)
	. = ..()
	boss = null

/datum/action/boss/IsAvailable(silent = FALSE)
	. = ..()
	if(!.)
		return
	if(!istype(boss, boss_type))
		return FALSE
	if(!boss.atb)
		return FALSE
	if(boss.atb.points < boss_cost)
		return FALSE
	if(!boss.client && needs_target && !boss.target)
		return FALSE

/datum/action/boss/Trigger()
	. = ..()
	if(!.)
		return
	if(!boss.atb.spend(boss_cost))
		return FALSE
	if(say_when_triggered)
		boss.say(say_when_triggered, forced = "boss action")

//Example:
/*
/datum/action/boss/selfgib/Trigger()
	if(..())
		boss.gib()
*/


//Designed for boss mobs only
/datum/boss_active_timed_battle
	var/list/abilities //a list of /datum/action/boss owned by a boss mob
	var/point_regen_delay = 20
	var/point_regen_amount = 1
	var/max_points = 100
	var/points = 50 //start with 50 so we can use some abilities but not insta-buttfug somebody
	var/next_point_time = 0
	var/chance_to_hold_onto_points = 50
	var/highest_cost = 0
	var/mob/living/simple_animal/hostile/boss/boss

/datum/boss_active_timed_battle/New()
	..()
	START_PROCESSING(SSobj, src)

/datum/boss_active_timed_battle/proc/assign_abilities(list/L)
	if(!L)
		return FALSE
	abilities = L
	for(var/ab in abilities)
		var/datum/action/boss/AB = ab
		if(AB.boss_cost > highest_cost)
			highest_cost = AB.boss_cost

/datum/boss_active_timed_battle/proc/spend(cost)
	if(cost <= points)
		points -= cost
		return TRUE
	return FALSE

/datum/boss_active_timed_battle/proc/refund(cost)
	points = min(points+cost, max_points)

/datum/boss_active_timed_battle/process()
	if(world.time >= next_point_time && points < max_points)
		next_point_time = world.time + point_regen_delay
		points = min(max_points, points + point_regen_amount)

	if(!abilities)
		return
	chance_to_hold_onto_points = highest_cost*0.5
	if(points != max_points && prob(chance_to_hold_onto_points))
		return //Let's save our points for a better ability (unless we're at max points, in which case we can't save anymore!)
	if(!boss.client)
		abilities = shuffle(abilities)
	for(var/ab in abilities)
		var/datum/action/boss/AB = ab
		if(!boss.client && (!AB.req_statuses || (boss.AIStatus in AB.req_statuses)) && prob(AB.usage_probability) && AB.Trigger())
			break
		AB.UpdateButtonIcon(TRUE)


/datum/boss_active_timed_battle/Destroy()
	abilities = null
	STOP_PROCESSING(SSobj, src)
	return ..()
