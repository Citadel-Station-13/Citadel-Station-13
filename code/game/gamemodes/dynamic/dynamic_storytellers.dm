/datum/dynamic_storyteller
	var/name = "none" // Name for voting.
	var/config_tag = null // Config tag for config weights.
	var/desc = "A coder's idiocy." // Description for voting.
	var/list/property_weights = list() // See below.
	var/curve_centre = 0 // As GLOB.dynamic_curve_centre.
	var/curve_width = 1.8 // As GLOB.dynamic_curve_width.
	var/forced_threat_level = -1 // As GLOB.dynamic_forced_threat_level
	/*
		NO_ASSASSIN: Will not have permanent assassination targets.
		WAROPS_ALWAYS_ALLOWED: Can always do warops, regardless of threat level.
		USE_PREF_WEIGHTS: Will use peoples' preferences to change the threat centre.
		FORCE_IF_WON: If this mode won the vote, forces it
	*/
	var/flags = 0
	var/dead_player_weight = 1 // How much dead players matter for threat calculation
	var/weight = 3 // Weights for randomly picking storyteller. Multiplied by score after voting.
	var/event_frequency_lower = 6 MINUTES // How rare events will be, at least.
	var/event_frequency_upper = 20 MINUTES // How rare events will be, at most.
	var/min_players = -1 // How many players are required for this one to start.
	var/datum/game_mode/dynamic/mode = null // Cached as soon as it's made, by dynamic.

/**
Property weights are: 
"story_potential" -- essentially how many different ways the antag can be played.
"trust" -- How much it makes the crew trust each other. Negative values means they're suspicious. Team antags are like this.
"chaos" -- How chaotic it makes the round. Has some overlap with "valid" and somewhat contradicts "extended".
"valid" -- How likely the non-antag-enemy crew are to get involved, e.g. nukies encouraging the warden to 
           let everyone into the armory, wizard moving around and being a nuisance, nightmare busting lights.
"extended" -- How much the antag is conducive to a long round. Nukies and cults are bad for this; Wizard is less bad; and so on.
"conversion" -- Basically a bool. Conversion antags, well, convert. It's its own class for a good reason.
*/

/datum/dynamic_storyteller/proc/start_injection_cooldowns()
	var/latejoin_injection_cooldown_middle = 0.5*(GLOB.dynamic_first_latejoin_delay_max + GLOB.dynamic_first_latejoin_delay_min)
	mode.latejoin_injection_cooldown = round(CLAMP(EXP_DISTRIBUTION(latejoin_injection_cooldown_middle), GLOB.dynamic_first_latejoin_delay_min, GLOB.dynamic_first_latejoin_delay_max)) + world.time

	var/midround_injection_cooldown_middle = 0.5*(GLOB.dynamic_first_midround_delay_min + GLOB.dynamic_first_midround_delay_max)
	mode.midround_injection_cooldown = round(CLAMP(EXP_DISTRIBUTION(midround_injection_cooldown_middle), GLOB.dynamic_first_midround_delay_min, GLOB.dynamic_first_midround_delay_max)) + world.time
	
	var/event_injection_cooldown_middle = 0.5*(GLOB.dynamic_event_delay_max + GLOB.dynamic_event_delay_min)
	mode.event_injection_cooldown = (round(CLAMP(EXP_DISTRIBUTION(event_injection_cooldown_middle), GLOB.dynamic_event_delay_min, GLOB.dynamic_event_delay_max)) + world.time)

