GLOBAL_LIST_EMPTY(clients)							//all clients
GLOBAL_LIST_EMPTY(admins)							//all clients whom are admins
GLOBAL_PROTECT(admins)
GLOBAL_LIST_EMPTY(mentors)							//all clients whom are mentors
GLOBAL_PROTECT(mentors)
GLOBAL_LIST_EMPTY(deadmins)							//all ckeys who have used the de-admin verb.

GLOBAL_LIST_EMPTY(directory)							//all ckeys with associated client
GLOBAL_LIST_EMPTY(stealthminID)						//reference list with IDs that store ckeys, for stealthmins

GLOBAL_LIST_EMPTY(bunker_passthrough)

//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

GLOBAL_LIST_EMPTY(player_list)				//all mobs **with clients attached**.
GLOBAL_LIST_EMPTY(mob_list)					//all mobs, including clientless
GLOBAL_LIST_EMPTY(mob_directory)			//mob_id -> mob
GLOBAL_LIST_EMPTY(alive_mob_list)			//all alive mobs, including clientless. Excludes /mob/dead/new_player
GLOBAL_LIST_EMPTY(drones_list)
GLOBAL_LIST_EMPTY(dead_mob_list)			//all dead mobs, including clientless. Excludes /mob/dead/new_player
GLOBAL_LIST_EMPTY(joined_player_list)		//all clients that have joined the game at round-start or as a latejoin.
GLOBAL_LIST_EMPTY(silicon_mobs)				//all silicon mobs
GLOBAL_LIST_EMPTY(mob_living_list)				//all instances of /mob/living and subtypes
GLOBAL_LIST_EMPTY(carbon_list)				//all instances of /mob/living/carbon and subtypes, notably does not contain brains or simple animals
GLOBAL_LIST_EMPTY(human_list)				//all instances of /mob/living/carbon/human and subtypes
GLOBAL_LIST_EMPTY(ai_list)
GLOBAL_LIST_EMPTY(pai_list)
GLOBAL_LIST_EMPTY(available_ai_shells)
GLOBAL_LIST_INIT(simple_animals, list(list(),list(),list(),list())) // One for each AI_* status define
GLOBAL_LIST_EMPTY(spidermobs)				//all sentient spider mobs
GLOBAL_LIST_EMPTY(bots_list)
GLOBAL_LIST_EMPTY(aiEyes)

GLOBAL_LIST_EMPTY(language_datum_instances)
GLOBAL_LIST_EMPTY(all_languages)

GLOBAL_LIST_EMPTY(sentient_disease_instances)

GLOBAL_LIST_EMPTY(latejoin_ai_cores)

GLOBAL_LIST_EMPTY(mob_config_movespeed_type_lookup)
GLOBAL_LIST_EMPTY(mob_config_movespeed_type_lookup_floating)

GLOBAL_LIST_EMPTY(latejoiners) //CIT CHANGE - All latejoining people, for traitor-target purposes.

/// All alive antags with clients.
GLOBAL_LIST_EMPTY(current_living_antags)

/// All observers with clients that joined as observers.
GLOBAL_LIST_EMPTY(current_observers_list)

//Dynamic Port
GLOBAL_LIST_EMPTY(new_player_list) //all /mob/dead/new_player, in theory all should have clients and those that don't are in the process of spawning and get deleted when done.
//Family Port
GLOBAL_LIST_EMPTY(pre_setup_antags) //minds that have been picked as antag by the gamemode. removed as antag datums are set.

/proc/update_config_movespeed_type_lookup(update_mobs = TRUE)
	// NOTE: This is entirely based on the fact that byond typesof/subtypesof gets longer/deeper paths before shallower ones.
	// If that ever breaks this entire proc breaks.
	var/list/mob_types = typesof(/mob)
	var/list/mob_types_floating = typesof(/mob)
	var/list/entry_value = CONFIG_GET(keyed_list/multiplicative_movespeed/normal)
	var/list/entry_value_floating = CONFIG_GET(keyed_list/multiplicative_movespeed/floating)
	var/list/configured_types = list()
	var/list/configured_types_floating = list()
	for(var/path in entry_value)
		var/value = entry_value[path]
		if(isnull(value))
			continue
		// associative list sets for elements that already exist preserve order
		mob_types[path] = value
	for(var/path in entry_value_floating)
		var/value = entry_value_floating[path]
		if(isnull(value))
			continue
		mob_types_floating[path] = value
	// now go back up through it to set everything, making absolute sure that base paths are overridden by child paths all the way down the path tree.
	for(var/i in length(mob_types) to 1 step -1)
		var/path = mob_types[i]
		if(isnull(mob_types[path]))
			continue
		// we're going from bottom to top so it should be safe to do this without further checks..
		for(var/subpath in typesof(path))
			configured_types[subpath] = mob_types[path]
	for(var/i in length(mob_types_floating) to 1 step -1)
		var/path = mob_types_floating[i]
		if(isnull(mob_types_floating[path]))
			continue
		for(var/subpath in typesof(path))
			configured_types_floating[subpath] = mob_types_floating[path]
	GLOB.mob_config_movespeed_type_lookup = configured_types
	GLOB.mob_config_movespeed_type_lookup_floating = configured_types_floating
	if(update_mobs)
		update_mob_config_movespeeds()

/proc/update_mob_config_movespeeds()
	for(var/i in GLOB.mob_list)
		var/mob/M = i
		M.update_config_movespeed()

	//blood types
GLOBAL_LIST_INIT(regular_bloods,list(
		"O-",
		"O+",
		"A-",
		"A+",
		"B-",
		"B+",
		"AB-",
		"AB+"
		))

GLOBAL_LIST_INIT(all_types_bloods,list(
		"O-",
		"O+",
		"A-",
		"A+",
		"B-",
		"B+",
		"AB-",
		"AB+",
		"SY",
		"X*",
		"HF",
		"L",
		"U",
		"GEL",
		"BUG"
		))

GLOBAL_LIST_INIT(blood_reagent_types, list(
		/datum/reagent/blood,
		/datum/reagent/blood/jellyblood
		))
