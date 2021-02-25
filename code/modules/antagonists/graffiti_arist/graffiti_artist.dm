/datum/antagonist/graffiti_artist
	name = "Graffiti Artist"
	antagpanel_category = "Graffiti Artist"
	job_rank = ROLE_GRAFFITI_ARTIST
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	threat = 8

	var/obj/item/toy/crayon/spraycan/antag/special_spraycan

/datum/antagonist/graffiti_artist/on_gain()
	var/mob/living/carbon/human/H = owner.current
	if(H)
		special_spraycan = new
		var/list/slots = list("backpack" = SLOT_IN_BACKPACK)
		H.equip_in_one_of_slots(special_spraycan, slots, critical = TRUE)
	else
		message_admins("The graffiti artist antagonist was somehow given to the mind: [owner] without the mind having a mob. If this wasn't intended, you should report this!")
	forge_objectives()

/datum/antagonist/graffiti_artist/on_removal()
	if(special_spraycan)
		qdel(special_spraycan)
	. = ..()

/datum/antagonist/graffiti_artist/proc/forge_objectives()
	var/datum/objective/vandalize_objective = new("Vandalize the station with your art.")
	vandalize_objective.owner = owner
	objectives += vandalize_objective

	var/datum/objective/art_objective = new("You need some crew left alive to appreciate your art, such that the Wizard Federation's art department can gain relevance and not have its budget cut.")
	art_objective.owner = owner
	objectives += art_objective

	var/datum/objective/escape/escape_objective = new
	escape_objective.owner = owner
	objectives += escape_objective

/datum/antagonist/graffiti_artist/greet()
	to_chat(owner, "<span class='boldannounce'>The Wizard Federation's art department has assigned you the mission of vandalizing this station. You have been kitted with a standard issue Wizard Federation spraycan.</span>")

	owner.announce_objectives()
