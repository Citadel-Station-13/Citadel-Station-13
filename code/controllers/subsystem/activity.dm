SUBSYSTEM_DEF(activity)
	name = "Activity tracking"
	flags = SS_BACKGROUND | SS_NO_TICK_CHECK
	priority = FIRE_PRIORITY_ACTIVITY
	wait = 1 MINUTES
	var/list/deferred_threats = list()
	var/current_threat = 0
	var/list/threat_history = list()
	var/list/threats = list()

/datum/controller/subsystem/activity/Initialize(timeofday)
	RegisterSignal(SSdcs,COMSIG_GLOB_EXPLOSION,.proc/on_explosion)
	RegisterSignal(SSdcs,COMSIG_GLOB_MOB_DEATH,.proc/on_death)

/datum/controller/subsystem/activity/fire(resumed = 0)
	calculate_threat()

/datum/controller/subsystem/activity/proc/calculate_threat()
	threats = deferred_threats.Copy()
	deferred_threats.Cut()
	threats["antagonists"] = 0
	for(var/datum/antagonist/A in GLOB.antagonists)
		if(A?.owner?.current && A.owner.current.stat != DEAD)
			threats["antagonists"] += A.threat()
	threats["events"] = 0
	for(var/r in SSevents.running)
		var/datum/round_event/R = r
		threats["events"] += R.threat()
	threats["players"] = 0
	SEND_SIGNAL(src, COMSIG_THREAT_CALC, threats)
	for(var/m in GLOB.player_list)
		var/mob/M = m
		if (M?.mind?.assigned_role && M.stat != DEAD)
			var/datum/job/J = SSjob.GetJob(M.mind.assigned_role)
			if(J)
				if(length(M.mind.antag_datums))
					threats["players"] += J.GetThreat()
				else
					threats["players"] -= J.GetThreat()
		else if(M?.stat == DEAD && !M.voluntary_ghosted)
			threats["dead_players"] += 1
	current_threat = 0
	for(var/threat_type in threats)
		current_threat += threats[threat_type]
	threat_history += "[world.time]"
	threat_history["[world.time]"] = current_threat

/datum/controller/subsystem/activity/proc/get_average_threat()
	if(!length(threat_history))
		return 0
	var/total_weight = 0
	var/total_amt = 0
	for(var/i in 1 to threat_history.len-1)
		var/weight = (text2num(threat_history[i+1])-text2num(threat_history[i]))
		total_weight += weight
		total_amt += weight * (threat_history[threat_history[i]])
	return round(total_amt / total_weight,0.1)

/datum/controller/subsystem/activity/proc/get_max_threat()
	. = 0
	for(var/threat in threat_history)
		. = max(threat_history[threat], .)

/datum/controller/subsystem/activity/proc/on_explosion(datum/source, atom/epicenter, devastation_range, heavy_impact_range, light_impact_range, took, orig_dev_range, orig_heavy_range, orig_light_range)
	if(!("explosions" in deferred_threats))
		deferred_threats["explosions"] = 0
	var/area/A = get_area(epicenter)
	if(is_station_level(epicenter.z) && (A.area_flags & BLOBS_ALLOWED) && !istype(A, /area/asteroid))
		deferred_threats["explosions"] += devastation_range**2 + heavy_impact_range**2 / 4 + light_impact_range**2 / 8 // 75 for a maxcap

/datum/controller/subsystem/activity/proc/on_death(datum/source, mob/M, gibbed)
	if(!("crew_deaths" in deferred_threats))
		deferred_threats["crew_deaths"] = 0
	if(M?.mind && SSjob.GetJob(M.mind.assigned_role))
		deferred_threats["crew_deaths"] += 1
