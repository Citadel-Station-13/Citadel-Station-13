INITIALIZE_IMMEDIATE(/obj/screen/plane_render_target)
/**
  * Just an object to hold a render_source for planes to draw on.
  */
/obj/screen/plane_render_target
	name = "plane render target"

/obj/screen/plane_render_target/Initialize(mapload, planename, plane, layer, render_source)
	. = ..()
	src.plane = plane
	src.layer = layer
	name = "[planename] render target"
	src.render_source = render_source
