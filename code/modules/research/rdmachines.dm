

//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.


/obj/machinery/r_n_d
	name = "R&D Device"
	icon = 'icons/obj/machines/research.dmi'
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	var/busy = FALSE
	var/hacked = FALSE
<<<<<<< HEAD
	var/disabled = 0
=======
	var/console_link = TRUE		//allow console link.
	var/requires_console = TRUE
	var/disabled = FALSE
>>>>>>> 1f32d16... Automatic changelog compile, [ci skip] (#33393)
	var/shocked = FALSE
	var/obj/machinery/computer/rdconsole/linked_console
	var/obj/item/loaded_item = null //the item loaded inside the machine (currently only used by experimentor and destructive analyzer)

/obj/machinery/r_n_d/Initialize()
	. = ..()
	wires = new /datum/wires/r_n_d(src)

/obj/machinery/r_n_d/Destroy()
	QDEL_NULL(wires)
	return ..()

/obj/machinery/r_n_d/proc/shock(mob/user, prb)
	if(stat & (BROKEN|NOPOWER))		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0
	do_sparks(5, TRUE, src)
	if (electrocute_mob(user, get_area(src), src, 0.7, TRUE))
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
	if(is_open_container() && O.is_open_container())
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
		to_chat(user, "<span class='warning'>You can't load [src] while it's opened!</span>")
<<<<<<< HEAD
		return
	if (disabled)
		return
	if (!linked_console) // Try to auto-connect to new RnD consoles nearby.
		for(var/obj/machinery/computer/rdconsole/console in oview(3, src))
			if(console.first_use)
				console.SyncRDevices()

		if(!linked_console)
			to_chat(user, "<span class='warning'>[src] must be linked to an R&D console first!</span>")
			return
	if (busy)
=======
		return FALSE
	if(disabled)
		return FALSE
	if(requires_console && !linked_console)
		to_chat(user, "<span class='warning'>[src] must be linked to an R&D console first!</span>")
		return FALSE
	if(busy)
>>>>>>> 1f32d16... Automatic changelog compile, [ci skip] (#33393)
		to_chat(user, "<span class='warning'>[src] is busy right now.</span>")
		return FALSE
	if(stat & BROKEN)
		to_chat(user, "<span class='warning'>[src] is broken.</span>")
		return FALSE
	if(stat & NOPOWER)
		to_chat(user, "<span class='warning'>[src] has no power.</span>")
		return FALSE
	if(loaded_item)
		to_chat(user, "<span class='warning'>[src] is already loaded.</span>")
<<<<<<< HEAD
		return
	return 1
=======
		return FALSE
	return TRUE
>>>>>>> 1f32d16... Automatic changelog compile, [ci skip] (#33393)

//we eject the loaded item when deconstructing the machine
/obj/machinery/r_n_d/on_deconstruction()
	if(loaded_item)
		loaded_item.forceMove(loc)
	..()

/obj/machinery/r_n_d/proc/AfterMaterialInsert(type_inserted, id_inserted, amount_inserted)
	var/stack_name
	if(ispath(type_inserted, /obj/item/ore/bluespace_crystal))
		stack_name = "bluespace"
		use_power(MINERAL_MATERIAL_AMOUNT / 10)
	else
		var/obj/item/stack/S = type_inserted
		stack_name = initial(S.name)
		use_power(max(1000, (MINERAL_MATERIAL_AMOUNT * amount_inserted / 10)))
	add_overlay("protolathe_[stack_name]")
	addtimer(CALLBACK(src, /atom/proc/cut_overlay, "protolathe_[stack_name]"), 10)
