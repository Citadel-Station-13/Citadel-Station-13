SUBSYSTEM_DEF(character_setup)
	name = "Character Setup"
	flags = SS_NO_FIRE

	/// Holds all preferences collections
	var/datum/preferences_collection/collections
	/// Holds all player preferences
	var/datum/preferences/preferences

/datum/controller/subsystem/character_setup/PreInit()
	. = ..()
	SetupDatumLists()

/datum/controller/subsystem/character_setup/proc/SetupDatumLists()
	LAZYINITLIST(preferences)
	if(collections)
		QDEL_LIST(collections)
	collections = list()
	for(var/subtype in subtypesof(/datum/preferences_collection))
		collections += new subtype
	sortTim(collections, /proc/cmp_preference_collection_priority)