/datum/dynamic_storyteller/proc/calculate_threat()
	var/threat = 0
	for(var/datum/antagonist/A in GLOB.antagonists)
		if(A?.owner?.current && A.owner.current.stat != DEAD)
			threat += A.threat()
	for(var/r in SSevents.running)
		var/datum/round_event/R = r
		threat += R.threat()
	for(var/mob/living/simple_animal/hostile/H in GLOB.mob_living_list)
		var/turf/T = get_turf(H)
		if(H.stat != DEAD && is_station_level(T.z) && !("Station" in H.faction))
			threat += H.threat()
	for(var/obj/item/phylactery/P in GLOB.poi_list)
		threat += 25 // can't be giving them too much of a break
	for (var/mob/M in mode.current_players[CURRENT_LIVING_PLAYERS])
		if (M?.mind?.assigned_role && M.stat != DEAD)
			var/datum/job/J = SSjob.GetJob(M.mind.assigned_role)
			if(J)
				if(length(M.mind.antag_datums))
					threat += J.GetThreat()
				else
					threat -= J.GetThreat()
	threat += (mode.current_players[CURRENT_DEAD_PLAYERS].len)*dead_player_weight
	return round(threat,0.1)

/datum/dynamic_storyteller/proc/do_process()
	return

/datum/dynamic_storyteller/proc/on_start()
	if (istype(SSticker.mode, /datum/game_mode/dynamic))
		mode = SSticker.mode
		GLOB.dynamic_curve_centre = curve_centre
		GLOB.dynamic_curve_width = curve_width
		if(flags & USE_PREF_WEIGHTS)
			var/voters = 0
			var/mean = 0
			for(var/client/c in GLOB.clients)
				var/vote = c.prefs.preferred_chaos
				if(vote)
					voters += 1
					switch(vote)
						if(CHAOS_NONE)
							mean -= 5
						if(CHAOS_LOW)
							mean -= 2.5
						if(CHAOS_HIGH)
							mean += 2.5
						if(CHAOS_MAX)
							mean += 5
			if(voters)
				GLOB.dynamic_curve_centre += (mean/voters)
		GLOB.dynamic_forced_threat_level = forced_threat_level

/datum/dynamic_storyteller/proc/get_midround_cooldown()
	var/midround_injection_cooldown_middle = 0.5*(GLOB.dynamic_midround_delay_max + GLOB.dynamic_midround_delay_min)
	return round(CLAMP(EXP_DISTRIBUTION(midround_injection_cooldown_middle), GLOB.dynamic_midround_delay_min, GLOB.dynamic_midround_delay_max))

/datum/dynamic_storyteller/proc/get_event_cooldown()
	var/event_injection_cooldown_middle = 0.5*(GLOB.dynamic_event_delay_max + GLOB.dynamic_event_delay_min)
	return round(CLAMP(EXP_DISTRIBUTION(event_injection_cooldown_middle), GLOB.dynamic_event_delay_min, GLOB.dynamic_event_delay_max))

/datum/dynamic_storyteller/proc/get_latejoin_cooldown()
	var/latejoin_injection_cooldown_middle = 0.5*(GLOB.dynamic_latejoin_delay_max + GLOB.dynamic_latejoin_delay_min)
	return round(CLAMP(EXP_DISTRIBUTION(latejoin_injection_cooldown_middle), GLOB.dynamic_latejoin_delay_min, GLOB.dynamic_latejoin_delay_max))

/datum/dynamic_storyteller/proc/get_injection_chance(dry_run = FALSE)
	if(mode.forced_injection)
		mode.forced_injection = !dry_run
		return 100
	var/threat_perc = mode.threat/mode.threat_level

	return round(max(0,100*(1-(threat_perc*threat_perc*threat_perc))))

/datum/dynamic_storyteller/proc/roundstart_draft()
	var/list/drafted_rules = list()
	for (var/datum/dynamic_ruleset/roundstart/rule in mode.roundstart_rules)
		if (rule.acceptable(mode.roundstart_pop_ready, mode.threat_level))	// If we got the population and threat required
			rule.candidates = mode.candidates.Copy()
			rule.trim_candidates()
			if (rule.ready() && rule.candidates.len > 0)
				var/property_weight = 0
				for(var/property in property_weights)
					if(property in rule.property_weights) // just treat it as 0 if it's not in there
						property_weight += rule.property_weights[property] * property_weights[property]
				drafted_rules[rule] = (rule.get_weight() * property_weight)*rule.weight_mult
	return drafted_rules

