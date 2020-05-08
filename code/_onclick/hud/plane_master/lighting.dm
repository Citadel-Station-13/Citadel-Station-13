///Contains all lighting objects
/obj/screen/plane_master/lighting
	name = "lighting plane master"
	plane = LIGHTING_PLANE
	blend_mode = BLEND_MULTIPLY
	appearance_flags = PLANE_MASTER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = LIGHTING_RENDER_TARGET

/obj/screen/plane_master/lighting/Initialize()
	. = ..()
	filters += filter(type="alpha", render_source=EMISSIVE_RENDER_TARGET, flags=MASK_INVERSE)
	filters += filter(type="alpha", render_source=EMISSIVE_UNBLOCKABLE_RENDER_TARGET, flags=MASK_INVERSE)

/obj/screen/plane_master/lighting/backdrop(mob/mymob)
	mymob.overlay_fullscreen("lighting_backdrop_lit", /obj/screen/fullscreen/lighting_backdrop/lit)
	mymob.overlay_fullscreen("lighting_backdrop_unlit", /obj/screen/fullscreen/lighting_backdrop/unlit)

/**
  * Things placed on this mask the lighting plane. Doesn't render directly.
  *
  * Gets masked by blocking plane. Use for things that you want blocked by
  * mobs, items, etc.
  */
/obj/screen/plane_master/emissive
	name = "emissive plane master"
	plane = EMISSIVE_PLANE
	appearance_flags = PLANE_MASTER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = EMISSIVE_RENDER_TARGET

/obj/screen/plane_master/emissive/Initialize()
	. = ..()
	filters += filter(type="alpha", render_source=EMISSIVE_BLOCKER_RENDER_TARGET, flags=MASK_INVERSE)

/**
  * Things placed on this always mask the lighting plane. Doesn't render directly.
  *
  * Always masks the light plane, isn't blocked by anything. Use for on mob glows,
  * magic stuff, etc.
  */

/obj/screen/plane_master/emissive_unblockable
	name = "unblockable emissive plane master"
	plane = EMISSIVE_UNBLOCKABLE_PLANE
	appearance_flags = PLANE_MASTER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = EMISSIVE_UNBLOCKABLE_RENDER_TARGET

/**
  * Things placed on this layer mask the emissive layer. Doesn't render directly
  *
  * You really shouldn't be directly using this, use atom helpers instead
  */
/obj/screen/plane_master/emissive_blocker
	name = "emissive blocker plane master"
	plane = EMISSIVE_BLOCKER_PLANE
	appearance_flags = PLANE_MASTER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = EMISSIVE_BLOCKER_RENDER_TARGET
