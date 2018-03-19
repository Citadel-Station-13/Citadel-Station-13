// Loadout system. All items are children of /datum/gear. To make a new item, you usually just define a new item like /datum/gear/example
// then set required vars like name(string), category(slot define, take them from code/__DEFINES/inventory.dm (the lowertext ones) (be sure that there is an entry in
// slot_to_string(slot) proc in hippiestation/code/_HELPERS/mobs.dm to show the category name in preferences menu) and path (the actual item path).
// description defaults to the path initial desc, cost defaults to 1 point but if you think your item requires more points, the framework allows that
// and lastly, restricted_roles list allows you to let someone spawn with certain items only if the job they spawned with is on the list.
GLOBAL_LIST_EMPTY(loadout_catagories)
GLOBAL_LIST_EMPTY(loadout_items)

/datum/loadout_category
	var/category = ""
	var/list/gear = list()
	var/donor_only = FALSE

/datum/loadout_category/New(cat)
	category = cat
	..()

/proc/initialize_global_loadout_items()
	LAZYINITLIST(GLOB.loadout_items)
	//create a list of gear datums to sort
	for(var/geartype in subtypesof(/datum/gear))
		var/datum/gear/G = geartype

		var/use_name = initial(G.name)
		var/use_category = initial(G.sort_category)

		if(G == initial(G.subtype_path))
			continue

		if(!use_name)
			error("Loadout - Missing display name: [G]")
			continue
		if(!initial(G.cost))
			error("Loadout - Missing cost: [G]")
			continue
		if(!initial(G.path))
			error("Loadout - Missing path definition: [G]")
			continue

		if(!GLOB.loadout_catagories[use_category])
			GLOB.loadout_catagories[use_category] = new /datum/loadout_category(use_category)
		var/datum/loadout_category/LC = GLOB.loadout_catagories[use_category]
		if(initial(G.donor_only))
			LC.donor_only = TRUE
		GLOB.loadout_items[use_name] = new geartype
		LC.gear[use_name] = GLOB.loadout_items[use_name]

	GLOB.loadout_catagories = sortAssoc(loadout_catagories)
	for(var/loadout_category in GLOB.loadout_catagories)
		var/datum/loadout_category/LC = GLOB.loadout_catagories[loadout_category]
		LC.gear = sortAssoc(LC.gear)
	return 1

/*
/proc/initialize_global_loadout_items()
	LAZYINITLIST(GLOB.loadout_items)
	for(var/item in subtypesof(/datum/gear))
		var/datum/gear/I = new item
		if(!GLOB.loadout_items[slot_to_string(I.category)])
			LAZYINITLIST(GLOB.loadout_items[slot_to_string(I.category)])
		LAZYSET(GLOB.loadout_items[slot_to_string(I.category)], I.name, I)
*/

/datum/gear
	var/name
	var/slot
	var/description
	var/path //item-to-spawn path
	var/cost = 1 //normally, each loadout costs a single point.
	var/list/restricted_roles
	var/list/ckeywhitelist
	var/sort_category = "General"
	var/list/gear_tweaks = list() //List of datums which will alter the item after it has been spawned.
	var/subtype_path = /datum/gear //for skipping organizational subtypes (optional)
	var/subtype_cost_overlap = TRUE //if subtypes can take points at the same time
	var/donor_only = FALSE // if it's only available to donors

/datum/gear/New()
	..()
	if(!description && path)
		var/obj/O = path
		description = initial(O.desc)

/datum/gear_data
	var/path
	var/location

/datum/gear_data/New(npath, nlocation)
	path = npath
	location = nlocation

/datum/gear/proc/spawn_item(location, metadata)
	var/datum/gear_data/gd = new(path, location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		gt.tweak_gear_data(metadata["[gt]"], gd)
	var/item = new gd.path(gd.location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		gt.tweak_item(item, metadata["[gt]"])
	return item