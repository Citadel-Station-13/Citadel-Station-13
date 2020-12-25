/datum/antagonist/greybois
	name = "Emergency Assistant"
	show_name_in_check_antagonists = TRUE
	show_in_antagpanel = FALSE
	threat = -1
	var/mission = "Assist the station."
	var/datum/outfit/outfit = /datum/outfit/ert/greybois

/datum/antagonist/greybois/greygod
	outfit = /datum/outfit/ert/greybois/greygod

/datum/antagonist/greybois/greet()
	to_chat(owner, "<B><font size=3 color=red>You are an Emergency Assistant.</font></B>")
	to_chat(owner, "Central Command is sending you to [station_name()] with the task: [mission]")

/datum/antagonist/greybois/on_gain()
	equipERT()
	. = ..()

/datum/antagonist/greybois/proc/equipERT()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return
	H.equipOutfit(outfit)
