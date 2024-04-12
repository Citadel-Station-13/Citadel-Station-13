#define LUNGS_MAX_HEALTH 300

/obj/item/organ/lungs
	name = "lungs"
	desc = "Looking at them makes you start manual breathing."
	icon_state = "lungs"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_LUNGS
	gender = PLURAL
	w_class = WEIGHT_CLASS_NORMAL

	var/failed = FALSE
	var/operated = FALSE	//whether we can still have our damages fixed through surgery

	//health
	maxHealth = 3 * STANDARD_ORGAN_THRESHOLD

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY
	high_threshold = 0.6 * LUNGS_MAX_HEALTH	//threshold at 180
	low_threshold = 0.3 * LUNGS_MAX_HEALTH	//threshold at 90

	high_threshold_passed = "<span class='warning'>You feel some sort of constriction around your chest as your breathing becomes shallow and rapid.</span>"
	now_fixed = "<span class='warning'>Your lungs seem to once again be able to hold air.</span>"
	high_threshold_cleared = "<span class='info'>The constriction around your chest loosens as your breathing calms down.</span>"

	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/medicine/salbutamol = 5)

	//Breath damage
	var/breathing_class = BREATH_OXY // can be a gas instead of a breathing class
	var/safe_breath_min = 16
	var/safe_breath_max = 50
	var/safe_breath_dam_min = MIN_TOXIC_GAS_DAMAGE
	var/safe_breath_dam_max = MAX_TOXIC_GAS_DAMAGE
	var/safe_damage_type = OXY
	var/list/gas_min = list()
	var/list/gas_max = list(
		GAS_CO2 = 30, // Yes it's an arbitrary value who cares?
		GAS_METHYL_BROMIDE = 1,
		GAS_PLASMA = MOLES_GAS_VISIBLE
	)
	var/list/gas_damage = list(
		"default" = list(
			min = MIN_TOXIC_GAS_DAMAGE,
			max = MAX_TOXIC_GAS_DAMAGE,
			damage_type = OXY
		),
		GAS_PLASMA = list(
			min = MIN_TOXIC_GAS_DAMAGE,
			max = MAX_TOXIC_GAS_DAMAGE,
			damage_type = TOX
		)
	)

	var/SA_para_min = 1 //nitrous values
	var/SA_sleep_min = 5
	var/BZ_trip_balls_min = 0.1 //BZ gas
	var/BZ_brain_damage_min = 1
	var/gas_stimulation_min = 0.002 //Nitryl and Stimulum

	var/cold_message = "your face freezing and an icicle forming"
	var/cold_level_1_threshold = 260
	var/cold_level_2_threshold = 200
	var/cold_level_3_threshold = 120
	var/cold_level_1_damage = COLD_GAS_DAMAGE_LEVEL_1 //Keep in mind with gas damage levels, you can set these to be negative, if you want someone to heal, instead.
	var/cold_level_2_damage = COLD_GAS_DAMAGE_LEVEL_2
	var/cold_level_3_damage = COLD_GAS_DAMAGE_LEVEL_3
	var/cold_damage_type = BURN

	var/hot_message = "your face burning and a searing heat"
	var/heat_level_1_threshold = 360
	var/heat_level_2_threshold = 400
	var/heat_level_3_threshold = 1000
	var/heat_level_1_damage = HEAT_GAS_DAMAGE_LEVEL_1
	var/heat_level_2_damage = HEAT_GAS_DAMAGE_LEVEL_2
	var/heat_level_3_damage = HEAT_GAS_DAMAGE_LEVEL_3
	var/heat_damage_type = BURN

	var/smell_sensitivity = 1

	var/crit_stabilizing_reagent = /datum/reagent/medicine/epinephrine

/obj/item/organ/lungs/New()
	. = ..()
	populate_gas_info()

