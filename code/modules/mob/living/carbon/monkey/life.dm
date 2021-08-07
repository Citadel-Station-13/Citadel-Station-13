

/mob/living/carbon/monkey


/mob/living/carbon/monkey/BiologicalLife(seconds, times_fired)
	if(!(. = ..()))
		return
	if(client)
		return
	if(stat == CONSCIOUS)
		if(on_fire || buckled || restrained() || (!CHECK_MOBILITY(src, MOBILITY_STAND) && CHECK_MOBILITY(src, MOBILITY_MOVE))) //CIT CHANGE - makes it so monkeys attempt to resist if they're resting)
			if(!resisting && prob(MONKEY_RESIST_PROB))
				resisting = TRUE
				walk_to(src,0)
				resist()
		else if(resisting)
			resisting = FALSE
		else if((mode == MONKEY_IDLE && !pickupTarget && !prob(MONKEY_SHENANIGAN_PROB)) || !handle_combat())
			if(prob(25) && CHECK_MOBILITY(src, MOBILITY_MOVE) && isturf(loc) && !pulledby)
				step(src, pick(GLOB.cardinals))
			else if(prob(1))
				emote(pick("scratch","jump","roll","tail"))
	else
		walk_to(src,0)

/mob/living/carbon/monkey/handle_mutations_and_radiation()
	if(radiation)
		if(radiation > RAD_MONKEY_GORILLIZE)
			if(prob((((radiation - RAD_MONKEY_GORILLIZE + RAD_MOB_GORILLIZE_FACTOR)/RAD_MOB_GORILLIZE_FACTOR)^RAD_MONKEY_GORILLIZE_EXPONENT) - 1))
				gorillize()
				return
		if(radiation > RAD_MOB_KNOCKDOWN && prob(RAD_MOB_KNOCKDOWN_PROB))
			if(!(combat_flags & COMBAT_FLAG_HARD_STAMCRIT))
				emote("collapse")
			DefaultCombatKnockdown(RAD_MOB_KNOCKDOWN_AMOUNT)
			to_chat(src, "<span class='danger'>You feel weak.</span>")
		if(radiation > RAD_MOB_MUTATE)
			if(prob(1))
				to_chat(src, "<span class='danger'>You mutate!</span>")
				easy_randmut(NEGATIVE+MINOR_NEGATIVE)
				emote("gasp")
				domutcheck()
		if(radiation > RAD_MOB_VOMIT && prob(RAD_MOB_VOMIT_PROB))
			vomit(10, TRUE)
	return ..()

/mob/living/carbon/monkey/handle_breath_temperature(datum/gas_mixture/breath)
	if(abs(BODYTEMP_NORMAL - breath.return_temperature()) > 50)
		switch(breath.return_temperature())
			if(-INFINITY to 120)
				adjustFireLoss(3)
			if(120 to 200)
				adjustFireLoss(1.5)
			if(200 to 260)
				adjustFireLoss(0.5)
			if(360 to 400)
				adjustFireLoss(2)
			if(400 to 1000)
				adjustFireLoss(3)
			if(1000 to INFINITY)
				adjustFireLoss(8)

