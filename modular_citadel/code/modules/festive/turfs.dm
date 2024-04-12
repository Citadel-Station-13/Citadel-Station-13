//Turfy Turfs

/turf/open/floor/grass/snow/edina//But for now, we just handle what is outside, for light control etc.
	name = "Scottish snow"
	desc = "Looks super chilly!"

	light_range = 3 //MIDNIGHT BLUE
	light_power = 0.15 //NOT PITCH BLACK, JUST REALLY DARK
	light_color = "#00111a" //The light can technically cycle on a timer worldwide, but no daynight cycle.
	baseturfs = /turf/open/floor/grass/snow/edina //If we explode or die somehow, we just make more! Ahahaha!!!
	tiled_dirt = 0 //NO TILESMOOTHING DIRT/DIRT SPAWNS OR SOME SHIT
	//initial_gas_mix = OPENTURF_DEFAULT_ATMOS //DO NOT FREEZE EVERYONE TO DEATH ON CHRISTMAS
	initial_gas_mix = FESTIVE_ATMOS
	planetary_atmos = 1	//Uses new!!! planetmos wow!!! maybe?

//lets people build
/turf/open/floor/grass/snow/edina/attackby(obj/item/C, mob/user, params)
	.=..()
	if(istype(C, /obj/item/stack/tile))
		for(var/obj/O in src)
			if(O.level == 1) //ex. pipes laid underneath a tile
				for(var/M in O.buckled_mobs)
					to_chat(user, "<span class='warning'>Someone is buckled to \the [O]! Unbuckle [M] to move \him out of the way.</span>")
					return
		var/obj/item/stack/tile/W = C
		if(!W.use(1))
			return
		var/turf/open/floor/T = PlaceOnTop(W.turf_type)
		T.icon_state = initial(T.icon_state)
		if(istype(W, /obj/item/stack/tile/light)) //TODO: get rid of this ugly check somehow
			var/obj/item/stack/tile/light/L = W
			var/turf/open/floor/light/F = T
			F.state = L.state
		playsound(src, 'sound/weapons/genhit.ogg', 50, 1)

/turf/open/floor/festive/cobblestone
	name = "cobblestone"
	baseturfs = /turf/open/floor/festive/cobblestone
	icon = 'modular_citadel/code/modules/festive/cobblestone.dmi'
	icon_state = "unsmooth"
	smooth = SMOOTH_MORE | SMOOTH_BORDER
	canSmoothWith = list(/turf/open/floor/festive/cobblestone)
	initial_gas_mix = FESTIVE_ATMOS
	planetary_atmos = 1

/turf/open/floor/festive/cobblestone/safe	//this is literally cobblestone but safe for inside use because I don't want to fuck with aesthetics
	baseturfs = /turf/open/floor/festive/cobblestone/safe
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = FALSE

/turf/open/floor/festive/sidewalk
	name = "sidewalk"
	baseturfs = /turf/open/floor/festive/sidewalk
	icon = 'modular_citadel/code/modules/festive/sidewalk.dmi'
	icon_state = "unsmooth"
	smooth = SMOOTH_MORE | SMOOTH_BORDER
	canSmoothWith = list(/turf/open/floor/festive/sidewalk)
	initial_gas_mix = FESTIVE_ATMOS
	planetary_atmos = 1

/turf/open/floor/festive/alleyway
	name = "alleyway bricks"
	baseturfs = /turf/open/floor/festive/alleyway
	icon = 'modular_citadel/code/modules/festive/alleywaybricks.dmi'
	icon_state = "unsmooth"
	smooth = SMOOTH_MORE | SMOOTH_BORDER
	canSmoothWith = list(/turf/open/floor/festive/alleyway, /turf/open/floor/festive/white_alleyway)
	initial_gas_mix = FESTIVE_ATMOS
	planetary_atmos = 1

/turf/open/floor/festive/alleyway/safe	//this is literally alleyway but safe for inside use because I don't want to fuck with aesthetics
	baseturfs = /turf/open/floor/festive/alleyway/safe
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = FALSE

/turf/open/floor/festive/white_alleyway
	name = "alleyway bricks"
	baseturfs = /turf/open/floor/festive/alleyway
	icon = 'modular_citadel/code/modules/festive/white_alleywaybricks.dmi'
	icon_state = "unsmooth"
	smooth = SMOOTH_MORE | SMOOTH_BORDER
	canSmoothWith = list(/turf/open/floor/festive/alleyway, /turf/open/floor/festive/white_alleyway)
	initial_gas_mix = FESTIVE_ATMOS
	planetary_atmos = 1

