#define NO_KNOT 0
#define KNOT_AUTO 1
#define KNOT_FORCED 2

/// Automatically links on init to power cables and other cable builder helpers. Only supports cardinals.
/obj/effect/network_builder/power_cable
	name = "power line autobuilder"
	icon_state = "powerlinebuilder"

	/// Whether or not we forcefully make a knot
	var/knot = NO_KNOT

	/// cable color as from GLOB.cable_colors
	var/cable_color = "red"

	color = "ff0000"

/obj/effect/network_builder/power_cable/check_duplicates()
	return (locate(/obj/structure/cable) in loc) || (locate(/obj/effect/network_builder/power_cable) in loc)

/// Scans directions, sets network_directions to have every direction that we can link to. If there's another power cable builder detected, make sure they know we're here by adding us to their cable directions list before we're deleted.
/obj/effect/network_builder/power_cable/scan_directions()
	var/turf/T
	for(var/i in GLOB.cardinal)
		if(i in network_directions)
			continue				//we're already set, that means another builder set us.
		T = get_step(loc, i)
		if(!T)
			continue
		var/obj/effect/network_builder/power_cable/other = locate() in T
		if(other)
			network_directions += i
			LAZYADD(other.network_directions, turn(i, 180))
			continue
		for(var/obj/structure/cable/C in T)
			if(C.d1 == turn(i, 180) || C.d2 == turn(i, 180))
				network_directions += i
				continue
	return network_directions

/// Directions should only ever have cardinals.
/obj/effect/network_builder/power_cable/build_network(list/directions = network_directions)
	if(!length(directions))
		return
	else if(length(directions) == 1)
		var/knot = (knot == KNOT_FORCED) || ((knot == KNOT_AUTO) && should_auto_knot())
		if(knot)
			var/dir = directions[1]
			new /obj/structure/cable(loc, cable_color, NONE, directions[1])
	else
		if(knot == KNOT_FORCED)
			for(var/d in directions)
				new /obj/structure/cable(loc, cable_color, NONE, d)
		else
			var/knot = (knot == KNOT_FORCED) || ((knot == KNOT_AUTO) && should_auto_knot())
			var/dirs = length(directions)
			for(var/i in dirs)
				var/li = i - 1
				if(li < 1)
					li = dirs + li
				new /obj/structure/cable(loc, cable_color, directions[i], directions[li])
				if(knot)
					new /obj/structure/cable(loc, cable_color, NONE, directions[i])
					knot = FALSE

/obj/effect/network_builder/power_cable/proc/should_auto_knot()
	return (locate(/obj/machinery/terminal) in loc)

/obj/effect/network_buidler/power_cable/knot
	icon_state = "powerlinebuilderknot"
	knot = KNOT_FORCED

/obj/effect/network_builder/power_cable/auto
	icon_state = "powerlinebuilderauto"
	knot = KNOT_AUTO

#define AUTODEF_COLOR(hex, enum) \
/obj/effect/network_builder/power_cable/##enum \
	color = #hex \
	cable_color = #enum \
/obj/effect/network_builder/power_cable/knot/##enum \
	color = #hex \
	cable_color = #enum \
/obj/effect/network_builder/power_cable/auto/##enum \
	color = #hex \
	cable_color = #enum

AUTODEF_COLOR("#ff0000", red)
AUTODEF_COLOR("#ffffff", white)
AUTODEF_COLOR("#00ffff", cyan)
AUTODEF_COLOR("#ff8000", orange)
AUTODEF_COLOR("#ff3cc8", pink)
AUTODEF_COLOR("#1919c8", blue)
AUTODEF_COLOR("#00aa00", green)
AUTODEF_COLOR("#ffff00", yellow)

#undef AUTODEF_COLOR
