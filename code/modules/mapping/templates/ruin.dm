////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////// DO NOT PUT RUIN DEFS INTO THIS FILE - Put them in modules/maps/ruins/* ///////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Ruin datums - legacy map templates for dynamic seeding of POIs/structures
 */
/datum/map_template/ruin
	//name = "A Chest of Doubloons"
	name = null
	var/id = null // For blacklisting purposes, all ruins need an id
	var/description = "In the middle of a clearing in the rockface, there's a chest filled with gold coins with Spanish engravings. \
	How is there a wooden container filled with 18th century coinage in the middle of a lavawracked hellscape? \
	It is clearly a mystery."

	var/unpickable = FALSE 	 //If TRUE these won't be placed automatically (can still be forced or loaded with another ruin)
	var/always_place = FALSE //Will skip the whole weighting process and just plop this down, ideally you want the ruins of this kind to have no cost.
	var/placement_weight = 1 //How often should this ruin appear
	var/cost = 0 //Cost in ruin budget placement system
	var/allow_duplicates = TRUE
	var/list/always_spawn_with = null //These ruin types will be spawned along with it (where dependent on the flag) eg list(/datum/map_template/ruin/space/teleporter_space = SPACERUIN_Z)
	var/list/never_spawn_with = null //If this ruin is spawned these will not eg list(/datum/map_template/ruin/base_alternate)

/datum/map_template/ruin/New()
	if(!name && id)
		name = id

	mappath = prefix + suffix
	..(path = mappath)

/datum/map_template/ruin/proc/try_to_place(z,allowed_areas,turf/forced_turf)
	var/sanity = forced_turf ? 1 : PLACEMENT_TRIES
	while(sanity > 0)
		sanity--
		var/width_border = TRANSITIONEDGE + SPACERUIN_MAP_EDGE_PAD + round(width / 2)
		var/height_border = TRANSITIONEDGE + SPACERUIN_MAP_EDGE_PAD + round(height / 2)
		var/turf/central_turf = forced_turf ? forced_turf : locate(rand(width_border, world.maxx - width_border), rand(height_border, world.maxy - height_border), z)
		var/valid = TRUE

		for(var/turf/check in get_affected_turfs(central_turf,1))
			var/area/new_area = get_area(check)
			valid = FALSE // set to false before we check
			if(check.flags_1 & NO_RUINS_1)
				break
			for(var/type in allowed_areas)
				if(istype(new_area, type)) // it's at least one of our types so it's whitelisted
					valid = TRUE
					break

			if(!valid)
				break


		if(!valid)
			continue

		testing("Ruin \"[name]\" placed at ([central_turf.x], [central_turf.y], [central_turf.z])")

		for(var/i in get_affected_turfs(central_turf, 1))
			var/turf/T = i
			for(var/obj/structure/spawner/nest in T)
				qdel(nest)
			for(var/mob/living/simple_animal/monster in T)
				qdel(monster)
			for(var/obj/structure/flora/ash/plant in T)
				qdel(plant)

		load(central_turf,centered = TRUE)
		loaded++

		for(var/turf/T in get_affected_turfs(central_turf, 1))
			T.flags_1 |= NO_RUINS_1

		new /obj/effect/landmark/ruin(central_turf, src)
		return central_turf

