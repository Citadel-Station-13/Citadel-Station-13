/**
 * Preferences collection datums
 * A global copy of these exist so we don't need to instantiate them for every player
 *
 * NOTE ON CROSS-SAVES:
 * Please be reasonable regarding naming.
 * Like, for example, for a character data key for name, just.. put "name"
 * Don't put something ridiculous like "c_name", etc
 * Simple is best
 * Prefer IDs over typepaths
 * It'll make integration of crosssave functionality between our two servers much easier later.
 *
 * **EACH COLLECTION CAN EITHER BE CHARACTER, GLOBAL, OR HYBRID**
 * Mixed are not allowed - they're either character-linked, global preferences, or global-with-override.
 * Mixed can be done with current procs but it'll be more or less unmaintainable compared to the above 3.
 */
/datum/preferences_collection
	/// Name
	var/name = "ERROR"
	/// Sort order. Lower is in front.
	var/sort_order = 0
	/// Save key. This should NEVER BE MODIFIED WITHOUT A MIGRATION! See _preferences.dm for how this works.
	var/save_key = PREFERENCES_SAVE_KEY_DEFAULT
	/// Preferences type - Character, hybrid, or global
	/// Coontrols rendering/ordering. The actual save load, however, is agnostic - a proc must be overridden.
	var/collection_type = null

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
		log_admin("[key_name(usr)] sent a mismatched preferences setup href! Expected: [prefs.ckey], actual: [usr.ckey]")
		message_admins("[key_name(usr)] sent a mismatched preferences setup href! Expected: [prefs.ckey], actual: [usr.ckey]")
		return
	var/returned = OnTopic(usr, prefs, href_list)
	if(returned & PREFERENCES_ONTOPIC_REFRESH)
		prefs.Render()
	if(returned & PREFERENCES_ONTOPIC_REGENERATE_PREVIEW)
		#warn implement preview regeneration

/datum/preferences_collection/proc/generate_topic(datum/preferences/prefs, text, key)
	return "<a href='?src=[REF(src)];[key]=1;parent=[REF(prefs)]'>[text]</a>"

/datum/preferences_collection/proc/generate_topic_key_value(datum/preferences/prefs, text, key, value)
	return "<a href='?src=[REF(src)];[key]=[value];parent=[REF(prefs)]'>[text]</a>"

/**
 * Handles topic.
 * Returns flags - check __DEFINES/preferences.dm
 */
/datum/preferences_collection/proc/OnTopic(mob/user, datum/preferences/prefs, list/href_list)
	return NONE

/**
 * Saves data to a preferences datum
 */
/datum/preferences_collection/proc/SaveKey(datum/preferences/prefs, key, value)
	CRASH("Base SaveKey() called on preferences_collection")

/**
 * Loads data from a preferences datum
 */
/datum/preferences_collection/proc/LoadKey(datum/preferences/prefs, key)
	CRASH("Base LoadKey() called on preferences_collection")

/**
 * Loads or defaults data
 */
/datum/preferences_collection/proc/LoadOrDefault(datum/preferences/prefs, key, value, default)
	. = LoadKey(prefs, key, value)
	if(isnull(.))
		return default

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
 * visuals_only - If true, we just need a visual render, don't do anything fancy.
 */
/datum/preferences_collection/proc/copy_to_mob(datum/preferences/prefs, mob/M, visuals_only = FALSE)

/**
 * Handles global migrations during loading. Must only be called from preferences datum. Should write DIRECTLY to datalist.
 * Savefile is also provided in cases where data isn't in the datalist for this key.
 * NOTE: Sanitaization happens AFTER migrations - ensure your code can't be exploited!
 */
/datum/preferences_collection/proc/handle_global_migration(datum/preferences/prefs, list/data, savefile/S, list/errors = list(), current_version)

/**
 * Handles character slot migrations during loading. Must only be called from preferences datum. should write DIRECTLY to datalist.
 * Savefile is also provided in cases where data isn't in the datalist for this key.
 * NOTE: Sanitaization happens AFTER migrations - ensure your code can't be exploited!
 */
/datum/preferences_collection/proc/handle_character_migration(datum/preferences/prefs, list/data, savefile/S, list/errors = list(), current_version)

/**
 * DO NOT TOUCH THIS PROC:
 * Updates an older savefile version to the new savefile/character setup system, as of 8/9/2021
 * UNLESS YOU KNOW EXACTLY WHAT YOU ARE DOING, DO NOT EVER TOUCH THIS PROC.
 */
/datum/preferences_collection/proc/savefile_full_overhaul_character(datum/preferences/prefs, list/data, savefile/S, list/errors = list(), current_version)

/**
 * DO NOT TOUCH THIS PROC:
 * Updates an older savefile version to the new savefile/character setup system, as of 8/9/2021
 * UNLESS YOU KNOW EXACTLY WHAT YOU ARE DOING, DO NOT EVER TOUCH THIS PROC.
 */
/datum/preferences_collection/proc/savefile_full_overhaul_global(datum/preferences/prefs, list/data, savefile/S, list/errors = list(), current_version)

/**
 * Called on full reset due to unreadable data or other reasons
 * Use this to do things like force keybinding resets.
 */
/datum/preferences_collection/proc/on_full_preferences_reset(datum/preferences/prefs)

/**
 * Called on full reset due to unreadable character data or other reasons
 */
/datum/preferences_collection/proc/on_full_character_reset(datum/preferences/prefs)