/turf/open/floor/festive/trainplatform
	name = "trainplatform"
	baseturfs = /turf/open/floor/festive/trainplatform
	icon = 'modular_citadel/code/modules/festive/trainplatform.dmi'
	icon_state = "unsmooth"
	smooth = SMOOTH_MORE | SMOOTH_BORDER
	canSmoothWith = list(/turf/open/floor/festive/trainplatform)
	initial_gas_mix = FESTIVE_ATMOS
	planetary_atmos = 1

/turf/open/floor/festive/trainplatform/safe	//this is literally train platform but safe for inside use because I don't want to remap the strip club
	baseturfs = /turf/open/floor/festive/trainplatform/safe
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = FALSE

/turf/open/floor/festive/stairs/stairsnorth
	name = "stairs north"
	icon = 'modular_citadel/code/modules/festive/stairs.dmi'
	icon_state = "stairs_north"

/turf/open/floor/festive/stairs/stairssouth
	name = "stairs south"
	icon = 'modular_citadel/code/modules/festive/stairs.dmi'
	icon_state = "stairs_south"

/turf/open/floor/festive/stairs/stairseast
	name = "stairs east"
	icon = 'modular_citadel/code/modules/festive/stairs.dmi'
	icon_state = "stairs_east"

/turf/open/floor/festive/stairs/stairswest
	name = "stairs west"
	icon = 'modular_citadel/code/modules/festive/stairs.dmi'
	icon_state = "stairs_west"

/turf/open/floor/festive/wooden/wooden1
	name = "tile planks"
	baseturfs = /turf/open/floor/festive/wooden/wooden1
	icon = 'modular_citadel/code/modules/festive/wooden.dmi'
	icon_state = "wooden_1"

/turf/open/floor/festive/wooden/wooden2
	name = "decorative planks"
	baseturfs = /turf/open/floor/festive/wooden/wooden2
	icon = 'modular_citadel/code/modules/festive/wooden.dmi'
	icon_state = "wooden_2"



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

/obj/structure/festive/greybrick/windowdoorweend1
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_we_doorend_1"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/greybrick/windowdoorweend2
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_we_doorend_2"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/greybrick/windowdoornsend1
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_ns_doorend_1"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/greybrick/windowdoornsend2
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_ns_doorend_2"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/greybrick/windowWE
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_we"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/greybrick/windowWERight
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_we_right"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/greybrick/windowWERightEnd
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_we_right_end"
	canSmoothWith = list(/turf/closed/festive/greybrick)
	density = TRUE
	anchored = TRUE

/obj/structure/festive/greybrick/windowWEMiddle
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_we_middle"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/greybrick/windowWELeft
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_we_left"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/greybrick/windowWELeftEnd
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_we_left_end"
	canSmoothWith = list(/turf/closed/festive/greybrick)
	density = TRUE
	anchored = TRUE

/obj/structure/festive/greybrick/windowNS
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_ns"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/greybrick/windowNSRight
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_ns_right"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/greybrick/windowNSRightEnd
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_ns_right_end"
	canSmoothWith = list(/turf/closed/festive/greybrick)
	density = TRUE
	anchored = TRUE

/obj/structure/festive/greybrick/windowNSMiddle
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_ns_middle"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/greybrick/windowNSLeft
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_ns_left"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/greybrick/windowNSLeftEnd
	name = "grey window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/grey_brick_window.dmi'
	icon_state = "grey_brick_window_ns_left_end"
	canSmoothWith = list(/turf/closed/festive/greybrick)
	density = TRUE
	anchored = TRUE



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
	name = "red brick wall"
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

/obj/structure/festive/redbrick/windowdoorweend1
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_we_doorend_1"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/redbrick/windowdoorweend2
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_we_doorend_2"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/redbrick/windowdoornsend1
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_ns_doorend_1"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/redbrick/windowdoornsend2
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_ns_doorend_2"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/redbrick/windowWE
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_we"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/redbrick/windowWERight
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_we_right"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/redbrick/windowWERightEnd
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_we_right_end"
	canSmoothWith = list(/turf/closed/festive/redbrick)
	density = TRUE
	anchored = TRUE

/obj/structure/festive/redbrick/windowWEMiddle
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_we_middle"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/redbrick/windowWELeft
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_we_left"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/redbrick/windowWELeftEnd
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_we_left_end"
	canSmoothWith = list(/turf/closed/festive/redbrick)
	density = TRUE
	anchored = TRUE

