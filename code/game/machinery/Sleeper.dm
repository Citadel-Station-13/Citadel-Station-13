/obj/machinery/sleep_console
	name = "sleeper console"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "console"
	density = FALSE

/obj/machinery/sleeper
	name = "sleeper"
	desc = "An enclosed machine used to stabilize and heal patients."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	density = FALSE
	state_open = TRUE
	circuit = /obj/item/circuitboard/machine/sleeper
	req_access = list(ACCESS_CMO) //Used for reagent deletion and addition of non medicines
	var/efficiency = 1
	var/min_health = -25
	var/list/available_chems
	var/controls_inside = FALSE
	var/list/possible_chems = list(
		list(/datum/reagent/medicine/epinephrine, /datum/reagent/medicine/morphine, /datum/reagent/medicine/salbutamol, /datum/reagent/medicine/bicaridine, /datum/reagent/medicine/kelotane),
		list(/datum/reagent/medicine/oculine,/datum/reagent/medicine/inacusiate),
		list(/datum/reagent/medicine/antitoxin, /datum/reagent/medicine/mutadone, /datum/reagent/medicine/mannitol, /datum/reagent/medicine/multiver),
		list(/datum/reagent/medicine/omnizine)
	)
	var/list/chem_buttons	//Used when emagged to scramble which chem is used, eg: antitoxin -> morphine
	var/scrambled_chems = FALSE //Are chem buttons scrambled? used as a warning
	var/enter_message = "<span class='notice'><b>You feel cool air surround you. You go numb as your senses turn inward.</b></span>"
	payment_department = ACCOUNT_MED
	fair_market_price = 5

	var/dialysis = FALSE //Is the patient currently undergoing dialysis?
	var/antirad = FALSE //Is the patient currently undergoing radiation treatment?
	var/monitor = FALSE //Check to see if we're checking bloodstream

	//Units
	var/dispense_amount = 10

/obj/machinery/sleeper/Initialize()
	. = ..()
	// if(mapload)
	// 	component_parts -= circuit
	// 	QDEL_NULL(circuit)
	create_reagents(500, NO_REACT)
	occupant_typecache = GLOB.typecache_living
	update_icon()
	reset_chem_buttons()
	RefreshParts()
	add_inital_chems()

/obj/machinery/sleeper/on_deconstruction()
	var/obj/item/reagent_containers/sleeper_buffer/buffer = new (loc)
	buffer.volume = reagents.maximum_volume
	buffer.reagents.maximum_volume = reagents.maximum_volume
	reagents.trans_to(buffer.reagents, reagents.total_volume)
	..()

/obj/machinery/sleeper/proc/add_inital_chems()
	for(var/i in available_chems)
		var/datum/reagent/R = reagents.has_reagent(i)
		if(!R)
			reagents.add_reagent(i, 20, added_purity = 0.8)
			continue
		if(R.volume < 20)
			reagents.add_reagent(i, (20 - R.volume), added_purity = 0.8)

/obj/machinery/sleeper/RefreshParts()
	var/E
	for(var/obj/item/stock_parts/matter_bin/B in component_parts)
		E += B.rating
	var/I
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		I += M.rating

	efficiency = initial(efficiency)* E
	min_health = initial(min_health) - (10*(E-1)) // CIT CHANGE - changes min health equation to be min_health - (matterbin rating * 10)
	available_chems = list()
	for(var/i in 1 to I)
		available_chems |= possible_chems[i]
	reset_chem_buttons()

	//Total container size 500 - 2000u
	if(reagents)
		reagents.maximum_volume = (500*E)

/obj/machinery/sleeper/update_icon_state()
	if(state_open)
		icon_state = "[initial(icon_state)]-open"
	else
		icon_state = initial(icon_state)

/obj/machinery/sleeper/container_resist(mob/living/user)
	visible_message("<span class='notice'>[occupant] emerges from [src]!</span>",
		"<span class='notice'>You climb out of [src]!</span>")
	open_machine()

/obj/machinery/sleeper/Exited(atom/movable/user)
	if (!state_open && user == occupant)
		container_resist(user)