/obj/item/organ/lungs/proc/populate_gas_info()
	gas_min[breathing_class] = safe_breath_min
	gas_max[breathing_class] = safe_breath_max
	gas_damage[breathing_class] = list(
		min = safe_breath_dam_min,
		max = safe_breath_dam_max,
		damage_type = safe_damage_type
	)
	if(ispath(breathing_class))
		var/datum/breathing_class/class = GLOB.gas_data.breathing_classes[breathing_class]
		for(var/g in class.gases)
			if(class.gases[g] > 0)
				gas_min -= g

//TODO: lung health affects lung function
/obj/item/organ/lungs/onDamage(damage_mod) //damage might be too low atm.
	var/cached_damage = damage
	if (maxHealth == INFINITY)
		return
	if(cached_damage+damage_mod < 0)
		cached_damage = 0
		return

	cached_damage += damage_mod
	if ((cached_damage/ maxHealth) > 1)
		to_chat(owner, "<span class='userdanger'>You feel your lungs collapse within your chest as you gasp for air, unable to inflate them anymore!</span>")
		owner.emote("gasp")
		SSblackbox.record_feedback("tally", "fermi_chem", 1, "Lungs lost")
		//qdel(src) - Handled elsewhere for now.
	else if ((cached_damage / maxHealth) > 0.75)
		to_chat(owner, "<span class='warning'>It's getting really hard to breathe!!</span>")
		owner.emote("gasp")
		owner.Dizzy(3)
	else if ((cached_damage / maxHealth) > 0.5)
		owner.Dizzy(2)
		to_chat(owner, "<span class='notice'>Your chest is really starting to hurt.</span>")
		owner.emote("cough")
	else if ((cached_damage / maxHealth) > 0.2)
		to_chat(owner, "<span class='notice'>You feel an ache within your chest.</span>")
		owner.emote("cough")
		owner.Dizzy(1)