/obj/structure/festive/redbrick/windowNS
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_ns"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/redbrick/windowNSRight
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_ns_right"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/redbrick/windowNSRightEnd
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_ns_right_end"
	canSmoothWith = list(/turf/closed/festive/redbrick)
	density = TRUE
	anchored = TRUE

/obj/structure/festive/redbrick/windowNSMiddle
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_ns_middle"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/redbrick/windowNSLeft
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_ns_left"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/redbrick/windowNSLeftEnd
	name = "red window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/red_brick_window.dmi'
	icon_state = "red_brick_window_ns_left_end"
	canSmoothWith = list(/turf/closed/festive/redbrick)
	density = TRUE
	anchored = TRUE



//white Bricks



/turf/closed/festive/whitebrick
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick"
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/festive/whitebrick/whitebrickte, /turf/closed/festive/whitebrick/whitebricktw, /turf/closed/festive/whitebrick/whitebrickts, /turf/closed/festive/whitebrick/whitebricktn, /turf/closed/festive/whitebrick/whitebrickcornernw, /turf/closed/festive/whitebrick/whitebrickcornerne, /turf/closed/festive/whitebrick/whitebrickcornersw, /turf/closed/festive/whitebrick/whitebrickcornerse, /turf/closed/festive/whitebrick/whitebrickwe, /turf/closed/festive/whitebrick/whitebrickns, /obj/structure/festive/whitebrick/windowNSRightEnd, /obj/structure/festive/whitebrick/windowNSLeftEnd, /turf/closed/festive/whitebrick)

/turf/closed/festive/whitebrick/whitebrickns
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_wall_ns"
	smooth = SMOOTH_FALSE

/turf/closed/festive/whitebrick/whitebrickwe
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_wall_we"
	smooth = SMOOTH_FALSE

/turf/closed/festive/whitebrick/whitebrickcornerse
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_corner_se"
	smooth = SMOOTH_FALSE

/turf/closed/festive/whitebrick/whitebrickcornersw
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_corner_sw"
	smooth = SMOOTH_FALSE

/turf/closed/festive/whitebrick/whitebrickcornerne
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_corner_ne"
	smooth = SMOOTH_FALSE

/turf/closed/festive/whitebrick/whitebrickcornernw
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_corner_nw"
	smooth = SMOOTH_FALSE

/turf/closed/festive/whitebrick/whitebricktn
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_t_n"
	smooth = SMOOTH_FALSE

/turf/closed/festive/whitebrick/whitebrickts
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_t_s"
	smooth = SMOOTH_FALSE

/turf/closed/festive/whitebrick/whitebricktw
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_t_w"
	smooth = SMOOTH_FALSE

/turf/closed/festive/whitebrick/whitebrickte
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_t_e"
	smooth = SMOOTH_FALSE

/obj/structure/festive/whitebrick/windowdoorweend1
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_we_doorend_1"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/whitebrick/windowdoorweend2
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_we_doorend_2"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/whitebrick/windowdoornsend1
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_ns_doorend_1"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/whitebrick/windowdoornsend2
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_ns_doorend_2"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/whitebrick/windowWE
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_we"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/whitebrick/windowWERight
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_we_right"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/whitebrick/windowWERightEnd
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_we_right_end"
	canSmoothWith = list(/turf/closed/festive/whitebrick)
	density = TRUE
	anchored = TRUE

/obj/structure/festive/whitebrick/windowWEMiddle
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_we_middle"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/whitebrick/windowWELeft
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_we_left"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/whitebrick/windowWELeftEnd
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_we_left_end"
	canSmoothWith = list(/turf/closed/festive/whitebrick)
	density = TRUE
	anchored = TRUE

/obj/structure/festive/whitebrick/windowNS
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_ns"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/whitebrick/windowNSRight
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_ns_right"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/whitebrick/windowNSRightEnd
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_ns_right_end"
	canSmoothWith = list(/turf/closed/festive/whitebrick)
	density = TRUE
	anchored = TRUE

/obj/structure/festive/whitebrick/windowNSMiddle
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_ns_middle"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/whitebrick/windowNSLeft
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_ns_left"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/whitebrick/windowNSLeftEnd
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_ns_left_end"
	canSmoothWith = list(/turf/closed/festive/whitebrick)
	density = TRUE
	anchored = TRUE


//Cream Bricks

