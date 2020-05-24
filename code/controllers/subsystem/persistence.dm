#define FILE_ANTAG_REP "data/AntagReputation.json"
#define MAX_RECENT_MAP_RECORD 10

SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE
	flags = SS_NO_FIRE
	var/list/satchel_blacklist 		= list() //this is a typecache
	var/list/new_secret_satchels 	= list() //these are objects
	var/list/old_secret_satchels 	= list()

	var/list/obj/structure/chisel_message/chisel_messages = list()
	var/list/saved_messages = list()
	var/list/saved_modes = list(1,2,3)
	var/list/saved_dynamic_rules = list(list(),list(),list())
	var/list/saved_storytellers = list("foo","bar","baz")
	var/list/average_dynamic_threat = 50
	var/list/saved_maps
	var/list/saved_trophies = list()
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
	LoadSatchels()
	LoadPoly()
	LoadChiselMessages()
	LoadTrophies()
	LoadRecentModes()
	LoadRecentStorytellers()
	LoadRecentRulesets()
	LoadRecentMaps()
	LoadPhotoPersistence()
	for(var/client/C in GLOB.clients)
		LoadSavedVote(C.ckey)
	if(CONFIG_GET(flag/use_antag_rep))
		LoadAntagReputation()
	LoadRandomizedRecipes()
	LoadPanicBunker()
	return ..()

/datum/controller/subsystem/persistence/proc/LoadSatchels()
	var/placed_satchel = 0
	var/path
	if(fexists("data/npc_saves/SecretSatchels.sav")) //legacy conversion. Will only ever run once.
		var/savefile/secret_satchels = new /savefile("data/npc_saves/SecretSatchels.sav")
		for(var/map in secret_satchels)
			var/json_file = file("data/npc_saves/SecretSatchels[map].json")
			var/list/legacy_secret_satchels = splittext(secret_satchels[map],"#")
			var/list/satchels = list()
			for(var/i=1,i<=legacy_secret_satchels.len,i++)
				var/satchel_string = legacy_secret_satchels[i]
				var/list/chosen_satchel = splittext(satchel_string,"|")
				if(chosen_satchel.len == 3)
					var/list/data = list()
					data["x"] = text2num(chosen_satchel[1])
					data["y"] = text2num(chosen_satchel[2])
					data["saved_obj"] = chosen_satchel[3]
					satchels += list(data)
			var/list/file_data = list()
			file_data["data"] = satchels
			WRITE_FILE(json_file, json_encode(file_data))
		fdel("data/npc_saves/SecretSatchels.sav")

	var/json_file = file("data/npc_saves/SecretSatchels[SSmapping.config.map_name].json")
	var/list/json = list()
	if(fexists(json_file))
		json = json_decode(file2text(json_file))

	old_secret_satchels = json["data"]
	var/obj/item/storage/backpack/satchel/flat/F
	if(old_secret_satchels && old_secret_satchels.len >= 10) //guards against low drop pools assuring that one player cannot reliably find his own gear.
		var/pos = rand(1, old_secret_satchels.len)
		F = new()
		old_secret_satchels.Cut(pos, pos+1 % old_secret_satchels.len)
		F.x = old_secret_satchels[pos]["x"]
		F.y = old_secret_satchels[pos]["y"]
		F.z = SSmapping.station_start
		path = text2path(old_secret_satchels[pos]["saved_obj"])

	if(F)
		if(isfloorturf(F.loc) && !isplatingturf(F.loc))
			F.hide(1)
		if(ispath(path))
			var/spawned_item = new path(F)
			spawned_objects[spawned_item] = TRUE
		placed_satchel++
	var/free_satchels = 0
	for(var/turf/T in shuffle(block(locate(TRANSITIONEDGE,TRANSITIONEDGE,SSmapping.station_start), locate(world.maxx-TRANSITIONEDGE,world.maxy-TRANSITIONEDGE,SSmapping.station_start)))) //Nontrivially expensive but it's roundstart only
		if(isfloorturf(T) && !isplatingturf(T))
			new /obj/item/storage/backpack/satchel/flat/secret(T)
			free_satchels++
			if((free_satchels + placed_satchel) == 10) //ten tiles, more than enough to kill anything that moves
				break

