#define JOB_MODIFICATION_MAP_NAME "CogStation"

//Medical
/datum/job/scientist/New()
	..()
	MAP_JOB_CHECK
	access += ACCESS_CHEMISTRY
	minimal_access += ACCESS_CHEMISTRY

//Science

/datum/job/roboticist/New()
	..()
	MAP_JOB_CHECK
	access += list(ACCESS_MEDICAL, ACCESS_MORGUE)
	minimal_access += list(ACCESS_MEDICAL, ACCESS_MORGUE)

//Civilian
/datum/job/clown/New()
	..()
	MAP_JOB_CHECK
	access += ACCESS_MAINT_TUNNELS
	minimal_access += ACCESS_MAINT_TUNNELS

/datum/job/mime/New()
	..()
	MAP_JOB_CHECK
	access += ACCESS_MAINT_TUNNELS
	minimal_access += ACCESS_MAINT_TUNNELS
