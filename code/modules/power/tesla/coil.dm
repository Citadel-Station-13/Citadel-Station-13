/obj/machinery/power/tesla_coil
	name = "tesla coil"
	desc = "For the union!"
	icon = 'icons/obj/tesla_engine/tesla_coil.dmi'
	icon_state = "coil"
	anchored = 0
	density = 1
	var/power_loss = 2
	var/input_power_multiplier = 1

/obj/machinery/power/tesla_coil/New()
	..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/tesla_coil(null)
	B.apply_default_parts(src)

/obj/item/weapon/circuitboard/machine/tesla_coil
	name = "circuit board (Tesla Coil)"
	build_path = /obj/machinery/power/tesla_coil
	origin_tech = "programming=3;magnets=3;powerstorage=3"
	req_components = list(/obj/item/weapon/stock_parts/capacitor = 1)

/obj/machinery/power/tesla_coil/RefreshParts()
	var/power_multiplier = 0
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		power_multiplier += C.rating
	input_power_multiplier = power_multiplier

/obj/machinery/power/tesla_coil/attackby(obj/item/W, mob/user, params)
	if(default_deconstruction_screwdriver(user, "coil", "coil", W))
		return

	if(exchange_parts(user, W))
		return

	if(default_pry_open(W))
		return

	if(default_unfasten_wrench(user, W))
		if(!anchored)
			disconnect_from_network()
		else
			connect_to_network()
		return

	if(default_deconstruction_crowbar(W))
		return

	return ..()

/obj/machinery/power/tesla_coil/tesla_act(var/power)
	being_shocked = 1
	//don't lose arc power when it's not connected to anything
	//please place tesla coils all around the station to maximize effectiveness
	var/power_produced = powernet ? power / power_loss : power
	add_avail(power_produced*input_power_multiplier)
	flick("coilhit", src)
	playsound(src.loc, 'sound/magic/LightningShock.ogg', 100, 1, extrarange = 5)
	tesla_zap(src, 5, power_produced)
	addtimer(src, "reset_shocked", 10)

/obj/machinery/power/grounding_rod
	name = "Grounding Rod"
	desc = "Keep an area from being fried from Edison's Bane."
	icon = 'icons/obj/tesla_engine/tesla_coil.dmi'
	icon_state = "grounding_rod"
	anchored = 0
	density = 1

/obj/machinery/power/grounding_rod/New()
	..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/grounding_rod(null)
	B.apply_default_parts(src)

/obj/item/weapon/circuitboard/machine/grounding_rod
	name = "circuit board (Grounding Rod)"
	build_path = /obj/machinery/power/grounding_rod
	origin_tech = "programming=3;powerstorage=3;magnets=3;plasmatech=2"
	req_components = list(/obj/item/weapon/stock_parts/capacitor = 1)

/obj/machinery/power/grounding_rod/attackby(obj/item/W, mob/user, params)
	if(default_deconstruction_screwdriver(user, "grounding_rod", "grounding_rod", W))
		return

	if(exchange_parts(user, W))
		return

	if(default_pry_open(W))
		return

	if(default_unfasten_wrench(user, W))
		return

	if(default_deconstruction_crowbar(W))
		return

	return ..()

/obj/machinery/power/grounding_rod/tesla_act(var/power)
	flick("coil_shock_1", src)
