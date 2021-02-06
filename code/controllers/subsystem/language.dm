SUBSYSTEM_DEF(language)
	name = "Language"
	init_order = INIT_ORDER_LANGUAGE
	flags = SS_NO_FIRE
	var/list/languages_by_name = list() //SKYRAT CHANGE - language bullshit

/datum/controller/subsystem/language/Initialize(timeofday)
	for(var/L in subtypesof(/datum/language))
		var/datum/language/language = L
		if(!initial(language.key))
			continue

		GLOB.all_languages += language

		var/datum/language/instance = new language

		GLOB.language_datum_instances[language] = instance
		//skyrat change
		languages_by_name[initial(language.name)] = new language
		//

	return ..()

//Skyrat change
/datum/controller/subsystem/language/proc/AssignLanguage(mob/living/user, client/cli)
	var/list/my_lang = cli.prefs.language
	if(isnull(my_lang))
		return
	for(var/I in GLOB.all_languages)
		var/datum/language/L = I
		var/datum/language/cool = new L
		if(my_lang == cool.name)
			if(!cool.restricted || (cool.name in cli.prefs.pref_species.languagewhitelist))
				user.grant_language(cool.type, TRUE, TRUE, LANGUAGE_ADDITIONAL)
				to_chat(user, "<span class='notice'>You are able to speak in [my_lang]. If you're actually good at it or not, it's up to you.</span>")
			else
				for(var/datum/quirk/Q in cli.prefs.all_quirks)
					if(cool.name in Q.languagewhitelist)
						user.grant_language(cool, TRUE, TRUE, LANGUAGE_ADDITIONAL)
						to_chat(user, "<span class='notice'>You are able to speak in [my_lang]. If you're actually good at it or not, it's up to you.</span>")
						return
				to_chat(user, "<span class='warning'>[my_lang] is a restricted language, and has not been assigned.</span>")
		else
			continue
//
