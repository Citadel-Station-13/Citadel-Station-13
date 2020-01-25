#define NO_KNOT 0
#define KNOT_AUTO 1
#define KNOT_FORCED 2

/// Automatically links on init to power cables and other cable builder helpers. Only supports cardinals.
/obj/effect/mapping_helpers/network_builder/power_cable
	name = "power line autobuilder"
	icon_state = "powerlinebuilder"

	color = "#ff0000"

	/// Whether or not we forcefully make a knot
	var/knot = NO_KNOT

	/// cable color as from GLOB.cable_colors
	var/cable_color = "red"

/obj/effect/mapping_helpers/network_builder/power_cable/check_duplicates()
	var/obj/structure/cable/C = locate() in loc
	if(C)
		return C
	for(var/obj/effect/mapping_helpers/network_builder/power_cable/other in loc)
		if(other == src)
			continue
		return other

/// Scans directions, sets network_directions to have every direction that we can link to. If there's another power cable builder detected, make sure they know we're here by adding us to their cable directions list before we're deleted.
/obj/effect/mapping_helpers/network_builder/power_cable/scan_directions()
	var/turf/T
	for(var/i in GLOB.cardinals)
		if(i in network_directions)
			continue				//we're already set, that means another builder set us.
		T = get_step(loc, i)
		if(!T)
			continue
		var/obj/effect/mapping_helpers/network_builder/power_cable/other = locate() in T
		if(other)
			network_directions += i
			other.network_directions += turn(i, 180)
			continue
		for(var/obj/structure/cable/C in T)
			if(C.d1 == turn(i, 180) || C.d2 == turn(i, 180))
				network_directions += i
				continue
	return network_directions

/// Directions should only ever have cardinals.
/obj/effect/mapping_helpers/network_builder/power_cable/build_network()
	if(!length(network_directions))
		return
	else if(length(network_directions) == 1)
		new /obj/structure/cable(loc, cable_color, NONE, network_directions[1])
	else
		if(knot == KNOT_FORCED)
			for(var/d in network_directions)
				new /obj/structure/cable(loc, cable_color, NONE, d)
		else
			var/do_knot = (knot == KNOT_FORCED) || ((knot == KNOT_AUTO) && should_auto_knot())
			var/dirs = length(network_directions)
			for(var/i in 1 to dirs - 1)
				var/li = (i == 1)? dirs : (i - 1)
				var/d1 = network_directions[i]
				var/d2 = network_directions[li]
				if(d1 > d2)			//this is ugly please help me
					d1 = network_directions[li]
					d2 = network_directions[i]
				new /obj/structure/cable(loc, cable_color, d1, d2)
				if(do_knot)
					new /obj/structure/cable(loc, cable_color, NONE, network_directions[i])
					do_knot = FALSE

/obj/effect/mapping_helpers/network_builder/power_cable/proc/should_auto_knot()
	return (locate(/obj/machinery/power/terminal) in loc)

/obj/effect/mapping_helpers/network_builder/power_cable/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/obj/effect/mapping_helpers/network_builder/power_cable/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

// Red
/obj/effect/mapping_helpers/network_builder/power_cable/red
	color = "#ff0000"
	cable_color = "red"

/obj/effect/mapping_helpers/network_builder/power_cable/red/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/obj/effect/mapping_helpers/network_builder/power_cable/red/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

// White
/obj/effect/mapping_helpers/network_builder/power_cable/white
	color = "#ffffff"
	cable_color = "white"

/obj/effect/mapping_helpers/network_builder/power_cable/white/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/obj/effect/mapping_helpers/network_builder/power_cable/white/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

// Cyan
/obj/effect/mapping_helpers/network_builder/power_cable/cyan
	color = "#00ffff"
	cable_color = "cyan"

/obj/effect/mapping_helpers/network_builder/power_cable/cyan/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/obj/effect/mapping_helpers/network_builder/power_cable/cyan/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

// Orange
/obj/effect/mapping_helpers/network_builder/power_cable/orange
	color = "#ff8000"
	cable_color = "orange"

/obj/effect/mapping_helpers/network_builder/power_cable/orange/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/obj/effect/mapping_helpers/network_builder/power_cable/orange/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

// Pink
/obj/effect/mapping_helpers/network_builder/power_cable/pink
	color = "#ff3cc8"
	cable_color = "pink"

/obj/effect/mapping_helpers/network_builder/power_cable/pink/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/obj/effect/mapping_helpers/network_builder/power_cable/pink/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

// Blue
/obj/effect/mapping_helpers/network_builder/power_cable/blue
	color = "#1919c8"
	cable_color = "blue"

/obj/effect/mapping_helpers/network_builder/power_cable/blue/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/obj/effect/mapping_helpers/network_builder/power_cable/blue/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

// Green
/obj/effect/mapping_helpers/network_builder/power_cable/green
	color = "#00aa00"
	cable_color = "green"

/obj/effect/mapping_helpers/network_builder/power_cable/green/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/obj/effect/mapping_helpers/network_builder/power_cable/green/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

// Yellow
/obj/effect/mapping_helpers/network_builder/power_cable/yellow
	color = "#ffff00"
	cable_color = "yellow"

/obj/effect/mapping_helpers/network_builder/power_cable/yellow/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/obj/effect/mapping_helpers/network_builder/power_cable/yellow/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

#undef NO_KNOT
#undef KNOT_AUTO
#undef KNOT_FORCED
