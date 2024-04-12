/datum/round_event_control/space_dust
	name = "Minor Space Dust"
	typepath = /datum/round_event/space_dust
	weight = 200
	max_occurrences = 1000
	earliest_start = 0 MINUTES
	alert_observers = FALSE
	category = EVENT_CATEGORY_SPACE
	description = "A single space dust is hurled at the station."

/datum/round_event/space_dust
	start_when		= 1
	end_when			= 2
	fakeable = FALSE

/datum/round_event/space_dust/start()
	spawn_meteors(1, GLOB.meteorsC)

/datum/round_event_control/sandstorm
	name = "Sandstorm"
	typepath = /datum/round_event/sandstorm
	weight = 5
	max_occurrences = 1
	min_players = 10
	earliest_start = 20 MINUTES
	category = EVENT_CATEGORY_SPACE
	description = "The station is pelted by an extreme amount of sand for several minutes."

/datum/round_event/sandstorm
	start_when = 1
	end_when = 150 // ~5 min
	announce_when = 0
	fakeable = FALSE

/datum/round_event/sandstorm/announce(fake)
	priority_announce("The station is passing through a heavy debris cloud. Watch out for breaches.", "Collision Alert", has_important_message = TRUE)

/datum/round_event/sandstorm/tick()
	spawn_meteors(rand(6,10), GLOB.meteorsC)
