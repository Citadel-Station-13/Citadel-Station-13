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
	var/min_health = 30
	var/list/available_chems
	var/controls_inside = FALSE
	var/list/possible_chems = list(
		list(/datum/reagent/medicine/epinephrine, /datum/reagent/medicine/morphine, /datum/reagent/medicine/salbutamol, /datum/reagent/medicine/bicaridine, /datum/reagent/medicine/kelotane),
		list(/datum/reagent/medicine/oculine,/datum/reagent/medicine/inacusiate),
		list(/datum/reagent/medicine/antitoxin, /datum/reagent/medicine/mutadone, /datum/reagent/medicine/mannitol, /datum/reagent/medicine/pen_acid),
		list(/datum/reagent/medicine/omnizine)
	)
	var/list/chem_buttons	//Used when emagged to scramble which chem is used, eg: antitoxin -> morphine
	var/scrambled_chems = FALSE //Are chem buttons scrambled? used as a warning
	var/enter_message = "<span class='notice'><b>You feel cool air surround you. You go numb as your senses turn inward.</b></span>"
	payment_department = ACCOUNT_MED
	fair_market_price = 5

/obj/machinery/sleeper/Initialize()
	. = ..()
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

/obj/machinery/sleeper/proc/add_inital_chems()
	for(var/i in available_chems)
		var/datum/reagent/R = reagents.has_reagent(i)
		if(!R)
			reagents.add_reagent(i, (20))
			continue
		if(R.volume < 20)
			reagents.add_reagent(i, (20 - R.volume))

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
	icon_state = initial(icon_state)
	if(state_open)
		icon_state += "-open"

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
		..()

/obj/machinery/sleeper/close_machine(mob/user)
	if((isnull(user) || istype(user)) && state_open && !panel_open)
		..(user)
		var/mob/living/mob_occupant = occupant
		if(mob_occupant && mob_occupant.stat != DEAD)
			to_chat(occupant, "[enter_message]")

/obj/machinery/sleeper/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(is_operational() && occupant)
		var/datum/reagent/R = pick(reagents.reagent_list)
		inject_chem(R.type, occupant)
		open_machine()
	//Is this too much?
	if(severity == EMP_HEAVY)
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
	if(user.stat || user.lying || !Adjacent(user) || !user.Adjacent(target) || !iscarbon(target) || !user.IsAdvancedToolUser())
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

/obj/machinery/sleeper/AltClick(mob/user)
	. = ..()
	if(!user.canUseTopic(src, !hasSiliconAccessInArea(user)))
		return
	if(state_open)
		close_machine()
	else
		open_machine()
	return TRUE

/obj/machinery/sleeper/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click [src] to [state_open ? "close" : "open"] it.</span>"

/obj/machinery/sleeper/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
									datum/tgui/master_ui = null, datum/ui_state/state = GLOB.notcontained_state)

	if(controls_inside && state == GLOB.notcontained_state)
		state = GLOB.default_state // If it has a set of controls on the inside, make it actually controllable by the mob in it.

	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "sleeper", name, 550, 700, master_ui, state)
		ui.open()

/obj/machinery/sleeper/process()
	..()
	check_nap_violations()

/obj/machinery/sleeper/nap_violation(mob/violator)
	open_machine()

