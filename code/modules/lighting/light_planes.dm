/obj/screen/plane
	name = ""
	screen_loc = "CENTER"
	blend_mode = BLEND_MULTIPLY
	layer = 1

/obj/screen/plane/New(var/client/C)
	..()
	if(istype(C)) C.screen += src
	verbs.Cut()

/obj/screen/plane/master
	icon = 'icons/mob/screen1.dmi'
	appearance_flags = NO_CLIENT_COLOR | PLANE_MASTER | RESET_TRANSFORM | RESET_COLOR | RESET_ALPHA
	//list(null,null,null,"#0000","#000F")
	color = LIGHTING_PLANEMASTER_COLOR  // Completely black.
	plane = LIGHTING_PLANE
	mouse_opacity = 0

//poor inheritance shitcode
/obj/screen/backdrop
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
	verbs.Cut()
