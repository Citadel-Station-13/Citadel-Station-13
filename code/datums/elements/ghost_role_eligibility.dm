/datum/element/ghost_role_eligibility
	element_flags = ELEMENT_DETACH
	var/list/timeouts = list()
	var/list/mob/eligible_mobs = list()

/datum/element/ghost_role_eligibility/Attach(datum/target,penalize = FALSE)
	. = ..()
	if(!ismob(target))
		return ELEMENT_INCOMPATIBLE
	var/mob/M = target
	if(!(M in eligible_mobs))
		eligible_mobs += M
	if(penalize) //penalizing them from making a ghost role / midround antag comeback right away.
		var/penalty = CONFIG_GET(number/suicide_reenter_round_timer) MINUTES
		var/roundstart_quit_limit = CONFIG_GET(number/roundstart_suicide_time_limit) MINUTES
		if(world.time < roundstart_quit_limit) //add up the time difference to their antag rolling penalty if they quit before half a (ingame) hour even passed.
			penalty += roundstart_quit_limit - world.time
		if(penalty)
			penalty += world.realtime
			if(SSautotransfer.can_fire && SSautotransfer.maxvotes)
				var/maximumRoundEnd = SSautotransfer.starttime + SSautotransfer.voteinterval * SSautotransfer.maxvotes
				if(penalty - SSshuttle.realtimeofstart > maximumRoundEnd + SSshuttle.emergencyCallTime + SSshuttle.emergencyDockTime + SSshuttle.emergencyEscapeTime)
					penalty = CANT_REENTER_ROUND
			if(!(M.ckey in timeouts))
				timeouts += M.ckey
				timeouts[M.ckey] = 0
			else if(timeouts[M.ckey] == CANT_REENTER_ROUND)
				return
			timeouts[M.ckey] = max(timeouts[M.ckey],penalty)

/datum/element/ghost_role_eligibility/Detach(mob/M)
	. = ..()
	if(M in eligible_mobs)
		eligible_mobs -= M

/datum/element/ghost_role_eligibility/proc/get_all_ghost_role_eligible(silent = FALSE)
	var/list/candidates = list()
	for(var/m in eligible_mobs)
		var/mob/M = m
		if(M.can_reenter_round(TRUE))
			candidates += M
	return candidates

/mob/proc/can_reenter_round(silent = FALSE)
	var/datum/element/ghost_role_eligibility/eli = SSdcs.GetElement(list(/datum/element/ghost_role_eligibility))
	return eli.can_reenter_round(src,silent)

/datum/element/ghost_role_eligibility/proc/can_reenter_round(var/mob/M,silent = FALSE)
	if(!(M in eligible_mobs))
		return FALSE
	if(!(M.ckey in timeouts))
		return TRUE
	var/timeout = timeouts[M.ckey]
	if(timeout != CANT_REENTER_ROUND && timeout <= world.realtime)
		return TRUE
	if(!silent && M.client)
		to_chat(M, "<span class='warning'>You are unable to reenter the round[timeout != CANT_REENTER_ROUND ? " yet. Your ghost role blacklist will expire in [DisplayTimeText(timeout - world.realtime)]" : ""].</span>")
	return FALSE