/obj/machinery/sleeper/relaymove(mob/user)
	if (!state_open)
		container_resist(user)

/obj/machinery/sleeper/open_machine()
	if(!state_open && !panel_open)
		// flick("[initial(icon_state)]-anim", src)
		..()

/obj/machinery/sleeper/close_machine(mob/user)
	if((isnull(user) || istype(user)) && state_open && !panel_open)
		// flick("[initial(icon_state)]-anim", src)
		..(user)
		var/mob/living/mob_occupant = occupant
		if(mob_occupant && mob_occupant.stat != DEAD)
			to_chat(occupant, "[enter_message]")

/obj/machinery/sleeper/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(is_operational() && occupant)
		var/datum/reagent/R = pick(reagents.reagent_list) //cit specific
		inject_chem(R.type, occupant)
		open_machine()
	//Is this too much? Cit specific
	if(severity >= 80)
		var/chem = pick(available_chems)
		available_chems -= chem
		available_chems += get_random_reagent_id()
		reset_chem_buttons()

/obj/machinery/sleeper/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/sleeper_buffer))
		var/obj/item/reagent_containers/sleeper_buffer/SB = I
		if((SB.reagents.total_volume + reagents.total_volume) < reagents.maximum_volume)
			SB.reagents.trans_to(reagents, SB.reagents.total_volume)
			visible_message("[user] places the [SB] into the [src].")
			qdel(SB)
			return
		else
			SB.reagents.trans_to(reagents, SB.reagents.total_volume)
			visible_message("[user] adds as much as they can to the [src] from the [SB].")
			return
	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/RC = I
		if(RC.reagents.total_volume == 0)
			to_chat(user, "<span class='notice'>The [I] is empty!</span>")
		for(var/datum/reagent/R in RC.reagents.reagent_list)
			if((obj_flags & EMAGGED) || (allowed(usr)))
				break
			if(!istype(R, /datum/reagent/medicine))
				visible_message("The [src] gives out a hearty boop and rejects the [I]. The Sleeper's screen flashes with a pompous \"Medicines only, please.\"")
				return
		RC.reagents.trans_to(reagents, 1000)
		visible_message("[user] adds as much as they can to the [src] from the [I].")
		return

/obj/machinery/sleeper/MouseDrop_T(mob/target, mob/user)
	if(user.stat || !Adjacent(user) || !user.Adjacent(target) || !iscarbon(target) || !user.IsAdvancedToolUser())
		return
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_STAND))
			return
	close_machine(target)

/obj/machinery/sleeper/screwdriver_act(mob/living/user, obj/item/I)
	. = TRUE
	if(..())
		return
	if(occupant)
		to_chat(user, "<span class='warning'>[src] is currently occupied!</span>")
		return
	if(state_open)
		to_chat(user, "<span class='warning'>[src] must be closed to [panel_open ? "close" : "open"] its maintenance hatch!</span>")
		return
	if(default_deconstruction_screwdriver(user, "[initial(icon_state)]-o", initial(icon_state), I))
		return
	return FALSE

/obj/machinery/sleeper/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	if(default_change_direction_wrench(user, I))
		return TRUE

/obj/machinery/sleeper/crowbar_act(mob/living/user, obj/item/I)
	. = ..()
	if(default_pry_open(I))
		return TRUE
	if(default_deconstruction_crowbar(I))
		return TRUE

/obj/machinery/sleeper/default_pry_open(obj/item/I) //wew
	. = !(state_open || panel_open || (flags_1 & NODECONSTRUCT_1)) && I.tool_behaviour == TOOL_CROWBAR
	if(.)
		I.play_tool_sound(src, 50)
		visible_message("<span class='notice'>[usr] pries open [src].</span>", "<span class='notice'>You pry open [src].</span>")
		open_machine()

/obj/machinery/sleeper/ui_state(mob/user)
	if(controls_inside)
		return GLOB.default_state
	return GLOB.notcontained_state

/obj/machinery/sleeper/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Sleeper", name)
		ui.open()

