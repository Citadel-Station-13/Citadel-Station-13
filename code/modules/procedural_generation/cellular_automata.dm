/datum/procedural_generation/cellular_automata
	name = "Cellular Automata"
	binary = TRUE
	/// initial closed cell chance
	var/closed_chance = 45
	/// smoothing iterations
	var/smoothing_iterations = 20
	/// how many neighbors does a dead cell need to be alive
	var/birth_limit = 4
	/// how little neighbors does a alive cell need to die
	var/death_limit = 3

/datum/procedural_generation/cellular_automata/Variables()
	. = ..()
	.[NAMEOF(src, closed_chance)] = VV_NUM
	.[NAMEOF(src, smoothing_iterations)] = VV_NUM
	.[NAMEOF(src, birth_limit)] = VV_NUM
	.[NAMEOF(src, death_limit)] = VV_NUM

/datum/procedural_generation/cellular_automata/get_at(x, y)
	return text2num(cache[width * (y - 1) + x])

/datum/procedural_generation/cellular_automata/run()
	ASSERT(isnum(width))
	ASSERT(isnum(height))
	ASSERT(isnum(birth_limit))
	ASSERT(isnum(death_limit))
	ASSERT(isnum(smoothing_iterations))
	ASSERT(isnum(closed_chance))
	cache = rustg_cnoise_generate("[closed_chance]", "[smoothing_iterations]", "[birth_limit]", "[death_limit]", "[width]", "[height]")
	complete = TRUE
