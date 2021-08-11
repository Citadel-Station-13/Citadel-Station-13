/datum/preferences_collection/hybrid/fetish_content
	save_key = PREFERENCES_SAVE_KEY_FETISH
	sort_order = 2

/datum/preferences_collection/hybrid/fetish_content/content(datum/preferences/prefs)
	. = ..()
	var/cit_toggles = LoadKey(prefs, "cit_toggles")
	. += "<table><tr><td width='340px' height='300px' valign='top'>"
	. += "<h2>Fetish content prefs</h2>"
	. += "<b>Arousal:</b><a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=arousable'>[arousable == TRUE ? "Enabled" : "Disabled"]</a><BR>"
	. += "<b>Genital examine text</b>:<a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=genital_examine'>[(cit_toggles & GENITAL_EXAMINE) ? "Enabled" : "Disabled"]</a><BR>"
	. += "<b>Vore examine text</b>:<a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=vore_examine'>[(cit_toggles & VORE_EXAMINE) ? "Enabled" : "Disabled"]</a><BR>"
	. += "<b>Voracious MediHound sleepers:</b> <a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=hound_sleeper'>[(cit_toggles & MEDIHOUND_SLEEPER) ? "Yes" : "No"]</a><br>"
	. += "<b>Hear Vore Sounds:</b> <a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=toggleeatingnoise'>[(cit_toggles & EATING_NOISES) ? "Yes" : "No"]</a><br>"
	. += "<b>Hear Vore Digestion Sounds:</b> <a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=toggledigestionnoise'>[(cit_toggles & DIGESTION_NOISES) ? "Yes" : "No"]</a><br>"
	. += "<b>Allow trash forcefeeding (requires Trashcan quirk)</b> <a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=toggleforcefeedtrash'>[(cit_toggles & TRASH_FORCEFEED) ? "Yes" : "No"]</a><br>"
	. += "<b>Forced Feminization:</b> <a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=feminization'>[(cit_toggles & FORCED_FEM) ? "Allowed" : "Disallowed"]</a><br>"
	. += "<b>Forced Masculinization:</b> <a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=masculinization'>[(cit_toggles & FORCED_MASC) ? "Allowed" : "Disallowed"]</a><br>"
	. += "<b>Lewd Hypno:</b> <a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=hypno'>[(cit_toggles & HYPNO) ? "Allowed" : "Disallowed"]</a><br>"
	. += "<b>Bimbofication:</b> <a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=bimbo'>[(cit_toggles & BIMBOFICATION) ? "Allowed" : "Disallowed"]</a><br>"
	. += "</td>"
	. += "<td width='300px' height='300px' valign='top'>"
	. += "<h2>Other content prefs</h2>"
	. += "<b>Breast Enlargement:</b> <a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=breast_enlargement'>[(cit_toggles & BREAST_ENLARGEMENT) ? "Allowed" : "Disallowed"]</a><br>"
	. += "<b>Penis Enlargement:</b> <a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=penis_enlargement'>[(cit_toggles & PENIS_ENLARGEMENT) ? "Allowed" : "Disallowed"]</a><br>"
	. += "<b>Hypno:</b> <a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=never_hypno'>[(cit_toggles & NEVER_HYPNO) ? "Disallowed" : "Allowed"]</a><br>"
	. += "<b>Aphrodisiacs:</b> <a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=aphro'>[(cit_toggles & NO_APHRO) ? "Disallowed" : "Allowed"]</a><br>"
	. += "<b>Ass Slapping:</b> <a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=ass_slap'>[(cit_toggles & NO_ASS_SLAP) ? "Disallowed" : "Allowed"]</a><br>"
	. += "<b>Automatic Wagging:</b> <a href='?src=[REF(src)];parent=[REF(prefs)];cit_toggle=auto_wag'>[(cit_toggles & NO_AUTO_WAG) ? "Disabled" : "Enabled"]</a><br>"
	. += "</tr></table>"
	. += "<br>"

/datum/preferences_collection/hybrid/fetish_content/OnTopic(mob/user, datum/preferences/prefs, list/href_list)
	. = ..()
	if(href_list["cit_toggle"])
		switch(href_list["cit_toggle"])
			if("genital_examine")
				auto_toggle_bitfield(prefs, "cit_toggles", GENITAL_EXAMINE)

			if("vore_examine")
				auto_toggle_bitfield(prefs, "cit_toggles", VORE_EXAMINE)

			if("hound_sleeper")
				auto_toggle_bitfield(prefs, "cit_toggles", MEDIHOUND_SLEEPER)

			if("toggleeatingnoise")
				auto_toggle_bitfield(prefs, "cit_toggles", EATING_NOISES)

			if("toggledigestionnoise")
				auto_toggle_bitfield(prefs, "cit_toggles", DIGESTION_NOISES)

			if("toggleforcefeedtrash")
				auto_toggle_bitfield(prefs, "cit_toggles", TRASH_FORCEFEED)

			if("breast_enlargement")
				auto_toggle_bitfield(prefs, "cit_toggles", BREAST_ENLARGEMENT)

			if("penis_enlargement")
				auto_toggle_bitfield(prefs, "cit_toggles", PENIS_ENLARGEMENT)

			if("feminization")
				auto_toggle_bitfield(prefs, "cit_toggles", FORCED_FEM)

			if("masculinization")
				auto_toggle_bitfield(prefs, "cit_toggles", FORCED_MASC)

			if("hypno")
				auto_toggle_bitfield(prefs, "cit_toggles", HYPNO)

			if("never_hypno")
				auto_toggle_bitfield(prefs, "cit_toggles", NEVER_HYPNO)

			if("aphro")
				auto_toggle_bitfield(prefs, "cit_toggles", NO_APHRO)

			if("ass_slap")
				auto_toggle_bitfield(prefs, "cit_toggles", NO_ASS_SLAP)

			if("bimbo")
				auto_toggle_bitfield(prefs, "cit_toggles", BIMBOFICATION)

			if("auto_wag")
				auto_toggle_bitfield(prefs, "cit_toggles", NO_AUTO_WAG)
		return PREFERENCES_ONTOPIC_REFRESH

/datum/preferences_collection/hybrid/fetish_content/sanitize_any(datum/preferences/prefs)
	. = ..()
	auto_sanitize_bitfield(prefs, "cit_toggles")

/datum/preferences_collection/hybrid/fetish_content/on_full_character_reset(datum/preferences/prefs)
	. = ..()
	prefs.SetKeyCharacter(PREFERENCES_SAVE_KEY_FETISH, "cit_toggles", prefs.LoadKeyGlobal(PREFERENCES_SAVE_KEY_FETISH, "cit_toggles"))

/datum/preferences_collection/hybrid/fetish_content/on_full_global_reset(datum/preferences/prefs)
	. = ..()
	prefs.SetKeyGlobal(PREFERENCES_SAVE_KEY_FETISH, "cit_toggles", CIT_TOGGLES)
