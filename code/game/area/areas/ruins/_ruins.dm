//Parent types

/area/ruin
	name = "\improper Unexplored Location"
	icon_state = "away"
	has_gravity = STANDARD_GRAVITY
	hidden = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	ambientsounds = RUINS
	sound_environment = SOUND_ENVIRONMENT_STONEROOM
	var/valid_territory = FALSE // hey so what if we did not allow things like cult summons to appear on ruins
	minimap_color = "#775940"
	minimap_color2 = "#6b5d48"
	minimap_show_walls = FALSE


/area/ruin/unpowered
	always_unpowered = FALSE

/area/ruin/unpowered/no_grav
	has_gravity = FALSE

/area/ruin/powered
	requires_power = FALSE
