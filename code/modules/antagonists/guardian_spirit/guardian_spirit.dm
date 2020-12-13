/datum/antagonist/guardian_spirit
	name = "Guardian Spirit"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	blacklisted_quirks = list()
	threat = 2

/datum/antagonist/guardian_spirit/threat()
	. = ..()
	var/mob/living/simple_animal/hostile/guardian/G = owner?.current
	if(G?.summoner?.mind && !length(G.summoner.mind.antag_datums))
		. = . * -1