/proc/seedRuins(list/z_levels = null, budget = 0, whitelist = list(/area/space), list/potentialRuins)
	if(!z_levels || !z_levels.len)
		WARNING("No Z levels provided - Not generating ruins")
		return

	for(var/zl in z_levels)
		var/turf/T = locate(1, 1, zl)
		if(!T)
			WARNING("Z level [zl] does not exist - Not generating ruins")
			return

	var/list/ruins = potentialRuins.Copy()

	var/list/forced_ruins = list()		//These go first on the z level associated (same random one by default) or if the assoc value is a turf to the specified turf.
	var/list/ruins_availible = list()	//we can try these in the current pass

	//Set up the starting ruin list
	for(var/key in ruins)
		var/datum/map_template/ruin/R = ruins[key]
		if(R.cost > budget) //Why would you do that
			continue
		if(R.always_place)
			forced_ruins[R] = -1
		if(R.unpickable)
			continue
		ruins_availible[R] = R.placement_weight

	while(budget > 0 && (ruins_availible.len || forced_ruins.len))
		var/datum/map_template/ruin/current_pick
		var/forced = FALSE
		var/forced_z	//If set we won't pick z level and use this one instead.
		var/forced_turf //If set we place the ruin centered on the given turf
		if(forced_ruins.len) //We have something we need to load right now, so just pick it
			for(var/ruin in forced_ruins)
				current_pick = ruin
				if(isturf(forced_ruins[ruin]))
					var/turf/T = forced_ruins[ruin]
					forced_z = T.z //In case of chained ruins
					forced_turf = T
				else if(forced_ruins[ruin] > 0) //Load into designated z
					forced_z = forced_ruins[ruin]
				forced = TRUE
				break
		else //Otherwise just pick random one
			current_pick = pickweight(ruins_availible)

		var/placement_tries = forced_turf ? 1 : PLACEMENT_TRIES //Only try once if we target specific turf
		var/failed_to_place = TRUE
		var/target_z = 0
		var/turf/placed_turf //Where the ruin ended up if we succeeded
		outer:
			while(placement_tries > 0)
				placement_tries--
				target_z = pick(z_levels)
				if(forced_z)
					target_z = forced_z
				if(current_pick.always_spawn_with) //If the ruin has part below, make sure that z exists.
					for(var/v in current_pick.always_spawn_with)
						if(current_pick.always_spawn_with[v] == PLACE_BELOW)
							var/turf/T = locate(1,1,target_z)
							if(!T.Below())
								if(forced_z)
									continue outer
								else
									break outer

				placed_turf = current_pick.try_to_place(target_z,whitelist,forced_turf)
				if(!placed_turf)
					continue
				else
					failed_to_place = FALSE
					break

		//That's done remove from priority even if it failed
		if(forced)
			//TODO : handle forced ruins with multiple variants
			// this might work?
			forced_ruins -= current_pick
			if(!current_pick.allow_duplicates)
				for(var/datum/map_template/ruin/R in forced_ruins)
					if(R.id == current_pick.id)
						forced_ruins -= R
			forced = FALSE

		if(failed_to_place)
			for(var/datum/map_template/ruin/R in ruins_availible)
				if(R.id == current_pick.id)
					ruins_availible -= R
			log_world("Failed to place [current_pick.name] ruin.")
		else
			budget -= current_pick.cost
			if(!current_pick.allow_duplicates)
				for(var/datum/map_template/ruin/R in ruins_availible)
					if(R.id == current_pick.id)
						ruins_availible -= R
			if(current_pick.never_spawn_with)
				for(var/blacklisted_type in current_pick.never_spawn_with)
					for(var/possible_exclusion in ruins_availible)
						if(istype(possible_exclusion,blacklisted_type))
							ruins_availible -= possible_exclusion
			if(current_pick.always_spawn_with)
				for(var/v in current_pick.always_spawn_with)
					for(var/ruin_name in SSmapping.ruins_templates) //Because we might want to add space templates as linked of lava templates.
						var/datum/map_template/ruin/linked = SSmapping.ruins_templates[ruin_name] //why are these assoc, very annoying.
						if(istype(linked,v))
							switch(current_pick.always_spawn_with[v])
								if(PLACE_SAME_Z)
									forced_ruins[linked] = target_z //I guess you might want a chain somehow
								if(PLACE_LAVA_RUIN)
									forced_ruins[linked] = pick(SSmapping.LevelsByTrait(ZTRAIT_LAVA_RUINS))
								if(PLACE_SPACE_RUIN)
									forced_ruins[linked] = pick(SSmapping.LevelsByTrait(ZTRAIT_SPACE_RUINS))
								if(PLACE_DEFAULT)
									forced_ruins[linked] = -1
								if(PLACE_BELOW)
									forced_ruins[linked] = placed_turf.Below()

		//Update the availible list
		for(var/datum/map_template/ruin/R in ruins_availible)
			if(R.cost > budget)
				ruins_availible -= R

	log_world("Ruin loader finished with [budget] left to spend.")
