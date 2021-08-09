/// Preferences datums keyed to ckey = datum
GLOBAL_LIST_EMPTY(preferences_datums)

/**
  * Preferences datums
  *
  * Holds character setup and global settings information for players.
  */
/datum/preferences
	/// Owning client, if connected
	var/client/parent
	/// Owner ckey
	var/ckey
	/// Path to savefile
	var/savefile_path
	/// Currently loaded character
	var/loaded_slot
	/// Selected tab
	var/datum/preferences_collection/selected_collection

	/// Current slot: Variable store for the actual preference collections. list(save_key = list(var1 = val1, ...), ...)
	var/list/character_preferences
	/// Global settings: Variable store for the actual preference collections. list(save_key = list(var1 = val1, ...), ...)
	var/list/global_preferences

	// Key bindings are stored directly for performance
	/// Custom Keybindings
	var/list/key_bindings = list()
	/// List with a key string associated to a list of keybindings. Unlike key_bindings, this one operates on raw key, allowing for binding a key that triggers regardless of if a modifier is depressed as long as the raw key is sent.
	var/list/modless_key_bindings = list()

	// Metadata begin - stuff like current slot. Not important enough that we'll care about migrations, generally.
	/// Selected character slot
	var/selected_slot = 1
	// Metadata end

	// Other loaded settings begin - these aren't stored in [preferences] either because they're accessed super often, or for some other reason that makes the inherent slowness/access complexity unfavorable
	// In reality, this means most things.

	// End

/datum/preferences/New(client/C)
	var/ckey = istext(C)? C : C?.ckey
	if(!ckey)
		CRASH("Preferences datum instantiated with no client or ckey. Aborting initialization.")
	FullInitialize()

/**
 * Fully inits us, loading everything from disk.
 */
/datum/preferences/proc/FullInitialize()
	preferences = list()
	initialize_savefile_path()
	ASSERT(savefile_path)
	var/list/migration_errors = list()
	var/savefile/S = new savefile(savefile_path)
	// Load metadata
	load_metadata(S)
	// Store if we need to do migrations first.
	S.cd = "/"
	var/current_version
	S["version"] >> current_version
	var/migration_needed = current_version < SAVEFILE_VERSION_MAX
	if(migration_needed)
		#warn todo: save backup of file
		S["version"] << SAVEFILE_VERSION_MAX
	// Load preferences - This will perform migrations if needed
	load_preferences(S, migration_errors)
	// Load default slot
	S.cd = "/metadata"
	S["selected_slot"] >> selected_slot
	assert_character_selected(S, migration_errors)

/**
 * Generates our savefile path
 */
/datum/preferences/proc/initialize_savefile_path()
	savefile_path = "data/player_saves/[ckey[1]]/[ckey]/preferences.sav"

/**
 * Directly sets to in-memory stores for a certain collection of a save key
 */
/datum/preferences/proc/SetKeyCharacter(save_key, key, data)
	LAZYSET(character_preferences[save_key], key, data)

/**
 * Directly reads from in-memory stores for a certain collection of a save key
 */
/datum/preferences/proc/LoadKeyCharacter(save_key, key)
	return LAZYACCESS(character_preferences[save_key], key)

/**
 * Directly reads from in-memory stores for a certain collection of a save key. Returns default if null.
 */
/datum/preferences/proc/LoadKeyOrDefaultCharacter(save_key, key, default)
	. = LAZYACCESS(character_preferences[save_key], key)
	if(isnull(.))
		return default

/**
 * Directly sets to in-memory stores for a certain collection of a save key
 */
/datum/preferences/proc/SetKeyGlobal(save_key, key, data)
	LAZYSET(global_preferences[save_key], key, data)

/**
 * Directly reads from in-memory stores for a certain collection of a save key
 */
/datum/preferences/proc/LoadKeyGlobal(save_key, key)
	return LAZYACCESS(global_preferences[save_key], key)

/**
 * Directly reads from in-memory stores for a certain collection of a save key. Returns default if null.
 */
/datum/preferences/proc/LoadKeyOrDefaultGlobal(save_key, key, default)
	. = LAZYACCESS(global_preferences[save_key], key)
	if(isnull(.))
		return default

/datum/preferences/Topic(href, list/href_list)
	. = ..()
	ASSERT(usr)
	if(parent != usr)
		log_admin("[key_name(usr)] sent a mismatched preferences setup href! Expected: [ckey], actual: [usr.ckey]")
		message_admin("[key_name(usr)] sent a mismatched preferences setup href! Expected: [ckey], actual: [usr.ckey]")
		return
	var/returned = OnTopic(usr, href_list)
	if(returned & PREFERENCES_ONTOPIC_REFRESH)
		#warn implement refresh
	if(returned & PREFERENCES_ONTOPIC_REGENERATE_PREVIEW)
		#warn implement preview regeneration
	if(returned & PREFERENCES_ONTOPIC_CHARACTER_SWAP)
		render_character_select(usr)

/**
 * Handles topic input from a user.
 * Assumes sanity checks have already been done to make sure the right person is calling tthis.
 */
/datum/preferences/proc/OnTopic(mob/user, list/href_list)
	return NONE

/**
 * Loads metadata
 */
/datum/preferences/proc/load_metadata(savefile/S = new(savefile_path))
	S.cd = "/metadata"
	S["selected_slot"] >> selected_slot
	sanitize_num_clamp(selected_slot, 1, CONFIG_GET(number/max_save_slots), 1)