/turf/closed/festive/creambrick
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick"
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/festive/creambrick/creambrickte, /turf/closed/festive/creambrick/creambricktw, /turf/closed/festive/creambrick/creambrickts, /turf/closed/festive/creambrick/creambricktn, /turf/closed/festive/creambrick/creambrickcornernw, /turf/closed/festive/creambrick/creambrickcornerne, /turf/closed/festive/creambrick/creambrickcornersw, /turf/closed/festive/creambrick/creambrickcornerse, /turf/closed/festive/creambrick/creambrickwe, /turf/closed/festive/creambrick/creambrickns, /obj/structure/festive/creambrick/windowNSRightEnd, /obj/structure/festive/creambrick/windowNSLeftEnd, /turf/closed/festive/creambrick)
	color = "#fff6cc"

/turf/closed/festive/creambrick/creambrickns
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_wall_ns"
	smooth = SMOOTH_FALSE

/turf/closed/festive/creambrick/creambrickwe
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_wall_we"
	smooth = SMOOTH_FALSE

/turf/closed/festive/creambrick/creambrickcornerse
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_corner_se"
	smooth = SMOOTH_FALSE

/turf/closed/festive/creambrick/creambrickcornersw
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_corner_sw"
	smooth = SMOOTH_FALSE

/turf/closed/festive/creambrick/creambrickcornerne
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_corner_ne"
	smooth = SMOOTH_FALSE

/turf/closed/festive/creambrick/creambrickcornernw
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_corner_nw"
	smooth = SMOOTH_FALSE

/turf/closed/festive/creambrick/creambricktn
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_t_n"
	smooth = SMOOTH_FALSE

/turf/closed/festive/creambrick/creambrickts
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_t_s"
	smooth = SMOOTH_FALSE

/turf/closed/festive/creambrick/creambricktw
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_t_w"
	smooth = SMOOTH_FALSE

/turf/closed/festive/creambrick/creambrickte
	name = "white brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/white_brick_wall.dmi'
	icon_state = "white_brick_t_e"
	smooth = SMOOTH_FALSE

/obj/structure/festive/creambrick/windowdoorweend1
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_we_doorend_1"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/creambrick
	color = "#fff6cc"

/obj/structure/festive/creambrick/windowdoorweend2
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_we_doorend_2"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/creambrick/windowdoornsend1
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_ns_doorend_1"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/creambrick/windowdoornsend2
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_ns_doorend_2"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/creambrick/windowWE
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_we"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/creambrick/windowWERight
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_we_right"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/creambrick/windowWERightEnd
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_we_right_end"
	canSmoothWith = list(/turf/closed/festive/creambrick)
	density = TRUE
	anchored = TRUE

/obj/structure/festive/creambrick/windowWEMiddle
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_we_middle"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/creambrick/windowWELeft
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_we_left"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/creambrick/windowWELeftEnd
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_we_left_end"
	canSmoothWith = list(/turf/closed/festive/creambrick)
	density = TRUE
	anchored = TRUE

/obj/structure/festive/creambrick/windowNS
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_ns"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/creambrick/windowNSRight
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_ns_right"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/creambrick/windowNSRightEnd
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_ns_right_end"
	canSmoothWith = list(/turf/closed/festive/creambrick)
	density = TRUE
	anchored = TRUE

/obj/structure/festive/creambrick/windowNSMiddle
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_ns_middle"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/creambrick/windowNSLeft
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_ns_left"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/creambrick/windowNSLeftEnd
	name = "white window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/white_brick_window.dmi'
	icon_state = "white_brick_window_ns_left_end"
	canSmoothWith = list(/turf/closed/festive/creambrick)
	density = TRUE
	anchored = TRUE

//Blue Bricks



/turf/closed/festive/bluebrick
	name = "blue brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/blue_brick_wall.dmi'
	icon_state = "blue_brick"
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/festive/bluebrick/bluebrickte, /turf/closed/festive/bluebrick/bluebricktw, /turf/closed/festive/bluebrick/bluebrickts, /turf/closed/festive/bluebrick/bluebricktn, /turf/closed/festive/bluebrick/bluebrickcornernw, /turf/closed/festive/bluebrick/bluebrickcornerne, /turf/closed/festive/bluebrick/bluebrickcornersw, /turf/closed/festive/bluebrick/bluebrickcornerse, /turf/closed/festive/bluebrick/bluebrickwe, /turf/closed/festive/bluebrick/bluebrickns, /obj/structure/festive/bluebrick/windowNSRightEnd, /obj/structure/festive/bluebrick/windowNSLeftEnd, /turf/closed/festive/bluebrick)

