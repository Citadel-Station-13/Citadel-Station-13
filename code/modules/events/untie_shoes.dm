/datum/round_event_control/untied_shoes
	name = "Untied Shoes"
	typepath = /datum/round_event/untied_shoes
	weight = 50
	max_occurrences = 10
	alert_observers = FALSE

/datum/round_event/untied_shoes
	fakeable = FALSE

/datum/round_event/untied_shoes/start()
	var/budget = rand(5 SECONDS,20 SECONDS)
	for(var/mob/living/carbon/C in shuffle(GLOB.alive_mob_list))
		if(!C.client)
			continue
		if(C.stat == DEAD)
			continue
		if (HAS_TRAIT(C,TRAIT_EXEMPT_HEALTH_EVENTS))
			continue
		if(!C.shoes || !C.shoes.can_be_tied || C.shoes.tied != SHOES_TIED || C.shoes.lace_time > budget)
			continue
		if(!is_station_level(C.z) && prob(50))
			continue
		if(prob(5))
			C.shoes.adjust_laces(SHOES_KNOTTED)
			budget -= C.shoes.lace_time // doubling up on the budget removal on purpose
		else
			C.shoes.adjust_laces(SHOES_UNTIED)
		budget -= C.shoes.lace_time
		if(budget < 5 SECONDS)
			return
