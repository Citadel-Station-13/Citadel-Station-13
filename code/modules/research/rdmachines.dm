//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.


/obj/machinery/r_n_d
	name = "R&D Device"
	icon = 'icons/obj/machines/research.dmi'
	density = 1
	anchored = 1
	use_power = 1
	var/busy = 0
	var/hacked = 0
	var/disabled = 0
	var/shocked = 0
	var/obj/machinery/computer/rdconsole/linked_console
	var/obj/item/loaded_item = null //the item loaded inside the machine (currently only used by experimentor and destructive analyzer)

/obj/machinery/r_n_d/New()
	..()
	wires = new /datum/wires/r_n_d(src)

/obj/machinery/r_n_d/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/r_n_d/proc/shock(mob/user, prb)
	if(stat & (BROKEN|NOPOWER))		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if (electrocute_mob(user, get_area(src), src, 0.7))
		return 1
	else
		return 0

/obj/machinery/r_n_d/attack_hand(mob/user)
	if(shocked)
		if(shock(user,50))
			return
	if(panel_open)
		wires.interact(user)



/obj/machinery/r_n_d/attackby(obj/item/O, mob/user, params)
	if (shocked)
		if(shock(user,50))
			return 1
	if (default_deconstruction_screwdriver(user, "[initial(icon_state)]_t", initial(icon_state), O))
		if(linked_console)
			disconnect_console()
		return
	if(exchange_parts(user, O))
		return
	if(default_deconstruction_crowbar(O))
		return
	if((flags & OPENCONTAINER) && O.is_open_container())
		return 0 //inserting reagents into the machine
	if(Insert_Item(O, user))
		return 1
	else
		return ..()

//to disconnect the machine from the r&d console it's linked to
/obj/machinery/r_n_d/proc/disconnect_console()
	linked_console = null

//proc used to handle inserting items or reagents into r_n_d machines
/obj/machinery/r_n_d/proc/Insert_Item(obj/item/I, mob/user)
	return

//whether the machine can have an item inserted in its current state.
/obj/machinery/r_n_d/proc/is_insertion_ready(mob/user)
	if(panel_open)
		user << "<span class='warning'>You can't load the [src.name] while it's opened!</span>"
		return
	if (disabled)
		return
	if (!linked_console) // Try to auto-connect to new RnD consoles nearby.
		for(var/obj/machinery/computer/rdconsole/console in oview(3, src))
			if(console.first_use)
				console.SyncRDevices()

		if(!linked_console)
			user << "<span class='warning'>The [name] must be linked to an R&D console first!</span>"
			return
	if (busy)
		user << "<span class='warning'>The [src.name] is busy right now.</span>"
		return
	if(stat & BROKEN)
		user << "<span class='warning'>The [src.name] is broken.</span>"
		return
	if(stat & NOPOWER)
		user << "<span class='warning'>The [src.name] has no power.</span>"
		return
	if(loaded_item)
		user << "<span class='warning'>The [src] is already loaded.</span>"
		return
	return 1


//we eject the loaded item when deconstructing the machine
/obj/machinery/r_n_d/deconstruction()
	if(loaded_item)
		loaded_item.loc = loc
	..()
