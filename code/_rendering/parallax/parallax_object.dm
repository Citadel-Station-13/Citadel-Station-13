
/atom/movable/screen/parallax_layer
	icon = 'icons/screen/parallax.dmi'
	blend_mode = BLEND_ADD
	plane = PLANE_SPACE_PARALLAX_AUTO
	screen_loc = "CENTER-7,CENTER-7"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	// notice - all parallax layers are 15x15 tiles. They roll over every 240 pixels.
	/// pixel x/y shift per real x/y
	var/speed = 1
	/// current cached offset x
	var/offset_x = 0
	/// current cached offset y
	var/offset_y = 0
	/// normal centered x
	var/center_x = 0
	/// normal centered y
	var/center_y = 0
	/// absolute - always determine shift x/y as a function of real x/y instead of allowing for relative scroll.
	var/absolute = FALSE
	/// parallax level required to see this
	var/parallax_intensity = PARALLAX_INSANE
	/// current view we're adapted to
	var/view_current
	/// dynamic self tile - tile to our view size. set this to false for static parallax layers.
	var/dynamic_self_tile = TRUE
	/// map id
	var/map_id

/atom/movable/screen/parallax_layer/Initialize(mapload)
	. = ..()
	if(plane == PLANE_SPACE_PARALLAX_AUTO)
		plane = absolute? PLANE_SPACE_PARALLAX_STATIC : PLANE_SPACE_PARALLAX

/atom/movable/screen/parallax_layer/proc/ResetPosition(x, y)
	// remember that our offsets/directiosn are relative to the player's viewport
	// this means we need to scroll reverse to them.
	offset_x = -(center_x + speed * x)
	offset_y = -(center_y + speed * y)
	if(!absolute)
		offset_x = MODULUS(offset_x, 240)
		offset_y = MODULUS(offset_y, 240)
	screen_loc = "[map_id && "[map_id]:"]CENTER-7:[round(offset_x,1)],CENTER-7:[round(offset_y,1)]"

/atom/movable/screen/parallax_layer/proc/RelativePosition(x, y, rel_x, rel_y)
	if(absolute)
		return ResetPosition(x, y)
	offset_x -= rel_x * speed
	offset_y -= rel_y * speed
	offset_x = MODULUS(offset_x, 240)
	offset_y = MODULUS(offset_y, 240)
	screen_loc = "[map_id && "[map_id]:"]CENTER-7:[round(offset_x,1)],CENTER-7:[round(offset_y,1)]"

/atom/movable/screen/parallax_layer/proc/SetView(client_view = world.view)
	if(view_current == client_view)
		return
	view_current = client_view
	if(!dynamic_self_tile)
		return
	var/list/real_view = getviewsize(client_view)
	var/count_x = CEILING((real_view[1] / 2) / 15, 1) + 1
	var/count_y = CEILING((real_view[2] / 2) / 15, 1) + 1
	cut_overlays()
	var/list/new_overlays = list()
	for(var/x in -count_x to count_x)
		for(var/y in -count_y to count_y)
			if(!x && !y)
				continue
			var/mutable_appearance/clone = new
			// appearance clone
			clone.appearance = src
			// do NOT inherit our overlays! parallax layers should never have overlays,
			// because if it inherited us it'll result in exponentially increasing overlays
			// due to cut_overlays() above over there being a queue operation and not instant!
			clone.overlays = list()
			// shift to position
			clone.transform = matrix(1, 0, x * 480, 0, 1, y * 480)
			new_overlays += clone
	add_overlay(new_overlays)

/atom/movable/screen/parallax_layer/proc/ShouldSee(client/C, atom/location)
	return

/atom/movable/screen/parallax_layer/proc/Clone()
	var/atom/movable/screen/parallax_layer/layer = new type
	layer.speed = speed
	layer.offset_x = offset_x
	layer.offset_y = offset_y
	layer.absolute = absolute
	layer.parallax_intensity = parallax_intensity
	layer.view_current = view_current
	layer.appearance = appearance

/atom/movable/screen/parallax_layer/proc/default_x()
	return center_x

/atom/movable/screen/parallax_layer/proc/default_y()
	return center_y