/turf/closed/festive/bluebrick/bluebrickns
	name = "blue brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/blue_brick_wall.dmi'
	icon_state = "blue_brick_wall_ns"
	smooth = SMOOTH_FALSE

/turf/closed/festive/bluebrick/bluebrickwe
	name = "blue brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/blue_brick_wall.dmi'
	icon_state = "blue_brick_wall_we"
	smooth = SMOOTH_FALSE

/turf/closed/festive/bluebrick/bluebrickcornerse
	name = "blue brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/blue_brick_wall.dmi'
	icon_state = "blue_brick_corner_se"
	smooth = SMOOTH_FALSE

/turf/closed/festive/bluebrick/bluebrickcornersw
	name = "blue brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/blue_brick_wall.dmi'
	icon_state = "blue_brick_corner_sw"
	smooth = SMOOTH_FALSE

/turf/closed/festive/bluebrick/bluebrickcornerne
	name = "blue brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/blue_brick_wall.dmi'
	icon_state = "blue_brick_corner_ne"
	smooth = SMOOTH_FALSE

/turf/closed/festive/bluebrick/bluebrickcornernw
	name = "blue brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/blue_brick_wall.dmi'
	icon_state = "blue_brick_corner_nw"
	smooth = SMOOTH_FALSE

/turf/closed/festive/bluebrick/bluebricktn
	name = "blue brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/blue_brick_wall.dmi'
	icon_state = "blue_brick_t_n"
	smooth = SMOOTH_FALSE

/turf/closed/festive/bluebrick/bluebrickts
	name = "blue brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/blue_brick_wall.dmi'
	icon_state = "blue_brick_t_s"
	smooth = SMOOTH_FALSE

/turf/closed/festive/bluebrick/bluebricktw
	name = "blue brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/blue_brick_wall.dmi'
	icon_state = "blue_brick_t_w"
	smooth = SMOOTH_FALSE

/turf/closed/festive/bluebrick/bluebrickte
	name = "blue brick wall"
	desc = "A brick wall, intricately built up."
	icon = 'modular_citadel/code/modules/festive/blue_brick_wall.dmi'
	icon_state = "blue_brick_t_e"
	smooth = SMOOTH_FALSE

/obj/structure/festive/bluebrick/windowdoorweend1
	name = "blue window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/blue_brick_window.dmi'
	icon_state = "blue_brick_window_we_doorend_1"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/bluebrick/windowdoorweend2
	name = "blue window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/blue_brick_window.dmi'
	icon_state = "blue_brick_window_we_doorend_2"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/bluebrick/windowdoornsend1
	name = "blue window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/blue_brick_window.dmi'
	icon_state = "blue_brick_window_ns_doorend_1"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/bluebrick/windowdoornsend2
	name = "blue window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/blue_brick_window.dmi'
	icon_state = "blue_brick_window_ns_doorend_2"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/bluebrick/windowWE
	name = "blue window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/blue_brick_window.dmi'
	icon_state = "blue_brick_window_we"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/bluebrick/windowWERight
	name = "blue window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/blue_brick_window.dmi'
	icon_state = "blue_brick_window_we_right"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/bluebrick/windowWERightEnd
	name = "blue window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/blue_brick_window.dmi'
	icon_state = "blue_brick_window_we_right_end"
	canSmoothWith = list(/turf/closed/festive/bluebrick)
	density = TRUE
	anchored = TRUE

/obj/structure/festive/bluebrick/windowWEMiddle
	name = "blue window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/blue_brick_window.dmi'
	icon_state = "blue_brick_window_we_middle"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/bluebrick/windowWELeft
	name = "blue window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/blue_brick_window.dmi'
	icon_state = "blue_brick_window_we_left"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/bluebrick/windowWELeftEnd
	name = "blue window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/blue_brick_window.dmi'
	icon_state = "blue_brick_window_we_left_end"
	canSmoothWith = list(/turf/closed/festive/bluebrick)
	density = TRUE
	anchored = TRUE

/obj/structure/festive/bluebrick/windowNS
	name = "blue window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/blue_brick_window.dmi'
	icon_state = "blue_brick_window_ns"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/bluebrick/windowNSRight
	name = "blue window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/blue_brick_window.dmi'
	icon_state = "blue_brick_window_ns_right"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/bluebrick/windowNSRightEnd
	name = "blue window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/blue_brick_window.dmi'
	icon_state = "blue_brick_window_ns_right_end"
	canSmoothWith = list(/turf/closed/festive/bluebrick)
	density = TRUE
	anchored = TRUE

