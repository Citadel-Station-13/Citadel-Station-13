//SKYRAT EDIT - extra language
/datum/preferences/proc/SetLanguage(mob/user)
	var/list/dat = list()
	dat += "<center><b>Choose Additional Languages</b></center><br>"
	if(!CONFIG_GET(number/max_languages) == 0)
		dat += "<center>Do note, however, you can have many languages. <b>Do not abuse this.</b></center><br>"
		dat += "<center>If you want no additional language at all, click reset to disable all languages.</center><br>"
		dat += "<hr>"
		if(SSlanguage && SSlanguage.languages_by_name.len)
			for(var/V in SSlanguage.languages_by_name)
				var/datum/language/L = SSlanguage.languages_by_name[V]
				if(!L)
					return
				var/language_name = initial(L.name)
				var/restricted = FALSE
				if(L.restricted)
					restricted = TRUE
				var/font_color = "#4682B4"
				if(restricted && !(language_name in pref_species.languagewhitelist))
					var/quirklanguagefound = FALSE
					for(var/datum/quirk/Q in all_quirks)
						if(language_name in Q.languagewhitelist)
							quirklanguagefound = TRUE
					if(!quirklanguagefound)
						continue
				else
					var/picked = FALSE
					dat += "<b><font color='[font_color]'>[language_name]:</font></b> [initial(L.desc)]"
					if(language_name in language)
						picked = TRUE
					dat += "<a href='?_src_=prefs;preference=language;task=update;language=[language_name]'>[picked ? "Remove" : "Choose"]</a><br>"
		else
			dat += "<center><b>The language subsystem hasn't fully loaded yet! Please wait a bit and try again.</b></center><br>"
		dat += "<hr>"
		dat += "<td><center><a style='white-space:normal;background:#eb2e2e;' href='?_src_=prefs;preference=language;task=reset'>Reset</center></span></td>"
	else
		dat += "<hr>"
		dat += "<b>Additional Languages are disabled.</b>"
		dat += "<hr>"
	dat += "<center><a href='?_src_=prefs;preference=language;task=close'>Done</a></center>"

	var/datum/browser/popup = new(user, "mob_occupation", "<div align='center'>Language Preference</div>", 900, 600) //no reason not to reuse the occupation window, as it's cleaner that way
	popup.set_window_options("can_close=0")
	popup.set_content(dat.Join())
	popup.open(FALSE)
//

/datum/preferences/proc/toggle_language(lang)
	if(lang in language)
		language -= lang
	else if(check_language_maxhit())
		if(CONFIG_GET(number/max_languages) == 1)
			to_chat(usr, "<span class='danger'>You can only have 1 additional language!</span>")
		else
			to_chat(usr, "<span class='danger'>You can only have up to [CONFIG_GET(number/max_languages)] additional languages!</span>")
	else
		language += lang

/datum/preferences/proc/check_language_maxhit()
	if(CONFIG_GET(number/max_languages) == -1) //infinite
		return FALSE
	else if(language.len >= CONFIG_GET(number/max_languages))
		return TRUE
