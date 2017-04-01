//Parent types

/area/ruin
	name = "\improper Unexplored Location"
	icon_state = "away"
	has_gravity = 1
	sound_environment = SOUND_ENVIRONMENT_STONEROOM


/area/ruin/unpowered
	always_unpowered = 0

/area/ruin/unpowered/no_grav
	has_gravity = 0

/area/ruin/powered
	requires_power = 0
	sound_environment = SOUND_ENVIRONMENT_HALLWAY




//Areas
/area/ruin/unpowered/hierophant
	name = "Hierophant's Arena"

/area/ruin/unpowered/no_grav/way_home
	name = "\improper Salvation"
	icon_state = "away"

/area/ruin/powered/snow_biodome
	sound_environment = SOUND_ENVIRONMENT_STONEROOM

/area/ruin/powered/golem_ship
	name = "Free Golem Ship"
	sound_environment = SOUND_ENVIRONMENT_STONEROOM

/area/ruin/powered/syndicate_lava_base
	name = "Secret Base"
	sound_environment = SOUND_ENVIRONMENT_STONEROOM

// Ruins of "onehalf" ship

/area/ruin/onehalf/hallway
	name = "Hallway"
	icon_state = "hallC"
	sound_environment = SOUND_ENVIRONMENT_STONEROOM

/area/ruin/onehalf/drone_bay
	name = "Mining Drone Bay"
	icon_state = "engine"
	sound_environment = SOUND_ENVIRONMENT_STONEROOM

/area/ruin/onehalf/dorms_med
	name = "Crew Quarters"
	icon_state = "Sleep"
	sound_environment = SOUND_ENVIRONMENT_STONEROOM

/area/ruin/onehalf/bridge
	name = "Bridge"
	icon_state = "bridge"
	sound_environment = SOUND_ENVIRONMENT_STONEROOM



/area/ruin/powered/dinner_for_two
	name = "Dinner for Two"

/area/ruin/powered/authorship
	name = "Authorship"

/area/ruin/powered/aesthetic
	name = "Aesthetic"
	ambientsounds = list('sound/ambience/ambivapor1.ogg')


//Ruin of Hotel

/area/ruin/hotel
	name = "Hotel"
	sound_environment = SOUND_ENVIRONMENT_HALLWAY

/area/ruin/hotel/guestroom
	name = "Hotel Guest Room"
	icon_state = "Sleep"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/ruin/hotel/security
	name = "Hotel Security Post"
	icon_state = "security"

/area/ruin/hotel/pool
	name = "Hotel Pool Room"
	icon_state = "fitness"
	sound_environment = SOUND_ENVIRONMENT_BATHROOM

/area/ruin/hotel/bar
	name = "Hotel Bar"
	icon_state = "cafeteria"


/area/ruin/hotel/power
	name = "Hotel Power Room"
	icon_state = "engine_smes"
	sound_environment = SOUND_ENVIRONMENT_SEWER_PIPE

/area/ruin/hotel/custodial
	name = "Hotel Custodial Closet"
	icon_state = "janitor"
	sound_environment = SOUND_ENVIRONMENT_SEWER_PIPE

/area/ruin/hotel/shuttle
	name = "Hotel Shuttle"
	icon_state = "shuttle"
	requires_power = 0


/area/ruin/hotel/dock
	name = "Hotel Shuttle Dock"
	icon_state = "start"


/area/ruin/hotel/workroom
	name = "Hotel Staff Room"
	icon_state = "crew_quarters"
	sound_environment = SOUND_ENVIRONMENT_LIVINGROOM



/area/ruin/fakespace
	icon_state = "space"
	requires_power = 1
	always_unpowered = 1
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	has_gravity = 0
	power_light = 0
	power_equip = 0
	power_environ = 0
	valid_territory = 0
	outdoors = 1
	ambientsounds = list('sound/ambience/ambispace.ogg','sound/ambience/title2.ogg')
	blob_allowed = 0



//Ruin of Derelict Oupost

/area/ruin/derelictoutpost
	name = "Derelict Outpost"
	icon_state = "green"
	sound_environment = SOUND_ENVIRONMENT_ARENA

/area/ruin/derelictoutpost/cargostorage
	name = "Derelict Outpost Cargo Storage"
	icon_state = "storage"

/area/ruin/derelictoutpost/cargobay
	name = "Derelict Outpost Cargo Bay"
	icon_state = "quartstorage"

/area/ruin/derelictoutpost/powerstorage
	name = "Derelict Outpost Power Storage"
	icon_state = "engine_smes"

/area/ruin/derelictoutpost/dockedship
	name = "Derelict Outpost Docked Ship"
	icon_state = "red"


//Ruin of Space Bar

/area/ruin/powered/spacebar
	name = "Space Bar"
	icon_state = "yellow"

/area/ruin/powered/spacebar/bar
	icon_state = "bar"


//Ruin of turretedoutpost

/area/ruin/turretedoutpost
	name = "Turreted Outpost"
	icon_state = "red"
	sound_environment = SOUND_ENVIRONMENT_ARENA


//Ruin of old teleporter

/area/ruin/oldteleporter
	name = "Old teleporter"
	icon_state = "teleporter"
	has_gravity = 0
	sound_environment = SOUND_ENVIRONMENT_ARENA


//Ruin of mech transport

/area/ruin/powered/mechtransport
	name = "Mech Transport"
	icon_state = "green"


//Ruin of gas the lizard

/area/ruin/gasthelizard
	name = "Gas the lizard"


//Ruin of Deep Storage

/area/ruin/deepstorage
	name = "Deep Storage"
	icon_state = "storage"


//Ruin of Abandoned Zoo

/area/ruin/abandonedzoo
	name = "Abandoned Zoo"
	icon_state = "green"
