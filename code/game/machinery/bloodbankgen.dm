/obj/machinery/bloodbankgen
	name = "blood bank generator"
	desc = "Generates universally applicable synthetics for all blood types. Add regular blood to convert."
	icon = 'icons/obj/bloodbank.dmi'
	icon_state = "bloodbank-off"
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 80
	circuit = /obj/item/circuitboard/machine/bloodbankgen
	interaction_flags_machine = INTERACT_MACHINE_OPEN | INTERACT_MACHINE_ALLOW_SILICON
	var/draining = FALSE
	var/filling = FALSE
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
					filling_overlay.icon_state = "output-reagent0"
				if(10 to 24)
					filling_overlay.icon_state = "output-reagent10"
				if(25 to 49)
					filling_overlay.icon_state = "output-reagent25"
				if(50 to 74)
					filling_overlay.icon_state = "output-reagent50"
				if(75 to 79)
					filling_overlay.icon_state = "output-reagent75"
				if(80 to 90)
					filling_overlay.icon_state = "output-reagent80"
				if(91 to INFINITY)
					filling_overlay.icon_state = "output-reagent100"

			filling_overlay.color = list(mix_color_from_reagents(outbag.reagents.reagent_list))
			add_overlay(filling_overlay)
	return

/obj/machinery/bloodbankgen/process()
	if(!is_operational())
		return PROCESS_KILL

	bloodstored = reagents.total_volume

	var/transfer_amount = 20

	if(draining)
		if(reagents.total_volume >= reagents.maximum_volume)
			draining = FALSE
			return

		if(bag)
			if(bag.reagents.total_volume)
				var/datum/reagent/blood/B = bag.reagents.has_reagent("blood")
				if(B)
					var/amount = reagents.maximum_volume - reagents.total_volume //monitor the machine's internal storage
					amount = min(amount, transfer_amount)
					if(!amount)
						draining = FALSE
						updateUsrDialog()
						visible_message("[src] beeps loudly.")
						playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
						return

					if(bag.blood_type == "SY") //no infinite loops using synthetics.
						reagents.add_reagent("syntheticblood", amount)
					else
						reagents.add_reagent("syntheticblood", (amount+(5*efficiency)))

					if(bag.reagents.total_volume >= amount)
						bag.reagents.remove_reagent("blood", amount)
					else
						visible_message("[src] beeps loudly.")
						playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
						draining = FALSE

					bag.update_icon()
					update_icon()
					updateUsrDialog()
		else
			draining = FALSE
			updateUsrDialog()
			return

	if(filling)
		if(!reagents || !reagents.total_volume)
			filling = FALSE //there ain't anything in the machine yo.
			return
		if(outbag && outbag.reagents.total_volume < outbag.reagents.maximum_volume)
			var/amount = outbag.reagents.maximum_volume - outbag.reagents.total_volume //monitor the output bag's internal storage
			amount = min(amount, transfer_amount)
			if(!amount)
				filling = FALSE
				visible_message("[src] pings.")
				playsound(loc, 'sound/machines/beep.ogg', 50, 1)
				updateUsrDialog()
				return

			reagents.trans_to(outbag, amount)
			outbag.update_icon()
			update_icon()
			updateUsrDialog()
		else
			visible_message("[src] pings.")
			playsound(loc, 'sound/machines/beep.ogg', 50, 1)
			filling = FALSE
			updateUsrDialog()
			return

/obj/machinery/bloodbankgen/attackby(obj/item/O, mob/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()

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

			if(!bag && !outbag)
				var/choice = alert(user, "Choose where to place [O]", "", "Input", "Cancel", "Output")
				switch(choice)
					if("Cancel")
						return FALSE
					if("Input")
						attachinput(O, user)
					if("Output")
						attachoutput(O, user)
			else if(!bag)
				attachinput(O, user)
			else if(!outbag)
				attachoutput(O, user)
		else
			to_chat(user, "<span class='warning'>Close the maintenance panel first.</span>")
		return

	else
		to_chat(user, "<span class='warning'>You cannot put this in [src]!</span>")

/obj/machinery/bloodbankgen/ui_interact(mob/user)
	. = ..()

	if(!is_operational())
		return

	var/dat
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

	dat+= "<br><B>Current Synthetics stockpile: [reagents.total_volume] units.</B><HR>"

	dat += "<br>Supply Bag<HR>"
	if(bag)
		dat += "<br>Current Capacity: [bag.reagents.total_volume] of [bag.reagents.maximum_volume]"
		if(bag.reagents && bag.reagents.total_volume)
			dat += "<br><a href='?src=\ref[src];activateinput=1'>Drain</a>"

		dat += "<br><a href='?src=\ref[src];detachinput=1'>Detach</a>"


	dat += "<br><br>Synthetics Bag<HR>"
	if(outbag)
		dat += "<br>Current Capacity:[outbag.reagents.total_volume] of [outbag.reagents.maximum_volume]"
		if(!(outbag.reagents.total_volume >= outbag.reagents.maximum_volume))
			dat += "<br><a href='?src=\ref[src];activateoutput=1'>Fill</a>"
		dat += "<br><a href='?src=\ref[src];detachoutput=1'>Detach</a>"

	if(!bag && !outbag)
		dat += "<div class='statusDisplay'>No containers inside, please insert container.</div>"

	var/datum/browser/popup = new(user, "bloodbankgen", name, 350, 520)
	popup.set_content(dat)
	popup.open()

/obj/machinery/bloodbankgen/proc/activateinput()
	if(bag)
		draining = TRUE
		update_icon()
	else
		to_chat(usr, "<span class='warning'>There is no blood bag in the input slot.</span>")
		return

/obj/machinery/bloodbankgen/proc/activateoutput()
	if(outbag)
		filling = TRUE
		update_icon()
	else
		to_chat(usr, "<span class='warning'>There is no blood bag in the output slot.</span>")
		return

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
		if(usr && Adjacent(usr) && !issiliconoradminghost(usr))
			usr.put_in_hands(bag)
		bag = null
		update_icon()

/obj/machinery/bloodbankgen/proc/detachoutput()
	if(outbag)
		outbag.forceMove(drop_location())
		if(usr && Adjacent(usr) && !issiliconoradminghost(usr))
			usr.put_in_hands(outbag)
		outbag = null
		update_icon()

/obj/machinery/bloodbankgen/proc/attachinput(obj/item/O, mob/user)
	if(!bag)
		if(!user.transferItemToLoc(O, src))
			return
		bag = O
		to_chat(user, "<span class='notice'>You add [O] to the machine's input slot.</span>")
		update_icon()
		updateUsrDialog()
	else
		to_chat(user, "<span class='notice'>There is already something in this slot!</span>")

/obj/machinery/bloodbankgen/proc/attachoutput(obj/item/O, mob/user)
	if(!outbag)
		if(!user.transferItemToLoc(O, src))
			return
		outbag = O
		to_chat(user, "<span class='notice'>You add [O] to the machine's output slot.</span>")
		update_icon()
		updateUsrDialog()
	else
		to_chat(user, "<span class='notice'>There is already something in this slot!</span>")

/obj/machinery/bloodbankgen/Topic(href, href_list)
	if(..() || panel_open)
		return

	usr.set_machine(src)

	if(href_list["activateinput"])
		activateinput()
		updateUsrDialog()

	else if(href_list["detachinput"])
		detachinput()
		updateUsrDialog()

	else if(href_list["activateoutput"])
		activateoutput()
		updateUsrDialog()

	else if(href_list["detachoutput"])
		detachoutput()
		updateUsrDialog()
