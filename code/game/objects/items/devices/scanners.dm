
/*
CONTAINS:
T-RAY
DETECTIVE SCANNER
HEALTH ANALYZER
GAS ANALYZER
MASS SPECTROMETER

*/
/obj/item/device/t_scanner
	name = "\improper T-ray scanner"
	desc = "A terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	icon_state = "t-ray0"
	var/on = 0
	slot_flags = SLOT_BELT
	w_class = 2
	item_state = "electronic"
	materials = list(MAT_METAL=150)
	origin_tech = "magnets=1;engineering=1"

/obj/item/device/t_scanner/attack_self(mob/user)

	on = !on
	icon_state = copytext(icon_state, 1, length(icon_state))+"[on]"

	if(on)
		START_PROCESSING(SSobj, src)

/obj/item/device/t_scanner/proc/flick_sonar(obj/pipe)
	var/image/I = image('icons/effects/effects.dmi', pipe, "blip", pipe.layer+1)
	I.alpha = 128
	var/list/nearby = list()
	for(var/mob/M in viewers(pipe))
		if(M.client)
			nearby |= M.client
	flick_overlay(I,nearby,8)

/obj/item/device/t_scanner/process()
	if(!on)
		STOP_PROCESSING(SSobj, src)
		return null
	scan()

/obj/item/device/t_scanner/proc/scan()

	for(var/turf/T in range(2, src.loc) )
		for(var/obj/O in T.contents)

			if(O.level != 1)
				continue

			var/mob/living/L = locate() in O

			if(O.invisibility == INVISIBILITY_MAXIMUM)
				O.invisibility = 0
				if(L)
					flick_sonar(O)
				spawn(10)
					if(O && O.loc)
						var/turf/U = O.loc
						if(U.intact)
							O.invisibility = INVISIBILITY_MAXIMUM
			else
				if(L)
					flick_sonar(O)


/obj/item/device/healthanalyzer
	name = "health analyzer"
	icon_state = "health"
	item_state = "analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	flags = CONDUCT | NOBLUDGEON
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = 1
	throw_speed = 3
	throw_range = 7
	materials = list(MAT_METAL=200)
	origin_tech = "magnets=1;biotech=1"
	var/mode = 1
	var/scanmode = 0

/obj/item/device/healthanalyzer/attack_self(mob/user)
	if(!scanmode)
		user << "<span class='notice'>You switch the health analyzer to scan chemical contents.</span>"
		scanmode = 1
	else
		user << "<span class='notice'>You switch the health analyzer to check physical health.</span>"
		scanmode = 0

/obj/item/device/healthanalyzer/attack(mob/living/M, mob/living/carbon/human/user)

	// Clumsiness/brain damage check
	if ((user.disabilities & CLUMSY || user.getBrainLoss() >= 60) && prob(50))
		user << "<span class='notice'>You stupidly try to analyze the floor's vitals!</span>"
		user.visible_message("<span class='warning'>[user] has analyzed the floor's vitals!</span>")
		user << "<span class='info'>Analyzing results for The floor:\n\tOverall status: <b>Healthy</b>"
		user << "<span class='info'>Key: <font color='blue'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FF8000'>Burn</font>/<font color='red'>Brute</font></span>"
		user << "<span class='info'>\tDamage specifics: <font color='blue'>0</font>-<font color='green'>0</font>-<font color='#FF8000'>0</font>-<font color='red'>0</font></span>"
		user << "<span class='info'>Body temperature: ???</span>"
		return

	user.visible_message("<span class='notice'>[user] has analyzed [M]'s vitals.</span>")

	if(scanmode == 0)
		healthscan(user, M, mode)
	else if(scanmode == 1)
		chemscan(user, M)

	add_fingerprint(user)


