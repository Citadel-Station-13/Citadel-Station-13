/*
horrifying power drain proc made for clockcult's power drain in lieu of six istypes or six for(x in view) loops
args:
clockcult_user: If the user / source has to do with clockcult stuff
drain_weapons: If this drains weaponry, such as batons and guns
recursive: If this recurses through mob / storage contents. ONLY USE THIS IF IT'S NOT CALLED TOO FREQUENTLY, or I'm not liable for any lag / functional issues caused
drain_amount: How much is drained by default; Influenced by a multiplier on most things depending on how much power they usually hold.
*/
/atom/movable/proc/power_drain(clockcult_user, drain_weapons = FALSE, recursive = FALSE, drain_amount = MIN_CLOCKCULT_POWER) //This proc as of now is only in use for void volt and transmission sigils
	if(recursive)
		var/succ = 0
		for(var/V in contents)
			var/atom/movable/target = V
			succ += target.power_drain(clockcult_user, drain_weapons, recursive, drain_amount)
		return succ
	var/obj/item/stock_parts/cell/cell = get_cell()
	if(cell)
		return cell.power_drain(clockcult_user, drain_weapons, recursive, drain_amount)
	return FALSE //Returns 0 instead of FALSE to symbolise it returning the power amount in other cases, not TRUE aka 1

/obj/item/melee/baton/power_drain(clockcult_user, drain_weapons = FALSE, recursive = FALSE, drain_amount = MIN_CLOCKCULT_POWER)	//balance memes
	if(!drain_weapons)
		return FALSE
	var/obj/item/stock_parts/cell/cell = get_cell()
	if(cell)
		return cell.power_drain(clockcult_user, drain_weapons, recursive, drain_amount)
	return FALSE //No need to recurse further in batons

/obj/item/gun/power_drain(clockcult_user, drain_weapons = FALSE, recursive = FALSE, drain_amount = MIN_CLOCKCULT_POWER)	//balance memes
	if(!drain_weapons)
		return FALSE
	var/obj/item/stock_parts/cell/cell = get_cell()
	if(!cell)
		return FALSE
	if(cell.charge)
		. = min(cell.charge, drain_amount*4) //Done snowflakey because guns have far smaller cells than batons / other equipment, also no need to recurse further in guns
		cell.use(.)
		update_icon()

/obj/machinery/power/apc/power_drain(clockcult_user, drain_weapons = FALSE, recursive = FALSE, drain_amount = MIN_CLOCKCULT_POWER)
	if(cell && cell.charge)
		playsound(src, "sparks", 50, 1)
		flick("apc-spark", src)
		. = min(cell.charge, drain_amount*4)
		cell.use(min(cell.charge, . * 4)) //Better than a power sink!
		if(!cell.charge && !shorted)
			shorted = 1
			visible_message("<span class='warning'>The [name]'s screen blurs with static.</span>")
		update()
		update_icon()

/obj/machinery/power/smes/power_drain(clockcult_user, drain_weapons = FALSE, recursive = FALSE, drain_amount = MIN_CLOCKCULT_POWER)
	if(charge)
		. = min(charge, drain_amount*4)
		charge -= . * 50
		if(!charge && !panel_open)
			panel_open = TRUE
			icon_state = "[initial(icon_state)]-o"
			do_sparks(10, FALSE, src)
			visible_message("<span class='warning'>[src]'s panel flies open with a flurry of sparks!</span>")
		update_icon()

/obj/item/stock_parts/cell/power_drain(clockcult_user, drain_weapons = FALSE, recursive = FALSE, drain_amount = MIN_CLOCKCULT_POWER)
	if(charge)
		. = min(charge, drain_amount * 4) //Done like this because normal cells are usually quite a bit bigger than the ones used in guns / APCs
		use(min(charge, . * 10)) //Usually cell-powered equipment that is not a gun has at least ten times the capacity of a gun / 5 times the amount of an APC. This adjusts the drain to account for that.
		update_icon()

/mob/living/silicon/robot/power_drain(clockcult_user, drain_weapons = FALSE, recursive = FALSE, drain_amount = MIN_CLOCKCULT_POWER)
	if((!clockcult_user || !is_servant_of_ratvar(src)) && cell && cell.charge)
		. = min(cell.charge, drain_amount*8) //Silicons are very susceptible to Ratvar's might
		cell.use(.)
		spark_system.start()

/obj/vehicle/sealed/mecha/power_drain(clockcult_user, drain_weapons = FALSE, recursive = FALSE, drain_amount = MIN_CLOCKCULT_POWER)
	if(!clockcult_user || LAZYLEN(occupants))
		for(var/mob/living/MB in occupants)
			if(is_servant_of_ratvar(MB))
				return
		if(recursive)
			var/succ = 0
			for(var/atom/movable/target in contents) //Hiding in your mech won't save you.
				succ += target.power_drain(clockcult_user, drain_weapons, recursive, drain_amount)
			. = succ
		else if(cell && cell.charge)
			. = min(cell.charge, drain_amount*4)
			cell.use(.)
			spark_system.start()
