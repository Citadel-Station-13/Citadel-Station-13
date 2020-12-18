/**
 * Preferences collection datums
 * A global copy of these exist so we don't need to instantiate them for every player
 */
/datum/preferences_collection
	/// Sort order. Lower is in front.
	var/sort_order = PREFERENCES_COLLECTIONS_SORT_ORDER_DEFAULT
	/// Save key. This should NEVER BE MODIFIED WITHOUT A MIGRATION! See _preferences.dm for how this works.
	var/save_key = PREFERENCES_COLLECTIONS_SAVE_KEY_DEFAULT

/**
 * Renders HTML content
 * Returns a LIST.
 */
/datum/preferences_collection/proc/content(datum/preferences/prefs)
	. = list()

/datum/preferences_collection/Topic(href, list/href_list)
	. = ..()
	ASSERT(usr)
	var/datum/preferences/prefs = locate(href_list["parent"])
	if(!istype(prefs))
		return
	if(prefs.parent != usr)
		log_admin("[key_name(usr)] sent a potentially maliciously mismatched preferences setup href! Expected: [prefs.ckey], actual: [usr.ckey]")
		message_admin("[key_name(usr)] sent a potentially maliciously mismatched preferences setup href! Expected: [prefs.ckey], actual: [usr.ckey]")
		return
	var/returned = OnTopic(usr, prefs, href_list)
	if(returned & PREFERENCES_ONTOPIC_REFRESH)
		#warn implement refresh
	if(returned & PREFERENCES_ONTOPIC_REGENERATE_PREVIEW)
		#warn implement preview regeneration

/**
 * Handles topic.
 * Returns flags - check __DEFINES/preferences.dm
 */
/datum/preferences_collection/proc/OnTopic(mob/user, datum/preferences/prefs, list/href_list)
	return NONE

/**
 * Grabs data from a preferences datum of the specified key. This way, we don't need to define variables on the datum itself.
 */
/datum/preferences_collection/proc/data_from_key(datum/preferences/prefs, key)
	ASSERT(prefs)
	return LAZYACCESS(prefs.preferences[save_key], key)

/**
 * Saves data from a preferences datum to the specified key. This way, we don't need to define variables on the datum itself.
 */
/datum/preferences_collection/proc/data_to_key(datum/preferences/prefs, key, data)
	ASSERT(prefs)
	LAZYSET(prefs.preferences[save_key], key, data)

/**
 * Loads data from a preferences datum's global settings on disk. This MUST only be called from the preferences datum otherwise BAD THINGS WILL HAPPEN!
 */
/datum/preferences_collection/proc/load_preferences(datum/preferences/prefs)

/**
 * Sanitizes global settings held in memory for a preferences datum.
 */
/datum/preferences_collection/proc/sanitize_preferences(datum/preferences/prefs)

/**
 * Saves data to a preferences datum's global settings on disk. This MUST only be called from the preferences datum otherwise BAD THINGS WILL HAPPEN!
 */
/datum/preferences_collection/proc/save_preferences(datum/preferences/prefs)

/**
 * Saves data to a preferences datum's character slot on disk. This MUST only be called from the preferences datum otherwise BAD THINGS WILL HAPPEN!
 */
/datum/preferences_collection/proc/save_character(datum/preferences/prefs)

/**
 * Sanitizes character settings held in memory for a preferences datum.
 */
/datum/preferences_collection/proc/sanitize_character(datum/preferences/prefs)

/**
 * Loads data to a preferences datum's character slot on disk. This MUST only be called from the preferences datum otherwise BAD THINGS WILL HAPPEN!
 */
/datum/preferences_collection/proc/load_character(datum/preferences/prefs)

/**
 * Used post loading to apply settings. Usually used for global settings.
 */
/datum/preferences_collection/proc/post_load(datum/preferences/prefs)

/**
 * Used to export crosssave data.
 */
/datum/preferences_collection/proc/json_export(datum/preferences/prefs, list/json_list)

/**
 * Used to import crosssave data.
 * WARNING: USER JSON DATA SHOULD NEVER BE TRUSTED. This should ONLY be ran from /datum/preferences,
 * where it is ensured that sanitization will be used right after loading!
 */
/datum/preferences_collection/proc/json_import(datum/preferences/prefs, list/json_list)