/obj/machinery/sleeper/AltClick(mob/user)
	if(!user.canUseTopic(src, !issilicon(user)))
		return
	if(state_open)
		close_machine()
	else
		open_machine()

/obj/machinery/sleeper/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click [src] to [state_open ? "close" : "open"] it.</span>"

/obj/machinery/sleeper/process()
	..()
	check_nap_violations()

/obj/machinery/sleeper/nap_violation(mob/violator)
	open_machine()

/obj/machinery/sleeper/ui_data()
	var/list/data = list()
	data["occupied"] = occupant ? 1 : 0
	data["open"] = state_open
	data["dialysis"] = dialysis
	data["antirad"] = antirad
	data["efficiency"] = efficiency
	data["current_vol"] = reagents.total_volume
	data["tot_capacity"] = reagents.maximum_volume
	data["amount"] = dispense_amount
	data["monitor"] = monitor
	data["granularity"] = getCurVolEff()

	data["chems"] = list()
	for(var/chem in available_chems)
		var/datum/reagent/R = GLOB.chemical_reagents_list[chem]
		//data["chems"] += list(list("name" = R.name, "id" = R.type, "allowed" = chem_allowed(chem)))
		//R = GLOB.chemical_reagents_list[chem]
		data["synthchems"] += list(list("name" = R.name, "id" = R.type, "synth_allowed" = synth_allowed(chem)))
	for(var/datum/reagent/R in reagents.reagent_list)
		var/purityLevel = purityToColor(R.purity)
		data["chems"] += list(list("name" = R.name, "id" = R.type, "vol" = round(R.volume, 0.1), "purity" = round(R.purity, 0.01), "purityCol" = purityLevel, "allowed" = chem_allowed(R.type)))

	data["occupant"] = list()
	var/mob/living/mob_occupant = occupant
	var/mob/living/carbon/C = mob_occupant
	if(mob_occupant)
		data["occupant"]["name"] = mob_occupant.name
		switch(mob_occupant.stat)
			if(CONSCIOUS)
				data["occupant"]["stat"] = "Conscious"
				data["occupant"]["statstate"] = "good"
			if(SOFT_CRIT)
				data["occupant"]["stat"] = "Conscious"
				data["occupant"]["statstate"] = "average"
			if(UNCONSCIOUS)
				data["occupant"]["stat"] = "Unconscious"
				data["occupant"]["statstate"] = "average"
			if(DEAD)
				data["occupant"]["stat"] = "Dead"
				data["occupant"]["statstate"] = "bad"
		data["occupant"]["health"] = mob_occupant.health
		data["occupant"]["maxHealth"] = mob_occupant.maxHealth
		data["occupant"]["minHealth"] = HEALTH_THRESHOLD_DEAD
		data["occupant"]["bruteLoss"] = mob_occupant.getBruteLoss()
		data["occupant"]["oxyLoss"] = mob_occupant.getOxyLoss()
		data["occupant"]["toxLoss"] = mob_occupant.getToxLoss()
		data["occupant"]["fireLoss"] = mob_occupant.getFireLoss()
		data["occupant"]["cloneLoss"] = mob_occupant.getCloneLoss()
		data["occupant"]["brainLoss"] = mob_occupant.getOrganLoss(ORGAN_SLOT_BRAIN)
		data["occupant"]["reagents"] = list()
		if(mob_occupant.reagents && mob_occupant.reagents.reagent_list.len)
			for(var/datum/reagent/R in mob_occupant.reagents.reagent_list)
				if(R.chemical_flags & REAGENT_INVISIBLE)
					continue
				data["occupant"]["reagents"] += list(list("name" = R.name, "volume" = round(R.volume, 0.1)))
		var/obj/item/organ/liver/L = C.getorganslot(ORGAN_SLOT_LIVER)
		if(L)
			if(istype(L, /obj/item/organ/liver/slime))
				switch(L.metabolic_stress)
					if(-INFINITY to -25)
						data["occupant"]["metabolicColour"] = "basic"
						data["occupant"]["metabolicStress"] = "Chronic liver treatment"
					if(-25 to -0.5)
						data["occupant"]["metabolicColour"] = "highlight"
						data["occupant"]["metabolicStress"] = "Acute liver treatment"
					if(-0.5 to 15)
						data["occupant"]["metabolicColour"] = "good"
						data["occupant"]["metabolicStress"] = round(L.metabolic_stress, 0.1)
					if(15 to 25)
						data["occupant"]["metabolicColour"] = "average"
						data["occupant"]["metabolicStress"] = round(L.metabolic_stress, 0.1)
					if(25 to INFINITY)
						data["occupant"]["metabolicColour"] = "bad"
						data["occupant"]["metabolicStress"] = round(L.metabolic_stress, 0.1)
			else
				switch(L.metabolic_stress)
					if(-INFINITY to -10)
						data["occupant"]["metabolicColour"] = "basic"
						data["occupant"]["metabolicStress"] = "Chronic liver treatment [round(L.metabolic_stress, 0.1)]"
						data["occupant"]["metabolicVal"] = -round(L.metabolic_stress, 0.1)
					if(-10 to -0.5)
						data["occupant"]["metabolicColour"] = "highlight"
						data["occupant"]["metabolicStress"] = "Acute liver treatment [round(L.metabolic_stress, 0.1)]"
						data["occupant"]["metabolicVal"] = -round(L.metabolic_stress, 0.1)
					if(-0.5 to 15)
						data["occupant"]["metabolicColour"] = "good"
						data["occupant"]["metabolicStress"] = round(L.metabolic_stress, 0.1)
						data["occupant"]["metabolicVal"] = round(L.metabolic_stress, 0.1)
					if(15 to 25)
						data["occupant"]["metabolicColour"] = "average"
						data["occupant"]["metabolicStress"] = round(L.metabolic_stress, 0.1)
						data["occupant"]["metabolicVal"] = round(L.metabolic_stress, 0.1)
					if(25 to INFINITY)
						data["occupant"]["metabolicColour"] = "bad"
						data["occupant"]["metabolicStress"] = round(L.metabolic_stress, 0.1)
						data["occupant"]["metabolicVal"] = round(L.metabolic_stress, 0.1)
		data["occupant"]["failing_organs"] = list()
		if(C)
			for(var/obj/item/organ/Or in C.getFailingOrgans())
				if(istype(Or, /obj/item/organ/brain))
					continue
				data["occupant"]["failing_organs"] += list(list("name" = "[uppertext(Or.name)] "))

		if(mob_occupant.has_dna()) // Blood-stuff is mostly a copy-paste from the healthscanner.
			var/blood_id = C.get_blood_id()
			if(blood_id)
				data["occupant"]["blood"] = list()
				data["occupant"]["blood"]["max"] = (BLOOD_VOLUME_NORMAL*C.blood_ratio)
				data["occupant"]["blood"]["currentBloodVolume"] = C.blood_volume
				data["occupant"]["blood"]["danger"] = BLOOD_VOLUME_SAFE
				data["occupant"]["blood"]["bloodType"] = C.dna.blood_type
			else
				data["occupant"]["blood"] = list()
				data["occupant"]["blood"]["max"] = (BLOOD_VOLUME_NORMAL*C.blood_ratio)
				data["occupant"]["blood"]["currentBloodVolume"] = C.blood_volume
				data["occupant"]["blood"]["danger"] = BLOOD_VOLUME_SAFE
				data["occupant"]["blood"]["bloodType"] = "Unable to detect"

			

		data["occupant"]["is_robotic_organism"] = HAS_TRAIT(mob_occupant, TRAIT_ROBOTIC_ORGANISM)
		data["occupant"]["reagents"] = list()
		if(mob_occupant.reagents && mob_occupant.reagents.reagent_list.len)
			for(var/datum/reagent/R in mob_occupant.reagents.reagent_list)
				if(R.chemical_flags & REAGENT_INVISIBLE && efficiency < 4) //Ignore invisible chems, except when upgraded
					continue
				data["occupant"]["reagents"] += list(list("name" = R.name, "volume" = round(R.volume, 0.01), "desc" = R.description, "OD" = R.overdose_threshold))
	return data

