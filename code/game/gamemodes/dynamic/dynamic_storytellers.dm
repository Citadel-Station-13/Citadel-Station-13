/datum/dynamic_storyteller
	var/name = "none"
	var/desc = "A coder's idiocy."
	var/list/property_weights = list()
	var/curve_centre = 0
	var/curve_width = 1.8
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

/datum/dynamic_storyteller/proc/do_process()
	return

/datum/dynamic_storyteller/proc/on_start()
	return

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
				drafted_rules[rule] = rule.get_weight() + property_weight
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
				drafted_rules[rule] = rule.get_weight() + property_weight
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
				drafted_rules[rule] = rule.get_weight() + property_weight
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
				drafted_rules[rule] = rule.get_weight() + property_weight
		else if(mode.threat < rule.cost)
			SSblackbox.record_feedback("tally","dynamic",1,"Times rulesets rejected due to not enough threat to spend")
	return drafted_rules


/datum/dynamic_storyteller/cowabunga
	name = "Chaotic"
	curve_centre = 10
	desc = "Chaos: high. Variation: high. Likely antags: clock cult, revs, wizard."
	property_weights = list("extended" = -1, "chaos" = 10)

/datum/dynamic_storyteller/team
	name = "Teamwork"
	desc = "Chaos: high. Variation: low. Likely antags: nukies, clockwork cult, wizard, blob, xenomorph."
	curve_centre = 2
	curve_width = 1.5
	property_weights = list("valid" = 3, "trust" = 5)

/datum/dynamic_storyteller/classic
	name = "Classic"
	desc = "Chaos: medium. Variation: highest. Default dynamic."

/datum/dynamic_storyteller/memes
	name = "Story"
	desc = "Chaos: medium. Variation: high. Likely antags: abductors, nukies, wizard, traitor."
	curve_width = 4
	property_weights = list("story_potential" = 10, "extended" = 1)

/datum/dynamic_storyteller/suspicion
	name = "Intrigue"
	desc = "Chaos: low. Variation: high. Likely antags: traitor, bloodsucker. Rare: revs, blood cult."
	curve_centre = -2
	curve_width = 4
	property_weights = list("trust" = -5)

/datum/dynamic_storyteller/liteextended
	name = "Calm"
	desc = "Chaos: low. Variation: medium. Likely antags: bloodsuckers, traitors, sentient disease, revenant."
	curve_centre = -5
	curve_width = 0.5
	property_weights = list("extended" = 5, "chaos" = -1, "valid" = -1, "story_potential" = 1, "conversion" = -10)

/datum/dynamic_storyteller/extended
	name = "Extended"
	desc = "Chaos: none. Variation: none. Likely antags: none."
	curve_centre = -20
	curve_width = 0.5
	
/datum/dynamic_storyteller/extended/on_start()
	GLOB.dynamic_forced_extended = TRUE
