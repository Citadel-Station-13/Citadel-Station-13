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

///Things rendered on "openspace"; holes in multi-z
/obj/screen/plane_master/openspace
	name = "open space plane master"
	plane = OPENSPACE_BACKDROP_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_MULTIPLY
	alpha = 255

/obj/screen/plane_master/openspace/Initialize()
	. = ..()
	filters += filter(type="alpha", render_source=FIELD_OF_VISION_RENDER_TARGET, flags=MASK_INVERSE)

	filters += filter(type = "drop_shadow", color = "#04080FAA", size = -10)
	filters += filter(type = "drop_shadow", color = "#04080FAA", size = -15)
	filters += filter(type = "drop_shadow", color = "#04080FAA", size = -20)

/obj/screen/plane_master/proc/outline(_size, _color)
	filters += filter(type = "outline", size = _size, color = _color)

/obj/screen/plane_master/proc/shadow(_size, _offset = 0, _x = 0, _y = 0, _color = "#04080FAA")
	filters += filter(type = "drop_shadow", x = _x, y = _y, color = _color, size = _size, offset = _offset)

///Contains just the floor
/obj/screen/plane_master/floor
	name = "floor plane master"
	plane = FLOOR_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY

/obj/screen/plane_master/wall
	name = "wall plane master"
	plane = WALL_PLANE
	appearance_flags = PLANE_MASTER

/obj/screen/plane_master/wall/backdrop(mob/mymob)
	if(mymob?.client?.prefs.ambientocclusion)
		add_filter("ambient_occlusion", 0, AMBIENT_OCCLUSION(4, "#04080FAA"))
	else
		remove_filter("ambient_occlusion")

/obj/screen/plane_master/above_wall
	name = "above wall plane master"
	plane = ABOVE_WALL_PLANE
	appearance_flags = PLANE_MASTER

/obj/screen/plane_master/above_wall/Initialize()
	. = ..()
	add_filter("vision_cone", 100, list(type="alpha", render_source=FIELD_OF_VISION_RENDER_TARGET, flags=MASK_INVERSE))

/obj/screen/plane_master/above_wall/backdrop(mob/mymob)
	if(mymob?.client?.prefs.ambientocclusion)
		add_filter("ambient_occlusion", 0, AMBIENT_OCCLUSION(3, "#04080F64"))
	else
		remove_filter("ambient_occlusion")

///Contains most things in the game world
/obj/screen/plane_master/game_world
	name = "game world plane master"
	plane = GAME_PLANE
	appearance_flags = PLANE_MASTER //should use client color
	blend_mode = BLEND_OVERLAY

/obj/screen/plane_master/game_world/Initialize()
	. = ..()
	add_filter("vision_cone", 100, list(type="alpha", render_source=FIELD_OF_VISION_RENDER_TARGET, flags=MASK_INVERSE))

/obj/screen/plane_master/game_world/backdrop(mob/mymob)
	if(mymob?.client?.prefs.ambientocclusion)
		add_filter("ambient_occlusion", 0, AMBIENT_OCCLUSION(4, "#04080FAA"))
	else
		remove_filter("ambient_occlusion")

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
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/screen/plane_master/field_of_vision_visual/Initialize()
	. = ..()
	filters += filter(type="alpha", render_source=FIELD_OF_VISION_BLOCKER_RENDER_TARGET, flags=MASK_INVERSE)

///Contains all lighting objects
/obj/screen/plane_master/lighting
	name = "lighting plane master"
	plane = LIGHTING_PLANE
	blend_mode = BLEND_MULTIPLY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/screen/plane_master/lighting/backdrop(mob/mymob)
	mymob.overlay_fullscreen("lighting_backdrop_lit", /obj/screen/fullscreen/lighting_backdrop/lit)
	mymob.overlay_fullscreen("lighting_backdrop_unlit", /obj/screen/fullscreen/lighting_backdrop/unlit)

/obj/screen/plane_master/lighting/Initialize()
	. = ..()
	filters += filter(type="alpha", render_source = EMISSIVE_RENDER_TARGET, flags = MASK_INVERSE)
	filters += filter(type="alpha", render_source = EMISSIVE_UNBLOCKABLE_RENDER_TARGET, flags = MASK_INVERSE)

/**
  * Things placed on this mask the lighting plane. Doesn't render directly.
  *
  * Gets masked by blocking plane. Use for things that you want blocked by
  * mobs, items, etc.
  */
/obj/screen/plane_master/emissive
	name = "emissive plane master"
	plane = EMISSIVE_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = EMISSIVE_RENDER_TARGET

/obj/screen/plane_master/emissive/Initialize()
	. = ..()
	filters += filter(type="alpha", render_source=EMISSIVE_BLOCKER_RENDER_TARGET, flags=MASK_INVERSE)
	filters += filter(type="alpha", render_source=FIELD_OF_VISION_RENDER_TARGET, flags=MASK_INVERSE)

/**
  * Things placed on this always mask the lighting plane. Doesn't render directly.
  *
  * Always masks the light plane, isn't blocked by anything (except Field of Vision). Use for on mob glows,
  * magic stuff, etc.
  */

/obj/screen/plane_master/emissive_unblockable
	name = "unblockable emissive plane master"
	plane = EMISSIVE_UNBLOCKABLE_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = EMISSIVE_UNBLOCKABLE_RENDER_TARGET

/obj/screen/plane_master/emissive_unblockable/Initialize()
	. = ..()
	filters += filter(type="alpha", render_source=FIELD_OF_VISION_RENDER_TARGET, flags=MASK_INVERSE)

/**
  * Things placed on this layer mask the emissive layer. Doesn't render directly
  *
  * You really shouldn't be directly using this, use atom helpers instead
  */
/obj/screen/plane_master/emissive_blocker
	name = "emissive blocker plane master"
	plane = EMISSIVE_BLOCKER_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = EMISSIVE_BLOCKER_RENDER_TARGET

///Contains space parallax
/obj/screen/plane_master/parallax
	name = "parallax plane master"
	plane = PLANE_SPACE_PARALLAX
	blend_mode = BLEND_MULTIPLY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/screen/plane_master/parallax_white
	name = "parallax whitifier plane master"
	plane = PLANE_SPACE

/obj/screen/plane_master/camera_static
	name = "camera static plane master"
	plane = CAMERA_STATIC_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY


//Reserved to chat messages, so they are still displayed above the field of vision masking.
/obj/screen/plane_master/chat_messages
	name = "runechat plane master"
	plane = CHAT_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY
