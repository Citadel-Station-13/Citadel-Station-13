/datum/department/security
	name = "Security"
	SQL_name = "Security"
	jobs = list(
		/datum/job/officer,
		/datum/job/detective,
		/datum/job/warden,
		/datum/job/hos
	)
	supervisor = /datum/job/hos
	supervisor_announce_channels = list(
		RADIO_CHANNEL_SECURITY
	)
	color = "#ffaaa0"