/datum/controller/subsystem/persistence/proc/LoadPoly()
	for(var/mob/living/simple_animal/parrot/Poly/P in GLOB.alive_mob_list)
		twitterize(P.speech_buffer, "polytalk")
		break //Who's been duping the bird?!

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

/datum/controller/subsystem/persistence/proc/LoadTrophies()
	if(fexists("data/npc_saves/TrophyItems.sav")) //legacy compatability to convert old format to new
		var/savefile/S = new /savefile("data/npc_saves/TrophyItems.sav")
		var/saved_json
		S >> saved_json
		if(!saved_json)
			return
		saved_trophies = json_decode(saved_json)
		fdel("data/npc_saves/TrophyItems.sav")
	else
		var/json_file = file("data/npc_saves/TrophyItems.json")
		if(!fexists(json_file))
			return
		var/list/json = json_decode(file2text(json_file))
		if(!json)
			return
		saved_trophies = json["data"]
	SetUpTrophies(saved_trophies.Copy())

/datum/controller/subsystem/persistence/proc/LoadRecentModes()
	var/json_file = file("data/RecentModes.json")
	if(!fexists(json_file))
		return
	var/list/json = json_decode(file2text(json_file))
	if(!json)
		return
	saved_modes = json["data"]

/datum/controller/subsystem/persistence/proc/LoadRecentRulesets()
	var/json_file = file("data/RecentRulesets.json")
	if(!fexists(json_file))
		return
	var/list/json = json_decode(file2text(json_file))
	if(!json)
		return
	saved_dynamic_rules = json["data"]

/datum/controller/subsystem/persistence/proc/LoadRecentStorytellers()
	var/json_file = file("data/RecentStorytellers.json")
	if(!fexists(json_file))
		return
	var/list/json = json_decode(file2text(json_file))
	if(!json)
		return
	saved_storytellers = json["data"]
	if(saved_storytellers.len > 3)
		average_dynamic_threat = saved_storytellers[4]
	saved_storytellers.len = 3

/datum/controller/subsystem/persistence/proc/LoadRecentMaps()
	var/json_file = file("data/RecentMaps.json")
	if(!fexists(json_file))
		return
	var/list/json = json_decode(file2text(json_file))
	if(!json)
		return
	saved_maps = json["maps"]

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

/datum/controller/subsystem/persistence/proc/SetUpTrophies(list/trophy_items)
	for(var/A in GLOB.trophy_cases)
		var/obj/structure/displaycase/trophy/T = A
		if (T.showpiece)
			continue
		T.added_roundstart = TRUE

		var/trophy_data = pick_n_take(trophy_items)

		if(!islist(trophy_data))
			continue

		var/list/chosen_trophy = trophy_data

		if(!chosen_trophy || isemptylist(chosen_trophy)) //Malformed
			continue

		var/path = text2path(chosen_trophy["path"]) //If the item no longer exist, this returns null
		if(!path)
			continue

		T.showpiece = new /obj/item/showpiece_dummy(T, path)
		T.trophy_message = chosen_trophy["message"]
		T.placer_key = chosen_trophy["placer_key"]
		T.update_icon()

/datum/controller/subsystem/persistence/proc/CollectData()
	CollectChiselMessages()
	CollectSecretSatchels()
	CollectTrophies()
	CollectRoundtype()
	if(istype(SSticker.mode, /datum/game_mode/dynamic))
		var/datum/game_mode/dynamic/mode = SSticker.mode
		CollectStoryteller(mode)
		CollectRulesets(mode)
	RecordMaps()
	SavePhotoPersistence()						//THIS IS PERSISTENCE, NOT THE LOGGING PORTION.
	if(CONFIG_GET(flag/use_antag_rep))
		CollectAntagReputation()
	SaveRandomizedRecipes()
	SavePanicBunker()
	SavePaintings()

/datum/controller/subsystem/persistence/proc/LoadPanicBunker()
	var/bunker_path = file("data/bunker_passthrough.json")
	if(fexists(bunker_path))
		var/list/json = json_decode(file2text(bunker_path))
		GLOB.bunker_passthrough = json["data"]
		for(var/ckey in GLOB.bunker_passthrough)
			if(daysSince(GLOB.bunker_passthrough[ckey]) >= CONFIG_GET(number/max_bunker_days))
				GLOB.bunker_passthrough -= ckey

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

