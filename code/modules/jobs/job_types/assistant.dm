/*
Assistant
*/
/datum/job/assistant
	title = "Assistant"
	flag = ASSISTANT
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/assistant
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.
	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT
	dresscodecompliant = FALSE
	threat = 0.2

/datum/job/assistant/get_access()
	if(CONFIG_GET(flag/assistants_have_maint_access) || !CONFIG_GET(flag/jobs_have_minimal_access)) //Config has assistant maint access set
		. = ..()
		. |= list(ACCESS_MAINT_TUNNELS)
	else
		return ..()

/datum/outfit/job/assistant
	name = "Assistant"
	jobtype = /datum/job/assistant

/datum/outfit/job/assistant/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE, client/preference_source)
	..()
	var/suited = !preference_source || preference_source.prefs.jumpsuit_style == PREF_SUIT
	if (CONFIG_GET(flag/grey_assistants))
		if(suited)
			uniform = /obj/item/clothing/under/color/grey
		else
			uniform = /obj/item/clothing/under/color/jumpskirt/grey
	else
		if(suited)
			uniform = /obj/item/clothing/under/color/random
		else
			uniform = /obj/item/clothing/under/color/jumpskirt/random
