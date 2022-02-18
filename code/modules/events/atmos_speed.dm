/datum/round_event_control/atmos_flux
	name = "Atmospheric Flux"
	typepath = /datum/round_event/atmos_flux
	max_occurrences = 1
	weight = 5
	endWhen = 600
	var/original_speed

/datum/round_event/atmos_flux
	announceWhen = 1

/datum/round_event/atmos_flux/announce(fake)
	priority_announce("Atmospheric flux in your sector detected. Sensors show that air may move [(SSair.share_max_steps_target > original_speed) ? "faster" : "slower"] than usual for some time.", "Atmos Alert")

/datum/round_event/atmos_flux/start()
	original_speed = SSair.share_max_steps_target
	if(prob(20))
		SSair.share_max_steps_target = max(1, original_speed - rand(1,original_speed-1))
	else
		SSair.share_max_steps_target += rand(2,10)

/datum/round_event/atmos_flux/end()
	SSair.share_max_steps_target = original_speed
