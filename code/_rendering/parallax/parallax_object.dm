
/atom/movable/screen/parallax_layer
	icon = 'icons/screen/parallax.dmi'
	blend_mode = BLEND_ADD
	plane = PLANE_SPACE_PARALLAX
	screen_loc = "CENTER-7,CENTER-7"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	/// pixel x/y shift per real x/y
	var/speed = 1
	/// current cached offset x
	var/offset_x = 0
	/// current cached offset y
	var/offset_y = 0
	/// absolute - always determine shift x/y as a function of real x/y instead of allowing for relative scroll.
	var/absolute = FALSE

	var/view_sized

/atom/movable/screen/parallax_layer/Initialize(mapload, view)
	. = ..()
	if (!view)
		view = world.view
	update_o(view)

/atom/movable/screen/parallax_layer/proc/Clone()
	var/atom/movable/screen/parallax_layer/layer = new type
	layer.speed = speed
	layer.offset_x = offset_x
	layer.offset_y = offset_y
	layer.absolute = absolute
	layer.appearance = appearance

/atom/movable/screen/parallax_layer/proc/update_o(view)
	if (!view)
		view = world.view

	var/list/viewscales = getviewsize(view)
	var/countx = CEILING((viewscales[1]/2)/(480/world.icon_size), 1)+1
	var/county = CEILING((viewscales[2]/2)/(480/world.icon_size), 1)+1
	var/list/new_overlays = new
	for(var/x in -countx to countx)
		for(var/y in -county to county)
			if(x == 0 && y == 0)
				continue
			var/mutable_appearance/texture_overlay = mutable_appearance(icon, icon_state)
			texture_overlay.transform = matrix(1, 0, x*480, 0, 1, y*480)
			new_overlays += texture_overlay
	cut_overlays()
	add_overlay(new_overlays)
	view_sized = view

/atom/movable/screen/parallax_layer/proc/update_status(mob/M)
	return

/atom/movable/screen/parallax_layer/layer_1
	icon_state = "layer1"
	speed = 0.6
	layer = 1

/atom/movable/screen/parallax_layer/layer_2
	icon_state = "layer2"
	speed = 1
	layer = 2

/atom/movable/screen/parallax_layer/layer_3
	icon_state = "layer3"
	speed = 1.4
	layer = 3

/atom/movable/screen/parallax_layer/random
	blend_mode = BLEND_OVERLAY
	speed = 3
	layer = 3

/atom/movable/screen/parallax_layer/random/space_gas
	icon_state = "space_gas"

/atom/movable/screen/parallax_layer/random/space_gas/Initialize(mapload, view)
	. = ..()
	src.add_atom_colour(SSparallax.random_parallax_color, ADMIN_COLOUR_PRIORITY)

/atom/movable/screen/parallax_layer/random/asteroids
	icon_state = "asteroids"

/atom/movable/screen/parallax_layer/planet
	icon_state = "planet"
	blend_mode = BLEND_OVERLAY
	absolute = TRUE //Status of seperation
	speed = 3
	layer = 30

/atom/movable/screen/parallax_layer/planet/update_status(mob/M)
	var/client/C = M.client
	var/turf/posobj = get_turf(C.eye)
	if(!posobj)
		return
	invisibility = is_station_level(posobj.z) ? 0 : INVISIBILITY_ABSTRACT

/atom/movable/screen/parallax_layer/planet/update_o()
	return //Shit won't move
