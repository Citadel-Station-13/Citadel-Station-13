/datum/round_event_control/meteor_wave/cat
	name = "Meteor Wave: CATastrophic"
	typepath = /datum/round_event/meteor_wave/cat
	weight = 10
	max_occurrences = 1

/datum/round_event/meteor_wave/cat
	wave_name = "cat"

/datum/round_event/meteor_wave/cat/announce(fake)
		priority_announce("Unknown biological entities have been detected near [station_name()], please stand-by.", "Lifesign Alert", "meteors")
