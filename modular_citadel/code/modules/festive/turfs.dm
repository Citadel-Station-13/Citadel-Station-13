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
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/festive/redbrick/redbrickte, /turf/closed/festive/redbrick/redbricktw, /turf/closed/festive/redbrick/redbrickts, /turf/closed/festive/redbrick/redbricktn, /turf/closed/festive/redbrick/redbrickcornernw, /turf/closed/festive/redbrick/redbrickcornerne, /turf/closed/festive/redbrick/redbrickcornersw, /turf/closed/festive/redbrick/redbrickcornerse, /turf/closed/festive/redbrick/redbrickwe, /turf/closed/festive/redbrick/redbrickns, /obj/structure/festive/redbrick/windowNSRightEnd, /obj/structure/festive/redbrick/windowNSLeftEnd, /turf/closed/festive/redbrick)

/turf/closed/festive/redbrick/redbrickns
	name = "red brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/red_brick_wall.dmi'
	icon_state = "red_brick_wall_ns"
	smooth = SMOOTH_FALSE

/turf/closed/festive/redbrick/redbrickwe
	name = "red brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/red_brick_wall.dmi'
	icon_state = "red_brick_wall_we"
	smooth = SMOOTH_FALSE

/turf/closed/festive/redbrick/redbrickcornerse
	name = "red brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/red_brick_wall.dmi'
	icon_state = "red_brick_corner_se"
	smooth = SMOOTH_FALSE

/turf/closed/festive/redbrick/redbrickcornersw
	name = "red brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/red_brick_wall.dmi'
	icon_state = "red_brick_corner_sw"
	smooth = SMOOTH_FALSE

/turf/closed/festive/redbrick/redbrickcornerne
	name = "red brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/red_brick_wall.dmi'
	icon_state = "red_brick_corner_ne"
	smooth = SMOOTH_FALSE

/turf/closed/festive/redbrick/redbrickcornernw
	name = "red brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/red_brick_wall.dmi'
	icon_state = "red_brick_corner_nw"
	smooth = SMOOTH_FALSE

/turf/closed/festive/redbrick/redbricktn
	name = "red brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/red_brick_wall.dmi'
	icon_state = "red_brick_t_n"
	smooth = SMOOTH_FALSE

/turf/closed/festive/redbrick/redbrickts
	name = "grey brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/red_brick_wall.dmi'
	icon_state = "red_brick_t_s"
	smooth = SMOOTH_FALSE

/turf/closed/festive/redbrick/redbricktw
	name = "red brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/red_brick_wall.dmi'
	icon_state = "red_brick_t_w"
	smooth = SMOOTH_FALSE

/turf/closed/festive/redbrick/redbrickte
	name = "red brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/red_brick_wall.dmi'
	icon_state = "red_brick_t_e"
	smooth = SMOOTH_FALSE

/obj/structure/festive/redbrick/windowWE
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_we"

/obj/structure/festive/redbrick/windowWERight
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_we_right"

/obj/structure/festive/redbrick/windowWERightEnd
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_we_right_end"
	canSmoothWith = list(/turf/closed/festive/redbrick)

/obj/structure/festive/redbrick/windowWEMiddle
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_we_middle"

/obj/structure/festive/redbrick/windowWELeft
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_we_left"

/obj/structure/festive/redbrick/windowWELeftEnd
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_we_left_end"
	canSmoothWith = list(/turf/closed/festive/redbrick)

/obj/structure/festive/redbrick/windowNS
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_ns"

/obj/structure/festive/redbrick/windowNSRight
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_ns_right"

/obj/structure/festive/redbrick/windowNSRightEnd
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_ns_right_end"
	canSmoothWith = list(/turf/closed/festive/redbrick)

/obj/structure/festive/redbrick/windowNSMiddle
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_ns_middle"

/obj/structure/festive/redbrick/windowNSLeft
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_ns_left"

/obj/structure/festive/redbrick/windowNSLeftEnd
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_ns_left_end"
	canSmoothWith = list(/turf/closed/festive/redbrick)

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



//Train Decals

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

//Streets Decals

/obj/effect/festive/street/streetlinewest
	name = "street line west"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_w"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlineeast
	name = "street line east"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_e"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlinesouth
	name = "street line south"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_s"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlinenorth
	name = "street line north"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_n"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlinesw
	name = "street line southwest"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_sw"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlinese
	name = "street line southeast"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_se"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlinene
	name = "street line northeast"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_ne"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlinenw
	name = "street line northwest"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_nw"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlineinnernw
	name = "street line inner northwest"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_inner_nw"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlineinnerne
	name = "street line inner northeast"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_inner_ne"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlineinnersw
	name = "street line inner southwest"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_inner_sw"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlineinnerse
	name = "street line inner southeast"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_inner_se"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlinemns
	name = "street line middle northsouth"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_m_ns"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlinemwe
	name = "street line middle westeast"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_m_we"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlinewm
	name = "street line west middle"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_wm"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlineem
	name = "street line east middle"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_em"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlinenm
	name = "street line north middle"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_nm"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetlinesm
	name = "street line south middle"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_line_sm"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetliftedtile1
	name = "street tile lifted"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_lifted_tile_1"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/streetliftedtile2
	name = "street tile lifted"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "street_lifted_tile_2"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/sidewalkw
	name = "street walk west"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "side_walk_w"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/sidewalke
	name = "street walk east"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "side_walk_e"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/sidewalkn
	name = "street walk north"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "side_walk_n"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/sidewalks
	name = "street walk south"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "side_walk_s"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/sidewalknsm
	name = "street walk middle ns"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "side_walk_nsm"
	layer = TURF_DECAL_LAYER

/obj/effect/festive/street/sidewalkwem
	name = "street walk middle we"
	icon = 'modular_citadel/code/modules/festive/streetdecals.dmi'
	icon_state = "side_walk_wem"
	layer = TURF_DECAL_LAYER



