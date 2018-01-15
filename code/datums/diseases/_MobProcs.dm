
/mob/proc/HasDisease(datum/disease/D)
	for(var/thing in viruses)
		var/datum/disease/DD = thing
		if(D.IsSame(DD))
			return TRUE
	return FALSE


/mob/proc/CanContractDisease(datum/disease/D)
	if(stat == DEAD)
		return FALSE

	if(D.GetDiseaseID() in resistances)
		return FALSE

	if(HasDisease(D))
		return FALSE

	if(!(type in D.viable_mobtypes))
		return FALSE

	return TRUE


/mob/proc/ContactContractDisease(datum/disease/D)
	if(!CanContractDisease(D))
		return FALSE
	AddDisease(D)


/mob/proc/AddDisease(datum/disease/D)
	for(var/datum/disease/advance/P in viruses)
		if(istype(D, /datum/disease/advance))
			var/datum/disease/advance/DD = D
			if (P.totalResistance() < DD.totalTransmittable()) //Overwrite virus if the attacker's Transmission is lower than the defender's Resistance. This does not grant immunity to the lost virus.
				P.remove_virus()

	if (!viruses.len) //Only add the new virus if it defeated the existing one
		var/datum/disease/DD = new D.type(1, D, 0)
		viruses += DD
		DD.affected_mob = src
		SSdisease.active_diseases += DD //Add it to the active diseases list, now that it's actually in a mob and being processed.

		//Copy properties over. This is so edited diseases persist.
		var/list/skipped = list("affected_mob","holder","carrier","stage","type","parent_type","vars","transformed","symptoms","processing")
		for(var/V in DD.vars)
			if(V in skipped)
				continue
			if(islist(DD.vars[V]))
				var/list/L = D.vars[V]
				DD.vars[V] = L.Copy()
			else
				DD.vars[V] = D.vars[V]

		DD.after_add()
		DD.affected_mob.med_hud_set_status()


/mob/living/carbon/ContactContractDisease(datum/disease/D, target_zone)
	if(!CanContractDisease(D))
		return FALSE

	var/obj/item/clothing/Cl = null
	var/passed = TRUE

	var/head_ch = 80
	var/body_ch = 100
	var/hands_ch = 35
	var/feet_ch = 15

	if(prob(15/D.permeability_mod))
		return

	if(satiety>0 && prob(satiety/10)) // positive satiety makes it harder to contract the disease.
		return
	if(!target_zone)
		target_zone = pick(head_ch;"head",body_ch;"body",hands_ch;"hands",feet_ch;"feet")

	if(ishuman(src))
		var/mob/living/carbon/human/H = src

		switch(target_zone)
			if("head")
				if(isobj(H.head) && !istype(H.head, /obj/item/paper))
					Cl = H.head
					passed = prob((Cl.permeability_coefficient*100) - 1)
				if(passed && isobj(H.wear_mask))
					Cl = H.wear_mask
					passed = prob((Cl.permeability_coefficient*100) - 1)
				if(passed && isobj(H.wear_neck))
					Cl = H.wear_neck
					passed = prob((Cl.permeability_coefficient*100) - 1)
			if("body")
				if(isobj(H.wear_suit))
					Cl = H.wear_suit
					passed = prob((Cl.permeability_coefficient*100) - 1)
				if(passed && isobj(slot_w_uniform))
					Cl = slot_w_uniform
					passed = prob((Cl.permeability_coefficient*100) - 1)
			if("hands")
				if(isobj(H.wear_suit) && H.wear_suit.body_parts_covered&HANDS)
					Cl = H.wear_suit
					passed = prob((Cl.permeability_coefficient*100) - 1)

				if(passed && isobj(H.gloves))
					Cl = H.gloves
					passed = prob((Cl.permeability_coefficient*100) - 1)
			if("feet")
				if(isobj(H.wear_suit) && H.wear_suit.body_parts_covered&FEET)
					Cl = H.wear_suit
					passed = prob((Cl.permeability_coefficient*100) - 1)

				if(passed && isobj(H.shoes))
					Cl = H.shoes
					passed = prob((Cl.permeability_coefficient*100) - 1)

	else if(ismonkey(src))
		var/mob/living/carbon/monkey/M = src
		switch(target_zone)
			if("head")
				if(M.wear_mask && isobj(M.wear_mask))
					Cl = M.wear_mask
					passed = prob((Cl.permeability_coefficient*100) - 1)

	if(passed)
		AddDisease(D)

/mob/proc/AirborneContractDisease(datum/disease/D)
	if((D.spread_flags & VIRUS_SPREAD_AIRBORNE) && prob((50*D.permeability_mod) - 1))
		ForceContractDisease(D)

/mob/living/carbon/AirborneContractDisease(datum/disease/D)
	if(internal)
		return
	..()

/mob/living/carbon/human/AirborneContractDisease(datum/disease/D)
	if(dna && (NOBREATH in dna.species.species_traits))
		return
	..()


//Proc to use when you 100% want to infect someone, as long as they aren't immune
/mob/proc/ForceContractDisease(datum/disease/D)
	if(!CanContractDisease(D))
		return FALSE
	AddDisease(D)


/mob/living/carbon/human/CanContractDisease(datum/disease/D)

	if(dna)
		if((VIRUSIMMUNE in dna.species.species_traits) && !D.bypasses_immunity)
			return FALSE

		var/can_infect = FALSE
		for(var/host_type in D.infectable_hosts)
			if(host_type in dna.species.species_traits)
				can_infect = TRUE
				break
		if(!can_infect)
			return FALSE

	for(var/thing in D.required_organs)
		if(!((locate(thing) in bodyparts) || (locate(thing) in internal_organs)))
			return FALSE
	return ..()