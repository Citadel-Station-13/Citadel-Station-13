/mob/living/carbon/human/Topic(href, href_list)
	. = ..()
	if(href_list["skyrat_ooc_notes"])
		if(client)
			var/str = "[src]'s OOC Notes : <br> <b>ERP :</b> [client.prefs.erppref] <b>| Non-Con :</b> [client.prefs.nonconpref] <b>| Vore :</b> [client.prefs.vorepref]"
			if(client.prefs.extremepref == "Yes")
				str += "<br><b>Extreme content :</b> [client.prefs.extremepref] <b>| <b>Extreme content harm :</b> [client.prefs.extremeharm]"
			str += "<br>[html_encode(client.prefs.skyrat_ooc_notes)]"
			var/datum/browser/popup = new(usr, "[name]'s ooc info", "[name]'s OOC Information", 500, 200)
			popup.set_content(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", "[name]'s OOC information", replacetext(str, "\n", "<BR>")))
			popup.open()
			return
