/// Preferences datums keyed to ckey = datum
GLOBAL_LIST_EMPTY(preferences_datums)

/**
  * Preferences datums
  *
  * Holds character setup and global settings information for players.
  *
  * Init order:
  * 1. reads ckey
  * 2. gets path
  * 3. If path is a legacy savefile, does full conversion and continues
  * 4. Loads global preferences
  * 5. Loads active slot
  *
  * Full conversion:
  * 1. Legacy savefile is loaded
  * 2. Global prefs are migrated and saved
  * 3. Character slots 1 through 32 are migrated and saved
  * 4. Savefile cd is restored to / and postloads are called
  *
  * Global preferences load:
  * 1. If file doesn't exist or version is too low, all data is tossed and defaults are loaded
  * 2. Preferences are loaded
  * 3. Preferences are sanitized and postload is called
  * 4. Client variables are synced, etc
  *
  * Character preferences load:
  * 1. If file doesn't exist or version is too low, all data is tossed and a random character is generated
  * 2. Preferneces are loaded
  * 3. Preferences are sanitized
  * 4. Previews are regenerated
  * 5. On character creation, copy_to will generate the character from a human mob.
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

	// Metadata begin - stuff like current slot. Not important enough that we'll care about migrations, generally.
	/// Selected character slot
	var/selected_slot = 1
	/// Queued messages to display to the player
	var/list/debug_message_queue = list()
	// Metadata end

	// Other loaded settings begin - these aren't stored in [preferences] either because they're accessed super often, or for some other reason that makes the inherent slowness/access complexity unfavorable
	// Most things should use accessors in preferences/accessors to avoid this.

	// End

	// security
	//Cooldowns for saving/loading. These are four are all separate due to loading code calling these one after another
	var/saveprefcooldown
	var/loadprefcooldown
	var/savecharcooldown
	var/loadcharcooldowns

/datum/preferences/New(client/C)
	ckey = istext(C)? C : C?.ckey
	if(!ckey)
		CRASH("Preferences datum instantiated with no client or ckey. Aborting initialization.")
	FullInitialize()

/**
 * Fully inits us, loading everything from disk.
 */
/datum/preferences/proc/FullInitialize()
	character_preferences = list()
	global_preferences = list()
	initialize_savefile_path()
	ASSERT(savefile_path)
	var/list/migration_errors = list()
	var/existing = fexists(savefile_path)
	var/savefile/S = new savefile(savefile_path)
	// Load metadata
	load_metadata(S)
	// Store if we need to do migrations first.
	S.cd = "/"
	var/mode = PREFERENCES_LOAD_NORMAL
	if(!existing)
		mode = PREFERENCES_LOAD_NEW_FILE
	else
		// litmus test
		S.cd = "/global"
		var/vtest
		S["version"] >> vtest
		if(isnull(vtest))
			mode = PREFERENCES_LOAD_LEGACY_CONVERSION
		S.cd = "/"
	debug_message_queue += "Preferences initializing for [ckey]..."
	switch(mode)
		if(PREFERENCES_LOAD_NORMAL)
			debug_message_queue += "Loading in normal mode."
		if(PREFERENCES_LOAD_NEW_FILE)
			debug_message_queue += "Creating new savefile."
		if(PREFERENCES_LOAD_LEGACY_CONVERSION)
			debug_message_queue += "Legacy savefile detected; Beginning full conversion."
#warn call full savefile overhaul procs on global, then characters 1 through 32. should catch everything.

#warn rethink the initial modernization update as the old savefile format is too old to work with /global, etc
#warn maybe if it detects the old format (by just renaming the file) it can do the load
#warn that way we can reset savefile version to 0 too
#warn maybe also detect if the savefile doesn't exist, and call special init procs if so.
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
	if(ispath(key) || ispath(data))
		CRASH("Attempted to use typepaths directly in savefiles. This is not allowed due to the volatility of BYOND savefile operations.")
	LAZYSET(character_preferences[save_key], key, data)

/**
 * Directly reads from in-memory stores for a certain collection of a save key
 */
/datum/preferences/proc/LoadKeyCharacter(save_key, key)
	if(ispath(key))
		CRASH("Attempted to use typepaths directly in savefiles. This is not allowed due to the volatility of BYOND savefile operations.")
	return LAZYACCESS(character_preferences[save_key], key)

/**
 * Directly reads from in-memory stores for a certain collection of a save key. Returns default if null.
 */
/datum/preferences/proc/LoadKeyOrDefaultCharacter(save_key, key, default)
	if(ispath(key))
		CRASH("Attempted to use typepaths directly in savefiles. This is not allowed due to the volatility of BYOND savefile operations.")
	. = LAZYACCESS(character_preferences[save_key], key)
	if(isnull(.))
		return default

/**
 * Directly sets to in-memory stores for a certain collection of a save key
 */
/datum/preferences/proc/SetKeyGlobal(save_key, key, data)
	if(ispath(key) || ispath(data))
		CRASH("Attempted to use typepaths directly in savefiles. This is not allowed due to the volatility of BYOND savefile operations.")
	LAZYSET(global_preferences[save_key], key, data)

/**
 * Directly reads from in-memory stores for a certain collection of a save key
 */
/datum/preferences/proc/LoadKeyGlobal(save_key, key)
	if(ispath(key))
		CRASH("Attempted to use typepaths directly in savefiles. This is not allowed due to the volatility of BYOND savefile operations.")
	return LAZYACCESS(global_preferences[save_key], key)

/**
 * Directly reads from in-memory stores for a certain collection of a save key. Returns default if null.
 */
