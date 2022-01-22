/datum/parallax/space
	var/static/planet_offset_x = rand(100, 160)
	var/static/planet_offset_y = rand(100, 160)
	var/static/random_layer = pickweight(
		/atom/movable/screen/parallax_layer/space/random/asteroids = 35,
		/atom/movable/screen/parallax_layer/space/random/space_gas = 35,
		null = 30
	)
	var/static/random_gas_color = pick(COLOR_TEAL, COLOR_GREEN, COLOR_YELLOW, COLOR_CYAN, COLOR_ORANGE, COLOR_PURPLE)

/datum/parallax/space/CreateObjects()
	. = ..()
	objects += new /atom/movable/screen/parallax_layer/space/layer_1,
	objects += new /atom/movable/screen/parallax_layer/space/layer_2,
	objects += new /atom/movable/screen/parallax_layer/space/layer_3
	objects += new /atom/movable/screen/parallax_layer/space/planet/P
	if(random_layer)
		objects += random_layer
	if(ispath(random_layer, /atom/movable/screen/space/random/space_gas))
		var/atom/movable/screen/space/random/space_gas/SG = locate(random_layer) in objects
		SG.add_atom_colour(random_gas_color, ADMIN_COLOUR_PRIORITY)

/atom/movable/screen/parallax_layer/space/layer_1
	icon_state = "layer1"
	speed = 0.6
	layer = 1
	parallax_intensity = PARALLAX_LOW

/atom/movable/screen/parallax_layer/space/layer_2
	icon_state = "layer2"
	speed = 1
	layer = 2
	parallax_intensity = PARALLAX_MEDIUM

/atom/movable/screen/parallax_layer/space/layer_3
	icon_state = "layer3"
	speed = 1.4
	layer = 3
	parallax_intensity = PARALLAX_HIGH

/atom/movable/screen/parallax_layer/space/random
	blend_mode = BLEND_OVERLAY
	speed = 3
	layer = 3
	parallax_intensity = PARALLAX_INSANE

/atom/movable/screen/parallax_layer/space/random/space_gas
	icon_state = "space_gas"

/atom/movable/screen/parallax_layer/space/random/asteroids
	icon_state = "asteroids"

/atom/movable/screen/parallax_layer/space/planet
	icon_state = "planet"
	blend_mode = BLEND_OVERLAY
	absolute = TRUE //Status of seperation
	speed = 3
	layer = 30
	dynamic_self_tile = FALSE

/atom/movable/screen/parallax_layer/space/planet/ShouldSee(client/C, atom/location)
	var/turf/T = get_turf(location)
	return T && is_station_level(T.z)
