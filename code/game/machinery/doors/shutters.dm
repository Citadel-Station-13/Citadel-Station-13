/obj/machinery/door/poddoor/shutters
	gender = PLURAL
	name = "shutters"
	desc = "Mechanical metal shutters operated by a button with a magnetic seal, keeping them airtight."
	icon = 'icons/obj/doors/shutters.dmi'
	layer = SHUTTER_LAYER
	closingLayer = SHUTTER_LAYER
	armor = list("melee" = 20, "bullet" = 20, "laser" = 20, "energy" = 75, "bomb" = 25, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 70)
	damage_deflection = 20
	max_integrity = 100

/obj/machinery/door/poddoor/shutters/preopen
	icon_state = "open"
	density = FALSE
	opacity = 0

// The below shutters are the original ones from the TG codebase. They are remaining as "secure" shutters. If anyone wants to improve their animation, feel free.
// The original shutters are now shutters_old.dmi; copy the naming format of the files into new a new .dmi to add new shutters that work with the poddoor code for animating the doors.
// Originally, the shutters were reskins of blast doors. Eighty hits with the Cap's sabre to destroy one shutter is far too powerful considering shutters cannot be deconstructed (yet).
// If you're a mapper and want super strong shutter, use the 'old' ones.

/obj/machinery/door/poddoor/shutters/old
	name = "strong shutters"
	desc = "These shutters have an armoured frame; it looks like plasteel. These shutters look robust enough to survive explosions."
	icon = 'icons/obj/doors/shutters_old.dmi'
	icon_state = "closed"
	armor = list("melee" = 30, "bullet" = 30, "laser" = 30, "energy" = 75, "bomb" = 30, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 70)
	max_integrity = 300

/obj/machinery/door/poddoor/shutters/old/preopen
	icon_state = "open"
	density = FALSE
	opacity = 0

// End of old shutter stuff. Credit for the old shutter sprites to TG.

/obj/machinery/door/poddoor/shutters/radiation
	name = "radiation shutters"
	desc = "Lead-lined shutters painted yellow with a radioactive hazard symbol on it. Blocks out most radiation"
	icon = 'icons/obj/doors/shutters_radiation.dmi'
	icon_state = "closed"
	rad_insulation = 0.2

/obj/machinery/door/poddoor/shutters/radiation/preopen
	icon_state = "open"
	density = FALSE
	opacity = 0
	rad_insulation = 1

/obj/machinery/door/poddoor/shutters/radiation/do_animate(animation)
	..()
	switch(animation)
		if("opening")
			rad_insulation = 1
		if("closing")
			rad_insulation = 0.2

/obj/machinery/door/poddoor/shutters/window
	name = "windowed shutters"
	desc = "Mechanical shutters that have some form of plastic window in them, allowing you to see through the shutters at all times."
	icon = 'icons/obj/doors/shutters_window.dmi'
	icon_state = "closed"
	opacity = 0

/obj/machinery/door/poddoor/shutters/window/preopen
	icon_state = "open"
	density = FALSE
