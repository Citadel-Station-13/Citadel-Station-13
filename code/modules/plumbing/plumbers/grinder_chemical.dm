/obj/machinery/plumbing/grinder_chemical
	name = "chemical grinder"
	desc = "chemical grinder."
	icon_state = "grinder_chemical"
	layer = ABOVE_ALL_MOB_LAYER
	reagent_flags = TRANSPARENT | DRAINABLE
	rcd_cost = 30
	rcd_delay = 30
	buffer = 400
	var/eat_dir = NORTH

/obj/machinery/plumbing/grinder_chemical/Initialize(mapload, bolt)
	. = ..()
	AddComponent(/datum/component/plumbing/simple_supply, bolt)

/obj/machinery/plumbing/grinder_chemical/examine(mob/user)
	. = ..()
	. += span_notice("The input direction for this item can be rotated by using CTRL+SHIFT+CLICK")

/obj/machinery/plumbing/grinder_chemical/CtrlShiftClick(mob/user)
	if(anchored)
		to_chat(user, "<span class='warning'>It is fastened to the floor!</span>")
		return FALSE

	switch(eat_dir)
		if(WEST)
			balloon_alert(user, "set to north")
			eat_dir = NORTH
			return TRUE
		if(EAST)
			balloon_alert(user, "set to south")
			eat_dir = SOUTH
			return TRUE
		if(NORTH)
			balloon_alert(user, "set to east")
			eat_dir = EAST
			return TRUE
		if(SOUTH)
			balloon_alert(user, "set to west")
			eat_dir = WEST
			return TRUE

	return TRUE

/obj/machinery/plumbing/grinder_chemical/CanAllowThrough(atom/movable/AM)
	. = ..()
	if(!anchored)
		return

	var/move_dir = get_dir(loc, AM.loc)
	if(move_dir == eat_dir)
		return TRUE

/obj/machinery/plumbing/grinder_chemical/Crossed(atom/movable/AM)
	. = ..()
	grind(AM)

/obj/machinery/plumbing/grinder_chemical/proc/grind(atom/AM)
	if(machine_stat & NOPOWER)
		return
	if(reagents.holder_full())
		return
	if(!isitem(AM))
		return
	var/obj/item/I = AM
	if(I.juice_results || I.grind_results)
		if(I.juice_results)
			I.on_juice()
			reagents.add_reagent_list(I.juice_results)
			if(I.reagents)
				I.reagents.trans_to(src, I.reagents.total_volume)
			qdel(I)
			return
		I.on_grind()
		reagents.add_reagent_list(I.grind_results)

		if(I.reagents) //If the thing has any reagents inside of it, grind them up.
			I.reagents.trans_to(reagents, I.reagents.total_volume)

		qdel(I)
