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
