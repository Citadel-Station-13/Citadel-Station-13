/datum/preferences_collection/global/admin
	name = "Admin"
	save_key = PREFERENCES_SAVE_KEY_ADMIN
	sort_order = 2.5

/datum/preferences_collection/global/admin/is_visible(client/C)
	return GLOB.deadmins[C.ckey] || GLOB.admins[C.ckey]

/datum/preferences_collection/global/admin/post_global_load(datum/preferences/prefs)
	. = ..()

/datum/preferences_collection/global/admin/sanitize_global(datum/preferences/prefs)
	. = ..()

/datum/preferences_collection/global/admin/content(datum/preferences/prefs)
	. = ..()

/datum/preferences_collection/global/admin/savefile_full_overhaul_global(datum/preferences/prefs, list/data, savefile/S, list/errors, current_version)
	. = ..()

/datum/preferences_collection/global/admin/OnTopic(mob/user, datum/preferences/prefs, list/href_list)
	. = ..()


				if("hear_adminhelps")
					toggles ^= SOUND_ADMINHELP
				if("announce_login")
					toggles ^= ANNOUNCE_LOGIN
				if("combohud_lighting")
					toggles ^= COMBOHUD_LIGHTING

		dat += "</td>"
			if(user.client.holder)
				dat +="<td width='300px' height='300px' valign='top'>"
				dat += "<h2>Admin Settings</h2>"
				dat += "<b>Adminhelp Sounds:</b> <a href='?_src_=prefs;preference=hear_adminhelps'>[(toggles & SOUND_ADMINHELP)?"Enabled":"Disabled"]</a><br>"
				dat += "<b>Announce Login:</b> <a href='?_src_=prefs;preference=announce_login'>[(toggles & ANNOUNCE_LOGIN)?"Enabled":"Disabled"]</a><br>"
				dat += "<br>"
				dat += "<b>Combo HUD Lighting:</b> <a href = '?_src_=prefs;preference=combohud_lighting'>[(toggles & COMBOHUD_LIGHTING)?"Full-bright":"No Change"]</a><br>"
				dat += "</td>"
