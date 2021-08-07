#define FILE_ANTAG_REP "data/AntagReputation.json"
#define MAX_RECENT_MAP_RECORD 10

SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE
	flags = SS_NO_FIRE

	/// Marks if the station got horribly destroyed
	var/station_was_destroyed = FALSE
	/// Marks if persistence save should be disabled
	var/station_persistence_save_disabled = FALSE

	var/list/obj/structure/chisel_message/chisel_messages = list()
	var/list/saved_messages = list()
	var/list/spawned_objects = list()
	var/list/antag_rep = list()
	var/list/antag_rep_change = list()
	var/list/picture_logging_information = list()
	var/list/saved_votes = list()
	var/list/obj/structure/sign/picture_frame/photo_frames
	var/list/obj/item/storage/photo_album/photo_albums
	var/list/obj/structure/sign/painting/painting_frames = list()
	var/list/paintings = list()

/datum/controller/subsystem/persistence/Initialize()
	LoadServerPersistence()
	LoadGamePersistence()
	var/map_persistence_path = get_map_persistence_path()
	if(map_persistence_path)
		LoadMapPersistence()
	return ..()

/**
 * Gets the persistence path of the current map.
 */
/datum/controller/subsystem/persistence/proc/get_map_persistence_path()
	ASSERT(SSmapping.config)
	if(!SSmapping.config.persistence_key || (SSmapping.config.persistence_key == "NO_PERSIST"))
		return null
	return "data/persistence/[ckey(SSmapping.config.persistence_key)]"

/datum/controller/subsystem/persistence/proc/CollectData()
	SaveServerPersistence()
	if(station_persistence_save_disabled)
		return
	SaveGamePersistence()
	var/map_persistence_path = get_map_persistence_path()
	if(map_persistence_path)
		SaveMapPersistence()

/**
 * Loads persistent data relevant to the server: Configurations, past gamemodes, votes, antag rep, etc
 */
/datum/controller/subsystem/persistence/proc/LoadServerPersistence()
	for(var/client/C in GLOB.clients)
		LoadSavedVote(C.ckey)
	if(CONFIG_GET(flag/use_antag_rep))
		LoadAntagReputation()
	LoadRandomizedRecipes()
	LoadPaintings()

/**
 * Saves persistent data relevant to the server: Configurations, past gamemodes, votes, antag rep, etc
 */
/datum/controller/subsystem/persistence/proc/SaveServerPersistence()
	if(CONFIG_GET(flag/use_antag_rep))
		CollectAntagReputation()
	SaveRandomizedRecipes()

/**
 * Loads persistent data relevant to the game in general: Photos, etc
 *
 * Legacy map persistence systems also use this.
 */
/datum/controller/subsystem/persistence/proc/LoadGamePersistence()
	LoadChiselMessages()
	LoadPhotoPersistence()
	LoadPaintings()

/**
 * Saves persistent data relevant to the game in general: Photos, etc
 *
 * Legacy map persistence systems also use this.
 */
/datum/controller/subsystem/persistence/proc/SaveGamePersistence()
	CollectChiselMessages()
	SavePhotoPersistence()						//THIS IS PERSISTENCE, NOT THE LOGGING PORTION.
	SavePaintings()
	SaveScars()

/**
 * Loads persistent data relevant to the current map: Objects, etc.
 */
/datum/controller/subsystem/persistence/proc/LoadMapPersistence()
	return

/**
 * Saves persistent data relevant to the current map: Objects, etc.
 */
/datum/controller/subsystem/persistence/proc/SaveMapPersistence()
	return

/datum/controller/subsystem/persistence/proc/LoadChiselMessages()
	var/list/saved_messages = list()
	if(fexists("data/npc_saves/ChiselMessages.sav")) //legacy compatability to convert old format to new
		var/savefile/chisel_messages_sav = new /savefile("data/npc_saves/ChiselMessages.sav")
		var/saved_json
		chisel_messages_sav[SSmapping.config.map_name] >> saved_json
		if(!saved_json)
			return
		saved_messages = json_decode(saved_json)
		fdel("data/npc_saves/ChiselMessages.sav")
	else
		var/json_file = file("data/npc_saves/ChiselMessages[SSmapping.config.map_name].json")
		if(!fexists(json_file))
			return
		var/list/json = json_decode(file2text(json_file))

		if(!json)
			return
		saved_messages = json["data"]

	for(var/item in saved_messages)
		if(!islist(item))
			continue

		var/xvar = item["x"]
		var/yvar = item["y"]
		var/zvar = item["z"]

		if(!xvar || !yvar || !zvar)
			continue

		var/turf/T = locate(xvar, yvar, zvar)
		if(!isturf(T))
			continue

		if(locate(/obj/structure/chisel_message) in T)
			continue

		var/obj/structure/chisel_message/M = new(T)

		if(!QDELETED(M))
			M.unpack(item)

	log_world("Loaded [saved_messages.len] engraved messages on map [SSmapping.config.map_name]")


