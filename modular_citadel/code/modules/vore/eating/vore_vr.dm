
/*
VVVVVVVV           VVVVVVVV     OOOOOOOOO     RRRRRRRRRRRRRRRRR   EEEEEEEEEEEEEEEEEEEEEE
V::::::V           V::::::V   OO:::::::::OO   R::::::::::::::::R  E::::::::::::::::::::E
V::::::V           V::::::V OO:::::::::::::OO R::::::RRRRRR:::::R E::::::::::::::::::::E
V::::::V           V::::::VO:::::::OOO:::::::ORR:::::R     R:::::REE::::::EEEEEEEEE::::E
 V:::::V           V:::::V O::::::O   O::::::O  R::::R     R:::::R  E:::::E       EEEEEE
  V:::::V         V:::::V  O:::::O     O:::::O  R::::R     R:::::R  E:::::E
   V:::::V       V:::::V   O:::::O     O:::::O  R::::RRRRRR:::::R   E::::::EEEEEEEEEE
    V:::::V     V:::::V    O:::::O     O:::::O  R:::::::::::::RR    E:::::::::::::::E
     V:::::V   V:::::V     O:::::O     O:::::O  R::::RRRRRR:::::R   E:::::::::::::::E
      V:::::V V:::::V      O:::::O     O:::::O  R::::R     R:::::R  E::::::EEEEEEEEEE
       V:::::V:::::V       O:::::O     O:::::O  R::::R     R:::::R  E:::::E
        V:::::::::V        O::::::O   O::::::O  R::::R     R:::::R  E:::::E       EEEEEE
         V:::::::V         O:::::::OOO:::::::ORR:::::R     R:::::REE::::::EEEEEEEE:::::E
          V:::::V           OO:::::::::::::OO R::::::R     R:::::RE::::::::::::::::::::E
           V:::V              OO:::::::::OO   R::::::R     R:::::RE::::::::::::::::::::E
            VVV                 OOOOOOOOO     RRRRRRRR     RRRRRRREEEEEEEEEEEEEEEEEEEEEE

-Aro <3 */

//
// Overrides/additions to stock defines go here, as well as hooks. Sort them by
// the object they are overriding. So all /mob/living together, etc.
//

//
// The datum type bolted onto normal preferences datums for storing Vore stuff
//

#define VORE_VERSION 2
#define rustg_vore_write(fname, text) call(RUST_G, "file_write")(fname, text)
#define WRITE_VORE(fname, text) rustg_vore_write(fname, text)
GLOBAL_LIST_EMPTY(vore_preferences_datums)

/client
	var/datum/vore_preferences/prefs_vr

/datum/vore_preferences
	//Actual preferences
	var/digestable = FALSE
	var/devourable = FALSE
//	var/allowmobvore = TRUE
	var/list/belly_prefs = list()
	var/vore_taste = "nothing in particular"
//	var/can_be_drop_prey = FALSE
//	var/can_be_drop_pred = FALSE

	//Mechanically required
	var/path
	var/slot
	var/client/client
	var/client_ckey

/datum/vore_preferences/New(client/C)
	if(istype(C))
		client = C
		client_ckey = C.ckey
		load_vore()

//
//	Check if an object is capable of eating things, based on vore_organs
//
/proc/is_vore_predator(var/mob/living/O)
	if(istype(O,/mob/living))
		if(O.vore_organs.len > 0)
			return TRUE

	return FALSE

//
//	Belly searching for simplifying other procs
//  Mostly redundant now with belly-objects and isbelly(loc)
//
/proc/check_belly(atom/movable/A)
	return isbelly(A.loc)

//
// Save/Load Vore Preferences
//
/datum/vore_preferences/proc/load_path(ckey,slot,filename="character",ext="json")
	if(!ckey || !slot)
		return
	to_chat(world, "load_path fired for [ckey], [slot]")
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/vore/[filename][slot].[ext]"