/obj/item/organ/lungs/proc/check_breath(datum/gas_mixture/breath, mob/living/carbon/human/H)
//TODO: add lung damage = less oxygen gains
	var/breathModifier = (5-(5*(damage/maxHealth)/2)) //range 2.5 - 5
	if((H.status_flags & GODMODE))
		return
	if(HAS_TRAIT(H, TRAIT_NOBREATH))
		return

	if(!breath || (breath.total_moles() == 0))
		if(H.reagents.has_reagent(crit_stabilizing_reagent))
			return
		if(H.health >= H.crit_threshold)
			H.adjustOxyLoss(HUMAN_MAX_OXYLOSS)
		else if(!HAS_TRAIT(H, TRAIT_NOCRITDAMAGE))
			H.adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)

		H.failed_last_breath = TRUE
		var/alert_category
		var/alert_type
		if(ispath(breathing_class))
			var/datum/breathing_class/class = GLOB.gas_data.breathing_classes[breathing_class]
			alert_category = class.low_alert_category
			alert_type = class.low_alert_datum
		else
			var/list/breath_alert_info = GLOB.gas_data.breath_alert_info
			if(breathing_class in breath_alert_info)
				var/list/alert = breath_alert_info[breathing_class]["not_enough_alert"]
				alert_category = alert["alert_category"]
				alert_type = alert["alert_type"]
		if(alert_category)
			H.throw_alert(alert_category, alert_type)
		return FALSE

	#define PP_MOLES(X) ((X / total_moles) * pressure)

	#define PP(air, gas) PP_MOLES(air.get_moles(gas))

	var/gas_breathed = 0

	var/pressure = breath.return_pressure()
	var/total_moles = breath.total_moles()
	var/list/breath_alert_info = GLOB.gas_data.breath_alert_info
	var/list/breath_results = GLOB.gas_data.breath_results
	var/list/breathing_classes = GLOB.gas_data.breathing_classes
	var/list/mole_adjustments = list()
	for(var/entry in gas_min)
		var/required_pp = 0
		var/required_moles = 0
		var/safe_min = gas_min[entry]
		var/alert_category = null
		var/alert_type = null
		if(ispath(entry))
			var/datum/breathing_class/class = breathing_classes[entry]
			var/list/gases = class.gases
			var/list/products = class.products
			alert_category = class.low_alert_category
			alert_type = class.low_alert_datum
			for(var/gas in gases)
				var/moles = breath.get_moles(gas)
				var/multiplier = gases[gas]
				mole_adjustments[gas] = (gas in mole_adjustments) ? mole_adjustments[gas] - moles : -moles
				required_pp += PP_MOLES(moles) * multiplier
				required_moles += moles
				if(multiplier > 0)
					var/to_add = moles * multiplier
					for(var/product in products)
						mole_adjustments[product] = (product in mole_adjustments) ? mole_adjustments[product] + to_add : to_add
		else
			required_moles = breath.get_moles(entry)
			required_pp = PP_MOLES(required_moles)
			if(entry in breath_alert_info)
				var/list/alert = breath_alert_info[entry]["not_enough_alert"]
				alert_category = alert["alert_category"]
				alert_type = alert["alert_type"]
			mole_adjustments[entry] = -required_moles
			mole_adjustments[breath_results[entry]] = required_moles
		if(required_pp < safe_min)
			var/multiplier = handle_too_little_breath(H, required_pp, safe_min, required_moles)
			if(required_moles > 0)
				multiplier /= required_moles
			for(var/adjustment in mole_adjustments)
				mole_adjustments[adjustment] *= multiplier
			if(alert_category)
				H.throw_alert(alert_category, alert_type)
		else
			H.failed_last_breath = FALSE
			if(H.health >= H.crit_threshold)
				H.adjustOxyLoss(-breathModifier)
			if(alert_category)
				H.clear_alert(alert_category)
	var/list/danger_reagents = GLOB.gas_data.breath_reagents_dangerous
	for(var/entry in gas_max)
		var/found_pp = 0
		var/datum/breathing_class/breathing_class = entry
		var/datum/reagent/danger_reagent = null
		var/alert_category = null
		var/alert_type = null
		if(ispath(breathing_class))
			breathing_class = breathing_classes[breathing_class]
			alert_category = breathing_class.high_alert_category
			alert_type = breathing_class.high_alert_datum
			danger_reagent = breathing_class.danger_reagent
			found_pp = breathing_class.get_effective_pp(breath)
		else
			danger_reagent = danger_reagents[entry]
			if(entry in breath_alert_info)
				var/list/alert = breath_alert_info[entry]["too_much_alert"]
				alert_category = alert["alert_category"]
				alert_type = alert["alert_type"]
			found_pp = PP(breath, entry)
		if(found_pp > gas_max[entry])
			if(istype(danger_reagent))
				H.reagents.add_reagent(danger_reagent,1)
			var/list/damage_info = (entry in gas_damage) ? gas_damage[entry] : gas_damage["default"]
			var/dam = found_pp / gas_max[entry] * 10
			H.apply_damage_type(clamp(dam, damage_info["min"], damage_info["max"]), damage_info["damage_type"])
			if(alert_category && alert_type)
				H.throw_alert(alert_category, alert_type)
		else if(alert_category)
			H.clear_alert(alert_category)
	var/list/breath_reagents = GLOB.gas_data.breath_reagents
	var/static/datum/reagents/reagents_holder = new
	reagents_holder.clear_reagents()
	reagents_holder.chem_temp = breath.return_temperature()
	for(var/gas in breath.get_gases())
		if(gas in breath_reagents)
			var/datum/reagent/R = breath_reagents[gas]
			reagents_holder.add_reagent(R, breath.get_moles(gas) * initial(R.molarity))
			mole_adjustments[gas] = (gas in mole_adjustments) ? mole_adjustments[gas] - breath.get_moles(gas) : -breath.get_moles(gas)
	reagents_holder.reaction(H, VAPOR, from_gas = 1)
	H.smell(breath)
	for(var/gas in mole_adjustments)
		breath.adjust_moles(gas, mole_adjustments[gas])

	if(breath)	// If there's some other shit in the air lets deal with it here.

	// N2O

		var/SA_pp = PP(breath, GAS_NITROUS)
		if(SA_pp > SA_para_min) // Enough to make us stunned for a bit
			H.Unconscious(60) // 60 gives them one second to wake up and run away a bit!
			if(SA_pp > SA_sleep_min) // Enough to make us sleep as well
				H.Sleeping(max(H.AmountSleeping() + 40, 200))
		else if(SA_pp > 0.01)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
			if(prob(20))
				H.emote(pick("giggle", "laugh"))
				SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "chemical_euphoria", /datum/mood_event/chemical_euphoria)
		else
			SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "chemical_euphoria")

	// BZ

		var/bz_pp = PP(breath, GAS_BZ)
		if(bz_pp > BZ_brain_damage_min)
			H.hallucination += 10
			H.reagents.add_reagent(/datum/reagent/bz_metabolites,5)
			if(prob(33))
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3, 150)

		else if(bz_pp > BZ_trip_balls_min)
			H.hallucination += 5
			H.reagents.add_reagent(/datum/reagent/bz_metabolites,1)

	// Nitryl
		var/nitryl_pp = PP(breath,GAS_NITRYL)
		if (prob(nitryl_pp))
			to_chat(H, "<span class='alert'>Your mouth feels like it's burning!</span>")
		if (nitryl_pp >40)
			H.emote("gasp")
			H.adjustFireLoss(10)
			if (prob(nitryl_pp/2))
				to_chat(H, "<span class='alert'>Your throat closes up!</span>")
				H.silent = max(H.silent, 3)
		else
			H.adjustFireLoss(nitryl_pp/2)
		gas_breathed = breath.get_moles(GAS_NITRYL)
		if (gas_breathed > gas_stimulation_min)
			H.reagents.add_reagent(/datum/reagent/nitryl,1)

		breath.adjust_moles(GAS_NITRYL, -gas_breathed)

	// Stimulum
		gas_breathed = PP(breath,GAS_STIMULUM)
		if (gas_breathed > gas_stimulation_min)
			var/existing = H.reagents.get_reagent_amount(/datum/reagent/stimulum)
			H.reagents.add_reagent(/datum/reagent/stimulum, max(0, 5 - existing))
		breath.adjust_moles(GAS_STIMULUM, -gas_breathed)

	// Miasma
		if (breath.get_moles(GAS_MIASMA))
			var/miasma_pp = PP(breath,GAS_MIASMA)
			if(miasma_pp > MINIMUM_MOLES_DELTA_TO_MOVE)

				//Miasma sickness
				if(prob(0.05 * miasma_pp))
					var/datum/disease/advance/miasma_disease = new /datum/disease/advance/random(TRUE, 2,3)
					miasma_disease.name = "Unknown"
					miasma_disease.try_infect(owner)

				// Miasma side effects
				switch(miasma_pp)
					if(1 to 5)
						// At lower pp, give out a little warning
						SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "smell")
						if(prob(5))
							to_chat(owner, "<span class='notice'>There is an unpleasant smell in the air.</span>")
					if(5 to 15)
						//At somewhat higher pp, warning becomes more obvious
						if(prob(15))
							to_chat(owner, "<span class='warning'>You smell something horribly decayed inside this room.</span>")
							SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "smell", /datum/mood_event/disgust/bad_smell)
					if(15 to 30)
						//Small chance to vomit. By now, people have internals on anyway
						if(prob(5))
							to_chat(owner, "<span class='warning'>The stench of rotting carcasses is unbearable!</span>")
							SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "smell", /datum/mood_event/disgust/nauseating_stench)
							owner.vomit()
					if(30 to INFINITY)
						//Higher chance to vomit. Let the horror start
						if(prob(15))
							to_chat(owner, "<span class='warning'>The stench of rotting carcasses is unbearable!</span>")
							SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "smell", /datum/mood_event/disgust/nauseating_stench)
							owner.vomit()
					else
						SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "smell")

				// In a full miasma atmosphere with 101.34 pKa, about 10 disgust per breath, is pretty low compared to threshholds
				// Then again, this is a purely hypothetical scenario and hardly reachable
				owner.adjust_disgust(0.1 * miasma_pp)

				breath.adjust_moles(GAS_MIASMA, -gas_breathed)

		// Clear out moods when no miasma at all
		else
			SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "smell")

		handle_breath_temperature(breath, H)
	return TRUE