/datum/dynamic_storyteller/proc/midround_draft()
	var/list/drafted_rules = list()
	for (var/datum/dynamic_ruleset/midround/rule in mode.midround_rules)
		// if there are antags OR the rule is an antag rule, antag_acceptable will be true.
		if (rule.acceptable(mode.current_players[CURRENT_LIVING_PLAYERS].len, mode.threat_level))
			// Classic secret : only autotraitor/minor roles
			if (GLOB.dynamic_classic_secret && !((rule.flags & TRAITOR_RULESET) || (rule.flags & MINOR_RULESET)))
				continue
			rule.trim_candidates()
			var/threat_weight = 1
			if(!(rule.flags & MINOR_RULESET)) // makes the traitor rulesets always possible anyway
				var/cost_difference = abs(rule.cost-(mode.threat_level-mode.threat))
				/*	Basically, the closer the cost is to the current threat-level-away-from-threat, the more likely it is to
					pick this particular ruleset. 
					Let's use a toy example: there's 60 threat level and 10 threat spent.
					We want to pick a ruleset that's close to that, so we run the below equation, on two rulesets.
					Ruleset 1 has 30 cost, ruleset 2 has 5 cost.
					When we do the math, ruleset 1's threat_weight is 0.538, and ruleset 2's is 0.238, meaning ruleset 1
					is 2.26 times as likely to be picked, all other things considered.
					Of course, we don't want it to GUARANTEE the closest, that's no fun, so it's just a weight.
				*/
				threat_weight = 1-abs(1-LOGISTIC_FUNCTION(2,0.05,cost_difference,0))
			if (rule.ready())
				var/property_weight = 0
				for(var/property in property_weights)
					if(property in rule.property_weights)
						property_weight += rule.property_weights[property] * property_weights[property]
				drafted_rules[rule] = round(((rule.get_weight() * property_weight)*rule.weight_mult*threat_weight)*1000,1)
	return drafted_rules

/datum/dynamic_storyteller/proc/latejoin_draft(mob/living/carbon/human/newPlayer)
	var/list/drafted_rules = list()
	for (var/datum/dynamic_ruleset/latejoin/rule in mode.latejoin_rules)
		if (rule.acceptable(mode.current_players[CURRENT_LIVING_PLAYERS].len, mode.threat_level - mode.threat))
			// Classic secret : only autotraitor/minor roles
			if (GLOB.dynamic_classic_secret && !((rule.flags & TRAITOR_RULESET) || (rule.flags & MINOR_RULESET)))
				continue
			// No stacking : only one round-ender, unless threat level > stacking_limit.
			if (mode.threat_level > GLOB.dynamic_stacking_limit && GLOB.dynamic_no_stacking)
				if(rule.flags & HIGHLANDER_RULESET && mode.highlander_executed)
					continue

			rule.candidates = list(newPlayer)
			rule.trim_candidates()
			var/threat_weight = 1
			if(!(rule.flags & MINOR_RULESET))
				var/cost_difference = abs(rule.cost-(mode.threat_level-mode.threat))
				threat_weight = 1-abs(1-(LOGISTIC_FUNCTION(2,0.05,cost_difference,0)))
			if (rule.ready())
				var/property_weight = 0
				for(var/property in property_weights)
					if(property in rule.property_weights)
						property_weight += rule.property_weights[property] * property_weights[property]
				drafted_rules[rule] = round(((rule.get_weight() * property_weight)*rule.weight_mult*threat_weight)*1000,1)
	return drafted_rules

/datum/dynamic_storyteller/proc/event_draft()
	var/list/drafted_rules = list()
	for(var/datum/dynamic_ruleset/event/rule in mode.events)
		if(rule.acceptable(mode.current_players[CURRENT_LIVING_PLAYERS].len, mode.threat_level) && (mode.threat_level - mode.threat) >= rule.cost)
			if(rule.ready())
				var/property_weight = 0
				for(var/property in property_weights)
					if(property in rule.property_weights)
						property_weight += rule.property_weights[property] * property_weights[property]
				drafted_rules[rule] = (rule.get_weight() + property_weight)*rule.weight_mult
	return drafted_rules