/obj/structure/festive/bluebrick/windowNSMiddle
	name = "blue window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/blue_brick_window.dmi'
	icon_state = "blue_brick_window_ns_middle"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/bluebrick/windowNSLeft
	name = "blue window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/blue_brick_window.dmi'
	icon_state = "blue_brick_window_ns_left"
	density = TRUE
	anchored = TRUE

/obj/structure/festive/bluebrick/windowNSLeftEnd
	name = "blue window"
	desc = "A brick wall, intricately built up. Comes with a window."
	icon = 'modular_citadel/code/modules/festive/blue_brick_window.dmi'
	icon_state = "blue_brick_window_ns_left_end"
	canSmoothWith = list(/turf/closed/festive/bluebrick)
	density = TRUE
	anchored = TRUE



//Panel Walls



//Grey Paneled Walls



/turf/closed/festive/greypanel
	name = "grey panel wall"
	desc = "A panel wall, with horizontal sidings."
	icon = 'modular_citadel/code/modules/festive/grey_panel_wall.dmi'
	icon_state = "grey_panel"
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/festive/greypanel/greypanelte, /turf/closed/festive/greypanel/greypaneltw, /turf/closed/festive/greypanel/greypanelts, /turf/closed/festive/greypanel/greypaneltn, /turf/closed/festive/greypanel/greypanelcornernw, /turf/closed/festive/greypanel/greypanelcornerne, /turf/closed/festive/greypanel/greypanelcornersw, /turf/closed/festive/greypanel/greypanelcornerse, /turf/closed/festive/greypanel/greypanelwe, /turf/closed/festive/greypanel/greypanelns, /turf/closed/festive/greypanel)

/turf/closed/festive/greypanel/greypanelns
	name = "grey panel wall"
	desc = "A panel wall, with horizontal sidings."
	icon = 'modular_citadel/code/modules/festive/grey_panel_wall.dmi'
	icon_state = "grey_panel_wall_ns"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greypanel/greypanelwe
	name = "grey panel wall"
	desc = "A panel wall, with horizontal sidings."
	icon = 'modular_citadel/code/modules/festive/grey_panel_wall.dmi'
	icon_state = "grey_panel_wall_we"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greypanel/greypanelcornerse
	name = "grey panel wall"
	desc = "A panel wall, with horizontal sidings."
	icon = 'modular_citadel/code/modules/festive/grey_panel_wall.dmi'
	icon_state = "grey_panel_corner_se"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greypanel/greypanelcornersw
	name = "grey panel wall"
	desc = "A panel wall, with horizontal sidings."
	icon = 'modular_citadel/code/modules/festive/grey_panel_wall.dmi'
	icon_state = "grey_panel_corner_sw"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greypanel/greypanelcornerne
	name = "grey panel wall"
	desc = "A panel wall, with horizontal sidings."
	icon = 'modular_citadel/code/modules/festive/grey_panel_wall.dmi'
	icon_state = "grey_panel_corner_ne"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greypanel/greypanelcornernw
	name = "grey panel wall"
	desc = "A panel wall, with horizontal sidings."
	icon = 'modular_citadel/code/modules/festive/grey_panel_wall.dmi'
	icon_state = "grey_panel_corner_nw"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greypanel/greypaneltn
	name = "grey panel wall"
	desc = "A panel wall, with horizontal sidings."
	icon = 'modular_citadel/code/modules/festive/grey_panel_wall.dmi'
	icon_state = "grey_panel_t_n"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greypanel/greypanelts
	name = "grey panel wall"
	desc = "A panel wall, with horizontal sidings."
	icon = 'modular_citadel/code/modules/festive/grey_panel_wall.dmi'
	icon_state = "grey_panel_t_s"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greypanel/greypaneltw
	name = "grey panel wall"
	desc = "A panel wall, with horizontal sidings."
	icon = 'modular_citadel/code/modules/festive/grey_panel_wall.dmi'
	icon_state = "grey_panel_t_w"
	smooth = SMOOTH_FALSE

/turf/closed/festive/greypanel/greypanelte
	name = "grey panel wall"
	desc = "A panel wall, with horizontal sidings."
	icon = 'modular_citadel/code/modules/festive/grey_panel_wall.dmi'
	icon_state = "grey_panel_t_e"
	smooth = SMOOTH_FALSE

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