/datum/vore_preferences/proc/load_vore()
	if(!client || !client_ckey)
		return FALSE //No client, how can we save?
	to_chat(world, "[client], [client_ckey] detected for load_vore.")
	if(!client.prefs || !client.prefs.default_slot)
		to_chat(world, "[client] prefs weren't found.")
		return FALSE //Need to know what character to load!

	slot = client.prefs.default_slot
	to_chat(world, "[slot] is current slot")

	load_path(client_ckey,slot)

	if(!path)
		return FALSE //Path couldn't be set?
	to_chat(world, "[path] is path")
	if(!fexists(path)) //Never saved before
		to_chat(world, "[path] invalid or doesn't exist, attempting a save.")
		save_vore() //Make the file first
		return TRUE

	var/list/json_from_file = json_decode(file2text(path))
	if(!json_from_file)
		to_chat(world, "[client] failed json_from_file check")
		return FALSE //My concern grows

	var/version = json_from_file["version"]
	json_from_file = patch_version(json_from_file,version)
	to_chat(world, "[version] detected for load_vore.")

	digestable = json_from_file["digestable"]
	devourable = json_from_file["devourable"]
	vore_taste = json_from_file["vore_taste"]
	belly_prefs = json_from_file["belly_prefs"]

	//Quick sanitize
	if(isnull(digestable))
		digestable = FALSE
	if(isnull(devourable))
		devourable = FALSE
	if(isnull(belly_prefs))
		belly_prefs = list()

	return TRUE
/*
	allowmobvore = json_from_file["allowmobvore"]
	can_be_drop_prey = json_from_file["can_be_drop_prey"]
	can_be_drop_prey = json_from_file["can_be_drop_pred"]

	if(isnull(allowmobvore))
		allowmobvore = TRUE
	if(isnull(can_be_drop_prey))
		allowmobvore = FALSE
	if(isnull(can_be_drop_pred))
		allowmobvore = FALSE */

/datum/vore_preferences/proc/save_vore()
	to_chat(world, "save_vore triggered")
	var/json_file = path
	if(!path)
		return FALSE
	to_chat(world, "[json_file] is path")
	var/version = VORE_VERSION	//For "good times" use in the future
	to_chat(world, "[version] is version")
	var/list/settings_list = list()
	settings_list["version"] = version
	settings_list["digestable"] = digestable
	settings_list["devourable"] = devourable
	settings_list["vore_taste"] = vore_taste
	settings_list["belly_prefs"] = belly_prefs

	//List to JSON
	var/json_to_file = json_encode(settings_list)
	if(!json_to_file)
		to_chat(world, "Saving: json_to_file failed json_encode")
		return FALSE

	//Write it out
//#ifdef RUST_G
//	fdel(json_file)
//	WRITE_VORE(json_file, json_to_file)
//#else
	// Fall back to using old format if we are not using rust-g
	to_chat(world, "Saving: RUST_G failed or was bypassed.")
	var/list/json
	if(fexists(json_file))
		json = json_decode(file2text(json_file))
		to_chat(world, "Saving: [json_file] being deleted and remade")
		fdel(json_file) //Byond only supports APPENDING to files, not replacing.
	else
		json = list(json_to_file)
	json = serialize_json()
	WRITE_FILE(json_file, json_encode(json))
//#endif
	if(!fexists(json_file))
		to_chat(world, "Saving: [json_file] failed file write")
		return FALSE
	to_chat(world, "Saving: returning complete and TRUE")
	return TRUE

/* commented out list things
	"allowmobvore"			= allowmobvore,
	"can_be_drop_prey"		= can_be_drop_prey,
	"can_be_drop_pred"		= can_be_drop_pred, */

//Can do conversions here
//datum/vore_preferences/proc/patch_version(var/list/json_from_file,var/version)
//	return json_from_file

/datum/vore_preferences/proc/patch_version(var/list/json_from_file,var/version)
	var/savefile_version
	json_from_file["version"] = savefile_version
	if(savefile_version < VORE_VERSION)
		return savefile_version
	return json_from_file
#undef VORE_VERSION