/obj/machinery/sleeper/ui_act(action, params)
	if(..())
		return
	var/mob/living/mob_occupant = occupant
	check_nap_violations()
	switch(action)
		if("door")
			if(state_open)
				close_machine()
			else
				open_machine()
			. = TRUE
		if("inject")
			var/chem = text2path(params["chem"])
			//var/amount = text2num(params["volume"])
			if(!is_operational() || !mob_occupant || isnull(chem))
				return
			if(mob_occupant.health < min_health && chem != /datum/reagent/medicine/epinephrine)
				return
			var/datum/reagent/R = reagents.get_reagent(chem)
			if(inject_chem(R, usr))
				. = TRUE
				if(scrambled_chems && prob(5))
					to_chat(usr, "<span class='warning'>Chemical system re-route detected, results may not be as expected!</span>")

		if("amount")
			var/amount = params["amount"]
			if(text2num(amount) != null)
				amount = text2num(amount)
				. = TRUE
			if(.)
				dispense_amount = clamp(amount, 0, 100)

		if("synth")
			var/chem = text2path(params["chem"])
			if(!is_operational())
				return
			var/amount = dispense_amount
			var/datum/reagent/R = reagents.get_reagent(chem)
			if(R)
				if(R.volume+amount > 50)
					amount = 50 - R.volume
			reagents.add_reagent(chem_buttons[chem], amount, added_purity = 0.7)
		if("purge")
			var/chem = text2path(params["chem"])
			if(allowed(usr))
				if(!is_operational())
					return
				reagents.remove_reagent(chem, dispense_amount)
				return
			if(chem in available_chems)
				if(!is_operational())
					return
				/*var/datum/reagent/R = reagents.has_reagent(chem) //For when purity effects are in
				if(R.purity < 0.8)*/
				reagents.remove_reagent(chem, dispense_amount)
			else
				visible_message("<span class='warning'>Access Denied.</span>")
				playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
		if("synth_all")
			synth_all_avalible()

		if("antirad")
			antirad = !(antirad)
		if("dialysis")
			dialysis = !(dialysis)
		if("monitor")
			monitor = !(monitor)

