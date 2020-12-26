/obj/structure/light_construct/floor
	name = "floor light fixture frame"
	icon = 'sandcode/icons/obj/lighting.dmi'
	icon_state = "floor-construct-stage1"
	fixture_type = "floor"
	sheets_refunded = 1

/obj/machinery/light/floor/built
	icon_state = "floor-empty"
	start_with_cell = FALSE

/obj/machinery/light/floor/built/Initialize()
	. = ..()
	status = LIGHT_EMPTY
	update(0)
