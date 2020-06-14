///Contains most things in the game world
/obj/screen/plane_master/game_world
	name = "game world plane master"
	plane = GAME_PLANE
	appearance_flags = PLANE_MASTER | PIXEL_SCALE //should use client color
	blend_mode = BLEND_OVERLAY
	render_target = GAME_PLANE_RENDER_TARGET

/obj/screen/plane_master/game_world/Initialize()
	. = ..()
	add_filter("vision_cone", 100, list(type="alpha", render_source=FIELD_OF_VISION_RENDER_TARGET, flags=MASK_INVERSE))

/obj/screen/plane_master/game_world/backdrop(mob/mymob)
	if(istype(mymob) && mymob.client && mymob.client.prefs && mymob.client.prefs.ambientocclusion)
		add_filter("ambient_occlusion", 0, AMBIENT_OCCLUSION)
	else
		remove_filter("ambient_occlusion")
	update_filters()

/obj/screen/plane_master/blackness
	name = "blackness plane master"
	plane = BLACKNESS_PLANE
	render_target = BLACKNESS_PLANE_RENDER_TARGET
	appearance_flags = PLANE_MASTER | PIXEL_SCALE

/obj/screen/plane_master/above_lighting
	name = "above lighting plane master"
	plane = ABOVE_LIGHTING_PLANE
	render_target = ABOVE_LIGHTING_RENDER_TARGET
	appearance_flags = PLANE_MASTER | PIXEL_SCALE
	plane = PLANE_MASTER

/obj/screen/plane_master/camera_static
	name = "camera static plane master"
	plane = CAMERA_STATIC_PLANE
	appearance_flags = PLANE_MASTER | PIXEL_SCALE
	blend_mode = BLEND_OVERLAY
	render_target = CAMERA_STATIC_RENDER_TARGET

/obj/screen/plane_master/fullscreen
	name = "fullscreen plane master"
	plane = FULLSCREEN_PLANE
	appearance_flags = PLANE_MASTER | PIXEL_SCALE
	render_target = FULLSCREEN_RENDER_TARGET