/obj/item/organ/lungs/proc/handle_too_little_breath(mob/living/carbon/human/H = null, breath_pp = 0, safe_breath_min = 0, true_pp = 0)
	. = 0
	if(!H || !safe_breath_min) //the other args are either: Ok being 0 or Specifically handled.
		return FALSE

	if(prob(20))
		H.emote("gasp")
	if(breath_pp > 0)
		var/ratio = safe_breath_min/breath_pp
		H.adjustOxyLoss(min(5*ratio, HUMAN_MAX_OXYLOSS)) // Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS after all!
		H.failed_last_breath = TRUE
		. = true_pp*ratio/6
	else
		H.adjustOxyLoss(HUMAN_MAX_OXYLOSS)
		H.failed_last_breath = TRUE


/obj/item/organ/lungs/proc/handle_breath_temperature(datum/gas_mixture/breath, mob/living/carbon/human/H) // called by human/life, handles temperatures
	var/breath_temperature = breath.return_temperature()

	if(!HAS_TRAIT(H, TRAIT_RESISTCOLD)) // COLD DAMAGE
		var/cold_modifier = H.dna.species.coldmod
		if(breath_temperature < cold_level_3_threshold)
			H.apply_damage_type(cold_level_3_damage*cold_modifier, cold_damage_type)
			H.adjustOrganLoss(ORGAN_SLOT_LUNGS, (cold_level_3_damage*cold_modifier*2))
		if(breath_temperature > cold_level_3_threshold && breath_temperature < cold_level_2_threshold)
			H.apply_damage_type(cold_level_2_damage*cold_modifier, cold_damage_type)
			H.adjustOrganLoss(ORGAN_SLOT_LUNGS, (cold_level_2_damage*cold_modifier*2))
		if(breath_temperature > cold_level_2_threshold && breath_temperature < cold_level_1_threshold)
			H.apply_damage_type(cold_level_1_damage*cold_modifier, cold_damage_type)
			H.adjustOrganLoss(ORGAN_SLOT_LUNGS, (cold_level_1_damage*cold_modifier*2))
		if(breath_temperature < cold_level_1_threshold)
			if(prob(20))
				to_chat(H, "<span class='warning'>You feel [cold_message] in your [name]!</span>")

	if(!HAS_TRAIT(H, TRAIT_RESISTHEAT)) // HEAT DAMAGE
		var/heat_modifier = H.dna.species.heatmod
		if(breath_temperature > heat_level_1_threshold && breath_temperature < heat_level_2_threshold)
			H.apply_damage_type(heat_level_1_damage*heat_modifier, heat_damage_type)
			H.adjustOrganLoss(ORGAN_SLOT_LUNGS, (heat_level_1_damage*heat_modifier*2))
		if(breath_temperature > heat_level_2_threshold && breath_temperature < heat_level_3_threshold)
			H.apply_damage_type(heat_level_2_damage*heat_modifier, heat_damage_type)
			H.adjustOrganLoss(ORGAN_SLOT_LUNGS, (heat_level_2_damage*heat_modifier*2))
		if(breath_temperature > heat_level_3_threshold)
			H.apply_damage_type(heat_level_3_damage*heat_modifier, heat_damage_type)
			H.adjustOrganLoss(ORGAN_SLOT_LUNGS, (heat_level_3_damage*heat_modifier*2))
		if(breath_temperature > heat_level_1_threshold)
			if(prob(20))
				to_chat(H, "<span class='warning'>You feel [hot_message] in your [name]!</span>")