// Used by the PDA medical scanner too
/proc/healthscan(mob/living/user, mob/living/M, mode = 1)
	if(user.stat || user.eye_blind)
		return
	//Damage specifics
	var/oxy_loss = M.getOxyLoss()
	var/tox_loss = M.getToxLoss()
	var/fire_loss = M.getFireLoss()
	var/brute_loss = M.getBruteLoss()
	var/mob_status = (M.stat > 1 ? "<span class='alert'><b>Deceased</b></span>" : "<b>[round(M.health/M.maxHealth,0.01)*100] % healthy</b>")

	if(M.status_flags & FAKEDEATH)
		mob_status = "<span class='alert'>Deceased</span>"
		oxy_loss = max(rand(1, 40), oxy_loss, (300 - (tox_loss + fire_loss + brute_loss))) // Random oxygen loss

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.heart_attack && H.stat != DEAD)
			user << "<span class='danger'>Subject suffering from heart attack: Apply defibrillator immediately!</span>"
	user << "<span class='info'>Analyzing results for [M]:\n\tOverall status: [mob_status]</span>"

	// Damage descriptions
	if(brute_loss > 10)
		user << "\t<span class='alert'>[brute_loss > 50 ? "Severe" : "Minor"] tissue damage detected.</span>"
	if(fire_loss > 10)
		user << "\t<span class='alert'>[fire_loss > 50 ? "Severe" : "Minor"] burn damage detected.</span>"
	if(oxy_loss > 10)
		user << "\t<span class='info'><span class='alert'>[oxy_loss > 50 ? "Severe" : "Minor"] oxygen deprivation detected.</span>"
	if(tox_loss > 10)
		user << "\t<span class='alert'>[tox_loss > 50 ? "Critical" : "Dangerous"] amount of toxins detected.</span>"
	if(M.getStaminaLoss())
		user << "\t<span class='alert'>Subject appears to be suffering from fatigue.</span>"
	if (M.getCloneLoss())
		user << "\t<span class='alert'>Subject appears to have [M.getCloneLoss() > 30 ? "severe" : "minor"] cellular damage.</span>"
	if (M.reagents && M.reagents.get_reagent_amount("epinephrine"))
		user << "\t<span class='info'>Bloodstream analysis located [M.reagents:get_reagent_amount("epinephrine")] units of rejuvenation chemicals.</span>"
	if (M.getBrainLoss() >= 100 || !M.getorgan(/obj/item/organ/brain))
		user << "\t<span class='alert'>Subject brain function is non-existent.</span>"
	else if (M.getBrainLoss() >= 60)
		user << "\t<span class='alert'>Severe brain damage detected. Subject likely to have mental retardation.</span>"
	else if (M.getBrainLoss() >= 10)
		user << "\t<span class='alert'>Brain damage detected. Subject may have had a concussion.</span>"

	// Organ damage report
	if(istype(M, /mob/living/carbon/human) && mode == 1)
		var/mob/living/carbon/human/H = M
		var/list/damaged = H.get_damaged_bodyparts(1,1)
		if(length(damaged)>0 || oxy_loss>0 || tox_loss>0 || fire_loss>0)
			user << "<span class='info'>\tDamage: <span class='info'><font color='red'>Brute</font></span>-<font color='#FF8000'>Burn</font>-<font color='green'>Toxin</font>-<font color='blue'>Suffocation</font>\n\t\tSpecifics: <font color='red'>[brute_loss]</font>-<font color='#FF8000'>[fire_loss]</font>-<font color='green'>[tox_loss]</font>-<font color='blue'>[oxy_loss]</font></span>"
			for(var/obj/item/bodypart/org in damaged)
				user << "\t\t<span class='info'>[capitalize(org.name)]: [(org.brute_dam > 0) ? "<font color='red'>[org.brute_dam]</font></span>" : "<font color='red'>0</font>"]-[(org.burn_dam > 0) ? "<font color='#FF8000'>[org.burn_dam]</font>" : "<font color='#FF8000'>0</font>"]"

	// Species and body temperature
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		user << "<span class='info'>Species: [H.dna.species.name]</span>"
	user << "<span class='info'>Body temperature: [round(M.bodytemperature-T0C,0.1)] &deg;C ([round(M.bodytemperature*1.8-459.67,0.1)] &deg;F)</span>"

	// Time of death
	if(M.tod && (M.stat == DEAD || (M.status_flags & FAKEDEATH)))
		user << "<span class='info'>Time of Death:</span> [M.tod]"
		var/tdelta = round(world.time - M.timeofdeath)
		if(tdelta < (DEFIB_TIME_LIMIT * 10))
			user << "<span class='danger'>Subject died [tdelta / 10] seconds \
				ago, defibrillation may be possible!</span>"

	for(var/datum/disease/D in M.viruses)
		if(!(D.visibility_flags & HIDDEN_SCANNER))
			user << "<span class='alert'><b>Warning: [D.form] detected</b>\nName: [D.name].\nType: [D.spread_text].\nStage: [D.stage]/[D.max_stages].\nPossible Cure: [D.cure_text]</span>"

	// Blood Level
	if(M.has_dna())
		var/mob/living/carbon/C = M
		var/blood_id = C.get_blood_id()
		if(blood_id)
			if(ishuman(C))
				var/mob/living/carbon/human/H = C
				if(H.bleed_rate)
					user << "<span class='danger'>Subject is bleeding!</span>"
			var/blood_percent =  round((C.blood_volume / BLOOD_VOLUME_NORMAL)*100)
			var/blood_type = C.dna.blood_type
			if(blood_id != "blood")//special blood substance
				blood_type = blood_id
			if(C.blood_volume <= BLOOD_VOLUME_SAFE && C.blood_volume > BLOOD_VOLUME_OKAY)
				user << "<span class='danger'>LOW blood level [blood_percent] %, [C.blood_volume] cl,</span> <span class='info'>type: [blood_type]</span>"
			else if(C.blood_volume <= BLOOD_VOLUME_OKAY)
				user << "<span class='danger'>CRITICAL blood level [blood_percent] %, [C.blood_volume] cl,</span> <span class='info'>type: [blood_type]</span>"
			else
				user << "<span class='info'>Blood level [blood_percent] %, [C.blood_volume] cl, type: [blood_type]</span>"

		var/implant_detect
		for(var/obj/item/organ/cyberimp/CI in C.internal_organs)
			if(CI.status == ORGAN_ROBOTIC)
				implant_detect += "[C.name] is modified with a [CI.name].<br>"
		if(implant_detect)
			user << "<span class='notice'>Detected cybernetic modifications:</span>"
			user << "<span class='notice'>[implant_detect]</span>"

