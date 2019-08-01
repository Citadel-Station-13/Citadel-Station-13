/obj/machinery/bloodbankgen
	name = "blood bank generator"
	desc = "Generates universally applicable synthetics for all blood types. Add regular blood to convert quickly."
	icon = 'icons/obj/machines/biogenerator.dmi'
	icon_state = "bloodbank-off"
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 80
	circuit = /obj/item/circuitboard/machine/bloodbankgen
	var/processing = FALSE
	var/obj/item/reagent_containers/blood/bag = null
	var/obj/item/reagent_containers/blood/outbag = null
	var/bloodstored = 0
	var/maxbloodstored = 1000
	var/menustat = "menu"
	var/efficiency = 0
	var/productivity = 0

/obj/machinery/bloodbankgen/Initialize()
	. = ..()
	create_reagents(1000)
	update_icon()

/obj/machinery/bloodbankgen/Destroy()
	QDEL_NULL(bag)
	QDEL_NULL(outbag)
	return ..()

/obj/machinery/bloodbankgen/contents_explosion(severity, target)
	..()
	if(bag)
		bag.ex_act(severity, target)
	if(outbag)
		outbag.ex_act(severity, target)

/obj/machinery/bloodbankgen/handle_atom_del(atom/A)
	..()
	if(A == bag)
		bag = null
		update_icon()
		updateUsrDialog()
	if(A == outbag)
		outbag = null
		update_icon()
		updateUsrDialog()

/obj/machinery/bloodbankgen/RefreshParts()
	var/E = 0
	var/P = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		E += M.rating
	efficiency = E
	productivity = P

/obj/machinery/bloodbankgen/update_icon()
	cut_overlays()
	if(is_operational())
		icon_state = "bloodbank-on"

	if(panel_open)
		add_overlay("bloodbank-panel")

	if(src.bag)
		add_overlay("bloodbag-input")
		if(bag.reagents.total_volume)
			var/mutable_appearance/filling_overlay = mutable_appearance(icon, "input-reagent")

			var/percent = round((bag.reagents.total_volume / bag.volume) * 100)
			switch(percent)
				if(0 to 9)
					filling_overlay.icon_state = "input-reagent0"
				if(10 to 24)
					filling_overlay.icon_state = "input-reagent10"
				if(25 to 49)
					filling_overlay.icon_state = "input-reagent25"
				if(50 to 74)
					filling_overlay.icon_state = "input-reagent50"
				if(75 to 79)
					filling_overlay.icon_state = "input-reagent75"
				if(80 to 90)
					filling_overlay.icon_state = "input-reagent80"
				if(91 to INFINITY)
					filling_overlay.icon_state = "input-reagent100"

			filling_overlay.color = list(mix_color_from_reagents(bag.reagents.reagent_list))
			add_overlay(filling_overlay)

	if(src.outbag)
		add_overlay("bloodbag-output")
		if(outbag.reagents.total_volume)
			var/mutable_appearance/filling_overlay = mutable_appearance(icon, "output-reagent")

			var/percent = round((outbag.reagents.total_volume / outbag.volume) * 100)
			switch(percent)
				if(0 to 9)
					filling_overlay.icon_state = "input-reagent0"
				if(10 to 24)
					filling_overlay.icon_state = "input-reagent10"
				if(25 to 49)
					filling_overlay.icon_state = "input-reagent25"
				if(50 to 74)
					filling_overlay.icon_state = "input-reagent50"
				if(75 to 79)
					filling_overlay.icon_state = "input-reagent75"
				if(80 to 90)
					filling_overlay.icon_state = "input-reagent80"
				if(91 to INFINITY)
					filling_overlay.icon_state = "input-reagent100"

			filling_overlay.color = list(mix_color_from_reagents(outbag.reagents.reagent_list))
			add_overlay(filling_overlay)
	return

/obj/machinery/bloodbankgen/process()
	if(!is_operational())
		return PROCESS_KILL

	var/transfer_amount = 20
	var/efficent_amount = ((transfer_amount * 0.5) * (1.5 * efficiency))
	if(bag)
		if(bag.reagents)
			var/datum/reagent/blood/B = bag.reagents.has_reagent("blood")
			if(B)
				var/amount = reagents.maximum_volume - reagents.total_volume //monitor the machine's internal storage
				amount = min(amount, 4)
				if(!amount)
					return
				var/list/bloodtypes = list("A+", "A-", "B+", "B-", "O+", "O-", "L", "X*", "HF", "GEL", "U")
				for(var/blood in bloodtypes[bag.blood_type])
					if(blood) //no infinite loops using synthetics.
						src.add_reagent("syntheticblood", efficent_amount)
					else
						src.add_reagent("syntheticblood", transfer_amount)
				bag.reagents.remove_reagent(B,transfer_amount)
				update_icon()

	if(outbag)
		var/amount = outbag.reagents.maximum_volume - outbag.reagents.total_volume //monitor the output bag's internal storage
		amount = min(amount, 4)
		if(!amount)
			return
		if(bloodstored <= 0)
			return
		reagents.trans_to(outbag, transfer_amount)
		update_icon()

