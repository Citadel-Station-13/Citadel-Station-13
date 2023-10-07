// Loadout system. All items are children of /datum/gear. To make a new item, you usually just define a new item like /datum/gear/example
// then set required vars like name(string), category(slot define, take them from code/__DEFINES/inventory.dm (the lowertext ones) (be sure that there is an entry in
// slot_to_string(slot) proc in hippiestation/code/_HELPERS/mobs.dm to show the category name in preferences menu) and path (the actual item path).
// description defaults to the path initial desc, cost defaults to 1 point but if you think your item requires more points, the framework allows that
// and lastly, restricted_roles list allows you to let someone spawn with certain items only if the job they spawned with is on the list.

GLOBAL_LIST_EMPTY(loadout_items)
GLOBAL_LIST_EMPTY(loadout_whitelist_ids)

/proc/load_loadout_config(loadout_config)
	if(!loadout_config)
		loadout_config = "config/loadout_config.txt"
	var/list/file_lines = world.file2list(loadout_config)
	for(var/line in file_lines)
		if(!line || line[1] == "#")
			continue
		var/list/lineinfo = splittext(line, "|")
		var/lineID = lineinfo[1]
		for(var/subline in lineinfo)
			var/sublinetypedef = findtext(subline, "=")
			if(sublinetypedef)
				var/sublinetype = copytext(subline, 1, sublinetypedef)
				var/list/sublinecontent = splittext(copytext(subline, sublinetypedef+ length(sublinetypedef)), ",")
				if(sublinetype == "WHITELIST")
					GLOB.loadout_whitelist_ids["[lineID]"] = sublinecontent

/proc/initialize_global_loadout_items()
	load_loadout_config()
	for(var/item in subtypesof(/datum/gear))
		var/datum/gear/I = item
		if(!initial(I.name))
			continue
		I = new item
		LAZYINITLIST(GLOB.loadout_items[I.category])
		LAZYINITLIST(GLOB.loadout_items[I.category][I.subcategory])
		GLOB.loadout_items[I.category][I.subcategory][I.name] = I
		if(islist(I.geargroupID))
			var/list/ggidlist = I.geargroupID
			I.ckeywhitelist = list()
			for(var/entry in ggidlist)
				if(entry in GLOB.loadout_whitelist_ids)
					I.ckeywhitelist |= GLOB.loadout_whitelist_ids["[entry]"]
		else if(I.geargroupID in GLOB.loadout_whitelist_ids)
			I.ckeywhitelist = GLOB.loadout_whitelist_ids["[I.geargroupID]"]


/datum/gear
	var/name
	var/category = LOADOUT_CATEGORY_NONE
	var/subcategory = LOADOUT_SUBCATEGORY_NONE
	var/slot
	var/description
	var/path //item-to-spawn path
	var/cost = 1 //normally, each loadout costs a single point.
	var/geargroupID //defines the ID that the gear inherits from the config
	var/loadout_flags = LOADOUT_CAN_NAME | LOADOUT_CAN_DESCRIPTION
	var/list/loadout_initial_colors = list()
	var/handle_post_equip = FALSE

	//NEW DONATOR SYTSEM STUFF
	var/donoritem				//autoset on new if null	
	var/donator_group_id		//New donator group ID system.
	//END

	var/list/restricted_roles

	//Old donator system/snowflake ckey whitelist, used for single ckeys/exceptions
	var/list/ckeywhitelist
	//END

	var/restricted_desc

/datum/gear/New()
	if(isnull(donoritem))
		if(donator_group_id || ckeywhitelist)
			donoritem = TRUE
	if(!description && path)
		var/obj/O = path
		description = initial(O.desc)

//a comprehensive donator check proc is intentionally not implemented due to the fact that we (((might))) have job-whitelists for donator items in the future and I like to stay on the safe side.

//ckey only check
/datum/gear/proc/donator_ckey_check(key)
	if(ckeywhitelist && ckeywhitelist.Find(key))
		return TRUE
	return IS_CKEY_DONATOR_GROUP(key, donator_group_id)
