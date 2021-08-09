/**
 * Preferences collection datums
 * A global copy of these exist so we don't need to instantiate them for every player
 */
/datum/preferences_collection
	/// Sort order. Lower is in front.
	var/sort_order = PREFERENCE_SORT_ORDER_DEFAULT
	/// Save key. This should NEVER BE MODIFIED WITHOUT A MIGRATION! See _preferences.dm for how this works.
	var/save_key = PREFERENCES_SAVE_KEY_DEFAULT

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
		log_admin("[key_name(usr)] sent a potentially preferences setup href! Expected: [prefs.ckey], actual: [usr.ckey]")
		message_admin("[key_name(usr)] sent a potentially preferences setup href! Expected: [prefs.ckey], actual: [usr.ckey]")
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
 * Sanitizes global settings held in memory for a preferences datum.
 */
/datum/preferences_collection/proc/sanitize_global(datum/preferences/prefs)

/**
 * Sanitizes character settings held in memory for a preferences datum.
 */
/datum/preferences_collection/proc/sanitize_character(datum/preferences/prefs)

/**
 * Used post loading to apply settings. Usually used for global settings.
 */
/datum/preferences_collection/proc/post_load(datum/preferences/prefs)

/**
 * Applies settings to a character when a mob is being made for a player on joining the round
 * MOB IS NOT NECESSARILY HUMAN! Always check type first.
 */
/datum/preferences_collection/proc/copy_to_mob(datum/preferences/prefs, mob/M)

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

/**
 * Handles global migrations during loading. Must only be called from preferences datum. Should write DIRECTLY to savefile.
 */
/datum/preferences_collection/proc/handle_global_migration(datum/preferences/prefs, savefile/S, list/errors = list(), current_version)

/**
 * Handles character slot migrations during loading. Must only be called from preferences datum. should write DIRECTLY to savefile.
 */
/datum/preferences_collection/proc/handle_character_migration(datum/preferences/prefs, savefile/S, list/errors = list(), current_version)

/**
 * Called on full reset due to unreadable data or other reasons
 * Use this to do things like force keybinding resets.
 */
/datum/preferences_collection/proc/on_full_preferences_reset(datum/preferences/prefs)

/**
 * Called on full reset due to unreadable character data or other reasons
 */
/datum/preferences_collection/proc/on_full_character_reset(datum/preferences/prefs)
