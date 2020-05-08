INITIALIZE_IMMEDIATE(/obj/screen/plane_master)
/**
  * Plane masters. For rendering pipeline purposes, the objects that render_source from other planes should be defined on the target plane, not the source, for easier bookkeeping of layers.
  */
/obj/screen/plane_master
	screen_loc = "CENTER"
	icon_state = "blank"
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR | PIXEL_SCALE
	blend_mode = BLEND_OVERLAY
	var/show_alpha = 255
	var/hide_alpha = 0

	/// List of render source holders if other planes are rendering into us.
	var/list/obj/screen/plane_render_target/plane_render_holders

/obj/screen/plane_master/Initialize(mapload)
	. = ..()
	setup()

/**
  * Set up things like render target objects.
  */
/obj/screen/plane_master/proc/setup()
	if(plane_render_holders)
		QDEL_LIST(plane_render_holders)
	var/list/render_holders = get_render_holders()
	if(length(render_holders))
		plane_render_holders = render_holders

/**
  * Gets an instantiated list of plane render target objects.
  */
/obj/screen/plane_master/proc/get_render_holders()
	return list()

/obj/screen/plane_master/proc/Show(override)
	alpha = override || show_alpha

/obj/screen/plane_master/proc/Hide(override)
	alpha = override || hide_alpha

/**
  * Gets the list of objects that needs to be added or removed from a client's screen.
  */
/obj/screen/plane_master/proc/screen_objects(mob/M)
	if(!plane_render_holders)
		return list(src)
	return plane_render_holders + src

//Why do plane masters need a backdrop sometimes? Read https://secure.byond.com/forum/?post=2141928
//Trust me, you need one. Period. If you don't think you do, you're doing something extremely wrong.
/obj/screen/plane_master/proc/backdrop(mob/mymob)
