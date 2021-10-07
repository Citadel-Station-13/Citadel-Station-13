// like a recycler, but for plants only ig
/obj/machinery/autoloom
	name = "autoloom"
	desc = "A large processing machine used to process raw biological matter, like cotton or logs. There are lights on the side."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "grinder-o0"
	layer = ABOVE_ALL_MOB_LAYER // Overhead
	density = TRUE
	circuit = /obj/item/circuitboard/machine/autoloom
	var/icon_name = "grinder-o"
	var/eat_dir = WEST
	var/static/list/can_process = typecacheof(list(
		/obj/item/stack/sheet/cotton,
		/obj/item/grown/log
	))

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
	var/is_powered = !(stat & (BROKEN|NOPOWER))
	icon_state = icon_name + "[is_powered]" // add the blood tag at the end

/obj/machinery/autoloom/CanPass(atom/movable/AM)
	. = ..()
	if(!anchored)
		return

	var/move_dir = get_dir(loc, AM.loc)
	if(move_dir == eat_dir)
		return TRUE

/obj/machinery/autoloom/proc/eat(atom/movable/AM0, sound=TRUE)
	if(stat & (BROKEN|NOPOWER))
		return
	if(!isturf(AM0.loc))
		return //I don't know how you called Crossed() but stop it.

/obj/machinery/autoloom/proc/recycle_item(obj/item/I)

	. = list()
	for(var/A in I)
		var/atom/movable/AM = A
		AM.forceMove(loc)
		if(AM.loc == loc)
			. += AM

	I.forceMove(loc)
	var/obj/item/grown/log/L = I
	if(istype(L))
		var/seed_modifier = 0
		if(L.seed)
			seed_modifier = round(L.seed.potency / 25)
		new L.plank_type(src.loc, 1 + seed_modifier)
		qdel(L)
		return
