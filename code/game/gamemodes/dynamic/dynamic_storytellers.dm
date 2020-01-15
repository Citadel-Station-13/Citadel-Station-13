/datum/dynamic_storyteller
	var/name = "none"
	var/desc = "A coder's idiocy."
	var/list/property_weights = list()
	var/curve_centre = 0
	var/curve_width = 1.8
	var/forced_threat_level = -1
	var/flags = 0
	var/weight = 3 // how many rounds need to have been recently played for this storyteller to be left out of the vote
	var/datum/game_mode/dynamic/mode = null

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

/datum/dynamic_storyteller/New()
	..()
	if (istype(SSticker.mode, /datum/game_mode/dynamic))
		mode = SSticker.mode
		GLOB.dynamic_curve_centre = curve_centre
		GLOB.dynamic_curve_width = curve_width
		GLOB.dynamic_forced_threat_level = forced_threat_level

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
	return

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
	var/max_pop_per_antag = max(5,15 - round(mode.threat_level/10) - round(mode.current_players[CURRENT_LIVING_PLAYERS].len/(high_pop_factor ? 10 : 5)))
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
	curve_centre = 10
	desc = "Chaos: high. Variation: high. Likely antags: clock cult, revs, wizard."
	property_weights = list("extended" = -1, "chaos" = 10)
	weight = 2
	flags = WAROPS_ALWAYS_ALLOWED
	var/refund_cooldown
	
/datum/dynamic_storyteller/cowabunga/get_midround_cooldown()
	return ..() / 4
	
/datum/dynamic_storyteller/cowabunga/get_latejoin_cooldown()
	return ..() / 4

/datum/dynamic_storyteller/cowabunga/do_process()
	if(refund_cooldown < world.time)
		mode.refund_threat(10)
		mode.log_threat("Cowabunga it is. Refunded 10 threat. Threat is now [mode.threat].")
		refund_cooldown = world.time + 300 SECONDS

/datum/dynamic_storyteller/team
	name = "Teamwork"
	desc = "Chaos: high. Variation: low. Likely antags: nukies, clockwork cult, wizard, blob, xenomorph."
	curve_centre = 2
	curve_width = 1.5
	weight = 2
	flags = WAROPS_ALWAYS_ALLOWED
	property_weights = list("valid" = 3, "trust" = 5)

/datum/dynamic_storyteller/team/get_injection_chance(dry_run = FALSE)
	return (mode.current_players[CURRENT_LIVING_ANTAGS].len ? 0 : ..())

/datum/dynamic_storyteller/conversion
	name = "Conversion"
	desc = "Chaos: high. Variation: medium. Likely antags: cults, bloodsuckers, revs."
	curve_centre = 3
	curve_width = 1
	weight = 2
	flags = WAROPS_ALWAYS_ALLOWED
	property_weights = list("valid" = 1, "conversion" = 20)

/datum/dynamic_storyteller/classic
	name = "Random"
	desc = "Chaos: varies. Variation: highest. No special weights attached."
	weight = 6
	curve_width = 4

/datum/dynamic_storyteller/memes
	name = "Story"
	desc = "Chaos: varies. Variation: high. Likely antags: abductors, nukies, wizard, traitor."
	curve_width = 4
	property_weights = list("story_potential" = 10)

/datum/dynamic_storyteller/suspicion
	name = "Intrigue"
	desc = "Chaos: low. Variation: high. Likely antags: traitor, bloodsucker. Rare: revs, blood cult."
	curve_width = 4
	property_weights = list("trust" = -5)

/datum/dynamic_storyteller/liteextended
	name = "Calm"
	desc = "Chaos: low. Variation: medium. Likely antags: bloodsuckers, traitors, sentient disease, revenant."
	curve_centre = -5
	curve_width = 0.5
	flags = NO_ASSASSIN
	weight = 2
	property_weights = list("extended" = 1, "chaos" = -1, "valid" = -1, "story_potential" = 1, "conversion" = -10)

/datum/dynamic_storyteller/liteextended/get_injection_chance(dry_run = FALSE)
	return ..()/2

/datum/dynamic_storyteller/extended
	name = "Extended"
	desc = "Chaos: none. Variation: none. Likely antags: none."
	curve_centre = -20
	weight = 2
	curve_width = 0.5

/datum/dynamic_storyteller/extended/on_start()
	GLOB.dynamic_forced_extended = TRUE
