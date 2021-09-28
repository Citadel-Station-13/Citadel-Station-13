/datum/procedural_generation/perlin
	name = "Perlin 2D Noise"
	binary = FALSE
	/// zoom level
	var/zoom

/datum/procedural_generation/perlin/Variables()
	. = ..()
	.[NAMEOF(src, zoom)] = VV_NUM

/datum/procedural_generation/perlin/run()
	complete = TRUE

/datum/procedural_generation/perlin/get_at(x, y)
	ASSERT(isnum(x))
	ASSERT(isnum(y))
	return rustg_noise_get_at_coordinates("[seed]", "[x / zoom]", "[y / zoom]")