//train platform stuff
//I know, this is stupid of me to do, but it's all I could get working with my brain

/obj/structure/festive/trainplatform/edge_north
	name = "train platform"
	icon = 'modular_citadel/code/modules/festive/trainplatformedges.dmi'
	icon_state = "edge_north"
	anchored = TRUE
	density = TRUE
	layer = ABOVE_OBJ_LAYER //Just above doors
	flags_1 = ON_BORDER_1
	var/reinf = FALSE
	var/ini_dir = null
	var/fulltile = FALSE
	CanAtmosPass = ATMOS_PASS_PROC

/obj/structure/festive/trainplatform/edge_north/Initialize(mapload, direct)
	. = ..()
	if(direct)
		setDir(direct)

	ini_dir = dir
	air_update_turf(1)

/obj/structure/festive/trainplatform/edge_north/setDir(direct)
	if(!fulltile)
		..()
	else
		..(FULLTILE_WINDOW_DIR)

/obj/structure/festive/trainplatform/edge_north/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSGLASS))
		return TRUE
	if(dir == FULLTILE_WINDOW_DIR)
		return FALSE
	if(get_dir(loc, target) == dir)
		return !density
	if(istype(mover, /obj/structure/festive/trainplatform/edge_north))
		var/obj/structure/window/W = mover
		if(!valid_window_location(loc, W.ini_dir))
			return FALSE
	else if(istype(mover, /obj/structure/windoor_assembly))
		var/obj/structure/festive/trainplatform/edge_north/W = mover
		if(!valid_window_location(loc, W.ini_dir))
			return FALSE
	else if(istype(mover, /obj/machinery/door/window) && !valid_window_location(loc, mover.dir))
		return FALSE
	return TRUE

/obj/structure/festive/trainplatform/edge_north/CheckExit(atom/movable/O, turf/target)
	if(istype(O) && (O.pass_flags & PASSGLASS))
		return TRUE
	if(get_dir(O.loc, target) == dir)
		return FALSE
	return TRUE

/obj/structure/festive/trainplatform/edge_north
	dir = SOUTH



/obj/structure/festive/trainplatform/edge_south
	name = "train platform"
	icon = 'modular_citadel/code/modules/festive/trainplatformedges.dmi'
	icon_state = "edge_south"
	anchored = TRUE
	density = TRUE
	layer = ABOVE_OBJ_LAYER //Just above doors
	flags_1 = ON_BORDER_1
	var/reinf = FALSE
	var/ini_dir = null
	var/fulltile = FALSE
	CanAtmosPass = ATMOS_PASS_PROC

/obj/structure/festive/trainplatform/edge_south/Initialize(mapload, direct)
	. = ..()
	if(direct)
		setDir(direct)

	ini_dir = dir
	air_update_turf(1)

/obj/structure/festive/trainplatform/edge_south/setDir(direct)
	if(!fulltile)
		..()
	else
		..(FULLTILE_WINDOW_DIR)

/obj/structure/festive/trainplatform/edge_south/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSGLASS))
		return TRUE
	if(dir == FULLTILE_WINDOW_DIR)
		return FALSE
	if(get_dir(loc, target) == dir)
		return !density
	if(istype(mover, /obj/structure/festive/trainplatform/edge_south))
		var/obj/structure/window/W = mover
		if(!valid_window_location(loc, W.ini_dir))
			return FALSE
	else if(istype(mover, /obj/structure/windoor_assembly))
		var/obj/structure/festive/trainplatform/edge_south/W = mover
		if(!valid_window_location(loc, W.ini_dir))
			return FALSE
	else if(istype(mover, /obj/machinery/door/window) && !valid_window_location(loc, mover.dir))
		return FALSE
	return TRUE

/obj/structure/festive/trainplatform/edge_north/CheckExit(atom/movable/O, turf/target)
	if(istype(O) && (O.pass_flags & PASSGLASS))
		return TRUE
	if(get_dir(O.loc, target) == dir)
		return FALSE
	return TRUE

/obj/structure/festive/trainplatform/edge_south
	dir = NORTH



/obj/structure/festive/trainplatform/edge_east
	name = "train platform"
	icon = 'modular_citadel/code/modules/festive/trainplatformedges.dmi'
	icon_state = "edge_east"
	anchored = TRUE
	density = TRUE
	layer = ABOVE_OBJ_LAYER //Just above doors
	flags_1 = ON_BORDER_1
	var/reinf = FALSE
	var/ini_dir = null
	var/fulltile = FALSE
	CanAtmosPass = ATMOS_PASS_PROC

