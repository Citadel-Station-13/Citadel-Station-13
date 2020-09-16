/obj/machinery/poweredfans
	icon = 'icons/obj/poweredfans.dmi'
	icon_state = "mfan_powered"
	name = "micro powered fan"
	desc = "A handmade fan, releasing a thin gust of air."
	use_power = ACTIVE_POWER_USE
	idle_power_usage = 5
	active_power_usage = 10
	layer = ABOVE_NORMAL_TURF_LAYER
	anchored = TRUE
	density = FALSE
	CanAtmosPass = ATMOS_PASS_NO
	var/obj/structure/fan_assembly/assembly = null

/obj/machinery/poweredfans/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(disassembled)
			if(!assembly)
				assembly = new()
			assembly.forceMove(drop_location())
			assembly.state = 2
			assembly.setAnchored(TRUE)
			assembly.setDir(dir)
			assembly = null
			new /obj/item/stack/cable_coil(loc, 2)
		else
			new /obj/structure/fan_assembly (loc)
			new /obj/item/stack/cable_coil(loc, 2)
	qdel(src)

/obj/machinery/poweredfans/wirecutter_act(mob/living/user, obj/item/I)
	user.visible_message("<span class='warning'>[user] removes the wires from the [src].</span>",
		"<span class='notice'>You start to remove the wires from the [src]...</span>", "You hear clanking and banging noises.")
	if(I.use_tool(src, user, 30, volume=50))
		deconstruct()
	return TRUE

/obj/machinery/poweredfans/Initialize(mapload, obj/structure/fan_assembly/FA)
	. = ..()
	if(FA)
		assembly = FA
	else
		assembly = new(src)
		assembly.state = 3
	air_update_turf(1)

/obj/machinery/poweredfans/power_change()
	..()
	update_icon()

/obj/machinery/poweredfans/update_icon()
	//if(state & NOPOWER)
	if(powered())
		icon_state = "mfan_powered"
		CanAtmosPass = ATMOS_PASS_NO
		air_update_turf(1)
		return
	else
		icon_state = "mfan_unpowered"
		CanAtmosPass = ATMOS_PASS_YES
		air_update_turf(1)
		return