/datum/dynamic_storyteller/chaotic
	name = "Chaotic"
	config_tag = "chaotic"
	curve_centre = 10
	desc = "High chaos modes. Revs, wizard, clock cult. Multiple antags at once. Chaos is kept up all round."
	property_weights = list("extended" = -1, "chaos" = 1)
	weight = 1
	event_frequency_lower = 2 MINUTES
	event_frequency_upper = 10 MINUTES
	flags = WAROPS_ALWAYS_ALLOWED
	min_players = 40
	var/refund_cooldown = 0
	
/datum/dynamic_storyteller/chaotic/do_process()
	if(refund_cooldown < world.time)
		mode.create_threat(20)
		mode.log_threat("Chaotic storyteller ramped up the chaos. Threat level is now [mode.threat_level].")
		refund_cooldown = world.time + 20 MINUTES

/datum/dynamic_storyteller/chaotic/get_midround_cooldown()
	return ..() / 4
	
/datum/dynamic_storyteller/chaotic/get_latejoin_cooldown()
	return ..() / 4

/datum/dynamic_storyteller/team
	name = "Teamwork"
	config_tag = "teamwork"
	desc = "Modes where the crew must band together. Nukies, xenos, blob. Only one antag threat at once."
	curve_centre = 2
	curve_width = 1.5
	weight = 2
	min_players = 30
	flags = WAROPS_ALWAYS_ALLOWED
	property_weights = list("valid" = 3, "trust" = 5)

/datum/dynamic_storyteller/team/get_injection_chance(dry_run = FALSE)
	return (mode.current_players[CURRENT_LIVING_ANTAGS].len ? 0 : ..())

/datum/dynamic_storyteller/conversion
	name = "Conversion"
	config_tag = "conversion"
	desc = "Conversion antags. Cults, revs."
	curve_centre = 3
	curve_width = 1
	weight = 0
	flags = WAROPS_ALWAYS_ALLOWED
	property_weights = list("valid" = 1, "conversion" = 20)

/datum/dynamic_storyteller/random
	name = "Random"
	config_tag = "random"
	weight = 1
	desc = "No weighting at all; every ruleset has the same chance of happening. Cooldowns vary wildly. As random as it gets."

/datum/dynamic_storyteller/random/on_start()
	..()
	GLOB.dynamic_forced_threat_level = rand(0,100)

/datum/dynamic_storyteller/random/get_midround_cooldown()
	return rand(GLOB.dynamic_midround_delay_min/2, GLOB.dynamic_midround_delay_max*2)

/datum/dynamic_storyteller/random/get_event_cooldown()
	return rand(GLOB.dynamic_event_delay_min/2, GLOB.dynamic_event_delay_max*2)

/datum/dynamic_storyteller/random/get_latejoin_cooldown()
	return rand(GLOB.dynamic_latejoin_delay_min/2, GLOB.dynamic_latejoin_delay_max*2)

/datum/dynamic_storyteller/random/get_injection_chance()
	return 50 // i would do rand(0,100) but it's actually the same thing when you do the math

/datum/dynamic_storyteller/random/calculate_threat()
	return 0 // what IS threat

/datum/dynamic_storyteller/random/roundstart_draft()
	var/list/drafted_rules = list()
	for (var/datum/dynamic_ruleset/roundstart/rule in mode.roundstart_rules)
		if (rule.acceptable(mode.roundstart_pop_ready, mode.threat_level))	// If we got the population and threat required
			rule.candidates = mode.candidates.Copy()
			rule.trim_candidates()
			if (rule.ready() && rule.candidates.len > 0)
				drafted_rules[rule] = 1
	return drafted_rules

/datum/dynamic_storyteller/random/midround_draft()
	var/list/drafted_rules = list()
	for (var/datum/dynamic_ruleset/midround/rule in mode.midround_rules)
		if (rule.acceptable(mode.current_players[CURRENT_LIVING_PLAYERS].len, mode.threat_level))
			// Classic secret : only autotraitor/minor roles
			if (GLOB.dynamic_classic_secret && !((rule.flags & TRAITOR_RULESET) || (rule.flags & MINOR_RULESET)))
				continue
			rule.trim_candidates()
			if (rule.ready())
				drafted_rules[rule] = 1
	return drafted_rules