/obj/structure/festive/trainplatform/edge_east/Initialize(mapload, direct)
	. = ..()
	if(direct)
		setDir(direct)

	ini_dir = dir
	air_update_turf(1)

/obj/structure/festive/trainplatform/edge_east/setDir(direct)
	if(!fulltile)
		..()
	else
		..(FULLTILE_WINDOW_DIR)

/obj/structure/festive/trainplatform/edge_east/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSGLASS))
		return TRUE
	if(dir == FULLTILE_WINDOW_DIR)
		return FALSE
	if(get_dir(loc, target) == dir)
		return !density
	if(istype(mover, /obj/structure/festive/trainplatform/edge_east))
		var/obj/structure/window/W = mover
		if(!valid_window_location(loc, W.ini_dir))
			return FALSE
	else if(istype(mover, /obj/structure/windoor_assembly))
		var/obj/structure/festive/trainplatform/edge_east/W = mover
		if(!valid_window_location(loc, W.ini_dir))
			return FALSE
	else if(istype(mover, /obj/machinery/door/window) && !valid_window_location(loc, mover.dir))
		return FALSE
	return TRUE

/obj/structure/festive/trainplatform/edge_east/CheckExit(atom/movable/O, turf/target)
	if(istype(O) && (O.pass_flags & PASSGLASS))
		return TRUE
	if(get_dir(O.loc, target) == dir)
		return FALSE
	return TRUE

/obj/structure/festive/trainplatform/edge_east
	dir = WEST



/obj/structure/festive/trainplatform/edge_west
	name = "train platform"
	icon = 'modular_citadel/code/modules/festive/trainplatformedges.dmi'
	icon_state = "edge_west"
	anchored = TRUE
	density = TRUE
	layer = ABOVE_OBJ_LAYER //Just above doors
	flags_1 = ON_BORDER_1
	var/reinf = FALSE
	var/ini_dir = null
	var/fulltile = FALSE
	CanAtmosPass = ATMOS_PASS_PROC

/obj/structure/festive/trainplatform/edge_west/Initialize(mapload, direct)
	. = ..()
	if(direct)
		setDir(direct)

	ini_dir = dir
	air_update_turf(1)

/obj/structure/festive/trainplatform/edge_west/setDir(direct)
	if(!fulltile)
		..()
	else
		..(FULLTILE_WINDOW_DIR)

/obj/structure/festive/trainplatform/edge_west/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSGLASS))
		return TRUE
	if(dir == FULLTILE_WINDOW_DIR)
		return FALSE
	if(get_dir(loc, target) == dir)
		return !density
	if(istype(mover, /obj/structure/festive/trainplatform/edge_west))
		var/obj/structure/window/W = mover
		if(!valid_window_location(loc, W.ini_dir))
			return FALSE
	else if(istype(mover, /obj/structure/windoor_assembly))
		var/obj/structure/festive/trainplatform/edge_west/W = mover
		if(!valid_window_location(loc, W.ini_dir))
			return FALSE
	else if(istype(mover, /obj/machinery/door/window) && !valid_window_location(loc, mover.dir))
		return FALSE
	return TRUE

/obj/structure/festive/trainplatform/edge_west/CheckExit(atom/movable/O, turf/target)
	if(istype(O) && (O.pass_flags & PASSGLASS))
		return TRUE
	if(get_dir(O.loc, target) == dir)
		return FALSE
	return TRUE

/obj/structure/festive/trainplatform/edge_west
	dir = EAST

/obj/structure/festive/trainplatform/necorner
	name = "train platform"
	icon = 'modular_citadel/code/modules/festive/trainplatformedges.dmi'
	icon_state = "ne_corner"
	anchored = TRUE

/obj/structure/festive/trainplatform/nwcorner
	name = "train platform"
	icon = 'modular_citadel/code/modules/festive/trainplatformedges.dmi'
	icon_state = "nw_corner"
	anchored = TRUE

/obj/structure/festive/trainplatform/secorner
	name = "train platform"
	icon = 'modular_citadel/code/modules/festive/trainplatformedges.dmi'
	icon_state = "se_corner"
	anchored = TRUE

/obj/structure/festive/trainplatform/swcorner
	name = "train platform"
	icon = 'modular_citadel/code/modules/festive/trainplatformedges.dmi'
	icon_state = "sw_corner"
	anchored = TRUE