/obj/item/organ/lungs/applyOrganDamage(d, maximum = maxHealth)
	. = ..()
	if(!.)
		return
	if(!failed && organ_flags & ORGAN_FAILING)
		if(owner && owner.stat == CONSCIOUS && !HAS_TRAIT(owner, TRAIT_NOBREATH))
			owner.visible_message("<span class='danger'>[owner] grabs [owner.p_their()] throat, struggling for breath!</span>", \
								"<span class='userdanger'>You suddenly feel like you can't breathe!</span>")
		failed = TRUE
	else if(!(organ_flags & ORGAN_FAILING))
		failed = FALSE

/obj/item/organ/lungs/ipc
	name = "ipc cooling system"
	icon_state = "lungs-c"
	var/is_cooling = 0
	var/cooling_coolant_drain = 5	//Coolant (blood) use per tick of active cooling.
	var/next_warn = BLOOD_VOLUME_NORMAL
	actions_types = list(/datum/action/item_action/organ_action/toggle)

/obj/item/organ/lungs/ipc/emp_act(severity) //Should probably put it somewhere else later
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	to_chat(owner, "<span class='warning'>Alert: Critical cooling system failure!</span>")
	switch(severity)
		if(1 to 50)
			owner.adjust_bodytemperature(30*TEMPERATURE_DAMAGE_COEFFICIENT)
		if(50 to INFINITY)
			owner.adjust_bodytemperature(100*TEMPERATURE_DAMAGE_COEFFICIENT)

