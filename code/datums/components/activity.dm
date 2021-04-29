/datum/component/activity
	var/activity_level = 0
	var/not_moved_counter = 0
	var/list/historical_activity_levels = list()

/datum/component/activity/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/L = parent

	RegisterSignal(L, COMSIG_LIVING_SET_AS_ATTACKER, .proc/on_set_as_attacker)
	RegisterSignal(L, COMSIG_LIVING_ATTACKER_SET, .proc/on_attacker_set)
	RegisterSignal(L, COMSIG_MOB_DEATH, .proc/on_death)
	RegisterSignal(L, COMSIG_EXIT_AREA, .proc/on_exit_area)
	RegisterSignal(L, COMSIG_LIVING_LIFE, .proc/on_life)
	RegisterSignal(L, list(COMSIG_MOB_ITEM_ATTACK, COMSIG_MOB_ATTACK_RANGED, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, COMSIG_MOB_ATTACK_HAND, COMSIG_MOB_THROW, COMSIG_MOVABLE_TELEPORTED, COMSIG_LIVING_GUN_PROCESS_FIRE, COMSIG_MOB_APPLY_DAMAGE), .proc/minor_activity)

/datum/component/activity/proc/log_activity()
	historical_activity_levels[world.time] = activity_level

/datum/component/activity/proc/minor_activity(datum/source)
	activity_level += 1

/datum/component/activity/proc/on_attacker_set(datum/source, mob/attacker)
	activity_level += 10
	if(attacker?.mind)
		activity_level += 10
	log_activity()

/datum/component/activity/proc/on_set_as_attacker(datum/source, mob/target)
	activity_level += 10
	if(target?.mind)
		activity_level += 20
	log_activity()

/datum/component/activity/proc/on_death(datum/source)
	activity_level += 100 // dying means you're doing SOMETHING
	log_activity()

/datum/component/activity/proc/on_exit_area(datum/source)
	activity_level += 1
	not_moved_counter = 0

/datum/component/activity/proc/on_life(datum/source, seconds, times_fired)
	var/mob/living/L = source
	if(L.stat >= UNCONSCIOUS) // can't expect the unconscious to move
		return
	not_moved_counter += seconds
	var/should_log = FALSE
	switch(not_moved_counter)
		if(60 to 120)
			activity_level -= 1
		if(120 to 600)
			activity_level -= 5
		if(600 to 1200)
			activity_level -= 10
			should_log = TRUE
		if(1200 to INFINITY)
			activity_level -= 20
			should_log = TRUE
	activity_level = max(activity_level, 0)
	if(should_log)
		log_activity()
