/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = ""

	var/list/Lines = list()

	if(length(admins) > 0)
		Lines += "<b>Admins:</b>"
		for(var/client/C in sortList(admins))
			if(!C.holder.fakekey)
				Lines += "\t <font color='#FF0000'>[C.key]</font>[show_info(C)]"

	if(length(mentors) > 0)
		Lines += "<b>Mentors:</b>"
		for(var/client/C in sortList(clients))
			var/mentor = mentor_datums[C.ckey]
			if(mentor)
				Lines += "\t <font color='#0033CC'>[C.key]</font>[show_info(C)]"

	Lines += "<b>Players:</b>"
	for(var/client/C in sortList(clients))
		if(!check_mentor_other(C) || (C.holder && C.holder.fakekey))
			Lines += "\t [C.key][show_info(C)]"

	for(var/line in Lines)
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	src << msg

/client/proc/show_info(var/client/C)
	if(!C)
		return ""

	if(!src.holder)
		return ""

	var/entry = ""
	if(C.holder && C.holder.fakekey)
		entry += " <i>(as [C.holder.fakekey])</i>"
	if (isnewplayer(C.mob))
		entry += " - <font color='darkgray'><b>In Lobby</b></font>"
	else
		entry += " - Playing as [C.mob.real_name]"
		switch(C.mob.stat)
			if(UNCONSCIOUS)
				entry += " - <font color='darkgray'><b>Unconscious</b></font>"
			if(DEAD)
				if(isobserver(C.mob))
					var/mob/dead/observer/O = C.mob
					if(O.started_as_observer)
						entry += " - <font color='gray'>Observing</font>"
					else
						entry += " - <font color='black'><b>DEAD</b></font>"
				else
					entry += " - <font color='black'><b>DEAD</b></font>"
		if(is_special_character(C.mob))
			entry += " - <b><font color='red'>Antagonist</font></b>"
	entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
	entry += " ([round(C.avgping, 1)]ms)"
	return entry

/client/verb/adminwho()
	set category = "Admin"
	set name = "Adminwho"

	var/msg = "<b>Current Admins:</b>\n"
	if(holder)
		for(var/client/C in admins)
			msg += "\t[C] is a [C.holder.rank]"

			if(C.holder.fakekey)
				msg += " <i>(as [C.holder.fakekey])</i>"

			if(isobserver(C.mob))
				msg += " - Observing"
			else if(isnewplayer(C.mob))
				msg += " - Lobby"
			else
				msg += " - Playing"

			if(C.is_afk())
				msg += " (AFK)"
			msg += "\n"
	else
		for(var/client/C in admins)
			if(C.is_afk())
				continue //Don't show afk admins to adminwho
			if(!C.holder.fakekey)
				msg += "\t[C] is a [C.holder.rank]\n"
		msg += "<span class='info'>Adminhelps are also sent to IRC. If no admins are available in game adminhelp anyways and an admin on IRC will see it and respond.</span>"
	src << msg

/client/verb/mentorwho()
	set category = "Mentor"
	set name = "Mentorwho"
	var/msg = "<b>Current Mentors:</b>\n"
	for(var/client/C in mentors)
		var/suffix = ""
		if(holder)
			if(isobserver(C.mob))
				suffix += " - Observing"
			else if(istype(C.mob,/mob/dead/new_player))
				suffix += " - Lobby"
			else
				suffix += " - Playing"

			if(C.is_afk())
				suffix += " (AFK)"
		msg += "\t[C][suffix]\n"
	to_chat(src, msg)