/datum/controller/subsystem/persistence/proc/CollectSecretSatchels()
	satchel_blacklist = typecacheof(list(/obj/item/stack/tile/plasteel, /obj/item/crowbar))
	var/list/satchels_to_add = list()
	for(var/A in new_secret_satchels)
		var/obj/item/storage/backpack/satchel/flat/F = A
		if(QDELETED(F) || F.z != SSmapping.station_start || F.invisibility != INVISIBILITY_MAXIMUM)
			continue
		var/list/savable_obj = list()
		for(var/obj/O in F)
			if(is_type_in_typecache(O, satchel_blacklist) || (O.flags_1 & ADMIN_SPAWNED_1))
				continue
			if(O.persistence_replacement)
				savable_obj += O.persistence_replacement
			else
				savable_obj += O.type
		if(isemptylist(savable_obj))
			continue
		var/list/data = list()
		data["x"] = F.x
		data["y"] = F.y
		data["saved_obj"] = pick(savable_obj)
		satchels_to_add += list(data)

	var/json_file = file("data/npc_saves/SecretSatchels[SSmapping.config.map_name].json")
	var/list/file_data = list()
	fdel(json_file)
	file_data["data"] = old_secret_satchels + satchels_to_add
	WRITE_FILE(json_file, json_encode(file_data))

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


/datum/controller/subsystem/persistence/proc/CollectTrophies()
	var/json_file = file("data/npc_saves/TrophyItems.json")
	var/list/file_data = list()
	file_data["data"] = remove_duplicate_trophies(saved_trophies)
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/persistence/proc/SavePanicBunker()
	var/json_file = file("data/bunker_passthrough.json")
	var/list/file_data = list()
	file_data["data"] = GLOB.bunker_passthrough
	fdel(json_file)
	WRITE_FILE(json_file,json_encode(file_data))

/datum/controller/subsystem/persistence/proc/remove_duplicate_trophies(list/trophies)
	var/list/ukeys = list()
	. = list()
	for(var/trophy in trophies)
		var/tkey = "[trophy["path"]]-[trophy["message"]]"
		if(ukeys[tkey])
			continue
		else
			. += list(trophy)
			ukeys[tkey] = TRUE

/datum/controller/subsystem/persistence/proc/SaveTrophy(obj/structure/displaycase/trophy/T)
	if(!T.added_roundstart && T.showpiece)
		var/list/data = list()
		data["path"] = T.showpiece.type
		data["message"] = T.trophy_message
		data["placer_key"] = T.placer_key
		saved_trophies += list(data)

/datum/controller/subsystem/persistence/proc/CollectRoundtype()
	saved_modes[3] = saved_modes[2]
	saved_modes[2] = saved_modes[1]
	saved_modes[1] = SSticker.mode.config_tag
	var/json_file = file("data/RecentModes.json")
	var/list/file_data = list()
	file_data["data"] = saved_modes
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/persistence/proc/CollectStoryteller(var/datum/game_mode/dynamic/mode)
	saved_storytellers.len = 3
	saved_storytellers[3] = saved_storytellers[2]
	saved_storytellers[2] = saved_storytellers[1]
	saved_storytellers[1] = mode.storyteller.name
	average_dynamic_threat = (mode.threat_average + average_dynamic_threat) / 2
	var/json_file = file("data/RecentStorytellers.json")
	var/list/file_data = list()
	file_data["data"] = saved_storytellers + average_dynamic_threat
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/persistence/proc/CollectRulesets(var/datum/game_mode/dynamic/mode)
	saved_dynamic_rules[3] = saved_dynamic_rules[2]
	saved_dynamic_rules[2] = saved_dynamic_rules[1]
	saved_dynamic_rules[1] = list()
	for(var/r in mode.executed_rules)
		var/datum/dynamic_ruleset/rule = r
		saved_dynamic_rules[1] += rule.config_tag
	var/json_file = file("data/RecentRulesets.json")
	var/list/file_data = list()
	file_data["data"] = saved_dynamic_rules
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/persistence/proc/RecordMaps()
	saved_maps = saved_maps?.len ? list("[SSmapping.config.map_name]") | saved_maps : list("[SSmapping.config.map_name]")
	var/json_file = file("data/RecentMaps.json")
	var/list/file_data = list()
	file_data["maps"] = saved_maps
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))


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
