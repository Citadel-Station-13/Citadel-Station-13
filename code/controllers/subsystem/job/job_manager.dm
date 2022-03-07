/datum/controller/subsystem/job
	// Job datum management
	// You'll note that I used static
	// This means that Recover() isn't needed to recover them.
	// But.
	// If things break horribly, this also means there's no way to automatically fix things
	// SHOULD anyone ever fuck up the round so badly we need a Recover(), feel free to yell at me.
	// All the Recover() would need to do is for(job in world) to recover state variables, and then manually recreate everything.
	/// all instantiated job datums
	var/static/list/datum/job/jobs = list()
	/// all instantiated department datums,
	var/static/list/datum/department/departments = list()
	/// job datums by type
	var/static/list/job_type_lookup = list()
	/// job datums by priamry name
	var/static/list/job_name_lookup = list()
	/// departments by type
	var/static/list/department_type_lookup = list()
	/// departments by name
	var/static/list/department_name_lookup = list()
	/// alt titles to real titles lookup
	var/static/list/alt_title_lookup = list()
	/// job types in departments
	var/static/list/job_types_in_department = list()
	/// job names in departments
	var/static/list/job_names_in_department = list()

	/// used for prefs setup - tgui when lmfao
	var/static/list/horrifying_preferences_render_list

/datum/controller/subsystem/job/proc/SetupOccupations()
	var/list/all_jobs = subtypesof(/datum/job)
	if(!all_jobs.len)
		CRASH("Couldn't setup any job datums.")
	jobs = list()
	departments = list()
	job_type_lookup = list()
	department_type_lookup = list()
	job_name_lookup = list()
	department_name_lookup = list()
	alt_title_lookup = list()
	// instantiate jobs
	for(var/path in subtypesof(/datum/job))
		var/datum/job/J = path
		if(initial(J.abstract_type) == path)
			continue
		J = new J
		if(!J.config_check())
			continue
		if(!J.ProcessMap(SSmapping.config))
			continue
		jobs += J
		job_type_lookup[path] = J
		job_name_lookup[J.title] = J
		J.departments = list()
		J.departments_supervised = list()
		for(var/apath in J.alt_titles)
			if(!ispath(apath, /datum/alt_title))
				stack_trace("[apath] on [path] is not a valid alt title path.")
				continue
			var/datum/alt_title/title = apath
			alt_title_lookup[initial(title.name)] = J.title
	// instantiate departments
	var/list/departments_temporary = list()
	for(var/path in subtypesof(/datum/department))
		var/datum/department/D = new path
		departments += D
		departments_temporary += D
		department_type_lookup[path] = D
		department_name_lookup[D.name] = D
	// assign departments to jobs and vice versa
	sortTim(departments_temporary, /proc/cmp_department_priority_dsc, FALSE)
	// why don't we sort the real departments list while we're at it
	sortTim(departments, /proc/cmp_department_priority_dsc, FALSE)
	for(var/datum/department/D as anything in departments_temporary)
		for(var/path in D.jobs)
			if(!ispath(path))
				stack_trace("[path] in [D.type] is not a typepath.")
				continue
			var/datum/job/J = job_type_lookup[path]
			J.departments += D.type
			LAZYOR(job_types_in_department[D.type], J.type)
			LAZYOR(job_names_in_department[D.type], J.title)
		// force head to first
		if(D.supervisor && (D.supervisor in D.jobs))
			D.jobs -= D.supervisor
			D.jobs.Insert(1, D.supervisor)
		// end
		if(D.supervisor)
			if(!ispath(D.supervisor))
				stack_trace("[D.supervisor] in [D.type]'s supervisor is not a typepath.")
			else
				var/datum/job/J = job_type_lookup[D.supervisor]
				J.departments_supervised += D.type
	// sweep up any jobs without departments
	var/datum/department/misc/misc_department = department_type_lookup[/datum/department/misc]
	for(var/datum/job/J as anything in jobs)
		if(!LAZYLEN(J.departments))
			J.departments = list(/datum/department/misc)
			misc_department.jobs += J.type
	RecomputePreferencesRender()
	return TRUE

