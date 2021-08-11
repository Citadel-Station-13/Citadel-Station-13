/datum/preferences_collection/hybrid/fetish_content
	save_key = PREFERENCES_SAVE_KEY_FETISH
	sort_order = 2

/datum/preferences_collection/hybrid/fetish_content/content(datum/preferences/prefs)
	. = ..()
	var/cit_toggles = LoadKey(prefs, "cit_toggles")

/*
	var/cit_toggles = TOGGLES_CITADEL


if(CONTENT_PREFERENCES_TAB) // Content preferences
dat += "<table><tr><td width='340px' height='300px' valign='top'>"
dat += "<h2>Fetish content prefs</h2>"
dat += "<b>Arousal:</b><a href='?_src_=prefs;preference=arousable'>[arousable == TRUE ? "Enabled" : "Disabled"]</a><BR>"
dat += "<b>Genital examine text</b>:<a href='?_src_=prefs;preference=genital_examine'>[(check_cit_toggle(GENITAL_EXAMINE)) ? "Enabled" : "Disabled"]</a><BR>"
dat += "<b>Vore examine text</b>:<a href='?_src_=prefs;preference=vore_examine'>[(check_cit_toggle(VORE_EXAMINE)) ? "Enabled" : "Disabled"]</a><BR>"
dat += "<b>Voracious MediHound sleepers:</b> <a href='?_src_=prefs;preference=hound_sleeper'>[(check_cit_toggle(MEDIHOUND_SLEEPER)) ? "Yes" : "No"]</a><br>"
dat += "<b>Hear Vore Sounds:</b> <a href='?_src_=prefs;preference=toggleeatingnoise'>[(check_cit_toggle(EATING_NOISES)) ? "Yes" : "No"]</a><br>"
dat += "<b>Hear Vore Digestion Sounds:</b> <a href='?_src_=prefs;preference=toggledigestionnoise'>[(check_cit_toggle(DIGESTION_NOISES)) ? "Yes" : "No"]</a><br>"
dat += "<b>Allow trash forcefeeding (requires Trashcan quirk)</b> <a href='?_src_=prefs;preference=toggleforcefeedtrash'>[(check_cit_toggle(TRASH_FORCEFEED)) ? "Yes" : "No"]</a><br>"
dat += "<b>Forced Feminization:</b> <a href='?_src_=prefs;preference=feminization'>[(check_cit_toggle(FORCED_FEM)) ? "Allowed" : "Disallowed"]</a><br>"
dat += "<b>Forced Masculinization:</b> <a href='?_src_=prefs;preference=masculinization'>[(check_cit_toggle(FORCED_MASC)) ? "Allowed" : "Disallowed"]</a><br>"
dat += "<b>Lewd Hypno:</b> <a href='?_src_=prefs;preference=hypno'>[(check_cit_toggle(HYPNO)) ? "Allowed" : "Disallowed"]</a><br>"
dat += "<b>Bimbofication:</b> <a href='?_src_=prefs;preference=bimbo'>[(check_cit_toggle(BIMBOFICATION)) ? "Allowed" : "Disallowed"]</a><br>"
dat += "</td>"
dat +="<td width='300px' height='300px' valign='top'>"
dat += "<h2>Other content prefs</h2>"
dat += "<b>Breast Enlargement:</b> <a href='?_src_=prefs;preference=breast_enlargement'>[(check_cit_toggle(BREAST_ENLARGEMENT)) ? "Allowed" : "Disallowed"]</a><br>"
dat += "<b>Penis Enlargement:</b> <a href='?_src_=prefs;preference=penis_enlargement'>[(check_cit_toggle(PENIS_ENLARGEMENT)) ? "Allowed" : "Disallowed"]</a><br>"
dat += "<b>Hypno:</b> <a href='?_src_=prefs;preference=never_hypno'>[(check_cit_toggle(NEVER_HYPNO)) ? "Disallowed" : "Allowed"]</a><br>"
dat += "<b>Aphrodisiacs:</b> <a href='?_src_=prefs;preference=aphro'>[(check_cit_toggle(NO_APHRO)) ? "Disallowed" : "Allowed"]</a><br>"
dat += "<b>Ass Slapping:</b> <a href='?_src_=prefs;preference=ass_slap'>[(check_cit_toggle(NO_ASS_SLAP)) ? "Disallowed" : "Allowed"]</a><br>"
dat += "<b>Automatic Wagging:</b> <a href='?_src_=prefs;preference=auto_wag'>[(check_cit_toggle(NO_AUTO_WAG)) ? "Disabled" : "Enabled"]</a><br>"
dat += "</tr></table>"
dat += "<br>"

	// Citadel edit - Prefs don't work outside of this. :c

	if("genital_examine")
		cit_toggles ^= GENITAL_EXAMINE

	if("vore_examine")
		cit_toggles ^= VORE_EXAMINE

	if("hound_sleeper")
		cit_toggles ^= MEDIHOUND_SLEEPER

	if("toggleeatingnoise")
		cit_toggles ^= EATING_NOISES

	if("toggledigestionnoise")
		cit_toggles ^= DIGESTION_NOISES

	if("toggleforcefeedtrash")
		cit_toggles ^= TRASH_FORCEFEED

	if("breast_enlargement")
		cit_toggles ^= BREAST_ENLARGEMENT

	if("penis_enlargement")
		cit_toggles ^= PENIS_ENLARGEMENT

	if("feminization")
		cit_toggles ^= FORCED_FEM

	if("masculinization")
		cit_toggles ^= FORCED_MASC

	if("hypno")
		cit_toggles ^= HYPNO

	if("never_hypno")
		cit_toggles ^= NEVER_HYPNO

	if("aphro")
		cit_toggles ^= NO_APHRO

	if("ass_slap")
		cit_toggles ^= NO_ASS_SLAP

	if("bimbo")
		cit_toggles ^= BIMBOFICATION

	if("auto_wag")
		cit_toggles ^= NO_AUTO_WAG

	//END CITADEL EDIT





	S["cit_toggles"]		>> cit_toggles
	cit_toggles			= sanitize_integer(cit_toggles, 0, 16777215, initial(cit_toggles))
	WRITE_FILE(S["cit_toggles"], cit_toggles)
*/

/datum/preferences_collection/hybrid/fetish_content/sanitize_any(datum/preferences/prefs)
	. = ..()
	auto_sanitize_bitfield(prefs, "cit_toggles")

/datum/preferences_collection/hybrid/fetish_content/on_full_character_reset(datum/preferences/prefs)
	. = ..()
	prefs.SetKeyCharacter(PREFERENCES_SAVE_KEY_FETISH, "cit_toggles", prefs.LoadKeyGlobal(PREFERENCES_SAVE_KEY_FETISH, "cit_toggles"))

/datum/preferences_collection/hybrid/fetish_content/on_full_global_reset(datum/preferences/prefs)
	. = ..()
	prefs.SetKeyGlobal(PREFERENCES_SAVE_KEY_FETISH, "cit_toggles", CIT_TOGGLES)
