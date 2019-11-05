//Turfy Turfs

/turf/open/floor/festive/cobblestone
	name = "cobblestone"
	baseturfs = /turf/open/floor/festive/cobblestone
	icon = 'modular_citadel/code/modules/festive/cobblestone.dmi'
	icon_state = "unsmooth"
	smooth = SMOOTH_MORE | SMOOTH_BORDER
	canSmoothWith = list(/turf/open/floor/festive/cobblestone)

/turf/open/floor/festive/sidewalk
	name = "sidewalk"
	baseturfs = /turf/open/floor/festive/sidewalk
	icon = 'modular_citadel/code/modules/festive/sidewalk.dmi'
	icon_state = "unsmooth"
	smooth = SMOOTH_MORE | SMOOTH_BORDER
	canSmoothWith = list(/turf/open/floor/festive/sidewalk)

/turf/open/floor/festive/alleyway
	name = "alleyway bricks"
	baseturfs = /turf/open/floor/festive/alleyway
	icon = 'modular_citadel/code/modules/festive/alleywaybricks.dmi'
	icon_state = "unsmooth"
	smooth = SMOOTH_MORE | SMOOTH_BORDER
	canSmoothWith = list(/turf/open/floor/festive/alleyway)

//Grey Bricks, this will hurt some peoples eyes.

/turf/closed/festive/greybrick
	name = "grey brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/grey_brick_wall.dmi'
	icon_state = "grey_brick"
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/festive/greybrick/greybrickte, /turf/closed/festive/greybrick/greybricktw, /turf/closed/festive/greybrick/greybrickts, /turf/closed/festive/greybrick/greybricktn, /turf/closed/festive/greybrick/greybrickcornernw, /turf/closed/festive/greybrick/greybrickcornerne, /turf/closed/festive/greybrick/greybrickcornersw, /turf/closed/festive/greybrick/greybrickcornerse, /turf/closed/festive/greybrick/greybrickwe, /turf/closed/festive/greybrick/greybrickns, /obj/structure/festive/greybrick/windowNSRightEnd, /obj/structure/festive/greybrick/windowNSLeftEnd, /turf/closed/festive/greybrick)

/turf/closed/festive/greybrick/greybrickns
	name = "grey brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/grey_brick_wall.dmi'
	icon_state = "grey_brick_wall_ns"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greybrick/greybrickwe
	name = "grey brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/grey_brick_wall.dmi'
	icon_state = "grey_brick_wall_we"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greybrick/greybrickcornerse
	name = "grey brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/grey_brick_wall.dmi'
	icon_state = "grey_brick_corner_se"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greybrick/greybrickcornersw
	name = "grey brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/grey_brick_wall.dmi'
	icon_state = "grey_brick_corner_sw"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greybrick/greybrickcornerne
	name = "grey brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/grey_brick_wall.dmi'
	icon_state = "grey_brick_corner_ne"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greybrick/greybrickcornernw
	name = "grey brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/grey_brick_wall.dmi'
	icon_state = "grey_brick_corner_nw"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greybrick/greybricktn
	name = "grey brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/grey_brick_wall.dmi'
	icon_state = "grey_brick_t_n"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greybrick/greybrickts
	name = "grey brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/grey_brick_wall.dmi'
	icon_state = "grey_brick_t_s"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greybrick/greybricktw
	name = "grey brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/grey_brick_wall.dmi'
	icon_state = "grey_brick_t_w"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greybrick/greybrickte
	name = "grey brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/grey_brick_wall.dmi'
	icon_state = "grey_brick_t_e"
	smooth = SMOOTH_FALSE

/obj/structure/festive/greybrick/windowWE
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_we"

/obj/structure/festive/greybrick/windowWERight
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_we_right"

/obj/structure/festive/greybrick/windowWERightEnd
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_we_right_end"
	canSmoothWith = list(/turf/closed/festive/greybrick)

/obj/structure/festive/greybrick/windowWEMiddle
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_we_middle"

/obj/structure/festive/greybrick/windowWELeft
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_we_left"

/obj/structure/festive/greybrick/windowWELeftEnd
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_we_left_end"
	canSmoothWith = list(/turf/closed/festive/greybrick)

/obj/structure/festive/greybrick/windowNS
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_ns"

/obj/structure/festive/greybrick/windowNSRight
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_ns_right"

/obj/structure/festive/greybrick/windowNSRightEnd
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_ns_right_end"
	canSmoothWith = list(/turf/closed/festive/greybrick)

/obj/structure/festive/greybrick/windowNSMiddle
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_ns_middle"

/obj/structure/festive/greybrick/windowNSLeft
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_ns_left"

/obj/structure/festive/greybrick/windowNSLeftEnd
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_ns_left_end"
	canSmoothWith = list(/turf/closed/festive/greybrick)

//Red Bricks

/turf/closed/festive/redbrick
	name = "red brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/red_brick_wall.dmi'
	icon_state = "red_brick"
	canSmoothWith = null
	smooth = SMOOTH_MORE

//Cream Bricks

/turf/closed/festive/creambrick
	name = "cream brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/cream_brick_wall.dmi'
	icon_state = "cream_brick"
	canSmoothWith = null
	smooth = SMOOTH_MORE

//Blue Bricks

/turf/closed/festive/bluebrick
	name = "blue brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/blue_brick_wall.dmi'
	icon_state = "blue_brick"
	canSmoothWith = null
	smooth = SMOOTH_MORE

//Random Decals

/obj/effect/festive/trainrails/north
	name = "trainrail north"
	icon = 'modular_citadel/code/modules/festive/rails.dmi'
	icon_state = "trainrails_north"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/trainrails/south
	name = "trainrail south"
	icon = 'modular_citadel/code/modules/festive/rails.dmi'
	icon_state = "trainrails_south"
	layer = TURF_DECAL_LAYER