/obj/machinery/sleeper/emag_act(mob/user)
	. = ..()
	obj_flags |= EMAGGED
	scramble_chem_buttons()
	to_chat(user, "<span class='warning'>You scramble the sleeper's user interface!</span>")
	return TRUE

/obj/machinery/sleeper/proc/inject_chem(chem, mob/user, volume = 10)
	if(chem_allowed(chem))
		var/datum/reagent/R
		if(scrambled_chems) //We can't index from chem_buttoms because we also have the posibility of chems outside of the synthed ones, so we randomize the selection.
			R = pick(reagents.reagent_list)
		else //Works as expected otherwise
			R = reagents.get_reagent(chem)
		if(volume > R.volume)
			volume = R.volume
		var/trans_data = reagents.copy_data(R)
		occupant.reagents.add_reagent(R.type, volume, trans_data, added_purity = R.purity)
		reagents.remove_reagent(R.type, volume, safety = TRUE, ignore_pH = TRUE)
		if(user)
			log_combat(user, occupant, "injected [chem] into", addition = "via [src]")
		return TRUE

/obj/machinery/sleeper/proc/chem_allowed(chem)
	var/mob/living/mob_occupant = occupant
	if(!mob_occupant || !mob_occupant.reagents)
		return
	var/amount = mob_occupant.reagents.get_reagent_amount(chem) + 10 <= 20 * efficiency
	var/occ_health = mob_occupant.health > min_health || chem == /datum/reagent/medicine/epinephrine
	return amount && occ_health

/obj/machinery/sleeper/proc/getCurVolEff()
	switch(efficiency)
		if(1)
			return 10
		if(2)
			return 5
		if(3)
			return 2
		if(4)
			return 1
	return 1//just in case

