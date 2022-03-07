/datum/controller/subsystem/job
	/// jexp map
	var/list/job_exp_map

/datum/controller/subsystem/job/proc/InitJEXPMap()
	job_exp_map = list(
		EXP_TYPE_CREW = list(
			"titles" = GetAllJobNames(JOB_FACTION_STATION)
		),
		EXP_TYPE_COMMAND = list(
			"titles" = GetDepartmentJobNames(/datum/department/command)
		),
		EXP_TYPE_ENGINEERING = list(
			"titles" = GetDepartmentJobNames(/datum/department/engineering)
		),
		EXP_TYPE_MEDICAL = list(
			"titles" = GetDepartmentJobNames(/datum/department/medical)
		),
		EXP_TYPE_SCIENCE = list(
			"titles" = GetDepartmentJobNames(/datum/department/science)
		),
		EXP_TYPE_SUPPLY = list(
			"titles" = GetDepartmentJobNames(/datum/department/cargo)
		),
		EXP_TYPE_SECURITY = list(
			"titles" = GetDepartmentJobNames(/datum/department/security)
		),
		EXP_TYPE_SILICON = list(
			"titles" = GetDepartmentJobNames(/datum/department/silicon)
		),
		EXP_TYPE_SERVICE = list(
			"titles" = GetDepartmentJobNames(/datum/department/service) | GetDepartmentJobNames(/datum/department/civillian)
		),
	)
