/obj/machinery/sleep_console
	name = "sleeper console"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "console"
	density = FALSE

/obj/machinery/reagent_sleeper
	name = "sleeper"
	desc = "An enclosed machine used to stabilize and heal patients."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	density = FALSE
	state_open = TRUE
	circuit = /obj/item/circuitboard/machine/sleeper
	var/efficiency = 1
	var/min_health = -25
	var/list/available_chems
	var/controls_inside = FALSE
	var/list/possible_chems = list(
		list("epinephrine", "morphine", "salbutamol", "bicaridine", "kelotane"),
		list("oculine","inacusiate"),
		list("antitoxin", "mutadone", "mannitol", "pen_acid"),
		list("omnizine")
	)
	var/list/chem_buttons	//Used when emagged to scramble which chem is used, eg: antitoxin -> morphine
	var/scrambled_chems = FALSE //Are chem buttons scrambled? used as a warning
	var/enter_message = "<span class='notice'><b>You feel cool air surround you. You go numb as your senses turn inward.</b></span>"

/obj/machinery/reagent_sleeper/Initialize()
	. = ..()
	create_reagents(300, NO_REACT)
	occupant_typecache = GLOB.typecache_living
	update_icon()
	reset_chem_buttons()
	//add_inital_chems()

/obj/machinery/reagent_sleeper/Destroy()
	var/buffer = new /obj/item/reagent_containers/sleeper_buffer(loc)
	buffer.reagents = reagents
	..()

/obj/machinery/reagent_sleeper/RefreshParts()
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

	//Total container size 300 - 1200u
	reagents.maximum_volume = (300*E)

/obj/machinery/reagent_sleeper/update_icon()
	icon_state = initial(icon_state)
	if(state_open)
		icon_state += "-open"

/obj/machinery/reagent_sleeper/container_resist(mob/living/user)
	visible_message("<span class='notice'>[occupant] emerges from [src]!</span>",
		"<span class='notice'>You climb out of [src]!</span>")
	open_machine()

/obj/machinery/reagent_sleeper/Exited(atom/movable/user)
	if (!state_open && user == occupant)
		container_resist(user)

/obj/machinery/reagent_sleeper/relaymove(mob/user)
	if (!state_open)
		container_resist(user)

/obj/machinery/reagent_sleeper/open_machine()
	if(!state_open && !panel_open)
		..()

/obj/machinery/reagent_sleeper/close_machine(mob/user)
	if((isnull(user) || istype(user)) && state_open && !panel_open)
		..(user)
		var/mob/living/mob_occupant = occupant
		if(mob_occupant && mob_occupant.stat != DEAD)
			to_chat(occupant, "[enter_message]")

/obj/machinery/reagent_sleeper/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(is_operational() && occupant)
		var/datum/reagent/R = pick(reagents.reagent_list)
		inject_chem(R.id, occupant)
		open_machine()

/obj/machinery/reagent_sleeper/attackby(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/reagent_containers/sleeper_buffer))
		var/obj/item/reagent_containers/sleeper_buffer/SB = I
		if((SB.reagents.total_volume + reagents.total_volume) < reagents.max_volume)
			SB.reagents.trans_to(reagents, SB.reagents.total_volume)
			visible_message("[user] places the [SB] into the [src].")
			qdel(SB)
			return
		else
			SB.reagents.trans_to(reagents, SB.reagents.total_volume)
			visible_message("[user] adds as much as they can to the [src] from the [SB].")
			return

/obj/machinery/reagent_sleeper/MouseDrop_T(mob/target, mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !user.Adjacent(target) || !iscarbon(target) || !user.IsAdvancedToolUser())
		return
	close_machine(target)

/obj/machinery/reagent_sleeper/screwdriver_act(mob/living/user, obj/item/I)
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

/obj/machinery/reagent_sleeper/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	if(default_change_direction_wrench(user, I))
		return TRUE

/obj/machinery/reagent_sleeper/crowbar_act(mob/living/user, obj/item/I)
	. = ..()
	if(default_pry_open(I))
		return TRUE
	if(default_deconstruction_crowbar(I))
		return TRUE

/obj/machinery/reagent_sleeper/default_pry_open(obj/item/I) //wew
	. = !(state_open || panel_open || (flags_1 & NODECONSTRUCT_1)) && I.tool_behaviour == TOOL_CROWBAR
	if(.)
		I.play_tool_sound(src, 50)
		visible_message("<span class='notice'>[usr] pries open [src].</span>", "<span class='notice'>You pry open [src].</span>")
		open_machine()

/obj/machinery/reagent_sleeper/AltClick(mob/user)
	if(!user.canUseTopic(src, !issilicon(user)))
		return
	if(state_open)
		close_machine()
	else
		open_machine()

/obj/machinery/reagent_sleeper/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>Alt-click [src] to [state_open ? "close" : "open"] it.</span>")

