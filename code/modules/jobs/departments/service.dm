/datum/department/service
	name = "Service"
	SQL_name = "Service"
	priority = 10
	jobs = list(
		/datum/job/bartender,
		/datum/job/hydro,
		/datum/job/cook,
		/datum/job/janitor,
		/datum/job/hop
	)
	supervisor = /datum/job/hop
	supervisor_announce_channels = list(
		RADIO_CHANNEL_SERVICE
	)
