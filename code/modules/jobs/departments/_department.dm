/**
 * Department datums
 * Groups jobs by departments.
 */
/datum/department
	/// name
	var/name = "Unknown Department"
	/// IDs of the jobs in it. NOT references.
	var/list/jobs = list()
	/// SQL name for things like JEXP - defaults to name
	var/SQL_name = "DEFAULT"
	/// ID of the primary supervisor job. NOT reference to datum.
	var/supervisor
	/// Priority - higher = override lower
	var/priority = 0
	/// List in manifest?
	var/unlisted = FALSE
	/// List of channels to announce supervisor joins to
	var/list/supervisor_announce_channels
	/// primary color theme - DO NOT MAKE THIS TOO DARK
	var/color = rgb(150,150,150)

/datum/department/New()
	if(SQL_name == "DEFAULT")
		SQL_name = name

/datum/department/proc/GetJobs()
	RETURN_TYPE(/datum/job)
	. = list()
	for(var/path in jobs)
		. += SSjob.GetJobType(path)

/datum/department/proc/GetJobIDs()
	return jobs.Copy()

/datum/department/proc/GetJobNames()
	. = list()
	for(var/id in jobs)
		var/datum/job/J = SSjob.job_type_lookup[id]
		. += istype(J)? J.title : "(ERROR - [id] not found)"

/datum/department/proc/GetSupervisor()
	RETURN_TYPE(/datum/job)
	return supervisor && SSjob.GetJobType(supervisor)

/datum/department/proc/GetSupervisorName()
	return supervisor && SSjob.GetJobType(supervisor)?.GetName()

/datum/department/proc/GetSupervisorID()
	return supervisor

/datum/department/proc/GetMinds()
	RETURN_TYPE(/datum/mind)
	return SSjob.GetDepartmentMinds(src)

/datum/department/proc/GetLivingMinds()
	RETURN_TYPE(/datum/mind)
	return SSjob.GetLivingDepartmentMinds(src)
