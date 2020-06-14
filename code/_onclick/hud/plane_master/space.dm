///Contains space parallax

/obj/screen/plane_master/parallax
	name = "parallax plane master"
	plane = PLANE_SPACE_PARALLAX
	blend_mode = BLEND_OVERLAY
	appearance_flags = PLANE_MASTER | PIXEL_SCALE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = PLANE_SPACE_PARALLAX_RENDER_TARGET

/obj/screen/plane_render_target/parallax
	name = "Render Holder - Game - Space Parallax"
	render_source = PLANE_SPACE_PARALLAX_RENDER_TARGET

/obj/screen/plane_master/space
	name = "space plane master"
	plane = PLANE_SPACE
	render_target = PLANE_SPACE_RENDER_TARGET
	appearance_flags = PLANE_MASTER | PIXEL_SCALE

/obj/screen/plane_render_target/space
	name = "Render Holder - Game - Space"
	render_source = PLANE_SPACE_RENDER_TARGET
