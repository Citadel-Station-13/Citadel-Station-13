/obj/machinery/plumbing/fermenter
	name = "chemical fermenter"
	desc = "Turns plants into various types of booze."
	icon_state = "fermenter"
	layer = ABOVE_ALL_MOB_LAYER

	reagent_flags = TRANSPARENT | DRAINABLE
	rcd_cost = 30
	rcd_delay = 30
	buffer = 400

	///input dir
	var/eat_dir = SOUTH

/obj/machinery/plumbing/fermenter/Initialize(mapload, bolt, layer)
	. = ..()
	AddComponent(/datum/component/plumbing/simple_supply, bolt, layer)

/obj/machinery/plumbing/fermenter/can_be_rotated(mob/user, rotation_type)
	if(anchored)
		to_chat(user, "<span class='warning'>It is fastened to the floor!</span>")
		return FALSE
	return TRUE

/obj/machinery/plumbing/fermenter/setDir(newdir)
	. = ..()
	eat_dir = newdir

/obj/machinery/plumbing/fermenter/CanPass(atom/movable/AM)
	. = ..()
	if(!anchored)
		return
	var/move_dir = get_dir(loc, AM.loc)
	if(move_dir == eat_dir)
		return TRUE

/obj/machinery/plumbing/fermenter/Crossed(atom/movable/AM)
	. = ..()
	ferment(AM)

/// uses fermentation proc similar to fermentation barrels
/obj/machinery/plumbing/fermenter/proc/ferment(atom/AM)
	if(machine_stat & NOPOWER)
		return
	if(reagents.holder_full())
		return
	if(!isitem(AM))
		return
	if(istype(AM, /obj/item/reagent_containers/food/snacks/grown))
		var/obj/item/reagent_containers/food/snacks/grown/G = AM
		if(G.distill_reagent)
			var/amount = G.seed.potency * 0.25
			reagents.add_reagent(G.distill_reagent, amount)
			qdel(G)
