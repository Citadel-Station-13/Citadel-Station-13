/datum/department/engineering
	name = "Engineering"
	SQL_name = "Engineering"
	jobs = list(
		/datum/job/atmos,
		/datum/job/engineer,
		/datum/job/chief_engineer
	)
	supervisor = /datum/job/chief_engineer
	supervisor_announce_channels = list(
		RADIO_CHANNEL_ENGINEERING
	)
	color = rgb(255,200,0)
