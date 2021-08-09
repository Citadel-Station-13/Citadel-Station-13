SUBSYSTEM_DEF(character_setup)
	name = "Character Setup"
	flags = SS_NO_FIRE

	/// Holds all preferences collections
	var/list/datum/preferences_collection/collections
	/// Holds all player preferences
	var/list/datum/preferences/preferences
	/// Holds ordered collections: 3 lists.
	var/list/ordered_collections

/datum/controller/subsystem/character_setup/PreInit()
	. = ..()
	SetupDatumLists()
	SortCollections()

/datum/controller/subsystem/character_setup/proc/SetupDatumLists()
	LAZYINITLIST(preferences)
	if(collections)
		QDEL_LIST(collections)
	collections = list()
	for(var/subtype in subtypesof(/datum/preferences_collection))
		collections += new subtype
	sortTim(collections, /proc/cmp_preference_collection_priority)

/datum/controller/subsystem/character_setup/proc/SortCollections()
	// they're already sorted from SetupDatumLists()
	var/list/g = list()
	var/list/c = list()
	var/list/h = list()
	var/list/m = list()
	// global, character, hybrid, misc/unsorted
	for(var/datum/preferences_collection/collection in collections)
		switch(collection.collection_type)
			if(COLLECTION_GLOBAL)
				g += collection
			if(COLLECTION_CHARACTER)
				c += collection
			if(COLLECTION_HYBRID)
				h += collection
			else
				m += collection
	ordered_collections = list(g, c, h, m)