/obj/item/organ/lungs/ipc/ui_action_click(mob/user, actiontype)
	if(!owner)
		return
	if(!HAS_TRAIT(user, TRAIT_ROBOTIC_ORGANISM))
		to_chat(user, "<span class='notice'>Biotype incompatible with cooling system. Activation signal suppressed.</span>")
		return
	if(!is_cooling && owner.blood_volume < cooling_coolant_drain)
		to_chat(user, "<span class='warning'>Coolant levels insufficient to enable active cooling - Replenish immediately.</span>")
		return

	is_cooling = !is_cooling
	to_chat(user, "<span class='notice'>Active cooling [is_cooling ? "enabled" : "disabled"] - current coolant level: [round(owner.blood_volume / BLOOD_VOLUME_NORMAL * 100, 0.1)] percent.</span>")
	var/possible_next_warn = owner.blood_volume - (BLOOD_VOLUME_NORMAL * 0.1)
	if(possible_next_warn > next_warn)
		next_warn = possible_next_warn	//If we recovered blood inbetween activations, update warning

/obj/item/organ/lungs/ipc/on_life(seconds, times_fired)
	. = ..()
	if(!.)
		if(is_cooling)
			to_chat(owner, "<span class='warning'>Cooling system safeguards triggered - active cooling aborted.</span>")
			is_cooling = 0
		return
	if(!is_cooling)
		return
	if(!HAS_TRAIT(owner, TRAIT_ROBOTIC_ORGANISM))
		to_chat(owner, "<span class='warning'>Biotype incompatible with cooling system. Commencing emergency shutdown.</span>")
		is_cooling = 0
		return
	if(owner.stat >= SOFT_CRIT)
		to_chat(owner, "<span class='warning'>Operating system ping returned null response - Shutting down active cooling to avoid component damage.</span>")
		is_cooling = 0
		return
	if(owner.blood_volume < cooling_coolant_drain)
		to_chat(owner, "<span class='warning'>Coolant levels insufficient to maintain active cooling - Replenish immediately.</span>")
		is_cooling = 0
		return
	if(abs(owner.bodytemperature - T20C) < SYNTH_ACTIVE_COOLING_TEMP_BOUNDARY)
		return	//Does not drain coolant (blood) nor do anything if we are close enough to room temp.
	var/cooling_efficiency =  owner.get_cooling_efficiency()
	var/actual_drain = cooling_coolant_drain * max(1 - cooling_efficiency, 0.2)	//Being in a suitable environment reduces drain by up to 80%
	var/temp_diff = owner.bodytemperature - T20C
	if(temp_diff > 0)
		owner.adjust_bodytemperature(clamp(((T0C - owner.bodytemperature) * max(cooling_efficiency, 0.5) / BODYTEMP_COLD_DIVISOR), BODYTEMP_COOLING_MAX, -SYNTH_ACTIVE_COOLING_MIN_ADJUSTMENT))
	else
		owner.adjust_bodytemperature(clamp(((T20C - owner.bodytemperature) * max(cooling_efficiency, 0.5) / BODYTEMP_HEAT_DIVISOR), SYNTH_ACTIVE_COOLING_MIN_ADJUSTMENT, BODYTEMP_HEATING_MAX))
	var/datum/gas_mixture/air = owner.loc.return_air()
	if(!air || air.return_pressure() < ONE_ATMOSPHERE * SYNTH_ACTIVE_COOLING_LOW_PRESSURE_THRESHOLD)
		actual_drain *= SYNTH_ACTIVE_COOLING_LOW_PRESSURE_PENALTY	//Our cooling system can handle hot places okayish, but starts to cry at low pressures (reads: Effectively vents hot coolant thats been warmed up via internal heat-exchange as emergency measure and with very low efficiency)
	owner.blood_volume = max(owner.blood_volume - actual_drain, 0)
	if(owner.blood_volume <= next_warn)
		to_chat(owner, "[owner.blood_volume > BLOOD_VOLUME_BAD ? "<span class='notice'>" : "<span class='warning'>"]Coolant level passed threshold - now [round(owner.blood_volume / BLOOD_VOLUME_NORMAL * 100, 0.1)] percent.</span>")
		next_warn -= (BLOOD_VOLUME_NORMAL * 0.1)

