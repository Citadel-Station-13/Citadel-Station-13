/datum/preferences_collection/character/quirks
	save_key = PREFERENCES_SAVE_KEY_QUIRKS
	sort_order = 7

/datum/preferences_collection/character/quirks/is_visible(client/C)
	return CONFIG_GET(flag/roundstart_traits)

/datum/preferences_collection/character/quirks/content(datum/preferences/prefs)
	. = ..()
	. += "<center><b>Choose quirk setup</b></center><br>"
	. += "<div align='center'>Left-click to add or remove quirks. You need negative quirks to have positive ones.<br>\
	Quirks are applied at roundstart and cannot normally be removed.</div>"
	. += "<hr>"
	. += "<center><b>Current quirks:</b> [all_quirks.len ? all_quirks.Join(", ") : "None"]</center>"
	. += "<center>[GetPositiveQuirkCount(prefs)] / [MAX_QUIRKS] max positive quirks<br>\
	<b>Quirk balance remaining:</b> [GetQuirkBalance(prefs)]</center><br>"
	for(var/V in SSquirks.quirks)
		var/datum/quirk/T = SSquirks.quirks[V]
		var/quirk_name = initial(T.name)
		var/has_quirk
		var/quirk_cost = initial(T.value) * -1
		var/lock_reason = "This trait is unavailable."
		var/quirk_conflict = FALSE
		for(var/_V in all_quirks)
			if(_V == quirk_name)
				has_quirk = TRUE
		if(initial(T.mood_quirk) && CONFIG_GET(flag/disable_human_mood))
			lock_reason = "Mood is disabled."
			quirk_conflict = TRUE
		if(has_quirk)
			if(quirk_conflict)
				all_quirks -= quirk_name
				has_quirk = FALSE
			else
				quirk_cost *= -1 //invert it back, since we'd be regaining this amount
		if(quirk_cost > 0)
			quirk_cost = "+[quirk_cost]"
		var/font_color = "#AAAAFF"
		if(initial(T.value) != 0)
			font_color = initial(T.value) > 0 ? "#AAFFAA" : "#FFAAAA"
		if(quirk_conflict)
			. += "<font color='[font_color]'>[quirk_name]</font> - [initial(T.desc)] \
			<font color='red'><b>LOCKED: [lock_reason]</b></font><br>"
		else
			if(has_quirk)
				. += "<a href='?src=[REF(src)];parent=[REF(prefs)];update=[quirk_name]'>[has_quirk ? "Remove" : "Take"] ([quirk_cost] pts.)</a> \
				<b><font color='[font_color]'>[quirk_name]</font></b> - [initial(T.desc)]<br>"
			else
				. += "<a href='?src=[REF(src)];parent=[REF(prefs)];update=[quirk_name]'>[has_quirk ? "Remove" : "Take"] ([quirk_cost] pts.)</a> \
				<font color='[font_color]'>[quirk_name]</font> - [initial(T.desc)]<br>"
	. += "<br><center><a href='?src=[REF(src)];parent=[REF(prefs)];reset=1'>Reset Quirks</a></center>"

/datum/preferences_collection/character/quirks/sanitize_character(datum/preferences/prefs)
	. = ..()
	auto_sanitize_list("quirks")

/datum/preferences_collection/character/quirks/OnTopic(mob/user, datum/preferences/prefs, list/href_list)
	. = ..()
	if(href_list["update"])
		var/quirk = href_list["update"]
		if(!SSquirks.quirks[quirk])
			return
		for(var/V in SSquirks.quirk_blacklist) //V is a list
			var/list/L = V
			for(var/Q in all_quirks)
				if((quirk in L) && (Q in L) && !(Q == quirk)) //two quirks have lined up in the list of the list of quirks that conflict with each other, so return (see quirks.dm for more details)
					to_chat(user, "<span class='danger'>[quirk] is incompatible with [Q].</span>")
					return
		var/value = SSquirks.quirk_points[quirk]
		var/balance = GetQuirkBalance()
		var/list/existing = LoadKey(prefs, "quirks")
		if(quirk in existing)
			if(balance + value < 0)
				to_chat(user, "<span class='warning'>Refunding this would cause you to go below your balance!</span>")
				return
			existing -= quirk
		else
			if(GetPositiveQuirkCount() >= MAX_QUIRKS)
				to_chat(user, "<span class='warning'>You can't have more than [MAX_QUIRKS] positive quirks!</span>")
				return
			if(balance - value < 0)
				to_chat(user, "<span class='warning'>You don't have enough balance to gain this quirk!</span>")
				return
			existing += quirk
		SaveKey(prefs, "quirks", existing)
		return PREFERENCES_ONTOPIC_REFRESH

	if(href_list["reset"])
		SaveKey("quirks", list())
		return PREFERENCES_ONTOPIC_REFRESH

/datum/preferences_collection/character/quirks/savefile_full_overhaul_character(datum/preferences/prefs, list/data, savefile/S, list/errors, current_version)
	. = ..()
	var/list/all_quirks
	S["all_qurks"] >> all_quirks
	data["quirks"] = all_quirks

/datum/preferences_collection/character/quirks/proc/GetQuirkBalance(datum/preferences/prefs)
	var/list/all_quirks = LoadKey(prefs, "quirks")
	var/bal = 0
	for(var/V in all_quirks)
		var/datum/quirk/T = SSquirks.quirks[V]
		bal -= initial(T.value)
	for(var/modification in modified_limbs)
		if(modified_limbs[modification][1] == LOADOUT_LIMB_PROSTHETIC)
			return bal + 1 //max 1 point regardless of how many prosthetics
	return bal

/datum/preferences_collection/character/quirks/proc/GetPositiveQuirkCount(datum/preferences/prefs)
	var/list/all_quirks = LoadKey(prefs, "quirks")
	. = 0
	for(var/q in all_quirks)
		if(SSquirks.quirk_points[q] > 0)
			.++

