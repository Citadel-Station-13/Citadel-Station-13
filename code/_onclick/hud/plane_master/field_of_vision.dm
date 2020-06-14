///Contains all shadow cone masks, whose image overrides are displayed only to their respective owners.
/obj/screen/plane_master/field_of_vision
	name = "field of vision mask plane master"
	plane = FIELD_OF_VISION_PLANE
	render_target = FIELD_OF_VISION_RENDER_TARGET
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/screen/plane_master/field_of_vision/Initialize()
	. = ..()
	filters += filter(type="alpha", render_source=FIELD_OF_VISION_BLOCKER_RENDER_TARGET, flags=MASK_INVERSE)

///Used to display the owner and its adjacent surroundings through the FoV plane mask.
/obj/screen/plane_master/field_of_vision_blocker
	name = "field of vision blocker plane master"
	plane = FIELD_OF_VISION_BLOCKER_PLANE
	render_target = FIELD_OF_VISION_BLOCKER_RENDER_TARGET
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

///Stores the visible portion of the FoV shadow cone.
/obj/screen/plane_master/field_of_vision_visual
	name = "field of vision visual plane master"
	plane = FIELD_OF_VISION_VISUAL_PLANE
	render_target = FIELD_OF_VISION_VISUAL_RENDER_TARGET
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/screen/plane_master/field_of_vision_visual/Initialize()
	. = ..()
	filters += filter(type="alpha", render_source=FIELD_OF_VISION_BLOCKER_RENDER_TARGET, flags=MASK_INVERSE)

/obj/screen/plane_render_target/field_of_vision_visual
	name = "Render Holder - Game - FOV Visual Effects"
	render_source = FIELD_OF_VISION_VISUAL_RENDER_TARGET
