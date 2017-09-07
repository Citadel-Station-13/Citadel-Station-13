/*				ENGINEERING OBJECTIVES				*/

/datum/objective/crew/chiefengineer

/datum/objective/crew/chiefengineer/integrity //ported from old Hippie
	explanation_text = "Ensure the station's integrity rating is at least (Yo something broke, yell on the development discussion channel of citadels discord about this)% when the shift ends."

/datum/objective/crew/chiefengineer/integrity/New()
	. = ..()
	target_amount = rand(60,95)
	update_explanation_text()

/datum/objective/crew/chiefengineer/integrity/update_explanation_text()
	. = ..()
	explanation_text = "Ensure the station's integrity rating is at least [target_amount]% when the shift ends."

/datum/objective/crew/chiefengineer/integrity/check_completion()
	var/datum/station_state/end_state = new /datum/station_state()
	end_state.count()
	var/station_integrity = min(PERCENT(GLOB.start_state.score(end_state)), 100)
	if(!SSticker.mode.station_was_nuked && station_integrity >= target_amount)
		return 1
	else
		return 0

/datum/objective/crew/stationengineer

/datum/objective/crew/stationengineer/integrity
	explanation_text = "Ensure the station's integrity rating is at least (Yo something broke, yell on the development discussion channel of citadels discord about this)% when the shift ends."

/datum/objective/crew/stationengineer/integrity/New()
	. = ..()
	target_amount = rand(60,95)
	update_explanation_text()

/datum/objective/crew/stationengineer/integrity/update_explanation_text()
	. = ..()
	explanation_text = "Ensure the station's integrity rating is at least [target_amount]% when the shift ends."

/datum/objective/crew/stationengineer/integrity/check_completion()
	var/datum/station_state/end_state = new /datum/station_state()
	end_state.count()
	var/station_integrity = min(PERCENT(GLOB.start_state.score(end_state)), 100)
	if(!SSticker.mode.station_was_nuked && station_integrity >= target_amount)
		return 1
	else
		return 0