/obj/machinery/reagent_sleeper/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
									datum/tgui/master_ui = null, datum/ui_state/state = GLOB.notcontained_state)

	if(controls_inside && state == GLOB.notcontained_state)
		state = GLOB.default_state // If it has a set of controls on the inside, make it actually controllable by the mob in it.

	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "reagent_sleeper", name, 375, 650, master_ui, state)
		ui.open()

/obj/machinery/reagent_sleeper/ui_data()
	var/list/data = list()
	data["occupied"] = occupant ? 1 : 0
	data["open"] = state_open
	data["efficiency"] = efficiency
	data["current_vol"] = reagents.total_volume
	data["tot_capacity"] = reagents.maximum_volume

	data["chems"] = list()
	for(var/chem in reagents.reagent_list)
		var/datum/reagent/R = GLOB.chemical_reagents_list[chem]
		if(R.id in available_chems)
			data["synthchems"] += list(list("name" = R.name, "id" = R.id, "vol" = R.volume, "allowed" = chem_allowed(chem)))
		else
			data["chems"] += list(list("name" = R.name, "id" = R.id, "vol" = R.volume, "allowed" = chem_allowed(chem)))

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
		data["occupant"]["reagents"] = list()
		if(mob_occupant.reagents && mob_occupant.reagents.reagent_list.len)
			for(var/datum/reagent/R in mob_occupant.reagents.reagent_list)
				data["occupant"]["reagents"] += list(list("name" = R.name, "volume" = R.volume))
		if(mob_occupant.has_dna()) // Blood-stuff is mostly a copy-paste from the healthscanner.
			var/mob/living/carbon/C = mob_occupant
			var/blood_id = C.get_blood_id()
			if(blood_id)
				data["occupant"]["blood"] = list() // We can start populating this list.
				var/blood_type = C.dna.blood_type
				if(blood_id != "blood") // special blood substance
					var/datum/reagent/R = GLOB.chemical_reagents_list[blood_id]
					if(R)
						blood_type = R.name
					else
						blood_type = blood_id
				data["occupant"]["blood"]["maxBloodVolume"] = (BLOOD_VOLUME_NORMAL*C.blood_ratio)
				data["occupant"]["blood"]["currentBloodVolume"] = C.blood_volume
				data["occupant"]["blood"]["dangerBloodVolume"] = BLOOD_VOLUME_SAFE
				data["occupant"]["blood"]["bloodType"] = blood_type
	return data

/obj/machinery/reagent_sleeper/ui_act(action, params)
	if(..())
		return
	var/mob/living/mob_occupant = occupant

	switch(action)
		if("door")
			if(state_open)
				close_machine()
			else
				open_machine()
			. = TRUE
		if("inject")
			var/chem = params["chem"]
			var/amount = param["volume"]
			if(!is_operational() || !mob_occupant)
				return
			if(mob_occupant.health < min_health && chem != "epinephrine")
				return
			if(inject_chem(chem, usr, volume))
				. = TRUE
				if(scrambled_chems && prob(5))
					to_chat(usr, "<span class='warning'>Chemical system re-route detected, results may not be as expected!</span>")
		if("synth")
			var/chem = params["chem"]
			if(!is_operational())
				return
			reagents.add_reagent(chem, 10) //other_purity = 0.8 for when the mechanics are in


/obj/machinery/reagent_sleeper/emag_act(mob/user)
	. = ..()
	scramble_chem_buttons()
	to_chat(user, "<span class='warning'>You scramble the sleeper's user interface!</span>")
	return TRUE

//trans to
/obj/machinery/reagent_sleeper/proc/inject_chem(chem, mob/user, volume)
	if((chem in available_chems) && chem_allowed(chem))
		reagents.trans_id_to(occupant, chem_buttons[chem], volume)//emag effect kicks in here so that the "intended" chem is used for all checks, for extra FUUU
		if(user)
			log_combat(user, occupant, "injected [chem] into", addition = "via [src]")
		return TRUE

/obj/machinery/reagent_sleeper/proc/chem_allowed(chem)
	var/mob/living/mob_occupant = occupant
	if(!mob_occupant || !mob_occupant.reagents)
		return
	var/amount = mob_occupant.reagents.get_reagent_amount(chem) + 10 <= 20 * efficiency
	var/occ_health = mob_occupant.health > min_health || chem == "epinephrine"
	return amount && occ_health

/obj/machinery/reagent_sleeper/proc/reset_chem_buttons()
	scrambled_chems = FALSE
	LAZYINITLIST(chem_buttons)
	for(var/chem in available_chems)
		chem_buttons[chem] = chem

/obj/machinery/reagent_sleeper/proc/scramble_chem_buttons()
	scrambled_chems = TRUE
	var/list/av_chem = available_chems.Copy()
	for(var/chem in av_chem)
		chem_buttons[chem] = pick_n_take(av_chem) //no dupes, allow for random buttons to still be correct
