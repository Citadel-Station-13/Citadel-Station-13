area/edina
	name = "Nova Edina wilderness"
	icon_state = "edina"
	valid_territory = FALSE
	has_gravity = STANDARD_GRAVITY
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	clockwork_warp_allowed = FALSE // Can servants warp into this area from Reebe?
	clockwork_warp_fail = "The aurora borealis is interfering with your teleport! Try somewhere closer to the city."
	requires_power = TRUE
	always_unpowered = TRUE

	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	valid_territory = FALSE
	outdoors = TRUE
	ambientsounds = SPACE
	blob_allowed = FALSE //Eating up space doesn't count for victory as a blob.

	/// If false, loading multiple maps with this area type will create multiple instances.
	unique = TRUE


area/edina/backstreet
	name = "Nova Edina backstreets"
	icon_state = "edina_alley"
	clockwork_warp_allowed = TRUE
	ambientsounds = MAINTENANCE
	always_unpowered = FALSE //Sure you can have power if you want

area/edina/street
	name = "Nova Edina Streets"
	icon_state = "edina_street"
	ambientsounds = null //TODO:add ?

/area/edina/protected //Prevents ice storms
	name = "Sheltered Nova Edina"