/obj/item/organ/lungs/plasmaman
	name = "plasma filter"
	desc = "A spongy rib-shaped mass for filtering plasma from the air."
	icon_state = "lungs-plasma"
	breathing_class = BREATH_PLASMA
	maxHealth = INFINITY//I don't understand how plamamen work, so I'm not going to try t give them special lungs atm

/obj/item/organ/lungs/plasmaman/populate_gas_info()
	..()
	gas_max -= GAS_PLASMA

/obj/item/organ/lungs/cybernetic
	name = "basic cybernetic lungs"
	desc = "A basic cybernetic version of the lungs found in traditional humanoid entities."
	icon_state = "lungs-c"
	organ_flags = ORGAN_SYNTHETIC
	maxHealth = STANDARD_ORGAN_THRESHOLD * 0.5

	var/emp_vulnerability = 1 //The value the severity of emps are divided by to determine the likelihood of permanent damage.

/obj/item/organ/lungs/cybernetic/tier2
	name = "cybernetic lungs"
	desc = "A cybernetic version of the lungs found in traditional humanoid entities. Allows for greater intakes of oxygen than organic lungs, requiring slightly less pressure."
	icon_state = "lungs-c-u"
	maxHealth = 1.5 * STANDARD_ORGAN_THRESHOLD
	safe_breath_min = 13
	safe_breath_max = 100
	emp_vulnerability = 2
	smell_sensitivity = 1.5

/obj/item/organ/lungs/cybernetic/tier3
	name = "upgraded cybernetic lungs"
	desc = "A more advanced version of the stock cybernetic lungs. Features the ability to filter out various airbourne toxins and carbon dioxide even at heavy levels."
	icon_state = "lungs-c-u2"
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	safe_breath_min = 4 //You could literally be breathing the thinnest amount of oxygen and be fine
	safe_breath_max = 250 //Or be in an enriched oxygen room for that matter
	gas_max = list(
		GAS_PLASMA = 30,
		GAS_CO2 = 30,
		GAS_METHYL_BROMIDE = 10
	)
	SA_para_min = 30
	SA_sleep_min = 50
	BZ_brain_damage_min = 30
	emp_vulnerability = 3
	smell_sensitivity = 2

	cold_level_1_threshold = 200
	cold_level_2_threshold = 140
	cold_level_3_threshold = 100
	maxHealth = 550

/obj/item/organ/lungs/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!COOLDOWN_FINISHED(src, severe_cooldown)) //So we cant just spam emp to kill people.
		owner.losebreath += 20
		COOLDOWN_START(src, severe_cooldown, 30 SECONDS)
	if(prob(severity/emp_vulnerability)) //Chance of permanent effects
		organ_flags |= ORGAN_SYNTHETIC_EMP //Starts organ faliure - gonna need replacing soon.