/proc/chemscan(mob/living/user, mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.reagents)
			if(H.reagents.reagent_list.len)
				user << "<span class='notice'>Subject contains the following reagents:</span>"
				for(var/datum/reagent/R in H.reagents.reagent_list)
					user << "<span class='notice'>[R.volume] units of [R.name][R.overdosed == 1 ? "</span> - <span class='boldannounce'>OVERDOSING</span>" : ".</span>"]"
			else
				user << "<span class='notice'>Subject contains no reagents.</span>"
			if(H.reagents.addiction_list.len)
				user << "<span class='boldannounce'>Subject is addicted to the following reagents:</span>"
				for(var/datum/reagent/R in H.reagents.addiction_list)
					user << "<span class='danger'>[R.name]</span>"
			else
				user << "<span class='notice'>Subject is not addicted to any reagents.</span>"

/obj/item/device/healthanalyzer/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = "Object"

	if(usr.stat || !usr.canmove || usr.restrained())
		return

	mode = !mode
	switch (mode)
		if(1)
			usr << "The scanner now shows specific limb damage."
		if(0)
			usr << "The scanner no longer shows limb damage."


/obj/item/device/analyzer
	desc = "A hand-held environmental scanner which reports current gas levels."
	name = "analyzer"
	icon_state = "atmos"
	item_state = "analyzer"
	w_class = 2
	flags = CONDUCT | NOBLUDGEON
	slot_flags = SLOT_BELT
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	materials = list(MAT_METAL=30, MAT_GLASS=20)
	origin_tech = "magnets=1;engineering=1"

/obj/item/device/analyzer/attack_self(mob/user)

	add_fingerprint(user)

	if (user.stat || user.eye_blind)
		return

	var/turf/location = user.loc
	if(!istype(location))
		return

	var/datum/gas_mixture/environment = location.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles()

	user << "<span class='info'><B>Results:</B></span>"
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		user << "<span class='info'>Pressure: [round(pressure,0.1)] kPa</span>"
	else
		user << "<span class='alert'>Pressure: [round(pressure,0.1)] kPa</span>"
	if(total_moles)
		var/list/env_gases = environment.gases

		environment.assert_gases(arglist(hardcoded_gases))
		var/o2_concentration = env_gases["o2"][MOLES]/total_moles
		var/n2_concentration = env_gases["n2"][MOLES]/total_moles
		var/co2_concentration = env_gases["co2"][MOLES]/total_moles
		var/plasma_concentration = env_gases["plasma"][MOLES]/total_moles
		environment.garbage_collect()

		if(abs(n2_concentration - N2STANDARD) < 20)
			user << "<span class='info'>Nitrogen: [round(n2_concentration*100, 0.01)] %</span>"
		else
			user << "<span class='alert'>Nitrogen: [round(n2_concentration*100, 0.01)] %</span>"

		if(abs(o2_concentration - O2STANDARD) < 2)
			user << "<span class='info'>Oxygen: [round(o2_concentration*100, 0.01)] %</span>"
		else
			user << "<span class='alert'>Oxygen: [round(o2_concentration*100, 0.01)] %</span>"

		if(co2_concentration > 0.01)
			user << "<span class='alert'>CO2: [round(co2_concentration*100, 0.01)] %</span>"
		else
			user << "<span class='info'>CO2: [round(co2_concentration*100, 0.01)] %</span>"

		if(plasma_concentration > 0.005)
			user << "<span class='alert'>Plasma: [round(plasma_concentration*100, 0.01)] %</span>"
		else
			user << "<span class='info'>Plasma: [round(plasma_concentration*100, 0.01)] %</span>"


		for(var/id in env_gases)
			if(id in hardcoded_gases)
				continue
			var/gas_concentration = env_gases[id][MOLES]/total_moles
			user << "<span class='alert'>[env_gases[id][GAS_META][META_GAS_NAME]]: [round(gas_concentration*100, 0.01)] %</span>"
		user << "<span class='info'>Temperature: [round(environment.temperature-T0C)] &deg;C</span>"