/obj/machinery/sleeper/proc/purityToColor(purity)
	switch(purity)
		if(0 to 0.4)
			return "red"
		if(0.4 to 0.6)
			return "orange"
		if(0.6 to 0.69) //Just so the default isn't an ugly yellow
			return "average"
		if(0.69 to 0.75)
			return "olive"
		if(0.75 to 0.8)
			return "green"
		if(0.8 to 0.85)
			return "teal"
		if(0.85 to 0.9)
			return "blue"
		if(0.9 to 0.95)
			return "violet"
		if(0.95 to 1)
			return "purple"
	return "brown"


/obj/machinery/sleeper/proc/synth_allowed(chem)
	var/datum/reagent/R = reagents.has_reagent(chem)
	if(!R)
		return TRUE
	if(R.volume < 50)
		return TRUE
	return FALSE

/obj/machinery/sleeper/proc/reset_chem_buttons()
	scrambled_chems = FALSE
	LAZYINITLIST(chem_buttons)
	for(var/chem in available_chems)
		chem_buttons[chem] = chem

/obj/machinery/sleeper/proc/scramble_chem_buttons()
	scrambled_chems = TRUE
	var/list/av_chem = available_chems.Copy()
	for(var/chem in av_chem)
		chem_buttons[chem] = pick_n_take(av_chem) //no dupes, allow for random buttons to still be correct

/obj/machinery/sleeper/proc/synth_all_avalible()
	for(var/chem in available_chems)
		if(!synth_allowed(chem))
			continue
		var/datum/reagent/R = reagents.has_reagent(chem)
		if(!R)
			reagents.add_reagent(chem_buttons[chem], 50, added_purity = 0.7)
			continue
		if(R)
			var/add_amount = 50 - R.volume
			if(R.volume > 0)
				reagents.add_reagent(chem_buttons[chem], add_amount, added_purity = 0.7)


/obj/machinery/sleeper/process()
	var/mob/living/carbon/C = occupant
	if(dialysis)
		if(!occupant && !isliving(occupant))
			dialysis = FALSE
			return

		var/obj/item/organ/liver/L = C.getorganslot(ORGAN_SLOT_LIVER)
		if(L)
			L.adjustMetabolicStress(-(0.15+(efficiency/10)), (5+(efficiency*-5))) //0.25 - 0.55 | 0 - 15. Upgrade level 2 can treat acute livers, lvl 4 chronic.
			C.adjustToxLoss(-(1+(efficiency/4)))
			C.blood_volume -= 3/efficiency
		else
			C.adjustToxLoss(-5)//counteract missing liver
			C.blood_volume -= 6/efficiency //but take more blood
		for(var/datum/reagent/R in C.reagents.reagent_list)
			if(istype(R, /datum/reagent/metabolic))
				continue
			C.reagents.remove_reagent(R.type,R.volume/(40/efficiency))
	if(monitor)
		if(!occupant && !isliving(occupant))
			monitor = FALSE
			return
		for(var/datum/reagent/R in C.reagents.reagent_list)
			if(istype(R, /datum/reagent/metabolic))
				continue
			C.reagents.remove_reagent(R.type,0.1/efficiency)
			R.purity -= 0.001
		C.nutrition -= 0.1

	if(antirad)
		if(!occupant && !isliving(occupant))
			antirad = FALSE
			return
		C.radiation -= max(C.radiation-RAD_MOB_SAFE, 0)/(150/efficiency)
		C.randomOrganDamage(5.2/efficiency)
	//It is a sleeper after all.
	if(C)
		C.AdjustUnconscious(-5, 0)
		C.AdjustStun(-5, 0)
		C.AdjustKnockdown(-5, 0)



/obj/machinery/sleeper/syndie
	icon_state = "sleeper_s"
	controls_inside = TRUE