/obj/item/organ/lungs/ashwalker
	name = "ash lungs"
	desc = "blackened lungs identical from specimens recovered from lavaland, unsuited to higher air pressures."
	icon_state = "lungs-ll"
	safe_breath_min = 3 //able to handle much thinner oxygen, something something ash storm adaptation
	safe_breath_max = 18 // Air standards is 22kPa of O2, LL is 14kPa

	cold_level_1_threshold = 280 // Ash Lizards can't take the cold very well, station air is only just warm enough
	cold_level_2_threshold = 240
	cold_level_3_threshold = 200

	heat_level_1_threshold = 400 // better adapted for heat, obv. Lavaland standard is 300
	heat_level_2_threshold = 600 // up 200 from level 1, 1000 is silly but w/e for level 3

/obj/item/organ/lungs/ashwalker/populate_gas_info()
	// humans usually breathe 21 but require 16/17, so 80% - 1, which is more lenient but it's fine
	#define SAFE_THRESHOLD_RATIO 0.8
	var/datum/gas_mixture/breath = SSair.planetary[LAVALAND_DEFAULT_ATMOS] // y'all know
	if(breath.get_moles(GAS_METHANE) > 0.1)
		breathing_class = BREATH_METHANE
	var/pressure = breath.return_pressure()
	var/total_moles = breath.total_moles()
	for(var/id in breath.get_gases())
		var/this_pressure = PP(breath, id)
		if(id in gas_min)
			var/req_pressure = (this_pressure * SAFE_THRESHOLD_RATIO) - 1
			if(req_pressure > 0)
				gas_min[id] = req_pressure
			else
				gas_min -= id // if there's not even enough of the gas to register, we shouldn't need it
		if(id in gas_max)
			gas_max[id] += this_pressure
	var/bz = breath.get_moles(GAS_BZ) // snowflaked cause it's got special behavior, of course
	if(bz)
		BZ_trip_balls_min += bz
		BZ_brain_damage_min += bz

	gas_max[GAS_N2] = max(15, PP(breath, GAS_N2) + 3) // don't want ash lizards breathing on station; sometimes they might be able to, though
	var/datum/breathing_class/class = GLOB.gas_data.breathing_classes[breathing_class]
	var/o2_pp = class.get_effective_pp(breath)
	safe_breath_min = min(3, 0.3 * o2_pp)
	safe_breath_max = max(18, 1.3 * o2_pp + 1)
	..()
	#undef SAFE_THRESHOLD_RATIO

/obj/item/organ/lungs/slime
	name = "vacuole"
	icon_state = "lungs-s"
	desc = "A large organelle designed to store oxygen and other important gasses."

	cold_level_1_threshold = 285 // Remember when slimes used to be succeptable to cold? Well....
	cold_level_2_threshold = 260
	cold_level_3_threshold = 230

	maxHealth = 250

/obj/item/organ/lungs/ashwalker/populate_gas_info()
	..()
	gas_max -= GAS_PLASMA

/obj/item/organ/lungs/slime/check_breath(datum/gas_mixture/breath, mob/living/carbon/human/H)
	. = ..()
	if (breath)
		var/total_moles = breath.total_moles()
		var/pressure = breath.return_pressure()
		var/plasma_pp = PP(breath, GAS_PLASMA)
		owner.adjust_integration_blood(0.2 * plasma_pp) // 10/s when breathing literally nothing but plasma, which will suffocate you.

/obj/item/organ/lungs/yamerol
	name = "Yamerol lungs"
	desc = "A temporary pair of lungs made from self assembling yamerol molecules."
	maxHealth = 200
	color = "#68e83a"

/obj/item/organ/lungs/yamerol/on_life()
	. = ..()
	if(.)
		applyOrganDamage(2) //Yamerol lungs are temporary

#undef PP
#undef PP_MOLES