/datum/controller/subsystem/job/proc/GetJobAuto(thing)
	. = job_type_lookup[thing] || job_name_lookup[thing]
	if(!.)
		CRASH("Failed JobAutoLookup: [thing].")

/datum/controller/subsystem/job/proc/GetJobType(path)
	RETURN_TYPE(/datum/job)
	if(istext(path))
		path = text2path(path)
	if(!job_type_lookup[path])
		CRASH("Failed to fetch job path: [path]")
	return job_type_lookup[path]

/datum/controller/subsystem/job/proc/GetJobName(name)
	RETURN_TYPE(/datum/job)
	if(!job_name_lookup[name])
		CRASH("Failed to fetch job name: [name]")
	return job_name_lookup[name]

/datum/controller/subsystem/job/proc/GetDepartmentType(path)
	RETURN_TYPE(/datum/department)
	if(istext(path))
		path = text2path(path)
	if(!department_type_lookup[path])
		CRASH("Failed to fetch department path: [path]")
	return department_type_lookup[path]

/datum/controller/subsystem/job/proc/GetDepartmentName(name)
	RETURN_TYPE(/datum/department)
	if(!department_name_lookup[name])
		CRASH("Failed to fetch department name: [name]")
	return department_name_lookup[name]

/datum/controller/subsystem/job/proc/GetDepartmentMinds(path, list/mob_typecache_filter)
	RETURN_TYPE(/list)
	. = list()
	var/datum/department/D = ispath(path)? GetDepartmentType(path) : GetDepartmentName(path)
	if(!D)
		CRASH("Failed to fetch department [path].")
	for(var/mob/M as anything in GLOB.mob_list)
		if(mob_typecache_filter && !mob_typecache_filter[M.type])
			continue
		if(M.mind?.assigned_role in job_names_in_department[D.type])
			. += M.mind

/datum/controller/subsystem/job/proc/GetLivingDepartmentMinds(path, list/mob_typecache_filter)
	RETURN_TYPE(/list)
	. = list()
	var/datum/department/D = ispath(path)? GetDepartmentType(path) : GetDepartmentName(path)
	if(!D)
		CRASH("Failed to fetch department [path].")
	for(var/mob/M as anything in GLOB.alive_mob_list)
		if(mob_typecache_filter && !mob_typecache_filter[M.type])
			continue
		if(M.mind?.assigned_role in job_names_in_department[D.type])
			. += M.mind

/datum/controller/subsystem/job/proc/GetJobMinds(path, list/mob_typecache_filter)
	RETURN_TYPE(/list)
	. = list()
	var/datum/job/J = ispath(path)? GetJobType(path) : GetJobName(path)
	if(!J)
		CRASH("Failed to fetch job [path].")
	for(var/mob/M as anything in GLOB.mob_list)
		if(mob_typecache_filter && !mob_typecache_filter[M.type])
			continue
		if(M.mind?.assigned_role == J.GetName())
			. += M.mind

/datum/controller/subsystem/job/proc/GetLivingJobMinds(path, list/mob_typecache_filter)
	RETURN_TYPE(/list)
	. = list()
	var/datum/job/J = ispath(path)? GetJobType(path) : GetJobName(path)
	if(!J)
		CRASH("Failed to fetch job [path].")
	for(var/mob/M as anything in GLOB.alive_mob_list)
		if(mob_typecache_filter && !mob_typecache_filter[M.type])
			continue
		if(M.mind?.assigned_role == J.GetName())
			. += M.mind

/**
 * Frees a slot
 *
 * Can enter either a path or name.
 */
/datum/controller/subsystem/job/proc/FreeRole(path)
	var/datum/job/J = ispath(path)? GetJobType(path) : GetJobName(path)
	if(!J)
		CRASH("Failed to fetch job [path].")
	J.current_positions = max(0, J.current_positions - 1)

/**
 * Gets all job names of a certain faction
 */
/datum/controller/subsystem/job/proc/GetAllJobNames(faction)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/job/J as anything in jobs)
		if(!faction || (J.faction == faction))
			. += J.title

/**
 * Gets all job datums of a certain faction
 */
/datum/controller/subsystem/job/proc/GetAllJobs(faction)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/job/J as anything in jobs)
		if(!faction || (J.faction == faction))
			. += J

