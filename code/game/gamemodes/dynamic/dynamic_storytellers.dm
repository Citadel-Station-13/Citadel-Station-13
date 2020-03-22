/datum/dynamic_storyteller
	var/name = "none" // Name for voting.
	var/config_tag = null // Config tag for config weights.
	var/desc = "A coder's idiocy." // Description for voting.
	var/list/property_weights = list() // See below.
	var/curve_centre = 0 // As GLOB.dynamic_curve_centre.
	var/curve_width = 1.8 // As GLOB.dynamic_curve_width.
	var/forced_threat_level = -1
	/*
		NO_ASSASSIN: Will not have permanent assassination targets.
		WAROPS_ALWAYS_ALLOWED: Can always do warops, regardless of threat level.
		USE_PREF_WEIGHTS: Will use peoples' preferences to change the threat centre.
	*/
	var/flags = 0
	var/weight = 3 // Weights for randomly picking storyteller. Multiplied by score after voting.
	var/event_frequency_lower = 6 MINUTES // How rare events will be, at least.
	var/event_frequency_upper = 20 MINUTES // How rare events will be, at most.
	var/pop_antag_ratio = 5 // How many non-antags there should be vs antags.
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
	var/chance = 0
	// If the high pop override is in effect, we reduce the impact of population on the antag injection chance
	var/high_pop_factor = (mode.current_players[CURRENT_LIVING_PLAYERS].len >= GLOB.dynamic_high_pop_limit)
	var/max_pop_per_antag = max(pop_antag_ratio,15 - round(mode.threat_level/10) - round(mode.current_players[CURRENT_LIVING_PLAYERS].len/(high_pop_factor ? 10 : 5)))
	if (!mode.current_players[CURRENT_LIVING_ANTAGS].len)
		chance += 80 // No antags at all? let's boost those odds!
	else
		var/current_pop_per_antag = mode.current_players[CURRENT_LIVING_PLAYERS].len / mode.current_players[CURRENT_LIVING_ANTAGS].len
		if (current_pop_per_antag > max_pop_per_antag)
			chance += min(50, 25+10*(current_pop_per_antag-max_pop_per_antag))
		else
			chance += 25-10*(max_pop_per_antag-current_pop_per_antag)
	if (mode.current_players[CURRENT_DEAD_PLAYERS].len > mode.current_players[CURRENT_LIVING_PLAYERS].len)
		chance -= 30 // More than half the crew died? ew, let's calm down on antags
	if (mode.threat > 70)
		chance += 15
	if (mode.threat < 30)
		chance -= 15
	return round(max(0,chance))

/datum/dynamic_storyteller/proc/roundstart_draft()
	var/list/drafted_rules = list()
	for (var/datum/dynamic_ruleset/roundstart/rule in mode.roundstart_rules)
		if (rule.acceptable(mode.roundstart_pop_ready, mode.threat_level) && mode.threat >= rule.cost)	// If we got the population and threat required
			rule.candidates = mode.candidates.Copy()
			rule.trim_candidates()
			if (rule.ready() && rule.candidates.len > 0)
				var/property_weight = 0
				for(var/property in property_weights)
					if(property in rule.property_weights) // just treat it as 0 if it's not in there
						property_weight += rule.property_weights[property] * property_weights[property]
				drafted_rules[rule] = (rule.get_weight() + property_weight)*rule.weight_mult
	return drafted_rules

/datum/dynamic_storyteller/proc/midround_draft()
	var/list/drafted_rules = list()
	for (var/datum/dynamic_ruleset/midround/rule in mode.midround_rules)
		// if there are antags OR the rule is an antag rule, antag_acceptable will be true.
		if (rule.acceptable(mode.current_players[CURRENT_LIVING_PLAYERS].len, mode.threat_level) && mode.threat >= rule.cost)
			// Classic secret : only autotraitor/minor roles
			if (GLOB.dynamic_classic_secret && !((rule.flags & TRAITOR_RULESET) || (rule.flags & MINOR_RULESET)))
				continue
			rule.trim_candidates()
			if (rule.ready())
				var/property_weight = 0
				for(var/property in property_weights)
					if(property in rule.property_weights)
						property_weight += rule.property_weights[property] * property_weights[property]
				drafted_rules[rule] = (rule.get_weight() + property_weight)*rule.weight_mult
		else if(mode.threat < rule.cost)
			SSblackbox.record_feedback("tally","dynamic",1,"Times rulesets rejected due to not enough threat to spend")
	return drafted_rules