/obj/machinery/sleeper/ui_data()
	var/list/data = list()
	var/chemical_list = list()
	var/blood_percent = 0

	data["occupied"] = occupant ? 1 : 0
	data["open"] = state_open
	data["blood_levels"] = blood_percent
	data["blood_status"] = "Patient either has no blood, or does not require it to function."
	data["chemical_list"] = chemical_list

	data["chems"] = list()
	for(var/chem in available_chems)
		var/datum/reagent/R = reagents.has_reagent(chem)
		R = GLOB.chemical_reagents_list[chem]
		data["synthchems"] += list(list("name" = R.name, "id" = R.type, "synth_allowed" = synth_allowed(chem)))
	for(var/datum/reagent/R in reagents.reagent_list)
		data["chems"] += list(list("name" = R.name, "id" = R.type, "vol" = R.volume, "purity" = R.purity, "allowed" = chem_allowed(R.type)))

	data["occupant"] = list()
	var/mob/living/mob_occupant = occupant
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

		if(mob_occupant.reagents.reagent_list.len)
			for(var/datum/reagent/R in mob_occupant.reagents.reagent_list)
				chemical_list += list(list("name" = R.name, "volume" = R.volume))
		else
			chemical_list = "Patient has no reagents."

		data["occupant"]["failing_organs"] = list()
		var/mob/living/carbon/C = mob_occupant
		if(C)
			for(var/obj/item/organ/Or in C.getFailingOrgans())
				if(istype(Or, /obj/item/organ/brain))
					continue
				data["occupant"]["failing_organs"] += list(list("name" = Or.name))

		if(istype(C)) //Non-carbons shouldn't be able to enter sleepers, but this is to prevent runtimes if something ever breaks
			if(mob_occupant.has_dna()) // Blood-stuff is mostly a copy-paste from the healthscanner.
				blood_percent = round((C.blood_volume / BLOOD_VOLUME_NORMAL)*100)
				var/blood_id = C.get_blood_id()
				var/blood_warning = ""
				if(blood_percent < 80)
					blood_warning = "Patient has low blood levels."
				if(blood_percent < 60)
					blood_warning = "Patient has DANGEROUSLY low blood levels."
				if(blood_id)
					var/blood_type = C.dna.blood_type
					if(!(blood_id in GLOB.blood_reagent_types)) // special blood substance
						var/datum/reagent/R = GLOB.chemical_reagents_list[blood_id]
						if(R)
							blood_type = R.name
						else
							blood_type = blood_id
					data["blood_status"] = "Patient has [blood_type] type blood. [blood_warning]"
				data["blood_levels"] = blood_percent
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
			var/amount = text2num(params["volume"])
			if(!is_operational() || !mob_occupant || isnull(chem))
				return
			if(mob_occupant.health < min_health && chem != /datum/reagent/medicine/epinephrine)
				return
			if(inject_chem(chem, usr, amount))
				. = TRUE
				if(scrambled_chems && prob(5))
					to_chat(usr, "<span class='warning'>Chemical system re-route detected, results may not be as expected!</span>")
		if("synth")
			var/chem = text2path(params["chem"])
			if(!is_operational())
				return
			reagents.add_reagent(chem_buttons[chem], 10) //other_purity = 0.75 for when the mechanics are in
		if("purge")
			var/chem = text2path(params["chem"])
			if(allowed(usr))
				if(!is_operational())
					return
				reagents.remove_reagent(chem, 1000)
				return
			if(chem in available_chems)
				if(!is_operational())
					return
				/*var/datum/reagent/R = reagents.has_reagent(chem) //For when purity effects are in
				if(R.purity < 0.8)*/
				reagents.remove_reagent(chem, 1000)
			else
				visible_message("<span class='warning'>Access Denied.</span>")
				playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)


/obj/machinery/sleeper/emag_act(mob/user)
	. = ..()
	obj_flags |= EMAGGED
	scramble_chem_buttons()
	to_chat(user, "<span class='warning'>You scramble the sleeper's user interface!</span>")
	return TRUE

//trans to
/obj/machinery/sleeper/proc/inject_chem(chem, mob/user, volume = 10)
	if(chem_allowed(chem))
		reagents.trans_id_to(occupant, chem, volume)//emag effect kicks in here so that the "intended" chem is used for all checks, for extra FUUU
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

/obj/machinery/sleeper/clockwork
	name = "soothing sleeper"
	desc = "A large cryogenics unit built from brass. Its surface is pleasantly cool the touch."
	icon_state = "sleeper_clockwork"
	enter_message = "<span class='bold inathneq_small'>You hear the gentle hum and click of machinery, and are lulled into a sense of peace.</span>"
	possible_chems = list(list("epinephrine", "salbutamol", "bicaridine", "kelotane", "oculine", "inacusiate", "mannitol"))

/obj/machinery/sleeper/clockwork/process()
	if(occupant && isliving(occupant))
		var/mob/living/L = occupant
		if(GLOB.clockwork_vitality) //If there's Vitality, the sleeper has passive healing
			GLOB.clockwork_vitality = max(0, GLOB.clockwork_vitality - 1)
			L.adjustBruteLoss(-1)
			L.adjustFireLoss(-1)
			L.adjustOxyLoss(-5)

/obj/machinery/sleeper/old
	icon_state = "oldpod"
