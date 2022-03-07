/datum/department/science
	name = "Science"
	SQL_name = "Science"
	jobs = list(
		/datum/job/scientist,
		/datum/job/roboticist,
		/datum/job/geneticist,
		/datum/job/rd
	)
	supervisor = /datum/job/rd
	supervisor_announce_channels = list(
		RADIO_CHANNEL_SCIENCE
	)
	color = rgb(200,100,250)