/obj/machinery/sleeper/syndie/Initialize()
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/sleeper/syndie(null)
	component_parts += new /obj/item/stock_parts/matter_bin/super(null)
	component_parts += new /obj/item/stock_parts/manipulator/pico(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new /obj/item/stack/cable_coil(null)
	RefreshParts()

/obj/machinery/sleeper/syndie/fullupgrade/Initialize()
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/sleeper/syndie(null)
	component_parts += new /obj/item/stock_parts/matter_bin/bluespace(null)
	component_parts += new /obj/item/stock_parts/manipulator/femto(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new /obj/item/stack/cable_coil(null)
	RefreshParts()

/obj/machinery/sleeper/old
	icon_state = "oldpod"

/obj/machinery/sleeper/party
	name = "party pod"
	desc = "'Sleeper' units were once known for their healing properties, until a lengthy investigation revealed they were also dosing patients with deadly lead acetate. This appears to be one of those old 'sleeper' units repurposed as a 'Party Pod'. It’s probably not a good idea to use it."
	icon_state = "partypod"
	idle_power_usage = 3000
	circuit = /obj/item/circuitboard/machine/sleeper/party
	var/leddit = FALSE //Get it like reddit and lead alright fine

	controls_inside = TRUE
	possible_chems = list(
		list(/datum/reagent/consumable/ethanol/beer, /datum/reagent/consumable/laughter),
		list(/datum/reagent/spraytan,/datum/reagent/barbers_aid),
		list(/datum/reagent/colorful_reagent,/datum/reagent/hair_dye),
		list(/datum/reagent/drug/space_drugs,/datum/reagent/baldium)
	)//Exclusively uses non-lethal, "fun" chems. At an obvious downside.
	var/spray_chems = list(
		/datum/reagent/spraytan, /datum/reagent/hair_dye, /datum/reagent/baldium, /datum/reagent/barbers_aid
	)//Chemicals that need to have a touch or vapor reaction to be applied, not the standard chamber reaction.
	enter_message = "<span class='notice'><b>You're surrounded by some funky music inside the chamber. You zone out as you feel waves of krunk vibe within you.</b></span>"

/obj/machinery/sleeper/party/inject_chem(chem, mob/user)
	if(leddit)
		occupant.reagents.add_reagent(/datum/reagent/toxin/leadacetate, 4) //You're injecting chemicals into yourself from a recalled, decrepit medical machine. What did you expect?
	else if (prob(20))
		occupant.reagents.add_reagent(/datum/reagent/toxin/leadacetate, rand(1,3))
	if(chem in spray_chems)
		var/datum/reagents/holder = new()
		holder.add_reagent(chem_buttons[chem], 10) //I hope this is the correct way to do this.
		holder.reaction(occupant, VAPOR, 0)
		holder.trans_to(occupant, 10)
		playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE, -6)
		if(user)
			log_combat(user, occupant, "sprayed [chem] into", addition = "via [src]")
		return TRUE
	..()

/obj/machinery/sleeper/party/emag_act(mob/user)
	..()
	leddit = TRUE

/obj/machinery/sleeper/clockwork
	name = "soothing sleeper"
	desc = "A large cryogenics unit built from brass. Its surface is pleasantly cool the touch."
	icon_state = "sleeper_clockwork"
	enter_message = "<span class='bold inathneq_small'>You hear the gentle hum and click of machinery, and are lulled into a sense of peace.</span>"
	possible_chems = list(
		list(/datum/reagent/medicine/epinephrine, /datum/reagent/medicine/salbutamol, /datum/reagent/medicine/bicaridine, /datum/reagent/medicine/kelotane, /datum/reagent/medicine/oculine, /datum/reagent/medicine/inacusiate, /datum/reagent/medicine/mannitol)
	) //everything is available at start
	fair_market_price = 0 //it's free

/obj/machinery/sleeper/clockwork/process()
	..()
	if(occupant && isliving(occupant))
		var/mob/living/L = occupant
		if(GLOB.clockwork_vitality) //If there's Vitality, the sleeper has passive healing
			GLOB.clockwork_vitality = max(0, GLOB.clockwork_vitality - 1)
			L.adjustBruteLoss(-1)
			L.adjustFireLoss(-1)
			L.adjustOxyLoss(-5)
