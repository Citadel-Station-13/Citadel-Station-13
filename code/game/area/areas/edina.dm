/area/edina
	name = "Nova Edina wilderness"
	icon_state = "edina"
	has_gravity = STANDARD_GRAVITY
	clockwork_warp_allowed = FALSE // Can servants warp into this area from Reebe?
	clockwork_warp_fail = "The aurora borealis is interfering with your teleport! Try somewhere closer to the city."
	always_unpowered = TRUE

	//dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	outdoors = TRUE
	//ambientsounds = SPACE //For later

/area/edina/backstreet
	name = "Nova Edina backstreets"
	icon_state = "edina_alley"
	clockwork_warp_allowed = TRUE
	ambientsounds = MAINTENANCE
	always_unpowered = FALSE //Sure you can have power if you want

/area/edina/backstreet/supply
	name = "Supply Backstreets"
	icon_state = "edina_alley"
	clockwork_warp_allowed = TRUE
	ambientsounds = MAINTENANCE
	always_unpowered = FALSE //Sure you can have power if you want

/area/edina/backstreet/research
	name = "Research Backstreets"
	icon_state = "edina_alley"
	clockwork_warp_allowed = TRUE
	ambientsounds = MAINTENANCE
	always_unpowered = FALSE //Sure you can have power if you want

/area/edina/backstreet/med
	name = "Hospital Backstreets"
	icon_state = "edina_alley"
	clockwork_warp_allowed = TRUE
	ambientsounds = MAINTENANCE
	always_unpowered = FALSE //Sure you can have power if you want

///Nova Edina Streets///


/area/edina/street
	name = "Nova Edina Streets"
	icon_state = "edina_street"
	ambientsounds = null //TODO:add ?
	always_unpowered = FALSE //Sure you can have power if you want

/area/edina/street/primary
	name = "Nova Edina Streets"
	icon_state = "edina_street"
	ambientsounds = null //TODO:add ?

/area/edina/street/primary/princess
	name = "Princess Street"
	icon_state = "edina_street"
	ambientsounds = null //TODO:add ?

/area/edina/street/primary/progress
	name = "Progress Street"
	icon_state = "edina_street"
	ambientsounds = null //TODO:add ?

/area/edina/street/primary/perimeter
	name = "Perimeter Way"
	icon_state = "edina_street"
	ambientsounds = null //TODO:add ?

/area/edina/street/primary/servitor
	name = "Servitor Street"
	icon_state = "edina_street"
	ambientsounds = null //TODO:add ?

/area/edina/street/secondary
	name = "Nova Edina Streets"
	icon_state = "edina_street2"
	ambientsounds = null //TODO:add ?

/area/edina/street/secondary/command
	name = "Command Court"
	icon_state = "edina_street2"
	ambientsounds = null //TODO:add ?

/area/edina/street/secondary/supply
	name = "Supply Street"
	icon_state = "edina_street2"
	ambientsounds = null //TODO:add ?

/area/edina/street/secondary/castle
	name = "Castle Way"
	icon_state = "edina_street2"
	ambientsounds = null //TODO:add ?

/area/edina/street/secondary/aux
	name = "Auxiliary Avenue"
	icon_state = "edina_street2"
	ambientsounds = null //TODO:add ?

/area/edina/street/intersection
	name = "Nova Edina Streets"
	icon_state = "edina_street2"
	ambientsounds = null //TODO:add ?

/area/edina/street/intersection/princessprogress
	name = "Princess & Progress"
	icon_state = "edina_street2"
	ambientsounds = null //TODO:add ?

/area/edina/street/intersection/princessperimeter
	name = "Princess & Perimeter"
	icon_state = "edina_street2"
	ambientsounds = null //TODO:add ?

/area/edina/street/intersection/princessperimeter/north
	name = "Perimeter & N Princess"
	icon_state = "edina_street2"
	ambientsounds = null //TODO:add ?

/area/edina/street/intersection/princessperimeter/south
	name = "Perimeter & S Princess"
	icon_state = "edina_street2"
	ambientsounds = null //TODO:add ?

/area/edina/street/intersection/princessservitor
	name = "Servitor & Princess"
	icon_state = "edina_street2"
	ambientsounds = null //TODO:add ?

/area/edina/street/intersection/servsuppaux
	name = "Servitor, Supply, & Auxiliary"
	icon_state = "edina_street2"
	ambientsounds = null //TODO:add ?

/area/edina/street/intersection/progcastaux
	name = "Progress, Castle, & Auxiliary"
	icon_state = "edina_street2"
	ambientsounds = null //TODO:add ?

/area/edina/street/street2 //Just so laying areas is easier
	icon_state = "edina_street2"

/area/edina/protected //Prevents ice storms
	name = "Sheltered Nova Edina"

/////////////////Edina specific derivitives///////////////////////////////////

/area/edina/crew_quarters
	clockwork_warp_allowed = TRUE
	area_flags = BLOBS_ALLOWED | VALID_TERRITORY

/area/edina/crew_quarters/holo_atrium
	name = "Hologram atrium"

/area/edina/crew_quarters/store/clothes
	name = "Clothes Store"

/area/edina/crew_quarters/store/plushies
	name = "Plushies Store"

/area/edina/crew_quarters/store/pet
	name = "Pet Store"

////////////////Mapping helper/////////////////////////
/obj/effect/mapping_helpers/planet_z
	name = "planet z helper"
	layer = POINT_LAYER

/obj/effect/mapping_helpers/planet_z/Initialize(mapload)
	. = ..()
	var/datum/space_level/S = SSmapping.get_level(z)
	S.traits["Planet"] = TRUE //This probably doesn't work as I expect. But maybe!!