/datum/preferences/proc/LoadKeyOrDefaultGlobal(save_key, key, default)
	if(ispath(key))
		CRASH("Attempted to use typepaths directly in savefiles. This is not allowed due to the volatility of BYOND savefile operations.")
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
	if(returned & PREFERENCES_ONTOPIC_RESYNC_CACHE)
		resync_client_cache()
	if(returned & PREFERENCES_ONTOPIC_KEYBIND_REASSERT)
		if(parent)
			parent.ensure_keys_set()

/**
 * Resyncs prefs cache on our client, if possible.
 */
/datum/preferences/proc/resync_client_cache()
	if(!parent)
		return
	if(!parent.cached_prefs)
		parent.cached_prefs = new
	parent.cached_prefs.sync(src)

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
		errors += "Character slot [slot] either does not exist or was below minimum version [SAVEFILE_VERSION_MIN], and has been completely randomized."
		S["version"] << SAVEFILE_VERSION_MAX
		// First, call reset procs
		for(var/i in SScharacter_setup.collections)
			C.on_full_character_reset(src)
		// Then, randomize
		random_character()
		// Then save.
		save_character(S)
		return
	// Load
	#warn deserialize character_data from disk
	if(version < SAVEFILE_VERSION_MAX)
		// handle migrations
		for(var/i in SScharacter_setup.collections)
			var/datum/preferences_collection/C = i
			LAZYINITLIST(character_preferences[C.save_key])
			C.handle_character_migration(src, character_preferences[C.save_key], S, errors, version)
		S["version"] << SAVEFILE_VERSION_MAX
	for(var/i in SScharacter_setup.collections)
		var/datum/preferences_collection/C = i
		C.sanitize_character(src)
		C.sanitize_any(src)
		C.post_character_load(src)
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
		C.sanitize_any(src)
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
			C.sanitize_any(src)
			C.save_preferences(src, S)
			C.post_global_load(src)
		return
	// Load
	#warn deserialize global_preferences from disk
	if(version < SAVEFILE_VERSION_MAX)
		// handle migrations
		for(var/i in SScharacter_setup.collections)
			var/datum/preferences_collection/C = i
			LAZYINITLIST(global_preferences[C.save_key])
			C.handle_global_migration(src, global_preferences[C.save_key], S, errors, version)
		S["version"] << SAVEFILE_VERSION_MAX
	for(var/i in SScharacter_setup.collections)
		var/datum/preferences_collection/C = i
		C.sanitize_preferences(src)
		C.sanitize_any(src)
		C.post_global_load(src)

/datum/preferences/vv_edit_var(var_name, var_value)
	if((var_name == NAMEOF(src, ckey)) || (var_name == NAMEOF(src, savefile_path)))
		return			// OH NO NO NO NO NO NO.
	. = ..()

/**
 * Renders the current tab.
 */
/datum/preferences/proc/Render(mob/user = parent?.mob)
	ASSERT(user)
	assert_character_selected()
	user.client.OpenPreferencesWindow()
	var/list/content = list()
	content += "<head>"
	var/first = TRUE
	var/first_collection = TRUE
	for(var/list/ordered in SScharacter_setup.ordered_collections)
		if(!first)
			content += "  |  "
		for(var/datum/preferences_collection/C in ordered)
			if(!C.is_visible(user.client))
				continue
			if(C != selected_collection)
				content += "[first_collection? "" : "  "]<a href='?_src_=prefs;switch_collection=[REF(C)]'>[C.name]</a>  "
			else
				content += "[first_collection? "" : "  "]<span class='linkOn'>[C.name]</span>  "
			if(first_collection)
				first_collection = FALSE
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

/**
 * Output to the player queued messages
 */
/datum/preferences/proc/flush_messages()
	ASSERT(parent)
	to_chat(parent, debug_message_queue.Join("<br>"))
	debug_message_queue.Cut()

/**
 * Instantiates a mob.
 * Uses flags because frankly you shouldn't use this proc if you dont' know what you're doing.
 */
/datum/preferences/proc/InstantiateHuman(atom/loc, defer_late_copy = FALSE, flags = COPY_TO_WRITE_ORGANS)
	if(!istype(loc))
		CRASH("Cannot instantiate human in nullspace.")
	var/mob/living/carbon/human/H = new(loc)
	_copy_to(H, defer_late_copy, flags)

/**
 * Applies to a mob.
 *
 * if defer_late_copy is TRUE, late copy to, which runs things like PDAs, ringtones, suit sensors, etc,
 * will not run.
 *
 * if equip_loadout is TRUE, loadout will be equipped as well.
 */
/datum/preferences/proc/CopyTo(mob/M, defer_late_copy = FALSE, visuals_only = FALSE, roundstart = FALSE, equip_loadout = FALSE, apply_organs = FALSE)
	return _copy_to(M, defer_late_copy, (
		(visuals_only && COPY_TO_VISUALS_ONLY) |
		(equip_loadout && COPY_TO_EQUIP_LOADOUT) |
		(roundstart && COPY_TO_ROUNDSTART) |
		(apply_organs && COPY_TO_WRITE_ORGANS)
	))

/**
 * Creates a mob
 * Advanced thing for VV proccalls
 */
/datum/preferences/proc/_copy_to(mob/M, defer = FALSE, flags)
	for(var/datum/preferences_collection/C in SScharacter_setup.collections)
		C.copy_to_mob(src, M, flags)
	if(defer)
		return
	for(var/datum/preferences_collection/C in SScharacter_setup.collections)
		C.late_copy_to_mob(src, M, flags)
