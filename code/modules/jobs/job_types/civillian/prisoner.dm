/datum/job/prisoner
	title = "Prisoner"
	desc = "Outsourced prisoners shipped to the station; Try to behave, as it's probably more pleasant here than whereever you were from."
	faction = JOB_FACTION_STATION
	total_positions = 0
	roundstart_positions = 0

	outfit = /datum/outfit/job/prisoner
	plasma_outfit = /datum/outfit/plasmaman/prisoner

/datum/job/prisoner/after_spawn(mob/M, latejoin, client/C)
	. = ..()
	// todo make this generic on job
	var/list/policies = CONFIG_GET(keyed_list/policy)
	var/policy = policies[POLICYCONFIG_JOB_PRISONER]
	if(policy)
		to_chat(C, "<br><span class='userdanger'>!!READ THIS!!</span><br><span class='warning'>The following is server-specific policy configuration and overrides anything said above if conflicting.</span>")
		to_chat(C, "<br><br>")
		to_chat(C, "<span class='boldnotice'>[policy]</span>")

/datum/outfit/job/prisoner
	name = "Prisoner"
	jobtype = /datum/job/prisoner

	uniform = /obj/item/clothing/under/rank/prisoner
	shoes = /obj/item/clothing/shoes/sneakers/orange
	id = /obj/item/card/id/prisoner
	ears = /obj/item/radio/headset/headset_prisoner
	belt = null
