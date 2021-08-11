/datum/preferences_collection/hybrid
	collection_type = COLLECTION_HYBRID

/datum/preferences_collection/hybrid/SaveKey(datum/preferences/prefs, key, value)
	return CheckOverride(prefs)? prefs.SetKeyCharacter(key, value) : prefs.SetKeyGlobal(key, value)

/datum/preferences_collection/hybrid/LoadKey(datum/preferences/prefs, key, copy_lists)
	. = CheckOverride(prefs)? prefs.LoadKeyCharacter(key) : prefs.LoadKeyGlobal(key)
	if(copy_lists && islist(.))
		var/list/L = .
		. = deepCopyList(L)

/datum/preferences_collection/hybrid/proc/CheckOverride(datum/preferences/prefs)
	return prefs.LoadKeyCharacter("__[save_key]_override")

/datum/preferences_collection/hybrid/proc/SetOverride(datum/preferences/prefs, value)
	return prefs.SetKeyCharacter("__[save_key]_override", value)

/datum/preferences_collection/hybrid/content(datum/preferences/prefs)
	. = ..()
	. += "<h1><center>Character Override for this section on your current character is: "
	. += CheckOverride(prefs)? "<span class='linkOn'>ON</span> [generate_topic(prefs, "OFF", "__toggle_hybrid_override__")]" : \
		"[generate_topic(prefs, "ON", "__toggle_hybrid_override__")] <span class='linkOn'>OFF</span>"
	. += "</center></h1>"
	. += "<hr>"

/datum/preferences_collection/hybrid/OnTopic(mob/user, datum/preferences/prefs, list/href_list)
	. = ..()
	if(href_list["__toggle_hybrid_override__"])
		SetOverride(prefs, !CheckOverride(prefs))
		return PREFERENCES_ONTOPIC_REFRESH | PREFERENCES_ONTOPIC_REGENERATE_PREVIEW