/obj/machinery/bloodbankgen/attackby(obj/item/O, mob/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(processing)
		to_chat(user, "<span class='warning'>The generator is currently processing.</span>")
		return

	if(default_deconstruction_screwdriver(user, "bloodbank-off", "bloodbank-off", O))
		if(bag)
			var/obj/item/reagent_containers/blood/B = bag
			B.forceMove(drop_location())
			bag = null
		if(outbag)
			var/obj/item/reagent_containers/blood/B = outbag
			B.forceMove(drop_location())
			outbag = null
		update_icon()
		return

	if(default_deconstruction_crowbar(O))
		return

	if(istype(O, /obj/item/reagent_containers/blood))
		. = 1 //no afterattack
		if(!panel_open)
			if(bag && outbag)
				to_chat(user, "<span class='warning'>This machine already has bags attached.</span>")
			else if(!bag)
				if(!user.transferItemToLoc(O, src))
					return
				bag = O
				to_chat(user, "<span class='notice'>You add the container to the machine's input slot.</span>")
				update_icon()
				updateUsrDialog()
			else if(!outbag)
				if(!user.transferItemToLoc(O, src))
					return
				outbag = O
				to_chat(user, "<span class='notice'>You add the container to the machine's output slot.</span>")
				update_icon()
				updateUsrDialog()
		else
			to_chat(user, "<span class='warning'>Close the maintenance panel first.</span>")
		return

	else
		to_chat(user, "<span class='warning'>You cannot put this in [src.name]!</span>")

/obj/machinery/bloodbankgen/ui_interact(mob/user)
	if(stat & BROKEN || panel_open)
		return
	. = ..()
	var/dat
	if(processing)
		dat += "<div class='statusDisplay'>The blood generator is processing! Please wait...</div><BR>"
	else
		switch(menustat)
			if("noblood")
				dat += "<div class='statusDisplay'>You do not have enough blood product to create synthetics.</div>"
				menustat = "menu"
			if("complete")
				dat += "<div class='statusDisplay'>Operation complete.</div>"
				menustat = "menu"
			if("nobagspace")
				dat += "<div class='statusDisplay'>Not enough space left in container. Please replace receptical.</div>"
				menustat = "menu"
		if(bag)
			data["isBagLoaded"] = bag ? TRUE : FALSE
			var/bagContents = list()
			if(bag && bag.reagents && bag.reagents.reagent_list.len)
				for(var/datum/reagent/R in bag.reagents.reagent_list)
					bagContents += list(list("name" = R.name, "volume" = R.volume))
			data["bagContents"] = bagContents
			return data
		if(outbag)
			data["isOutbagLoaded"] = outbag ? TRUE : FALSE
			var/outbagContents = list()
			if(outbag && outbag.reagents && outbag.reagents.reagent_list.len)
				for(var/datum/reagent/R in outbag.reagents.reagent_list)
					outbagContents += list(list("name" = R.name, "volume" = R.volume))
			data["outbagContents"] = outbagContents
			return data
		else
			dat += "<div class='statusDisplay'>No containers inside, please insert container.</div>"

	var/datum/browser/popup = new(user, "bloodbank", name, 350, 520)
	popup.set_content(dat)
	popup.open()

/obj/machinery/bloodbankgen/proc/activate()
	if (usr.stat != CONSCIOUS)
		return
	if (src.stat != NONE) //NOPOWER etc
		return
	if(processing)
		to_chat(usr, "<span class='warning'>The bloodbankgen is in the process of working.</span>")
		return
	var/S = 0
	if(reagents)
		var/datum/reagent/blood/B = reagents.has_reagent("blood")
		S += 5
		if(B.reagents.get_reagent_amount("blood") < 0.1)
			bloodstored += 2*productivity
		else bloodstored += B.reagents.get_reagent_amount("nutriment")*10*productivity
		qdel(I)
	if(S)
		processing = TRUE
		update_icon()
		updateUsrDialog()
		playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
		use_power(S*30)
		sleep(S+15/productivity)
		processing = FALSE
		update_icon()
	else
		menustat = "void"

/obj/machinery/bloodbankgen/proc/check_cost(list/materials, multiplier = 1, remove_bloodstored = 1)
	if(materials.len != 1 || materials[1] != MAT_BIOMASS)
		return FALSE
	if (materials[MAT_BIOMASS]*multiplier/efficiency > bloodstored)
		menustat = "noblood"
		return FALSE
	else
		if(remove_bloodstored)
			bloodstored -= materials[MAT_BIOMASS]*multiplier/efficiency
		update_icon()
		updateUsrDialog()
		return TRUE

/obj/machinery/bloodbankgen/proc/check_container_volume(list/reagents, multiplier = 1)
	var/sum_reagents = 0
	for(var/R in reagents)
		sum_reagents += reagents[R]
	sum_reagents *= multiplier

	if(outbag.reagents.total_volume + sum_reagents > outbag.reagents.maximum_volume)
		menustat = "nobagspace"
		return FALSE

	return TRUE

/obj/machinery/bloodbankgen/proc/detachinput()
	if(bag)
		bag.forceMove(drop_location())
		bag = null
		update_icon()

/obj/machinery/bloodbankgen/proc/detachoutput()
	if(outbag)
		outbag.forceMove(drop_location())
		outbag = null
		update_icon()

/obj/machinery/bloodbankgen/Topic(href, href_list)
	if(..() || panel_open)
		return

	usr.set_machine(src)

	if(href_list["activate"])
		activate()
		updateUsrDialog()

	else if(href_list["detachinput"])
		detachinput()
		updateUsrDialog()

	else if(href_list["detachoutput"])
		detachoutput()
		updateUsrDialog()
