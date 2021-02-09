/**
 * Secret satchel persistence - allows storing of items in underfloor satchels that's loaded later.
 */
/datum/controller/subsystem/persistence
	var/list/satchel_blacklist 		= list() //this is a typecache
	var/list/new_secret_satchels 	= list() //these are objects
	var/list/old_secret_satchels 	= list()

/datum/controller/subsystem/persistence/LoadGamePersistence()
	. = ..()
	LoadSatchels()

/datum/controller/subsystem/persistence/SaveGamePersistence()
	. = ..()
	CollectSecretSatchels()

/datum/controller/subsystem/persistence/proc/LoadSatchels()
	var/placed_satchel = 0
	var/path

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
