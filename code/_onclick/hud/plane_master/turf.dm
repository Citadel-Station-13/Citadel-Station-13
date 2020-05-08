/obj/screen/plane_master/turf_subrender
	name = "turf subrendering plane master"
	plane = TURF_PLANE
	render_target = TURF_RENDER_TARGET
	appearance_flags = PLANE_MASTER | PIXEL_SCALE

/obj/screen/plane_master/turf_subrender/get_render_holders()
	. = ..()
	. += new /obj/screen/plane_render_target(null, "space", plane, 1, PLANE_SPACE_RENDER_TARGET)
	. += new /obj/screen/plane_render_target(null, "space parallax", plane, 1, PLANE_SPACE_PARALLAX_RENDER_TARGET)
	. += new /obj/screen/plane_render_target(null, "openspace", plane, 2, OPENSPACE_RENDER_TARGET)
	. += new /obj/screen/plane_render_target(null, "floor", plane, 3, FLOOR_PLANE_RENDER_TARGET)

///Things rendered on "openspace"; holes in multi-z
/obj/screen/plane_master/openspace
	name = "open space plane master"
	plane = OPENSPACE_PLANE
	appearance_flags = PLANE_MASTER | PIXEL_SCALE
	render_target = OPENSPACE_RENDER_TARGET

/obj/screen/plane_master/openspace/get_render_holders()
	. = ..()
	. += new /obj/screen/plane_render_target(null, "openspace backdrop", plane, 1, OPENSPACE_BACKDROP_RENDER_TARGET)

/obj/screen/plane_master/openspace_backdrop
	name = "openspace backdrop plane master"
	appearance_flags = PLANE_MASTER | PIXEL_SCALE
	alpha = 255
	render_target = OPENSPACE_BACKDROP_RENDER_TARGET
	plane = OPENSPACE_BACKDROP_PLANE
	blend_mode = BLEND_MULTIPLY

/obj/screen/plane_master/openspace_backdrop/backdrop(mob/mymob)
	filters = list()
	filters += filter(type = "drop_shadow", color = "#04080FAA", size = -10)
	filters += filter(type = "drop_shadow", color = "#04080FAA", size = -15)
	filters += filter(type = "drop_shadow", color = "#04080FAA", size = -20)

///Contains just the floor
/obj/screen/plane_master/floor
	name = "floor plane master"
	plane = FLOOR_PLANE
	appearance_flags = PLANE_MASTER | PIXEL_SCALE
	blend_mode = BLEND_OVERLAY
	render_target = FLOOR_PLANE_RENDER_TARGET