/datum/controller/subsystem/persistence/proc/LoadAntagReputation()
	var/json = file2text(FILE_ANTAG_REP)
	if(!json)
		var/json_file = file(FILE_ANTAG_REP)
		if(!fexists(json_file))
			WARNING("Failed to load antag reputation. File likely corrupt.")
			return
		return
	antag_rep = json_decode(json)

/datum/controller/subsystem/persistence/proc/LoadSavedVote(var/ckey)
	var/json_file = file("data/player_saves/[copytext(ckey,1,2)]/[ckey]/SavedVotes.json")
	if(!fexists(json_file))
		return
	var/list/json = json_decode(file2text(json_file))
	if(!json)
		return
	saved_votes[ckey] = json["data"]

/datum/controller/subsystem/persistence/proc/GetPhotoAlbums()
	var/album_path = file("data/photo_albums.json")
	if(fexists(album_path))
		return json_decode(file2text(album_path))

/datum/controller/subsystem/persistence/proc/GetPhotoFrames()
	var/frame_path = file("data/photo_frames.json")
	if(fexists(frame_path))
		return json_decode(file2text(frame_path))

/datum/controller/subsystem/persistence/proc/LoadPhotoPersistence()
	var/album_path = file("data/photo_albums.json")
	var/frame_path = file("data/photo_frames.json")
	if(fexists(album_path))
		var/list/json = json_decode(file2text(album_path))
		if(json.len)
			for(var/i in photo_albums)
				var/obj/item/storage/photo_album/A = i
				if(!A.persistence_id)
					continue
				if(json[A.persistence_id])
					A.populate_from_id_list(json[A.persistence_id])

	if(fexists(frame_path))
		var/list/json = json_decode(file2text(frame_path))
		if(json.len)
			for(var/i in photo_frames)
				var/obj/structure/sign/picture_frame/PF = i
				if(!PF.persistence_id)
					continue
				if(json[PF.persistence_id])
					PF.load_from_id(json[PF.persistence_id])

/datum/controller/subsystem/persistence/proc/SavePhotoPersistence()
	var/album_path = file("data/photo_albums.json")
	var/frame_path = file("data/photo_frames.json")

	var/list/frame_json = list()
	var/list/album_json = list()

	if(fexists(album_path))
		album_json = json_decode(file2text(album_path))
		fdel(album_path)

	for(var/i in photo_albums)
		var/obj/item/storage/photo_album/A = i
		if(!istype(A) || !A.persistence_id)
			continue
		var/list/L = A.get_picture_id_list()
		album_json[A.persistence_id] = L

	album_json = json_encode(album_json)

	WRITE_FILE(album_path, album_json)

	if(fexists(frame_path))
		frame_json = json_decode(file2text(frame_path))
		fdel(frame_path)

	for(var/i in photo_frames)
		var/obj/structure/sign/picture_frame/F = i
		if(!istype(F) || !F.persistence_id)
			continue
		frame_json[F.persistence_id] = F.get_photo_id()

	frame_json = json_encode(frame_json)

	WRITE_FILE(frame_path, frame_json)

/datum/controller/subsystem/persistence/proc/CollectChiselMessages()
	var/json_file = file("data/npc_saves/ChiselMessages[SSmapping.config.map_name].json")

	for(var/obj/structure/chisel_message/M in chisel_messages)
		saved_messages += list(M.pack())

	log_world("Saved [saved_messages.len] engraved messages on map [SSmapping.config.map_name]")
	var/list/file_data = list()
	file_data["data"] = saved_messages
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/persistence/proc/SaveChiselMessage(obj/structure/chisel_message/M)
	saved_messages += list(M.pack()) // dm eats one list

/datum/controller/subsystem/persistence/proc/CollectAntagReputation()
	var/ANTAG_REP_MAXIMUM = CONFIG_GET(number/antag_rep_maximum)

	for(var/p_ckey in antag_rep_change)
//		var/start = antag_rep[p_ckey]
		antag_rep[p_ckey] = max(0, min(antag_rep[p_ckey]+antag_rep_change[p_ckey], ANTAG_REP_MAXIMUM))

