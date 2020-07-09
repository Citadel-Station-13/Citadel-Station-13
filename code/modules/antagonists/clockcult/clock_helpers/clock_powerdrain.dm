//horrifying power drain proc made for clockcult's power drain in lieu of six istypes or six for(x in view) loops
/atom/movable/proc/power_drain(clockcult_user, drain_weapons = FALSE) //This proc as of now is only in use for void volt
	var/obj/item/stock_parts/cell/cell = get_cell()
	if(cell)
		return cell.power_drain(clockcult_user)
	return 0 //Returns 0 instead of FALSE to symbolise it returning the power amount in other cases, not TRUE aka 1

/obj/item/melee/baton/power_drain(clockcult_user, drain_weapons = FALSE)	//balance memes
	if(!drain_weapons)
		return 0
	return ..()

/obj/item/gun/power_drain(clockcult_user, drain_weapons = FALSE)	//balance memes
	if(!drain_weapons)
		return 0
	var/obj/item/stock_parts/cell/cell = get_cell()
	if(!cell)
		return 0
	if(cell.charge)
		. = min(cell.charge, MIN_CLOCKCULT_POWER*4) //Done snowflakey because guns have far smaller cells than batons / other equipment
		cell.use(.)
		update_icon()

/obj/machinery/power/apc/power_drain(clockcult_user, drain_weapons = FALSE)
	if(cell && cell.charge)
		playsound(src, "sparks", 50, 1)
		flick("apc-spark", src)
		. = min(cell.charge, MIN_CLOCKCULT_POWER*4)
		cell.use(.) //Better than a power sink!
		if(!cell.charge && !shorted)
			shorted = 1
			visible_message("<span class='warning'>The [name]'s screen blurs with static.</span>")
		update()
		update_icon()

/obj/machinery/power/smes/power_drain(clockcult_user, drain_weapons = FALSE)
	if(charge)
		. = min(charge, MIN_CLOCKCULT_POWER*4)
		charge -= . * 50
		if(!charge && !panel_open)
			panel_open = TRUE
			icon_state = "[initial(icon_state)]-o"
			do_sparks(10, FALSE, src)
			visible_message("<span class='warning'>[src]'s panel flies open with a flurry of sparks!</span>")
		update_icon()

/obj/item/stock_parts/cell/power_drain(clockcult_user, drain_weapons = FALSE)
	if(charge)
		. = min(charge, MIN_CLOCKCULT_POWER * 4) //Done like this because normal cells are usually quite a bit bigger than the ones used in guns / APCs
		use(min(charge, . * 10)) //Usually cell-powered equipment that is not a gun has at least ten times the capacity of a gun / 5 times the amount of an APC. This adjusts the drain to account for that.
		update_icon()

/mob/living/silicon/robot/power_drain(clockcult_user, drain_weapons = FALSE)
	if((!clockcult_user || !is_servant_of_ratvar(src)) && cell && cell.charge)
		. = min(cell.charge, MIN_CLOCKCULT_POWER*4)
		cell.use(.)
		spark_system.start()

/obj/mecha/power_drain(clockcult_user, drain_weapons = FALSE)
	if((!clockcult_user || (occupant && !is_servant_of_ratvar(occupant))) && cell && cell.charge)
		. = min(cell.charge, MIN_CLOCKCULT_POWER*4)
		cell.use(.)
		spark_system.start()
