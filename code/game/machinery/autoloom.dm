// like a recycler, but for plants only ig
/obj/machinery/autoloom
	name = "autoloom"
	desc = "A large processing machine used to process raw biological matter, like cotton or logs. It also looks like a recycler. There's a display on the side."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "grinder-o0"
	layer = ABOVE_ALL_MOB_LAYER // Overhead
	density = TRUE
	circuit = /obj/item/circuitboard/machine/autoloom
	var/icon_name = "grinder-o"
	var/eat_dir = WEST
	var/process_efficiency = 0
	var/static/list/can_process = typecacheof(list(
		/obj/item/stack/sheet/cotton,
		/obj/item/grown/log,
		/obj/item/grown/cotton
	))

/obj/machinery/autoloom/RefreshParts()
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		process_efficiency = M.rating

/obj/machinery/recycler/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Biomatter processing efficiency at <b>[amount_produced*100]%</b>.</span>"

/obj/machinery/autoloom/power_change()
	..()
	update_icon()

/obj/machinery/autoloom/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "grinder-oOpen", "grinder-o0", I))
		return

	if(default_pry_open(I))
		return

	if(default_unfasten_wrench(user, I))
		return

	if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/autoloom/update_icon_state()
	var/is_powered = !(machine_stat & (BROKEN|NOPOWER))
	icon_state = icon_name + "[is_powered]" // add the blood tag at the end

/obj/machinery/autoloom/CanPass(atom/movable/AM)
	. = ..()
	if(!anchored)
		return

	var/move_dir = get_dir(loc, AM.loc)
	if(move_dir == eat_dir)
		return TRUE

/obj/machinery/autoloom/Crossed(atom/movable/AM)
	eat(AM)
	. = ..()

/obj/machinery/autoloom/proc/eat(atom/movable/AM0, sound=TRUE)
	if(machine_stat & (BROKEN|NOPOWER))
		return
	if(!isturf(AM0.loc))
		return //I don't know how you called Crossed() but stop it.

	if(is_type_in_list(AM0, can_process))
		process_item(AM0)

/obj/machinery/autoloom/proc/process_item(obj/item/I)
	. = list()
	for(var/A in I)
		var/atom/movable/AM = A
		AM.forceMove(loc)
		if(AM.loc == loc)
			. += AM

	I.forceMove(loc)
	if(istype(I, /obj/item/grown/log))
		var/obj/item/grown/log/L = I
		var/seed_modifier = 0
		if(L.seed)
			seed_modifier = round(L.seed.potency / 25)
		new L.plank_type(src.loc, process_efficiency + seed_modifier)
		qdel(L)
		return

	if(istype(I, /obj/item/stack/sheet/cotton))
		var/obj/item/stack/sheet/cotton/RS = I
		var/tomake = round((RS.amount / 4) * process_efficiency)
		new RS.loom_result(src.loc, tomake)
		qdel(RS)
		return

	if(istype(I, /obj/item/grown/cotton))
		var/obj/item/grown/cotton/RC = I
		var/cottonAmt = 1 + round(RC.seed.potency / 25)
		var/newRaw = new RC.cotton_type(src.loc, cottonAmt)
		qdel(RC)
		process_item(newRaw)
		return
