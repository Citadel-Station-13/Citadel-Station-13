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
	. += new /obj/screen/plane_render_target(null, "blackness", plane, 3, BLACKNESS_RENDER_TARGET)
	. += new /obj/screen/plane_render_target(null, "lighting", plane, 4, LIGHTING_RENDER_TARGET)
	. += new /obj/screen/plane_render_target(null, "above lighting", plane, 5, ABOVE_LIGHTING_RENDER_TARGET)
	. += new /obj/screen/plane_render_target(null, "camerastatic", plane, 6, CAMERA_STATIC_RENDER_TARGET)
	. += new /obj/screen/plane_render_target(null, "fullscreen", plane, 7, FULLSCREEN_RENDER_TARGET)
