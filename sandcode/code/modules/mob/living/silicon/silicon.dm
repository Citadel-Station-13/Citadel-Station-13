/mob/living/silicon
	examine_cursor_icon = null
	combat_cursor_icon = null
	pull_cursor_icon = null
	throw_cursor_icon = null

/mob/living/silicon/Topic(href, href_list)
	. = ..()
	if(href_list["skyrat_ooc_notes"])
		if(client)
			var/str = "[src]'s OOC Notes : <br> <b>ERP :</b> [client.prefs.erppref] <b>| Non-Con :</b> [client.prefs.nonconpref] <b>| Vore :</b> [client.prefs.vorepref]<br>[client.prefs.skyrat_ooc_notes]"
			usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", "[name]'s OOC information", replacetext(str, "\n", "<BR>")), text("window=[];size=500x200", "[name]'s ooc info"))
			onclose(usr, "[name]'s ooc info")

/mob/living/silicon/verb/robot_nom(var/mob/living/T in oview(1))
	set name = "Eat Mob"
	set category = "Vore"
	set desc = "Allows you to eat someone."

	if(!CHECK_BITFIELD(T.vore_flags,DEVOURABLE))
		to_chat(src, "<span class='warning'>System error: Unauthorized operation.</span>")
		return
	return feed_grabbed_to_self(src,T)
