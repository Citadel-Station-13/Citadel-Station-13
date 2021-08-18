/**
 * Hidden section for storing menuoptions etc
 */
/datum/preferences_collection/global/hidden
	name = "Hidden"
	sort_order = 1000
	save_key = PREFERENCES_SAVE_KEY_HIDDEN

/datum/preferences_collection/global/hidden/is_visible(client/C)
	return FALSE

/datum/preferences_collection/global/hidden/sanitize_global(datum/preferences/prefs)
	. = ..()

/datum/preferences_collection/global/hidden/post_global_load(datum/preferences/prefs)
	. = ..()


	///Someone thought we were nice! We get a little heart in OOC until we join the server past the below time (we can keep it until the end of the round otherwise)
	var/hearted
	///If we have a hearted commendations, we honor it every time the player loads preferences until this time has been passed
	var/hearted_until


	var/list/menuoptions

	var/uses_glasses_colour = 0

	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change

	var/list/ignoring = list()

	favorite_outfits = SANITIZE_LIST(favorite_outfits)
	menuoptions		= SANITIZE_LIST(menuoptions)

	//favorite outfits
	S["favorite_outfits"]	>> favorite_outfits
	S["lastchangelog"]		>> lastchangelog
	S["menuoptions"]		>> menuoptions
	var/list/parsed_favs = list()
	for(var/typetext in favorite_outfits)
		var/datum/outfit/path = text2path(typetext)
		if(ispath(path)) //whatever typepath fails this check probably doesn't exist anymore
			parsed_favs += path
	favorite_outfits = uniqueList(parsed_favs)
