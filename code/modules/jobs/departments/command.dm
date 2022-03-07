/datum/department/command
	name = "Command"
	priority = 100
	SQL_name = "Command"
	jobs = list(
		/datum/job/hop,
		/datum/job/captain,
		/datum/job/rd,
		/datum/job/cmo,
		/datum/job/chief_engineer,
		/datum/job/hos,
		/datum/job/qm
	)
	supervisor = /datum/job/captain
	supervisor_announce_channels = list(
		RADIO_CHANNEL_COMMAND
	)
	color = rgb(125,125,255)
