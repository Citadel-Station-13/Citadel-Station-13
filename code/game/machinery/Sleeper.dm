/obj/machinery/sleep_console
	name = "sleeper console"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "console"
	density = FALSE
	anchored = TRUE

/obj/machinery/sleeper
	name = "sleeper"
	desc = "An enclosed machine used to stabilize and heal patients."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper"
	density = FALSE
	anchored = TRUE
	state_open = TRUE
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

/obj/machinery/sleeper/New()
	..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/sleeper(null)
	B.apply_default_parts(src)
	update_icon()
	reset_chem_buttons()

/obj/item/weapon/circuitboard/machine/sleeper
	name = "Sleeper (Machine Board)"
	build_path = /obj/machinery/sleeper
	origin_tech = "programming=3;biotech=2;engineering=3"
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/stack/sheet/glass = 1)

/obj/machinery/sleeper/RefreshParts()
	var/E
	for(var/obj/item/weapon/stock_parts/matter_bin/B in component_parts)
		E += B.rating
	var/I
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		I += M.rating

	efficiency = initial(efficiency)* E
	min_health = initial(min_health) * E
	available_chems = list()
	for(var/i in 1 to I)
		available_chems |= possible_chems[i]
	reset_chem_buttons()

/obj/machinery/sleeper/update_icon()
	icon_state = initial(icon_state)
	if(state_open)
		icon_state += "-open"

/obj/machinery/sleeper/container_resist(mob/living/user)
	visible_message("<span class='notice'>[occupant] emerges from [src]!</span>",
		"<span class='notice'>You climb out of [src]!</span>")
	open_machine()

/obj/machinery/sleeper/relaymove(mob/user)
	container_resist(user)

/obj/machinery/sleeper/open_machine()
	if(!state_open && !panel_open)
		..()

/obj/machinery/sleeper/close_machine(mob/user)
	if((isnull(user) || istype(user)) && state_open && !panel_open)
		..(user)
		if(occupant && occupant.stat != DEAD)
			to_chat(occupant, "<span class='notice'><b>You feel cool air surround you. You go numb as your senses turn inward.</b></span>")

/obj/machinery/sleeper/emp_act(severity)
	if(is_operational() && occupant)
		open_machine()
	..(severity)

/obj/machinery/sleeper/MouseDrop_T(mob/target, mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !user.Adjacent(target) || !iscarbon(target) || !user.IsAdvancedToolUser())
		return
	close_machine(target)

/obj/machinery/sleeper/attackby(obj/item/I, mob/user, params)
	if(!state_open && !occupant)
		if(default_deconstruction_screwdriver(user, "[initial(icon_state)]-o", initial(icon_state), I))
			return
	if(default_change_direction_wrench(user, I))
		return
	if(exchange_parts(user, I))
		return
	if(default_pry_open(I))
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/sleeper/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, \
									datum/tgui/master_ui = null, datum/ui_state/state = GLOB.notcontained_state)

	if(controls_inside && state == GLOB.notcontained_state)
		state = GLOB.default_state // If it has a set of controls on the inside, make it actually controllable by the mob in it.

	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "sleeper", name, 375, 550, master_ui, state)
		ui.open()

/obj/machinery/sleeper/ui_data()
	var/list/data = list()
	data["occupied"] = occupant ? 1 : 0
	data["open"] = state_open

	data["chems"] = list()
	for(var/chem in available_chems)
		var/datum/reagent/R = GLOB.chemical_reagents_list[chem]
		data["chems"] += list(list("name" = R.name, "id" = R.id, "allowed" = chem_allowed(chem)))

	data["occupant"] = list()
	if(occupant)
		data["occupant"]["name"] = occupant.name
		data["occupant"]["stat"] = occupant.stat
		data["occupant"]["health"] = occupant.health
		data["occupant"]["maxHealth"] = occupant.maxHealth
		data["occupant"]["minHealth"] = HEALTH_THRESHOLD_DEAD
		data["occupant"]["bruteLoss"] = occupant.getBruteLoss()
		data["occupant"]["oxyLoss"] = occupant.getOxyLoss()
		data["occupant"]["toxLoss"] = occupant.getToxLoss()
		data["occupant"]["fireLoss"] = occupant.getFireLoss()
		data["occupant"]["cloneLoss"] = occupant.getCloneLoss()
		data["occupant"]["brainLoss"] = occupant.getBrainLoss()
		data["occupant"]["reagents"] = list()
		if(occupant.reagents.reagent_list.len)
			for(var/datum/reagent/R in occupant.reagents.reagent_list)
				data["occupant"]["reagents"] += list(list("name" = R.name, "volume" = R.volume))
	return data

/obj/machinery/sleeper/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("door")
			if(state_open)
				close_machine()
			else
				open_machine()
			. = TRUE
		if("inject")
			var/chem = params["chem"]
			if(!is_operational() || !occupant)
				return
			if(occupant.health < min_health && chem != "epinephrine")
				return
			if(inject_chem(chem))
				. = TRUE
				if(scrambled_chems && prob(5))
					to_chat(usr, "<span class='warning'>Chem System Re-route detected, results may not be as expected!</span>")

/obj/machinery/sleeper/emag_act(mob/user)
	scramble_chem_buttons()
	to_chat(user, "<span class='warning'>You scramble the sleepers user interface!</span>")

/obj/machinery/sleeper/proc/inject_chem(chem)
	if((chem in available_chems) && chem_allowed(chem))
		occupant.reagents.add_reagent(chem_buttons[chem], 10) //emag effect kicks in here so that the "intended" chem is used for all checks, for extra FUUU
		return TRUE

/obj/machinery/sleeper/proc/chem_allowed(chem)
	if(!occupant)
		return
	var/amount = occupant.reagents.get_reagent_amount(chem) + 10 <= 20 * efficiency
	var/occ_health = occupant.health > min_health || chem == "epinephrine"
	return amount && occ_health

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


/obj/machinery/sleeper/old
	icon_state = "oldpod"
