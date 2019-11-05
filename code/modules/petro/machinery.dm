#define ICG_FUEL_TICK 1 //fuel consumed a tick
#define STIRLING_FUEL_TICK 0.1

/obj/machinery/power/gasgen
	name = "internal combustion generator"
	desc = "A machine that harnesses low explosives to drive an alternator."
	icon_state = "pill_press"
	var/power_gen = 1500
	density = TRUE
	use_power = NO_POWER_USE
	circuit = /obj/item/circuitboard/machine/icg
	var/active = 0 //duh

/obj/machinery/power/gasgen/RefreshParts()
	var/part_level = 0
	for(var/obj/item/stock_parts/SP in component_parts)
		part_level += SP.rating

	power_gen = initial(power_gen) * round(part_level/4)


/obj/machinery/power/gasgen/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>[src] [active ? "is running":"isn't running"].</span>"

/obj/machinery/power/gasgen/attack_hand(mob/user)
	if(!active)
		active = 1
		START_PROCESSING(SSobj, src)
		to_chat(user, "<span class='notice'>You start up the [src].</span>"
	else
		active = 0
		STOP_PROCESSING(SSobj, src)
		to_chat(user, "<span class='notice'>You shut down the [src].</span>"


/obj/machinery/power/gasgen/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/plumbing/simple_demand)



/obj/machinery/power/gasgen/wrench_act(mob/living/user, obj/item/I)
	connect_to_network()
	default_unfasten_wrench(user, I)
	return TRUE

/obj/machinery/power/gasgen/process()
	if(reagents.total_volume >= 1)
		if(reagents.remove_reagent("gasoline", ICG_FUEL_TICK) || reagents.remove_reagent("diesel", ICG_FUEL_TICK))
			add_avail(power_gen)
		else
			active = 0
			STOP_PROCESSING(SSobj, src)
			for(var/mob/living/M in viewers(get_turf(src), null))
				M.visible_message("<span class='notice'>The [src] sputters, shudders and slides to a stop.</span>")
			take_damage(20, BRUTE, "melee", 1) //dont let it run out of fuel

/obj/machinery/power/gasgen/stirling
	name = "stirling generator"
	desc = "The pinnacle of heat-based generator technology, a stirling engine uses a differential between two temperatures to create power. Creates more power if actively cooled with water."
	icon_state = "pill_press"
	power_gen = 750 //worse off, but more optimizable
	density = TRUE
	use_power = NO_POWER_USE
	circuit = /obj/item/circuitboard/machine/stirling
	var/active = 0 //duh
	var/coolant_mult = 1

/obj/machinery/power/gasgen/stirling/RefreshParts()
	var/part_level = 0
	for(var/obj/item/stock_parts/SP in component_parts)
		part_level += SP.rating
	power_gen = initial(power_gen) * round(part_level/6)

/obj/machinery/power/gasgen/stirling/process()
	if(reagents.total_volume >= 1)
		if(reagents.remove_reagent("gasoline", STIRLING_FUEL_TICK) || reagents.remove_reagent("diesel", STIRLING_FUEL_TICK) || reagents.remove_reagent("kerosene", STIRLING_FUEL_TICK) || reagents.remove_reagent("butane", STIRLING_FUEL_TICK) ||reagents.remove_reagent("naptha", STIRLING_FUEL_TICK) || reagents.remove_reagent("fueloil", STIRLING_FUEL_TICK))
			if(reagents.remove_reagent("water", ICG_FUEL_TICK)
				coolant_mult = 1.5
			else
				coolant_mult = 1
			add_avail(power_gen*coolant_mult)
		else
			active = 0
			STOP_PROCESSING(SSobj, src)
			for(var/mob/living/M in viewers(get_turf(src), null))
				M.visible_message("<span class='notice'>The [src] sputters, shudders and slides to a stop.</span>")

#undef ICG_FUEL_TICK
#undef STIRLING_FUEL_TICK