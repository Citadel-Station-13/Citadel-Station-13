/**
  * Plane master governing the final rendering plane that all other planes should ultimately pipe into.
  */
/obj/screen/plane_master/final_render
	name = "final render plane master"
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	plane = FINAL_RENDER_PLANE
	var/obj/screen/plane_render_target/hud_render
	var/obj/screen/plane_render_target/game_render

/obj/screen/plane_master/final_render/setup()
	hud_render = new(null, "hud render", HUD_RENDER_PLANE, 2, HUD_RENDER_TARGET)
	game_render = new(null, "game render", GAME_RENDER_PLANE, 1, GAME_RENDER_TARGET)

/obj/screen/plane_master/final_render/screen_objects()
	return list(src, hud_render, game_render)

/**
  * Plane master governing the result of all HUD rendering. All HUD elements or effects should render into this.
  */
/obj/screen/plane_master/hud_render
	name = "hud render plane master"
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	plane = HUD_RENDER_PLANE
	render_target = HUD_RENDER_TARGET

/obj/screen/plane_master

/**
  * Plane master governing the result of all game rendering. All game world objects and otherwise should render into this.
  */
/obj/screen/plane_master/game_render
	name = "game render plane master"
	appearance_flags = PLANE_MASTER
	plane = GAME_RENDER_PLANE
	render_target = GAME_RENDER_TARGET