/datum/dynamic_storyteller/proc/latejoin_draft(mob/living/carbon/human/newPlayer)
	var/list/drafted_rules = list()
	for (var/datum/dynamic_ruleset/latejoin/rule in mode.latejoin_rules)
		if (rule.acceptable(mode.current_players[CURRENT_LIVING_PLAYERS].len, mode.threat_level) && mode.threat >= rule.cost)
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
				var/property_weight = 0
				for(var/property in property_weights)
					if(property in rule.property_weights)
						property_weight += rule.property_weights[property] * property_weights[property]
				drafted_rules[rule] = (rule.get_weight() + property_weight)*rule.weight_mult
		else if(mode.threat < rule.cost)
			SSblackbox.record_feedback("tally","dynamic",1,"Times rulesets rejected due to not enough threat to spend")
	return drafted_rules

/datum/dynamic_storyteller/proc/event_draft()
	var/list/drafted_rules = list()
	for(var/datum/dynamic_ruleset/event/rule in mode.events)
		if(rule.acceptable(mode.current_players[CURRENT_LIVING_PLAYERS].len, mode.threat_level) && mode.threat >= rule.cost)
			if(rule.ready())
				var/property_weight = 0
				for(var/property in property_weights)
					if(property in rule.property_weights)
						property_weight += rule.property_weights[property] * property_weights[property]
				drafted_rules[rule] = (rule.get_weight() + property_weight)*rule.weight_mult
		else if(mode.threat < rule.cost)
			SSblackbox.record_feedback("tally","dynamic",1,"Times rulesets rejected due to not enough threat to spend")
	return drafted_rules


/datum/dynamic_storyteller/cowabunga
	name = "Chaotic"
	config_tag = "chaotic"
	curve_centre = 10
	desc = "High chaos modes. Revs, wizard, clock cult. Multiple antags at once. Chaos is kept up all round."
	property_weights = list("extended" = -1, "chaos" = 10)
	weight = 1
	event_frequency_lower = 2 MINUTES
	event_frequency_upper = 10 MINUTES
	flags = WAROPS_ALWAYS_ALLOWED
	pop_antag_ratio = 4
	var/refund_cooldown = 0
	
/datum/dynamic_storyteller/cowabunga/get_midround_cooldown()
	return ..() / 4
	
/datum/dynamic_storyteller/cowabunga/get_latejoin_cooldown()
	return ..() / 4

/datum/dynamic_storyteller/cowabunga/do_process()
	if(refund_cooldown < world.time)
		mode.refund_threat(40)
		mode.log_threat("Chaotic storyteller refunded 40 threat. Threat is now [mode.threat].")
		refund_cooldown = world.time + 1200 SECONDS

/datum/dynamic_storyteller/team
	name = "Teamwork"
	config_tag = "teamwork"
	desc = "Modes where the crew must band together. Nukies, xenos, blob. Only one antag threat at once."
	curve_centre = 2
	curve_width = 1.5
	weight = 2
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

/datum/dynamic_storyteller/classic
	name = "Random"
	config_tag = "random"
	desc = "No special weights attached. Anything goes."
	weight = 4
	curve_width = 4
	pop_antag_ratio = 7
	flags = USE_PREF_WEIGHTS

/datum/dynamic_storyteller/story
	name = "Story"
	config_tag = "story"
	desc = "Antags with options for loadouts and gimmicks. Traitor, wizard, nukies."
	weight = 2
	curve_width = 2
	pop_antag_ratio = 7
	property_weights = list("story_potential" = 10)

/datum/dynamic_storyteller/suspicion
	name = "Intrigue"
	config_tag = "intrigue"
	desc = "Antags that instill distrust in the crew. Traitors, bloodsuckers."
	weight = 2
	curve_width = 2
	pop_antag_ratio = 7
	property_weights = list("trust" = -5)

/datum/dynamic_storyteller/liteextended
	name = "Calm"
	config_tag = "calm"
	desc = "Low-chaos round. Few antags. No conversion."
	curve_centre = -3
	curve_width = 0.5
	flags = NO_ASSASSIN
	weight = 1
	pop_antag_ratio = 10
	property_weights = list("extended" = 1, "chaos" = -1, "valid" = -1, "story_potential" = 1, "conversion" = -10)

/datum/dynamic_storyteller/no_antag
	name = "Extended"
	config_tag = "semiextended"
	desc = "No standard antags. Threatening events may still spawn."
	curve_centre = -5
	curve_width = 0.5
	flags = NO_ASSASSIN
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
