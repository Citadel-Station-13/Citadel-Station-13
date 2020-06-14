/**
  * Plane master governing the final rendering plane that all other planes should ultimately pipe into.
  */
/obj/screen/plane_master/final_full_render
	name = "final render plane master"
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR | PIXEL_SCALE
	plane = FINAL_RENDER_PLANE

/obj/screen/plane_master/final_full_render/get_render_holders()
	. = ..()
	. += new /obj/screen/plane_render_target/final_hud_render(src, 2)
	. += new /obj/screen/plane_render_target/final_game_render(src, 1)

/**
  * Plane master governing the result of all HUD rendering. All HUD elements or effects should render into this.
  */
/obj/screen/plane_master/final_hud_render
	name = "hud render plane master"
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR | PIXEL_SCALE
	plane = HUD_RENDERING_PLANE
	render_target = HUD_RENDERING_TARGET

/obj/screen/plane_master/final_hud_render/get_render_holders()
	. = ..()
	. += new /obj/screen/plane_render_target/hud_general(src, 2)
	. += new /obj/screen/plane_render_target/volumetric_box(src, 5)
	. += new /obj/screen/plane_render_target/volumetric_item(src, 6)
	. += new /obj/screen/plane_render_target/above_hud(src, 10)

/obj/screen/plane_render_target/final_hud_render
	name = "Render Holder - Heads Up Display"
	render_source = HUD_RENDERING_TARGET

/**
  * Plane master governing the result of all game rendering. All game world objects and otherwise should render into this.
  */
/obj/screen/plane_master/final_game_render
	name = "game render plane master"
	appearance_flags = PLANE_MASTER | PIXEL_SCALE
	plane = GAME_RENDERING_PLANE
	render_target = GAME_RENDERING_TARGET

/obj/screen/plane_master/final_game_render/get_render_holders()
	. = ..()
	. += new /obj/screen/plane_render_target/turf_subrender(src, 0)
	. += new /obj/screen/plane_render_target/game_world(src, 10)
	. += new /obj/screen/plane_render_target/field_of_vision_visual(src, 15)
	. += new /obj/screen/plane_render_target/blackness(src, 20)
	. += new /obj/screen/plane_render_target/lighting(src, 30)
	. += new /obj/screen/plane_render_target/above_lighting(src, 35)
	. += new /obj/screen/plane_render_target/camera_static(src, 40)
	. += new /obj/screen/plane_render_target/fullscreen(src, 50)
	// this is better off being separated from final game plane so effects like potentially rotatium/skewium can be made to not affect chat messages but for now this works.
	. += new /obj/screen/plane_render_target/chat_messages(src, 100)

/obj/screen/plane_render_target/final_game_render
	name = "Render Holder - Game World"
	render_source = GAME_RENDERING_TARGET
