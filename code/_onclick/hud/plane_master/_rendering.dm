/**
  * Plane master governing the final rendering plane that all other planes should ultimately pipe into.
  */
/obj/screen/plane_master/final_full_render
	name = "final render plane master"
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	plane = FINAL_RENDER_PLANE

/obj/screen/plane_master/final_full_render/get_render_holders()
	. = ..()
	. += new /obj/screen/plane_render_target(null, "final hud", plane, 2, HUD_RENDERING_TARGET)
	. += new /obj/screen/plane_render_target(null, "final game", plane, 1, GAME_RENDERING_TARGET)
	. += new /obj/screen/plane_render_target(null, "splashscreen", plane, 3, SPLASHSCREEN_RENDER_TARGET)

/**
  * Plane master governing the result of all HUD rendering. All HUD elements or effects should render into this.
  */
/obj/screen/plane_master/final_hud_render
	name = "hud render plane master"
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	plane = HUD_RENDERING_PLANE
	render_target = HUD_RENDERING_TARGET

/obj/screen/plane_master/final_hud_render/get_render_holders()
	. = ..()
	. += new /obj/screen/plane_render_target(null, "hud", plane, 1, HUD_RENDER_TARGET)
	. += new /obj/screen/plane_render_target(null, "volumetric box", plane, 2, VOLUMETRIC_STORAGE_BOX_RENDER_TARGET)
	. += new /obj/screen/plane_render_target(null, "volumetric item", plane, 3, VOLUMETRIC_STORAGE_ITEM_RENDER_TARGET)
	. += new /obj/screen/plane_render_target(null, "above hud", plane, 4, ABOVE_HUD_RENDER_TARGET)

/**
  * Plane master governing the result of all game rendering. All game world objects and otherwise should render into this.
  */
/obj/screen/plane_master/final_game_render
	name = "game render plane master"
	appearance_flags = PLANE_MASTER
	plane = GAME_RENDERING_PLANE
	render_target = GAME_RENDERING_TARGET

/obj/screen/plane_master/final_game_render/get_render_holders()
	. = ..()
	. += new /obj/screen/plane_render_target(null, "turf", plane, 1, TURF_RENDER_TARGET)
	. += new /obj/screen/plane_render_target(null, "game", plane, 2, GAME_PLANE_RENDER_TARGET)
	. += new /obj/screen/plane_render_target(null, "lighting", plane, 3, LIGHTING_RENDER_TARGET)
	. += new /obj/screen/plane_render_target(null, "above lighting", plane, 4, ABOVE_LIGHTING_RENDER_TARGET)
	. += new /obj/screen/plane_render_target(null, "camerastatic", plane, 5, CAMERA_STATIC_RENDER_TARGET)
	. += new /obj/screen/plane_render_target(null, "fullscreen", plane, 6, FULLSCREEN_RENDER_TARGET)


///Contains just the floor
/obj/screen/plane_master/floor
	name = "floor plane master"
	plane = FLOOR_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY

///Contains most things in the game world
/obj/screen/plane_master/game_world
	name = "game world plane master"
	plane = GAME_PLANE
	appearance_flags = PLANE_MASTER //should use client color
	blend_mode = BLEND_OVERLAY

/obj/screen/plane_master/game_world/backdrop(mob/mymob)
	if(istype(mymob) && mymob.client && mymob.client.prefs && mymob.client.prefs.ambientocclusion)
		add_filter("ambient_occlusion", 0, AMBIENT_OCCLUSION)
	else
		remove_filter("ambient_occlusion")
	update_filters()


///Contains space parallax

/obj/screen/plane_master/parallax
	name = "parallax plane master"
	plane = PLANE_SPACE_PARALLAX
	blend_mode = BLEND_MULTIPLY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/screen/plane_master/parallax_white
	name = "parallax whitifier plane master"
	plane = PLANE_SPACE




#define PLANE_SPACE -95
#define PLANE_SPACE_RENDER_TARGET "PLANE_SPACE"
#define PLANE_SPACE_PARALLAX -90
#define PLANE_SPACE_PARALLAX_RENDER_TARGET "PLANE_SPACE_PARALLAX"

#define FLOOR_PLANE -2
#define FLOOR_PLANE_RENDER_TARGET "FLOOR_PLANE"

/// Turf rendering plane, all turfs should render into this.
#define TURF_PLANE -5
#define TURF_RENDER_TARGET "*TURF_SUBRENDER"

#define GAME_PLANE -1
#define GAME_PLANE_RENDER_TARGET "GAME_PLANE"

#define BLACKNESS_PLANE 0 //To keep from conflicts with SEE_BLACKNESS internals
#define BLACKNESS_PLANE_RENDER_TARGET "BLACKNESS_PLANE"