/mob/living/carbon/monkey/handle_environment(datum/gas_mixture/environment)
	if(!environment)
		return
	if(istype(loc, /obj/machinery/atmospherics/components/unary/cryo_cell))
		return

	var/loc_temp = get_temperature(environment)
	var/thermal_protection = get_thermal_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.

	var/temp_variation = (loc_temp - bodytemperature)*thermal_protection
	//Body temperature is adjusted in two parts: first there your body tries to naturally preserve homeostasis (shivering/sweating), then it reacts to the surrounding environment
	//Thermal protection (insulation) has mixed benefits in two situations (hot in hot places, cold in hot places)
	if(!on_fire) //If you're on fire, you do not heat up or cool down based on surrounding gases
		var/natural = 0
		if(stat != DEAD)
			natural = natural_bodytemperature_stabilization()

		var/heat_capacity = heat_capacity()
		if(natural)
			if(bodytemperature < bodytemp_normal)
				var/delta = (thermal_protection+1)*natural
				bodytemperature += delta
				adjust_nutrition(delta*-0.01)
			else
				var/delta = natural*(1-thermal_protection)
				var/sweat_made = (approx_heat_capacity*delta)/(initial(sweat_gas.specific_heat)*bodytemperature)
				var/max_vapor_capacity = (environment.return_volume())/(environment.return_temperature()*R_IDEAL_GAS_EQUATION)
				// implicit 1* at the start there--i'm just using "1 kilopascal partial pressure" for this
				var/original_sweat_made = sweat_made
				sweat_made = min(sweat_made,(sweat_made+environment.get_moles(sweat_gas))-max_vapor_capacity)
				bodytemperature += delta * (original_sweat_made/sweat_made)
				if(sweat_made > 0.0000001)
					var/datum/gas_mixture/sweat = new
					sweat.set_moles(sweat_gas,sweat_made)
					sweat.set_temperature(bodytemperature)
					environment.merge(sweat)
					nutrition -= sweat_made
		bodytemperature = environment.temperature_share(null,(1-thermal_protection)*0.1,bodytemperature,approx_heat_capacity)
		var/temp_good = TRUE
		switch(temp_variation)
			if(-INFINITY to cold_damage_limit)
				throw_alert("tempfeel", /obj/screen/alert/cold, 3)
				if(!HAS_TRAIT(H,TRAIT_RESISTCOLD))
					switch(temp_variation)
						if(BODYTEMP_COLD_DAMAGE_LIMIT*2 to BODYTEMP_COLD_DAMAGE_LIMIT)
							apply_damage(COLD_DAMAGE_LEVEL_1*coldmod*physiology.cold_mod, BURN)
						if(BODYTEMP_COLD_DAMAGE_LIMIT*3 to BODYTEMP_COLD_DAMAGE_LIMIT*2)
							apply_damage(COLD_DAMAGE_LEVEL_2*coldmod*physiology.cold_mod, BURN)
						else
							apply_damage(COLD_DAMAGE_LEVEL_3*coldmod*physiology.cold_mod, BURN)
			if(cold_damage_limit to cold_damage_limit*0.7)
				throw_alert("tempfeel", /obj/screen/alert/cold, 2)
			if(cold_damage_limit*0.7 to cold_damage_limit*0.4)
				throw_alert("tempfeel", /obj/screen/alert/cold, 1)
			if(cold_damage_limit*0.4 to 0) //This is the sweet spot where air is considered normal
				clear_alert("tempfeel")
			if(0 to heat_damage_limit*0.5) //When the air around you matches your body's temperature, you'll start to feel warm.
				throw_alert("tempfeel", /obj/screen/alert/hot, 1)
			if(heat_damage_limit*0.5 to heat_damage_limit)
				throw_alert("tempfeel", /obj/screen/alert/hot, 2)
			if(heat_damage_limit to INFINITY)
				throw_alert("tempfeel", /obj/screen/alert/hot, 3)
				if(!!HAS_TRAIT(H, TRAIT_RESISTHEAT))
					SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "cold")
					SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "hot", /datum/mood_event/hot)

					remove_movespeed_modifier(/datum/movespeed_modifier/cold)

					var/burn_damage
					var/firemodifier = fire_stacks / 50
					if (on_fire)
						burn_damage = max(log(2-firemodifier,temp_variation)-5,0)
					else
						firemodifier = min(firemodifier, 0)
						burn_damage = max(log(2-firemodifier,temp_variation)-5,0) // this can go below 5 at log 2.5
					burn_damage = burn_damage * heatmod * physiology.heat_mod
					if (stat < UNCONSCIOUS && (prob(burn_damage) * 10) / 4) //40% for level 3 damage on humans
						emote("scream")
					apply_damage(burn_damage, BURN)

	if(bodytemperature > hyperthermia_limit)
		var/severity = 1+((bodytemperature - hyperthermia_limit) / (hyperthermia_limit - bodytemp_normal))
		switch(severity)
			if(0 to 1)
				throw_alert("temp", /obj/screen/alert/sweat, 1)
			if(1 to 2)
				throw_alert("temp", /obj/screen/alert/sweat, 2)
			else
				throw_alert("temp", /obj/screen/alert/sweat, 3)
		if(prob(severity*50))
			confused += 5
		if(prob(severity*50))
			hallucination += 5
		if(prob(severity*20))
			vomiting += 5
		for(var/obj/item/organ/O in internal_organs)
			if(!(O?.status_flags & GODMODE) || !prob(severity*50))
				continue
			var/maximum = O.maxHealth
			O.applyOrganDamage(severity, maximum)
			O.onDamage(severity, maximum)
	else if(body_temperature < hypothermia_limit)
		var/severity = 1+((hypothermia_limit - bodytemperature) / (bodytemp_normal - hypothermia_limit))
		switch(severity)
			if(0 to 1)
				throw_alert("temp", /obj/screen/alert/shiver, 1)
			if(1 to 2)
				throw_alert("temp", /obj/screen/alert/shiver, 2)
			else
				throw_alert("temp", /obj/screen/alert/shiver, 3)
		if(prob(severity*100))
			hallucination += 5
		if(prob(severity*50))
			confused += 5
		if(prob(severity*30))
			applyOrganDamage(ORGAN_SLOT_LIVER,5)
		if(prob(severity*5))
			applyOrganDamage(ORGAN_SLOT_HEART,10)
		//Apply cold slowdown
		add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/cold, multiplicative_slowdown = ((cold_damage_limit - bodytemperature) / COLD_SLOWDOWN_FACTOR))
	else
		clear_alert("temp")

	//Account for massive pressure differences

	var/pressure = environment.return_pressure()
	var/adjusted_pressure = calculate_affecting_pressure(pressure) //Returns how much pressure actually affects the mob.
	switch(adjusted_pressure)
		if(HAZARD_HIGH_PRESSURE to INFINITY)
			adjustBruteLoss( min( ( (adjusted_pressure / HAZARD_HIGH_PRESSURE) -1 )*PRESSURE_DAMAGE_COEFFICIENT , MAX_HIGH_PRESSURE_DAMAGE) )
			throw_alert("pressure", /obj/screen/alert/highpressure, 2)
		if(WARNING_HIGH_PRESSURE to HAZARD_HIGH_PRESSURE)
			throw_alert("pressure", /obj/screen/alert/highpressure, 1)
		if(WARNING_LOW_PRESSURE to WARNING_HIGH_PRESSURE)
			clear_alert("pressure")
		if(HAZARD_LOW_PRESSURE to WARNING_LOW_PRESSURE)
			throw_alert("pressure", /obj/screen/alert/lowpressure, 1)
		else
			adjustBruteLoss( LOW_PRESSURE_DAMAGE )
			throw_alert("pressure", /obj/screen/alert/lowpressure, 2)

/mob/living/carbon/monkey/handle_random_events()
	if (prob(1) && prob(2))
		emote("scratch")

/mob/living/carbon/monkey/has_smoke_protection()
	if(wear_mask)
		if(wear_mask.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return 1

/mob/living/carbon/monkey/handle_fire()
	. = ..()
	if(on_fire)

		//the fire tries to damage the exposed clothes and items
		var/list/burning_items = list()
		//HEAD//
		var/obj/item/clothing/head_clothes = null
		if(wear_mask)
			head_clothes = wear_mask
		if(wear_neck)
			head_clothes = wear_neck
		if(head)
			head_clothes = head
		if(head_clothes)
			burning_items += head_clothes

		if(back)
			burning_items += back

		for(var/X in burning_items)
			var/obj/item/I = X
			if(!(I.resistance_flags & FIRE_PROOF))
				I.take_damage(fire_stacks, BURN, "fire", 0)

		adjust_bodytemperature(BODYTEMP_HEATING_MAX)
		adjustFireLoss(2)
		SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "on_fire", /datum/mood_event/on_fire)
