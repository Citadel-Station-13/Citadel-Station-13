// Contains code used to render the character select panel.

/datum/preferences/proc/render_character_select(mob/user = parent?.mob)
	ASSERT(user)
	var/datum/browser/popup = new(user, PREFERNECES_SKIN_CHARACTER_SELECT)
	var/savefile/S = new savefile(savefile_path)
	var/list/charnames = list()
	for(var/i in 1 to CONFIG_GET(number/max_save_slots))
		charnames += peek_character_name(i, S)
	var/list/content = list()


/datum/preferences/OnTopic(mob/user, list/href_list)
	. = ..()
	if(href_list["load_character_slot"])
		var/slot = sanitize_num_clamp(text2num(href_list["load_character_slot"], 1, CONFIG_GET(number/max_save_slots), 1, TRUE))
		var/list/migration_errors = list()
		load_character(S, slot, TRUE, migration_errors)
		if(migration_errors.len)
			to_chat(user, "<span class='warning'>Error while loading character:<br>[migration_errors.Join("<br>")]")
		return PREFERENCES_ONTOPIC_REFRESH | PREFERENCES_ONTOPIC_CHARACTER_SWAP

/datum/preferences/proc/peek_character_name(slot, savefile/S = new savefile(savefile_path))
	var/ccd = S.cd
	S.cd = "/character[slot]"
	S["real_name"] >> .
	S.cd = ccd
	if(!.)
		. = "Character[slot]"
