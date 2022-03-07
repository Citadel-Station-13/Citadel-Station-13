/datum/department/medical
	name = "Medical"
	SQL_name = "Medical"
	jobs = list(
		/datum/job/doctor,
		/datum/job/virologist,
		/datum/job/geneticist,
		/datum/job/chemist,
		/datum/job/paramedic,
		/datum/job/cmo
	)
	supervisor = /datum/job/cmo
	supervisor_announce_channels = list(
		RADIO_CHANNEL_MEDICAL
	)
	color = rgb(200,200,255)