/obj/item/device/mass_spectrometer
	desc = "A hand-held mass spectrometer which identifies trace chemicals in a blood sample."
	name = "mass-spectrometer"
	icon_state = "spectrometer"
	item_state = "analyzer"
	w_class = 2
	flags = CONDUCT | OPENCONTAINER
	slot_flags = SLOT_BELT
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	materials = list(MAT_METAL=150, MAT_GLASS=100)
	origin_tech = "magnets=2;biotech=1;plasmatech=2"
	var/details = 0

/obj/item/device/mass_spectrometer/New()
	..()
	create_reagents(5)

/obj/item/device/mass_spectrometer/on_reagent_change()
	if(reagents.total_volume)
		icon_state = initial(icon_state) + "_s"
	else
		icon_state = initial(icon_state)

/obj/item/device/mass_spectrometer/attack_self(mob/user)
	if (user.stat || user.eye_blind)
		return
	if (!user.IsAdvancedToolUser())
		user << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return
	if(reagents.total_volume)
		var/list/blood_traces = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			if(R.id != "blood")
				reagents.clear_reagents()
				user << "<span class='warning'>The sample was contaminated! Please insert another sample.</span>"
				return
			else
				blood_traces = params2list(R.data["trace_chem"])
				break
		var/dat = "<i><b>Trace Chemicals Found:</b>"
		if(!blood_traces.len)
			dat += "<br>None"
		else
			for(var/R in blood_traces)
				dat += "<br>[chemical_reagents_list[R]]"
				if(details)
					dat += " ([blood_traces[R]] units)"
		dat += "</i>"
		user << dat
		reagents.clear_reagents()


/obj/item/device/mass_spectrometer/adv
	name = "advanced mass-spectrometer"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = "magnets=4;biotech=3;plasmatech=3"

/obj/item/device/slime_scanner
	name = "slime scanner"
	desc = "A device that analyzes a slime's internal composition and measures its stats."
	icon_state = "adv_spectrometer"
	item_state = "analyzer"
	origin_tech = "biotech=2"
	w_class = 2
	flags = CONDUCT
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	materials = list(MAT_METAL=30, MAT_GLASS=20)

/obj/item/device/slime_scanner/attack(mob/living/M, mob/living/user)
	if(user.stat || user.eye_blind)
		return
	if (!isslime(M))
		user << "<span class='warning'>This device can only scan slimes!</span>"
		return
	var/mob/living/simple_animal/slime/T = M
	user << "Slime scan results:"
	user << "[T.colour] [T.is_adult ? "adult" : "baby"] slime"
	user << "Nutrition: [T.nutrition]/[T.get_max_nutrition()]"
	if (T.nutrition < T.get_starve_nutrition())
		user << "<span class='warning'>Warning: slime is starving!</span>"
	else if (T.nutrition < T.get_hunger_nutrition())
		user << "<span class='warning'>Warning: slime is hungry</span>"
	user << "Electric change strength: [T.powerlevel]"
	user << "Health: [round(T.health/T.maxHealth,0.01)*100]"
	if (T.slime_mutation[4] == T.colour)
		user << "This slime does not evolve any further."
	else
		if (T.slime_mutation[3] == T.slime_mutation[4])
			if (T.slime_mutation[2] == T.slime_mutation[1])
				user << "Possible mutation: [T.slime_mutation[3]]"
				user << "Genetic destability: [T.mutation_chance/2] % chance of mutation on splitting"
			else
				user << "Possible mutations: [T.slime_mutation[1]], [T.slime_mutation[2]], [T.slime_mutation[3]] (x2)"
				user << "Genetic destability: [T.mutation_chance] % chance of mutation on splitting"
		else
			user << "Possible mutations: [T.slime_mutation[1]], [T.slime_mutation[2]], [T.slime_mutation[3]], [T.slime_mutation[4]]"
			user << "Genetic destability: [T.mutation_chance] % chance of mutation on splitting"
	if (T.cores > 1)
		user << "Anomalious slime core amount detected"
	user << "Growth progress: [T.amount_grown]/[SLIME_EVOLUTION_THRESHOLD]"
