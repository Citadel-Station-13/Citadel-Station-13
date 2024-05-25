/datum/crew_manifest

/datum/crew_manifest/ui_state(mob/user)
	return GLOB.always_state

/datum/crew_manifest/ui_status(mob/user, datum/ui_state/state)
	return (isnewplayer(user) || isobserver(user) || isAI(user) || ispAI(user)) ? UI_INTERACTIVE : UI_CLOSE

/datum/crew_manifest/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CrewManifest")
		ui.open()

/datum/crew_manifest/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if (..())
		return

/datum/crew_manifest/ui_data(mob/user)
	var/list/positions = list(
		DEPARTMENT_COMMAND = 0,
		DEPARTMENT_SECURITY = 0,
		DEPARTMENT_ENGINEERING = 0,
		DEPARTMENT_MEDICAL = 0,
		DEPARTMENT_SCIENCE = 0,
		DEPARTMENT_CARGO = 0,
		DEPARTMENT_SERVICE = 0,
		DEPARTMENT_SILICON = 0
	)
	var/list/departments = list(
		list("flag" = DEPARTMENT_BITFLAG_COMMAND, "name" = DEPARTMENT_COMMAND),
		list("flag" = DEPARTMENT_BITFLAG_SECURITY, "name" = DEPARTMENT_SECURITY),
		list("flag" = DEPARTMENT_BITFLAG_ENGINEERING, "name" = DEPARTMENT_ENGINEERING),
		list("flag" = DEPARTMENT_BITFLAG_MEDICAL, "name" = DEPARTMENT_MEDICAL),
		list("flag" = DEPARTMENT_BITFLAG_SCIENCE, "name" = DEPARTMENT_SCIENCE),
		list("flag" = DEPARTMENT_BITFLAG_CARGO, "name" = DEPARTMENT_CARGO),
		list("flag" = DEPARTMENT_BITFLAG_SERVICE, "name" = DEPARTMENT_SERVICE),
		list("flag" = DEPARTMENT_BITFLAG_SILICON, "name" = DEPARTMENT_SILICON)
	)

	for(var/datum/job/job in SSjob.occupations)
		for(var/department in departments)
			// Check if the job is part of a department using its flag
			// Will return true for Research Director if the department is Science or Command, for example
			if(job.departments & department["flag"])
				// Add open positions to current department
				positions[department["name"]] += (job.total_positions - job.current_positions)

	return list(
		"manifest" = GLOB.data_core.get_manifest(),
		"positions" = positions
	)
