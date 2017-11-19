

//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.


/obj/machinery/rnd
	name = "R&D Device"
	icon = 'icons/obj/machines/research.dmi'
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	var/busy = FALSE
	var/hacked = FALSE
	var/disabled = FALSE
	var/shocked = FALSE
	var/obj/machinery/computer/rdconsole/linked_console
	var/obj/item/loaded_item = null //the item loaded inside the machine (currently only used by experimentor and destructive analyzer)

/obj/machinery/rnd/proc/reset_busy()
	busy = FALSE

/obj/machinery/rnd/Initialize()
	. = ..()
	wires = new /datum/wires/rnd(src)

/obj/machinery/rnd/Destroy()
	QDEL_NULL(wires)
	return ..()

/obj/machinery/rnd/proc/shock(mob/user, prb)
	if(stat & (BROKEN|NOPOWER))		// unpowered, no shock
		return FALSE
	if(!prob(prb))
		return FALSE
	do_sparks(5, TRUE, src)
	if (electrocute_mob(user, get_area(src), src, 0.7, TRUE))
		return TRUE
	else
		return FALSE

/obj/machinery/rnd/attack_hand(mob/user)
	if(shocked)
		if(shock(user,50))
			return
	if(panel_open)
		wires.interact(user)



/obj/machinery/rnd/attackby(obj/item/O, mob/user, params)
	if (shocked)
		if(shock(user,50))
			return TRUE
	if (default_deconstruction_screwdriver(user, "[initial(icon_state)]_t", initial(icon_state), O))
		if(linked_console)
			disconnect_console()
		return
	if(exchange_parts(user, O))
		return
	if(default_deconstruction_crowbar(O))
		return
	if(is_open_container() && O.is_open_container())
		return FALSE //inserting reagents into the machine
	if(Insert_Item(O, user))
		return TRUE
	else
		return ..()

//to disconnect the machine from the r&d console it's linked to
/obj/machinery/rnd/proc/disconnect_console()
	linked_console = null

//proc used to handle inserting items or reagents into rnd machines
/obj/machinery/rnd/proc/Insert_Item(obj/item/I, mob/user)
	return

//whether the machine can have an item inserted in its current state.
/obj/machinery/rnd/proc/is_insertion_ready(mob/user)
	if(panel_open)
		to_chat(user, "<span class='warning'>You can't load [src] while it's opened!</span>")
		return
	if (disabled)
		return
	if (!linked_console) // Try to auto-connect to new RnD consoles nearby.
		if(!linked_console)
			to_chat(user, "<span class='warning'>[src] must be linked to an R&D console first!</span>")
			return
	if (busy)
		to_chat(user, "<span class='warning'>[src] is busy right now.</span>")
		return
	if(stat & BROKEN)
		to_chat(user, "<span class='warning'>[src] is broken.</span>")
		return
	if(stat & NOPOWER)
		to_chat(user, "<span class='warning'>[src] has no power.</span>")
		return
	if(loaded_item)
		to_chat(user, "<span class='warning'>[src] is already loaded.</span>")
		return
	return TRUE


//we eject the loaded item when deconstructing the machine
/obj/machinery/rnd/on_deconstruction()
	if(loaded_item)
		loaded_item.forceMove(loc)
	..()
