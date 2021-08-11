/datum/preferences_collection/global/admin
	save_key = PREFERENCES_SAVE_KEY_ADMIN
	sort_order = 2.5

/datum/preferences_collection/global/admin/is_visible(client/C)
	return GLOB.deadmins[C.ckey] || GLOB.admins[C.ckey]
