/obj/effect/landmark/awaystart
	name = "away mission spawn"
	desc = "Randomly picked away mission spawn points."
	var/id
	var/delay = TRUE // If the generated destination should be delayed by configured gateway delay

/obj/effect/landmark/awaystart/Initialize()
	. = ..()
	var/datum/gateway_destination/point/current
	for(var/datum/gateway_destination/point/D in GLOB.gateway_destinations)
		if(D.id == id)
			current = D
	if(!current)
		current = new
		current.id = id
		if(delay)
			current.wait = CONFIG_GET(number/gateway_delay)
		GLOB.gateway_destinations += current
	current.target_turfs += get_turf(src)

/obj/effect/landmark/awaystart/nodelay
	delay = FALSE
