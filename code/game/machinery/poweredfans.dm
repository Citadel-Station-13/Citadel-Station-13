/obj/machinery/poweredfans
	icon = 'icons/obj/poweredfans.dmi'
	icon_state = "mfan_powered"
	name = "placeholder big fan"
	desc = "A large machine releasing a constant gust of air."
	anchored = TRUE
	density = TRUE
	var/buildstacktype = /obj/item/stack/sheet/metal
	var/buildstackamount = 5
	CanAtmosPass = ATMOS_PASS_NO

/obj/machinery/poweredfans/mpfan
	name = "micro powered fan"
	desc = "A handmade fan, releasing a thin gust of air."
	layer = ABOVE_NORMAL_TURF_LAYER
	density = FALSE
	icon_state = "mfan_powered"
	buildstackamount = 2
	use_power = ACTIVE_POWER_USE
	idle_power_usage = 1
	active_power_usage = 3
	CanAtmosPass = ATMOS_PASS_NO

/obj/machinery/poweredfans/deconstruct()
	if(!(flags_1 & NODECONSTRUCT_1))
		if(buildstacktype)
			new buildstacktype(loc,buildstackamount)
	qdel(src)

/obj/machinery/poweredfans/wrench_act(mob/living/user, obj/item/I)
	if(flags_1 & NODECONSTRUCT_1)
		return TRUE

	user.visible_message("<span class='warning'>[user] disassembles [src].</span>",
		"<span class='notice'>You start to disassemble [src]...</span>", "You hear clanking and banging noises.")
	if(I.use_tool(src, user, 20, volume=50))
		deconstruct()
	return TRUE

/obj/machinery/poweredfans/Initialize(mapload)
	. = ..()
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
