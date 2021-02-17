/datum/controller/subsystem/language/proc/AssignLanguage(mob/living/user, client/cli)
	if(!CONFIG_GET(number/max_languages) == 0)	//Simply disables everything
		var/list/languages = cli.prefs.language
		var/list/valid_languages = list()
		var/list/invalid_languages = list()
		if(!languages.len)
			return
		for(var/I in GLOB.all_languages)
			var/datum/language/L = I
			var/datum/language/cool = new L
			for(var/my_lang in languages)
				if(my_lang == cool.name)
					if(!cool.restricted || (cool.name in cli.prefs.pref_species.languagewhitelist))
						user.grant_language(cool.type, TRUE, TRUE, LANGUAGE_ADDITIONAL)
						valid_languages += my_lang
					else
						for(var/datum/quirk/Q in cli.prefs.all_quirks)
							if(cool.name in Q.languagewhitelist)
								user.grant_language(cool, TRUE, TRUE, LANGUAGE_ADDITIONAL)
								valid_languages += my_lang
								continue
						invalid_languages += my_lang
				else
					continue
		if(valid_languages.len)
			var/list/sorted_valid = sortList(valid_languages)
			to_chat(user, "<span class='notice'>You are able to speak in [sorted_valid.Join(", ")]. If you're actually good at [valid_languages.len > 1 ? "them" : "it"] or not, it's up to you.</span>")
		if(invalid_languages.len)
			var/list/sorted_invalid = sortList(invalid_languages)
			to_chat(user, "<span class='warning'>[sorted_invalid.Join(", ")] [invalid_languages.len > 1 ? "are" : "is a"] restricted language[invalid_languages.len > 1 ? "s" : ""], and ha[invalid_languages.len > 1 ? "ve" : "s"] not been assigned.</span>")