/datum/dynamic_storyteller/random/latejoin_draft(mob/living/carbon/human/newPlayer)
	var/list/drafted_rules = list()
	for (var/datum/dynamic_ruleset/latejoin/rule in mode.latejoin_rules)
		if (rule.acceptable(mode.current_players[CURRENT_LIVING_PLAYERS].len, mode.threat_level))
			// Classic secret : only autotraitor/minor roles
			if (GLOB.dynamic_classic_secret && !((rule.flags & TRAITOR_RULESET) || (rule.flags & MINOR_RULESET)))
				continue
			// No stacking : only one round-ender, unless threat level > stacking_limit.
			if (mode.threat_level > GLOB.dynamic_stacking_limit && GLOB.dynamic_no_stacking)
				if(rule.flags & HIGHLANDER_RULESET && mode.highlander_executed)
					continue
			rule.candidates = list(newPlayer)
			rule.trim_candidates()
			if (rule.ready())
				drafted_rules[rule] = 1
	return drafted_rules

/datum/dynamic_storyteller/random/event_draft()
	var/list/drafted_rules = list()
	for(var/datum/dynamic_ruleset/event/rule in mode.events)
		if(rule.acceptable(mode.current_players[CURRENT_LIVING_PLAYERS].len, mode.threat_level))
			if(rule.ready())
				drafted_rules[rule] = 1
	return drafted_rules

/datum/dynamic_storyteller/story
	name = "Story"
	config_tag = "story"
	desc = "Antags with options for loadouts and gimmicks. Traitor, wizard, nukies. Has a buildup-climax-falling action threat curve."
	weight = 2
	curve_width = 2
	property_weights = list("story_potential" = 2)


/datum/dynamic_storyteller/story/calculate_threat()
	var/current_time = (world.time / SSautotransfer.targettime)*180
	mode.threat_level = round(mode.initial_threat_level*(sin(current_time)+0.25),0.1)
	..()

/datum/dynamic_storyteller/classic
	name = "Classic"
	config_tag = "classic"
	desc = "No special antagonist weights. Good variety, but not like random. Uses your chaos preference to weight."
	flags = USE_PREF_WEIGHTS

/datum/dynamic_storyteller/suspicion
	name = "Intrigue"
	config_tag = "intrigue"
	desc = "Antags that instill distrust in the crew. Traitors, bloodsuckers."
	weight = 2
	curve_width = 2
	dead_player_weight = 2
	property_weights = list("trust" = -3)

/datum/dynamic_storyteller/liteextended
	name = "Calm"
	config_tag = "calm"
	desc = "Low-chaos round. Few antags. No conversion."
	curve_centre = -3
	curve_width = 0.5
	flags = NO_ASSASSIN | FORCE_IF_WON
	weight = 1
	dead_player_weight = 5
	property_weights = list("extended" = 2, "chaos" = -1, "valid" = -1, "story_potential" = 1, "conversion" = -10)

/datum/dynamic_storyteller/no_antag
	name = "Extended"
	config_tag = "semiextended"
	desc = "No standard antags. Threatening events may still spawn."
	curve_centre = -5
	curve_width = 0.5
	flags = NO_ASSASSIN | FORCE_IF_WON
	weight = 1
	property_weights = list("extended" = 2)

/datum/dynamic_storyteller/no_antag/roundstart_draft()
	return list()

/datum/dynamic_storyteller/no_antag/get_injection_chance(dry_run)
	return 0

/datum/dynamic_storyteller/extended
	name = "Super Extended"
	config_tag = "extended"
	desc = "No antags. No dangerous events."
	curve_centre = -20
	weight = 0
	curve_width = 0.5

/datum/dynamic_storyteller/extended/on_start()
	..()
	GLOB.dynamic_forced_extended = TRUE