/**
 * Saves metadata
 */
/datum/preferences/proc/save_metadata(savefile/S = new(savefile_path))
	S.cd = "/metadata"
	S["selected_slot"] << selected_slot

/**
 * Reassert that we loaded our selected slot
 */
/datum/preferences/proc/assert_character_selected(savefile/S, list/migration_errors = list())
	if(loaded_slot != selected_slot)
		load_character(S, selected_slot, FALSE, migration_errors)

/**
 * Saves character
 */
/datum/preferences/proc/save_character(savefile/S = new(savefile_path))
	S.cd = "/character[loaded_slot]"
	for(var/i in SScharacter_setup.collections)
		var/datum/preferences_collection/C = i
		C.sanitize_character(src)
	#warn serialize character_data to disk

/**
 * Loads character
 * Select_slot should only be true if the player initiated it.
 * selected_slot keeps track of what slot the player chose instead of loaded_slot, which prevents overwriting.
 */
/datum/preferences/proc/load_character(savefile/S = new(savefile_path), slot = selected_slot, select_slot = FALSE, list/errors = list())
	ASSERT(isnum(slot))
	loaded_slot = slot
	S.cd = "/character[slot]"
	var/version = S["version"]
	if(version < SAVEFILE_VERSION_MIN)
		random_character()
		errors += "Character slot [slot] either does not exist or was below minimum version [SAVEFILE_VERSION_MIN], and has been completely randomized."
		S["version"] << SAVEFILE_VERSION_MAX
		for(var/i in SScharacter_setup.collections)
			C.on_full_character_reset(src)
		save_character(S)
		return
	else if(version < SAVEFILE_VERSION_MAX)
		// handle migrations
		for(var/i in SScharacter_setup.collections)
			var/datum/preferences_collection/C = i
			LAZYINITLIST(character_preferences[C.save_key])
			C.handle_character_migration(src, character_preferences[C.save_key], S, errors, version)
		S["version"] << SAVEFILE_VERSION_MAX
	// Load
	#warn deserialize character_data from disk
	for(var/i in SScharacter_setup.collections)
		var/datum/preferences_collection/C = i
		C.sanitize_character(src)
	// If the player selected the slot, choose it properly and save metadata
	if(select_slot)
		selected_slot = slot
		save_metadata(S)

/**
 * Saves global settings
 */
/datum/preferences/proc/save_preferences(savefile/S = new(savefile_path), list/errors = list())
	S.cd = "/global"
	for(var/i in SScharacter_setup.collections)
		var/datum/preferences_collection/C = i
		C.sanitize_global(src)
	#warn serialize global_preferences to disk

/**
 * Loads global settings
 */
/datum/preferences/proc/load_preferences(savefile/S = new(savefile_path), list/errors = list())
	S.cd = "/global"
	var/version = S["version"]
	if(version < SAVEFILE_VERSION_MIN)
		errors += "Global preferences version [version] was below minimum version [SAVEFILE_VERSION_MIN]. All global settings have been wiped."
		S["version"] << SAVEFILE_VERSION_MAX
		for(var/i in SScharacter_setup.collections)
			var/datum/preferences_collection/C = i
			C.on_full_preferences_reset(src)
			C.sanitize_preferences(src)
			C.save_preferences(src, S)
		return
	if(version < SAVEFILE_VERSION_MAX)
		// handle migrations
		for(var/i in SScharacter_setup.collections)
			var/datum/preferences_collection/C = i
			LAZYINITLIST(global_preferences[C.save_key])
			C.handle_global_migration(src, global_preferences[C.save_key], S, errors, version)
		S["version"] << SAVEFILE_VERSION_MAX
	// Load
	#warn deserialize global_preferences from disk
	for(var/i in SScharacter_setup.collections)
		var/datum/preferences_collection/C = i
		C.sanitize_preferences(src)

/datum/preferences/vv_edit_var(var_name, var_value)
	if((var_name == NAMEOF(src, ckey)) || (var_name == NAMEOF(src, savefile_path)))
		return			// OH NO NO NO NO NO NO.
	. = ..()

/**
 * Renders the current tab.
 */
/datum/preferences/proc/Render(mob/user = parent?.mob)
	ASSERT(user)
	user.client.OpenPreferencesWindow()
	var/list/content = list()
	content += "<head>"
	var/first = TRUE
	for(var/list/ordered in SScharacter_setup.ordered_collections)
		if(!first)
			content += "  |  "
		for(var/datum/preferences_collection/C in ordered)
			if(C != selected_collection)
				content += "[first? "" : "  "]<a href='?_src_=prefs;switch_collection=[REF(C)]'>[C.name]</a>  "
			else
				content += "[first? "" : "  "]<span class='linkOn'>[C.name]</span>  "
		if(first)
			first = FALSE
	content += "</head>"
	content += "<body>"
	if(!selected_collection)
		content += "<center><h1>Error: No selected collection. Something broke. Select a tab above.</h1></center>"
	else
		content += selected_collection.content(src)

	content += "</body>"
	user << browse(content.Join(""), "window=[PREFERENCES_SKIN_MAIN]")

/**
 * Forcefully opens the character setup/preferences window.
 */
/client/proc/OpenPreferencesWindow()
#warn implement

/datum/preferences/OnTopic(client/user, list/href_list)
	. = ..()
	if(href_list["switch_collection"])
		var/datum/preferences_collection/C = locate(href_list["switch_collection"]) in SScharacter_setup.collections
		if(istype(C))
			selected_collection = C