//		WARNING("AR_DEBUG: [p_ckey]: Committed [antag_rep_change[p_ckey]] reputation, going from [start] to [antag_rep[p_ckey]]")

	antag_rep_change = list()

	fdel(FILE_ANTAG_REP)
	text2file(json_encode(antag_rep), FILE_ANTAG_REP)

/datum/controller/subsystem/persistence/proc/LoadRandomizedRecipes()
	var/json_file = file("data/RandomizedChemRecipes.json")
	var/json
	if(fexists(json_file))
		json = json_decode(file2text(json_file))

	for(var/randomized_type in subtypesof(/datum/chemical_reaction/randomized))
		var/datum/chemical_reaction/randomized/R = new randomized_type
		var/loaded = FALSE
		if(R.persistent && json)
			var/list/recipe_data = json[R.id]
			if(recipe_data && R.LoadOldRecipe(recipe_data) && (daysSince(R.created) <= R.persistence_period))
				loaded = TRUE
		if(!loaded) //We do not have information for whatever reason, just generate new one
			R.GenerateRecipe()

		if(!R.HasConflicts()) //Might want to try again if conflicts happened in the future.
			add_chemical_reaction(R)

/datum/controller/subsystem/persistence/proc/SaveRandomizedRecipes()
	var/json_file = file("data/RandomizedChemRecipes.json")
	var/list/file_data = list()

	//asert globchems done
	for(var/randomized_type in subtypesof(/datum/chemical_reaction/randomized))
		var/datum/chemical_reaction/randomized/R = randomized_type
		R = get_chemical_reaction(initial(R.id)) //ew, would be nice to add some simple tracking
		if(R && R.persistent && R.id)
			var/recipe_data = list()
			recipe_data["timestamp"] = R.created
			recipe_data["required_reagents"] = R.required_reagents
			recipe_data["required_catalysts"] = R.required_catalysts
			recipe_data["required_temp"] = R.required_temp
			recipe_data["is_cold_recipe"] = R.is_cold_recipe
			recipe_data["results"] = R.results
			recipe_data["required_container"] = "[R.required_container]"
			file_data["[R.id]"] = recipe_data

	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/persistence/proc/SaveSavedVotes()
	for(var/ckey in saved_votes)
		var/json_file = file("data/player_saves/[copytext(ckey,1,2)]/[ckey]/SavedVotes.json")
		var/list/file_data = list()
		file_data["data"] = saved_votes[ckey]
		fdel(json_file)
		WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/persistence/proc/LoadPaintings()
	var/json_file = file("data/paintings.json")
	if(fexists(json_file))
		paintings = json_decode(file2text(json_file))

	for(var/obj/structure/sign/painting/P in painting_frames)
		P.load_persistent()

/datum/controller/subsystem/persistence/proc/SavePaintings()
	for(var/obj/structure/sign/painting/P in painting_frames)
		P.save_persistent()

	var/json_file = file("data/paintings.json")
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(paintings))

/datum/controller/subsystem/persistence/proc/SaveScars()
	for(var/i in GLOB.joined_player_list)
		var/mob/living/carbon/human/ending_human = get_mob_by_ckey(i)
		if(!istype(ending_human) || !ending_human.mind || !ending_human.client || !ending_human.client.prefs || !ending_human.client.prefs.persistent_scars)
			continue

		var/mob/living/carbon/human/original_human = ending_human.mind.original_character
		if(!original_human || original_human.stat == DEAD || !original_human.all_scars || !(original_human == ending_human))
			if(ending_human.client) // i was told if i don't check this every step of the way byond might decide a client ceases to exist mid proc so here we go
				ending_human.client.prefs.scars_list["[ending_human.client.prefs.scars_index]"] = ""
		else
			for(var/k in ending_human.all_wounds)
				var/datum/wound/iter_wound = k
				iter_wound.remove_wound() // so we can get the scars for open wounds
			if(!ending_human.client)
				return
			ending_human.client.prefs.scars_list["[ending_human.client.prefs.scars_index]"] = ending_human.format_scars()
		if(!ending_human.client)
			return
		ending_human.client.prefs.save_character()

/datum/controller/subsystem/persistence/proc/SaveTCGCards()
	for(var/i in GLOB.joined_player_list)
		var/mob/living/carbon/human/ending_human = get_mob_by_ckey(i)
		if(!istype(ending_human) || !ending_human.mind || !ending_human.client || !ending_human.client.prefs || !ending_human.client.prefs.tcg_cards)
			continue

		var/mob/living/carbon/human/original_human = ending_human.mind.original_character
		if(!original_human || original_human.stat == DEAD || !(original_human == ending_human))
			continue

		ending_human.SaveTCGCards()