/**
 * Gets all job types of a certain faction
 */
/datum/controller/subsystem/job/proc/GetAllJobTypes(faction)
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/job/J as anything in jobs)
		if(!faction || (J.faction == faction))
			. += J.type

/**
 * Gets a list of job names in a department
 * Can use either department name or type.
 */
/datum/controller/subsystem/job/proc/GetDepartmentJobNames(department_id)
	RETURN_TYPE(/list)
	var/datum/department/D = department_type_lookup[department_id] || department_name_lookup[department_id]
	if(!D)
		CRASH("Failed to look up [department_id]")
	return D.GetJobNames()

/**
 * Gets a list of job IDs in a department
 * Can use either department name or type.
 */
/datum/controller/subsystem/job/proc/GetDepartmentJobIDs(department_id)
	RETURN_TYPE(/list)
	var/datum/department/D = department_type_lookup[department_id] || department_name_lookup[department_id]
	if(!D)
		CRASH("Failed to look up [department_id]")
	return D.GetJobIDs()

/**
 * Gets a list of job datums in a department
 * Can use either department name or type.
 */
/datum/controller/subsystem/job/proc/GetDepartmentJobDatums(department_id)
	RETURN_TYPE(/list)
	var/datum/department/D = department_type_lookup[department_id] || department_name_lookup[department_id]
	if(!D)
		CRASH("Failed to look up [department_id]")
	return D.GetJobs()

/**
 * gets the effective hud icon of a job
 */
/datum/controller/subsystem/job/proc/GetJobHUDIcon(title)
	if(alt_title_lookup[title])
		title = alt_title_lookup[title]
	if(job_name_lookup[title])
		var/datum/job/J = job_name_lookup[title]
		if(J.hud_icon_state)
			var/state = J.hud_icon_state
			return state == "DEFAFULT_TO_TITLE"? ckey(J.GetName()) : J.hud_icon_state
	if(title in get_all_centcom_jobs())
		return "CentCom"
	return "Unknown"

/**
 * i'm so fucking sorry
 * tgui preferences (not awful edition) when?
 */
/datum/controller/subsystem/job/proc/RecomputePreferencesRender()
	// inefficient and awful but hey, player UI experience am i right gamers :/
	// list is horrfiying_nested_list[faction as define text][department instance] = list(title = job instance)
	horrifying_preferences_render_list = list()
	var/list/horrifying_nested_list = horrifying_preferences_render_list
	for(var/datum/job/job as anything in GetAllJobs())
		if(!(job.join_types & JOB_ROUNDSTART))
			continue		// not necessary
		var/list/faction
		if(horrifying_nested_list[job.faction])
			faction = horrifying_nested_list[job.faction]
		else
			faction = horrifying_nested_list[job.faction] = list()
		var/datum/department/D = job.GetPrimaryDepartment()
		var/list/dept
		if(horrifying_nested_list[job.faction][D])
			dept = horrifying_nested_list[job.faction][D]
		else
			dept = horrifying_nested_list[job.faction][D] = list()
		dept += list(list(job.title = job))

	// *sigh
	var/list/_station = horrifying_nested_list[JOB_FACTION_STATION]
	// force station at top
	horrifying_nested_list -= JOB_FACTION_STATION
	horrifying_nested_list.Insert(1, JOB_FACTION_STATION)
	horrifying_nested_list[JOB_FACTION_STATION] = _station
	// sort rest
	sortTim(horrifying_nested_list, /proc/cmp_text_asc, associative = FALSE, fromIndex = 2)
	for(var/faction as anything in horrifying_nested_list)
		// sort departments
		var/list/L1 = horrifying_nested_list[faction]
		sortTim(L1, /proc/cmp_department_priority_dsc, associative = FALSE)
		for(var/datum/department/D as anything in L1)
			// sort jobs
			var/list/L2 = L1[D]
			// force head at top
			var/headname = D.GetSupervisorName()
			var/datum/job/_head = L2[headname]
			L2 -= headname
			L2.Insert(1, headname)
			L2[headname] = _head
			// sort the rest
			sortTim(L2, /proc/cmp_text_asc, associative = FALSE)
	// finish

