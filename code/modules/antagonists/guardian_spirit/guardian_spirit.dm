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

/datum/antagonist/guardian_spirit/roundend_report()
	var/list/report = list()

	if(!owner)
		CRASH("antagonist datum without owner")

	var/mob/living/simple_animal/hostile/guardian/G = owner?.current
	if(G && G.summoner?.mind)
		report += printplayer(G.summoner.mind)
		report += "[G.summoner.p_their()] guardian spirit was <span class='holoparasite bold'>[owner.name]</span>."
	else
		report += "<span class='holoparasite bold'>[owner.name]</span> was a guardian spirit who <span class='redtext'>died</span>."
	return report.Join("<br>")
