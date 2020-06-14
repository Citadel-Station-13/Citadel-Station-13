INITIALIZE_IMMEDIATE(/obj/screen/plane_render_target)
/**
  * Just an object to hold a render_source for planes to draw on.
  */
/obj/screen/plane_render_target
	name = "Render Holder"
	screen_loc = "CENTER"
	appearance_flags = APPEARANCE_UI | PASS_MOUSE

/obj/screen/plane_render_target/Initialize(mapload, layer)
	. = ..()
	var/obj/screen/plane_master/host = loc
	if(!istype(host))
		CRASH("Render target improperly initialized.")
	src.plane = host.plane
	moveToNullspace()		//hey hecc off, we're just an abstract screen object holder!
	src.layer = layer
