
///Things rendered on "openspace"; holes in multi-z
/obj/screen/plane_master/openspace
	name = "open space plane master"
	plane = OPENSPACE_PLANE
	appearance_flags = PLANE_MASTER
	render_target = OPENSPACE_RENDER_TARGET

/obj/screen/plane_master/openspace/get_render_holders()
	. = ..()
	. += new /obj/screen/plane_render_target(null, "openspace backdrop", plane, 1, OPENSPACE_BACKDROP_RENDER_TARGET)

/obj/screen/plane_master/openspace_backdrop
	name = "openspace backdrop plane master"
	appearance_flags = PLANE_MASTER
	alpha = 255
	render_target = OPENSPACE_BACKDROP_RENDER_TARGET
	plane = OPENSPACE_BACKDROP_PLANE
	blend_mode = BLEND_MULTIPLY

/obj/screen/plane_master/openspace_backdrop/backdrop(mob/mymob)
	filters = list()
	filters += filter(type = "drop_shadow", color = "#04080FAA", size = -10)
	filters += filter(type = "drop_shadow", color = "#04080FAA", size = -15)
	filters += filter(type = "drop_shadow", color = "#04080FAA", size = -20)
