/*				CARGO OBJECTIVES				*/

/datum/objective/crew/quartermaster

/datum/objective/crew/quartermaster/petsplosion
	explanation_text = "Ensure there are at least (If you see this, yell on citadels discord in the development discussion channel) pets on the station by the end of the shift. Interpret this as you wish."

/datum/objective/crew/quartermaster/petsplosion/New()
	. = ..()
	target_amount = rand(10,30)
	update_explanation_text()

/datum/objective/crew/quartermaster/petsplosion/update_explanation_text()
	. = ..()
	explanation_text = "Ensure there are at least [target_amount] pets on the station by the end of the shift. Interpret this as you wish."

/datum/objective/crew/quartermaster/petsplosion/check_completion()
	var/petcount = target_amount
	for(var/mob/living/simple_animal/pet/P in GLOB.mob_list)
		!(P.stat == DEAD)
			if(P.z == ZLEVEL_STATION_PRIMARY || SSshuttle.emergency.shuttle_areas[get_area(P)])
				petcount--
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		!(H.stat == DEAD)
			if(H.z == ZLEVEL_STATION_PRIMARY || SSshuttle.emergency.shuttle_areas[get_area(H)])
				if(istype(H.wear_neck, /obj/item/clothing/neck/petcollar))
					petcount--
	if(petcount <= 0)
		return TRUE
	else
		return FALSE

/datum/objective/crew/cargotechnician

/datum/objective/crew/cargotechnician/petsplosion
	explanation_text = "Ensure there are at least (If you see this, yell on citadels discord in the development discussion channel) pets on the station by the end of the shift. Interpret this as you wish."

/datum/objective/crew/cargotechnician/petsplosion/New()
	. = ..()
	target_amount = rand(10,30)
	update_explanation_text()

/datum/objective/crew/cargotechnician/petsplosion/update_explanation_text()
	. = ..()
	explanation_text = "Ensure there are at least [target_amount] pets on the station by the end of the shift. Interpret this as you wish."

/datum/objective/crew/cargotechnician/petsplosion/check_completion()
	var/petcount = target_amount
	for(var/mob/living/simple_animal/pet/P in GLOB.mob_list)
		!(P.stat == DEAD)
			if(P.z == ZLEVEL_STATION_PRIMARY || SSshuttle.emergency.shuttle_areas[get_area(P)])
				petcount--
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		!(H.stat == DEAD)
			if(H.z == ZLEVEL_STATION_PRIMARY || SSshuttle.emergency.shuttle_areas[get_area(H)])
				if(istype(H.wear_neck, /obj/item/clothing/neck/petcollar))
					petcount--
	if(petcount <= 0)
		return TRUE
	else
		return FALSE

/datum/objective/crew/shaftminer

/datum/objective/crew/shaftminer/bubblegum
	explanation_text = "Ensure Bubblegum is dead at the end of the shift."

/datum/objective/crew/shaftminer/bubblegum/check_completion()
	for(var/mob/living/simple_animal/hostile/megafauna/bubblegum/B in GLOB.mob_list)
		!(B.stat == DEAD)
			return FALSE
	return TRUE
