/datum/preferences_collection/character/speech
	save_key = PREFERENCES_SAVE_KEY_SPEECH
	sort_order = 4

/datum/preferences_collection/character/speech/content(datum/preferences/prefs)
	. = ..()

/datum/preferences_collection/character/speech/copy_to_mob(datum/preferences/prefs, mob/M, flags)
	. = ..()

/datum/preferences_collection/character/speech/OnTopic(mob/user, datum/preferences/prefs, list/href_list)
	. = ..()

/datum/preferences_collection/character/speech/savefile_full_overhaul_character(datum/preferences/prefs, list/data, savefile/S, list/errors, current_version)
	. = ..()

/datum/preferences_collection/character/speech/sanitize_character(datum/preferences/prefs)
	. = ..()


	S["custom_speech_verb"]		>> custom_speech_verb
	S["custom_tongue"]			>> custom_tongue
	S["additional_language"]	>> additional_language


	custom_speech_verb				= sanitize_inlist(custom_speech_verb, GLOB.speech_verbs, "default")
	custom_tongue					= sanitize_inlist(custom_tongue, GLOB.roundstart_tongues, "default")
	additional_language				= sanitize_inlist(additional_language, GLOB.roundstart_languages, "None")


			dat += "<table><tr><td width='340px' height='300px' valign='top'>"
			dat += "<h2>Speech preferences</h2>"
			dat += "<b>Custom Speech Verb:</b><BR>"
			dat += "</b><a style='display:block;width:100px' href='?_src_=prefs;preference=speech_verb;task=input'>[custom_speech_verb]</a><BR>"
			dat += "<b>Custom Tongue:</b><BR>"
			dat += "</b><a style='display:block;width:100px' href='?_src_=prefs;preference=tongue;task=input'>[custom_tongue]</a><BR>"
			dat += "<b>Additional Language</b><BR>"
			dat += "</b><a style='display:block;width:100px' href='?_src_=prefs;preference=language;task=input'>[additional_language]</a><BR>"
			dat += "</td>"
			dat += "</tr></table>"


				if("tongue")
					var/selected_custom_tongue = input(user, "Choose your desired tongue (none means your species tongue)", "Character Preference") as null|anything in GLOB.roundstart_tongues
					if(selected_custom_tongue)
						custom_tongue = selected_custom_tongue

				if("speech_verb")
					var/selected_custom_speech_verb = input(user, "Choose your desired speech verb (none means your species speech verb)", "Character Preference") as null|anything in GLOB.speech_verbs
					if(selected_custom_speech_verb)
						custom_speech_verb = selected_custom_speech_verb

				if("language")
					var/selected_language = input(user, "Choose your desired additional language", "Character Preference") as null|anything in GLOB.roundstart_languages
					if(selected_language)
						additional_language = selected_language


	var/custom_speech_verb = "default" //if your say_mod is to be something other than your races
	var/custom_tongue = "default" //if your tongue is to be something other than your races
	var/additional_language = "None" //additional language your character has







	//speech stuff
	if(custom_tongue != "default")
		var/new_tongue = GLOB.roundstart_tongues[custom_tongue]
		if(new_tongue)
			character.dna.species.mutanttongue = new_tongue //this means we get our tongue when we clone
			var/obj/item/organ/tongue/T = character.getorganslot(ORGAN_SLOT_TONGUE)
			if(T)
				qdel(T)
			var/obj/item/organ/tongue/new_custom_tongue = new new_tongue
			new_custom_tongue.Insert(character)
	if(custom_speech_verb != "default")
		character.dna.species.say_mod = custom_speech_verb
	if(additional_language && additional_language != "None")
		var/language_entry = GLOB.roundstart_languages[additional_language]
		if(language_entry)
			character.grant_language(language_entry, TRUE, TRUE)
