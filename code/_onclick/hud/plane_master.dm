/obj/screen/plane_master
	screen_loc = "CENTER"
	icon_state = "blank"
	appearance_flags = PLANE_MASTER|NO_CLIENT_COLOR
	blend_mode = BLEND_OVERLAY
	var/show_alpha = 255
	var/hide_alpha = 0

/obj/screen/plane_master/proc/Show(override)
	alpha = override || show_alpha

/obj/screen/plane_master/proc/Hide(override)
	alpha = override || hide_alpha

//Why do plane masters need a backdrop sometimes? Read https://secure.byond.com/forum/?post=2141928
//Trust me, you need one. Period. If you don't think you do, you're doing something extremely wrong.
/obj/screen/plane_master/proc/backdrop(mob/mymob)

/obj/screen/plane_master/floor
	name = "floor plane master"
	plane = FLOOR_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY

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

///obj/screen/plane_master/lighting
//	name = "lighting plane master"
//	plane = LIGHTING_PLANE
//	blend_mode = BLEND_MULTIPLY
//	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

#define LIGHTING_PLANEMASTER_COLOR list(null,null,null,"#0000","#000F")
/obj/screen/plane_master/lighting
	name = "lighting plane master"
	icon = 'icons/mob/screen1.dmi'
	appearance_flags = NO_CLIENT_COLOR | PLANE_MASTER// | RESET_TRANSFORM | RESET_COLOR | RESET_ALPHA
	screen_loc = "CENTER"
	//list(null,null,null,"#0000","#000F")
//	color = LIGHTING_PLANEMASTER_COLOR  // Completely black.
	blend_mode = BLEND_MULTIPLY
	layer = 1
	plane = LIGHTING_PLANE
	mouse_opacity = 0

//poor inheritance shitcode
/*obj/screen/backdrop
	blend_mode = BLEND_OVERLAY
	icon = 'icons/mob/screen1.dmi'
	icon_state = "black"
	layer = BACKGROUND_LAYER
	screen_loc = "CENTER"
	plane = LIGHTING_PLANE

/obj/screen/backdrop/New(var/client/C)
	..()
	if(istype(C)) C.screen += src
	var/matrix/M = matrix()
	M.Scale(world.view*3)
	transform = M
	verbs.Cut()*/


/obj/screen/plane_master/parallax
	name = "parallax plane master"
	plane = PLANE_SPACE_PARALLAX
	blend_mode = BLEND_MULTIPLY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/screen/plane_master/parallax_white
	name = "parallax whitifier plane master"
	plane = PLANE_SPACE

/obj/screen/plane_master/lighting/backdrop(mob/mymob)
	mymob.overlay_fullscreen("lighting_backdrop_lit", /obj/screen/fullscreen/lighting_backdrop/lit)
	mymob.overlay_fullscreen("lighting_backdrop_unlit", /obj/screen/fullscreen/lighting_backdrop/unlit)

/obj/screen/plane_master/camera_static
	name = "camera static plane master"
	plane = CAMERA_STATIC_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY
