/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/list/Lines = list()
	var/msg = "--------\n"

	if(length(admins) > 0)
		Lines += "<b>Admins:</b>"
		for(var/client/C in sortList(admins))
			if(C.holder)
				if(!C.holder.fakekey)
					Lines += "<font color='#FF0000'>[C.key]</font>[show_info(C)]"

	if(length(mentors) > 0)
		Lines += "<b>Mentors:</b>"
		for(var/client/C in sortList(clients))
			var/mentor = mentor_datums[C.ckey]
			if(mentor)
				Lines += "<font color='#0033CC'>[C.key]</font>[show_info(C)]"


	var/player_text = ""
	var/display_count = 0 //Used to detect as to whether or not we should display the players list
	for(var/client/C in sortList(clients))
		if(C.holder)
			if(C.holder.fakekey)
				display_count++
				player_text += "[C.holder.fakekey][show_info(C)]\n"
		else if(!check_mentor_other(C))
			display_count++
			player_text += "[C.key][show_info(C)]\n"

	if(display_count > 0)
		Lines += "<b>Players:</b>"
		Lines += player_text

	for(var/line in Lines)
		msg += "[line]\n"

	msg += "<b>Total Players: [length(clients)]</b>\n"
	msg += "--------"
	src << msg

/client/proc/show_info(var/client/C)
	if(!C)
		return ""

	if(!src.holder)
		return ""

	var/entry = "\t[C.key]"
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
			else if(istype(C.mob,/mob/new_player))
				msg += " - Lobby"
			else
				msg += " - Playing"

			if(C.is_afk())
				msg += " (AFK)"
			msg += "\n"
	else
		for(var/client/C in admins)
			if(!C.holder.fakekey)
				msg += "\t[C] is a [C.holder.rank]\n"

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
			else if(istype(C.mob,/mob/new_player))
				suffix += " - Lobby"
			else
				suffix += " - Playing"

			if(C.is_afk())
				suffix += " (AFK)"

		msg += "\t[C][suffix]\n"

	src << msg