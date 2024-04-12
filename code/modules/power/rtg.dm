// Radioisotope Thermoelectric Generator (RTG)
// Simple power generator that would replace "magic SMES" on various derelicts.

/obj/machinery/power/rtg
	name = "radioisotope thermoelectric generator"
	desc = "A simple nuclear power generator, used in small outposts to reliably provide power for decades."
	icon = 'icons/obj/power.dmi'
	icon_state = "rtg"
	density = TRUE
	use_power = NO_POWER_USE
	circuit = /obj/item/circuitboard/machine/rtg

	// You can buckle someone to RTG, then open its panel. Fun stuff.
	can_buckle = TRUE
	buckle_lying = FALSE
	buckle_requires_restraints = TRUE

	var/power_gen = 1000 // Enough to power a single APC. 4000 output with T4 capacitor.

	var/irradiate = TRUE // RTGs irradiate surroundings, but only when panel is open.

/obj/machinery/power/rtg/Initialize(mapload)
	. = ..()
	connect_to_network()

/obj/machinery/power/rtg/process()
	..()
	add_avail(power_gen)
	if(panel_open && irradiate)
		radiation_pulse(src, 60)

/obj/machinery/power/rtg/RefreshParts()
	var/part_level = 0
	for(var/obj/item/stock_parts/SP in component_parts)
		part_level += SP.rating

	power_gen = initial(power_gen) * part_level

/obj/machinery/power/rtg/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Power generation now at <b>[power_gen*0.001]</b>kW.</span>"

/obj/machinery/power/rtg/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "[initial(icon_state)]-open", initial(icon_state), I))
		return
	else if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/power/rtg/advanced
	desc = "An advanced RTG capable of moderating isotope decay, increasing power output but reducing lifetime. It uses plasma-fueled radiation collectors to increase output even further."
	power_gen = 1250 // 2500 on T1, 10000 on T4.
	circuit = /obj/item/circuitboard/machine/rtg/advanced

/obj/machinery/power/rtg/advanced/fullupgrade //fully ugpraded stock parts
	desc = "An advanced RTG capable of moderating isotope decay, increasing power output but reducing lifetime. It uses plasma-fueled radiation collectors to increase output even further. This model is fully upgraded with the latest tech available in this quadrant."

/obj/machinery/power/rtg/advanced/fullupgrade/Initialize(mapload)
	. = ..()
	//This looks terrifying. And apparently instancing vars and modifying the amount variable causes runtime errors. Guess we're sticking to copy pasta, thanks, byond.
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/rtg/advanced(null)
	component_parts += new /obj/item/stack/sheet/mineral/uranium(null)
	component_parts += new /obj/item/stack/sheet/mineral/uranium(null)
	component_parts += new /obj/item/stack/sheet/mineral/uranium(null)
	component_parts += new /obj/item/stack/sheet/mineral/uranium(null)
	component_parts += new /obj/item/stack/sheet/mineral/uranium(null)
	component_parts += new /obj/item/stack/sheet/mineral/uranium(null)
	component_parts += new /obj/item/stack/sheet/mineral/uranium(null)
	component_parts += new /obj/item/stack/sheet/mineral/uranium(null)
	component_parts += new /obj/item/stack/sheet/mineral/uranium(null)
	component_parts += new /obj/item/stack/sheet/mineral/uranium(null)
	component_parts += new /obj/item/stack/sheet/mineral/plasma(null)
	component_parts += new /obj/item/stack/sheet/mineral/plasma(null)
	component_parts += new /obj/item/stack/sheet/mineral/plasma(null)
	component_parts += new /obj/item/stack/sheet/mineral/plasma(null)
	component_parts += new /obj/item/stack/sheet/mineral/plasma(null)
	component_parts += new /obj/item/stock_parts/capacitor/quadratic(null)
	component_parts += new /obj/item/stock_parts/micro_laser/quadultra(null)
	RefreshParts()

// Void Core, power source for Abductor ships and bases.
// Provides a lot of power, but tends to explode when mistreated.

/obj/machinery/power/rtg/abductor
	name = "Void Core"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "core"
	desc = "An alien power source that produces energy seemingly out of nowhere."
	circuit = /obj/item/circuitboard/machine/abductor/core
	power_gen = 20000 // 280 000 at T1, 400 000 at T4. Starts at T4.
	irradiate = FALSE // Green energy!
	can_buckle = FALSE
	pixel_y = 7
	var/going_kaboom = FALSE // Is it about to explode?

/obj/machinery/power/rtg/abductor/proc/overload()
	if(going_kaboom)
		return
	going_kaboom = TRUE
	visible_message("<span class='danger'>\The [src] lets out an shower of sparks as it starts to lose stability!</span>",\
		"<span class='italics'>You hear a loud electrical crack!</span>")
	playsound(src.loc, 'sound/magic/lightningshock.ogg', 100, 1, extrarange = 5)
	tesla_zap(src, 5, power_gen * 0.05)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(explosion), get_turf(src), 2, 3, 4, 8), 100) // Not a normal explosion.

/obj/machinery/power/rtg/abductor/bullet_act(obj/item/projectile/Proj)
	. = ..()
	if(!going_kaboom && istype(Proj) && !Proj.nodamage && ((Proj.damage_type == BURN) || (Proj.damage_type == BRUTE)))
		message_admins("[ADMIN_LOOKUPFLW(Proj.firer)] triggered an Abductor Core explosion at [AREACOORD(src)] via projectile.")
		log_game("[key_name(Proj.firer)] triggered an Abductor Core explosion at [AREACOORD(src)] via projectile.")
		overload()

/obj/machinery/power/rtg/abductor/blob_act(obj/structure/blob/B)
	overload()

/obj/machinery/power/rtg/abductor/ex_act(severity, target, origin)
	if(going_kaboom)
		qdel(src)
	else
		overload()

/obj/machinery/power/rtg/abductor/fire_act(exposed_temperature, exposed_volume)
	overload()

/obj/machinery/power/rtg/abductor/zap_act(power, zap_flags, shocked_objects)
	. = ..() //extend the zap
	if(zap_flags & ZAP_MACHINE_EXPLOSIVE)
		overload()
