/datum/parallax/space

/datum/parallax/space/CreateObjects()


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

/atom/movable/screen/parallax_layer/space/random/space_gas/Initialize(mapload, view)
	. = ..()
	src.add_atom_colour(pick(COLOR_TEAL, COLOR_GREEN, COLOR_YELLOW, COLOR_CYAN, COLOR_ORANGE, COLOR_PURPLE), ADMIN_COLOUR_PRIORITY)

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
