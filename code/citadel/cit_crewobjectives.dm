/datum/controller/subsystem/ticker/proc/generate_crew_objectives()
	for(var/datum/mind/crewMind in SSticker.minds)
		if(prob(2) && !issilicon(crewMind.current) && !jobban_isbanned(crewMind, "Syndicate") && GLOB.miscreants_allowed && ROLE_MISCREANT in crewmind.client.prefs.be_special)
			generate_miscreant_objectives(crewMind)
		else
			if(CONFIG_GET(flag/allow_crew_objectives))
				generate_individual_objectives(crewMind)
	return

/datum/controller/subsystem/ticker/proc/generate_individual_objectives(var/datum/mind/crewMind)
	if(!(CONFIG_GET(flag/allow_crew_objectives)))
		return
	if(!crewMind)
		return
	if(!crewMind.current || !crewMind.objectives || crewMind.special_role)
		return
	if(!crewMind.assigned_role)
		return
	var/list/validobjs = get_valid_crew_objs(ckey(crewMind.assigned_role))
	if(!validobjs || !validobjs.len)
		return
	var/selectedObj = pick(validobjs)
	var/datum/objective/crew/newObjective = new selectedObj
	if(!newObjective)
		return
	newObjective.owner = crewMind
	crewMind.objectives += newObjective
	to_chat(crewMind, "<B>As a part of Nanotrasen's anti-tide efforts, you have been assigned an optional objective. It will be checked at the end of the shift. <font color=red>Performing traitorous acts in pursuit of your objective may result in termination of your employment.</font></B>")
	to_chat(crewMind, "<B>Your optional objective:</B> [newObjective.explanation_text]")

/datum/controller/subsystem/ticker/proc/get_valid_crew_objs(var/job = "")//taken from old hippie with adjustments
	var/list/objpaths = typesof(/datum/objective/crew)
	var/list/objlist = list()
	for(var/hoorayhackyshit in objpaths)
		var/datum/objective/crew/obj = hoorayhackyshit //dm is not a sane language in any way, shape, or form.
		var/list/availableto = splittext(initial(obj.jobs),",")
		if(job in availableto)
			objlist += obj
	return objlist

/datum/objective/crew/
	var/jobs = ""
	explanation_text = "Yell on the development discussion channel on Citadels discord if this ever shows up. Something just broke here, dude"

/datum/objective/crew/proc/setup()
