#define IRCREPLYCOUNT 2


//allows right clicking mobs to send an admin PM to their client, forwards the selected mob's client to cmd_admin_pm
/client/proc/cmd_admin_pm_context(mob/M in mob_list)
	set category = null
	set name = "Admin PM Mob"
	if(!holder)
		src << "<font color='red'>Error: Admin-PM-Context: Only administrators may use this command.</font>"
		return
	if( !ismob(M) || !M.client )	return
	cmd_admin_pm(M.client,null)
	feedback_add_details("admin_verb","APMM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//shows a list of clients we could send PMs to, then forwards our choice to cmd_admin_pm
/client/proc/cmd_admin_pm_panel()
	set category = "Admin"
	set name = "Admin PM"
	if(!holder)
		src << "<font color='red'>Error: Admin-PM-Panel: Only administrators may use this command.</font>"
		return
	var/list/client/targets[0]
	for(var/client/T)
		if(T.mob)
			if(isnewplayer(T.mob))
				targets["(New Player) - [T]"] = T
			else if(isobserver(T.mob))
				targets["[T.mob.name](Ghost) - [T]"] = T
			else
				targets["[T.mob.real_name](as [T.mob.name]) - [T]"] = T
		else
			targets["(No Mob) - [T]"] = T
	var/target = input(src,"To whom shall we send a message?","Admin PM",null) as null|anything in sortList(targets)
	cmd_admin_pm(targets[target],null)
	feedback_add_details("admin_verb","APM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_ahelp_reply(whom)
	if(prefs.muted & MUTE_ADMINHELP)
		src << "<font color='red'>Error: Admin-PM: You are unable to use admin PM-s (muted).</font>"
		return
	var/client/C
	if(istext(whom))
		if(cmptext(copytext(whom,1,2),"@"))
			whom = findStealthKey(whom)
		C = directory[whom]
	else if(istype(whom,/client))
		C = whom
	if(!C)
		if(holder)	src << "<font color='red'>Error: Admin-PM: Client not found.</font>"
		return
	var/datum/adminticket/ticket

	for(var/datum/adminticket/T in admintickets)
		if(T.permckey == C.ckey)
			ticket = T

	if(ticket)
		if(ticket.active == "No" && ticket.replying == 0)
			message_admins("[key_name_admin(src)] has been assigned to [key_name(C, 0, 0)]'s admin help. This is the first reply. ([ticket.uID])")
			ticket.replying = 1
			ticket.user << "<b>[src.ckey] has been assigned to your admin help, please await a reply.</b>"
		else if(ticket.replying == 1)
			src << "<b>Error, this ticket is already being replied to!</b>"
			return
		else if(ticket.admin != "N/A" && ticket.replying == 0)
			if(ticket.admin != src.ckey)
				if(alert(src, "This adminhelp already has an admin assigned: [ticket.admin]! Are you sure you want to take it over?", "Conflict", "Yes", "No") == "Yes")
					message_admins("[key_name_admin(src)] has been assigned to [key_name(C, 0, 0)]'s admin help. Override: [ticket.admin]. ([ticket.uID])")
					ticket.user << "<b>[src.ckey] has been assigned to your admin help, please await a reply.</b>"
					ticket.replying = 1
	else
		message_admins("[key_name_admin(src)] has started replying to [key_name(C, 0, 0)]'s admin help. They did not have an active ahelp.")
	var/msg = input(src,"Message:", "Private message to [key_name(C, 0, 0)]") as text|null
	if (!msg)
		message_admins("[key_name_admin(src)] has cancelled their reply to [key_name(C, 0, 0)]'s admin help.")
		return
	cmd_admin_pm(whom, msg)

//takes input from cmd_admin_pm_context, cmd_admin_pm_panel or /client/Topic and sends them a PM.
//Fetching a message if needed. src is the sender and C is the target client
/client/proc/cmd_admin_pm(whom, msg)
	if(prefs.muted & MUTE_ADMINHELP)
		src << "<font color='red'>Error: Admin-PM: You are unable to use admin PM-s (muted).</font>"
		return

	var/client/C
	var/irc = 0
	if(istext(whom))
		if(cmptext(copytext(whom,1,2),"@"))
			whom = findStealthKey(whom)
		if(whom == "IRCKEY")
			irc = 1
		else
			C = directory[whom]
	else if(istype(whom,/client))
		C = whom
	if(!C)
		if(holder)	src << "<font color='red'>Error: Admin-PM: Client not found.</font>"
		else		adminhelp(msg)	//admin we are replying to left. adminhelp instead
		return

	//get message text, limit it's length.and clean/escape html
	if(!msg)
		msg = input(src,"Message:", "Private message to [key_name(C, 0, 0)]") as text|null

		if(!msg)	return
		if(!C)
			if(holder)	src << "<font color='red'>Error: Admin-PM: Client not found.</font>"
			else		adminhelp(msg)	//admin we are replying to has vanished, adminhelp instead
			return

		//get message text, limit it's length.and clean/escape html
		if(!msg)
			msg = input(src,"Message:", "Private message to [key_name(C, 0, 0)]") as text|null

			if(!msg)
				return

			if(prefs.muted & MUTE_ADMINHELP)
				src << "<font color='red'>Error: Admin-PM: You are unable to use admin PM-s (muted).</font>"
				return

			if(!C)
				if(holder)
					src << "<font color='red'>Error: Admin-PM: Client not found.</font>"
				else
					adminhelp(msg)	//admin we are replying to has vanished, adminhelp instead
				return

	if (src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	//clean the message if it's not sent by a high-rank admin
	if(!check_rights(R_SERVER|R_DEBUG,0)||irc)//no sending html to the poor bots
		msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
		if(!msg)	return
	msg = emoji_parse(msg)
	var/keywordparsedmsg = keywords_lookup(msg)
	var/datum/adminticket/ticket

	if(C.holder)
		if(holder)	//both are admins
			for(var/datum/adminticket/T in admintickets)
				if(T.permckey == src.ckey && T.resolved == "No")
					T.logs += "<span class='notice'>[src] TO [C]: [msg] </span>"
					ticket = T
				else if(T.permckey == src.ckey)
					ticket = T
			if(ticket && ticket.resolved == "No")
				C << "<font color='red'>Admin PM from-<b>[key_name(src, C, 1)]</b>: [keywordparsedmsg] (<a href='?src=\ref[ticket];resolve=\ref[ticket]'>R</a>)</font>"
				src << "<font color='blue'>Admin PM to-<b>[key_name(C, src, 1)]</b>: [keywordparsedmsg] (<a href='?src=\ref[ticket];resolve=\ref[ticket]'>R</a>)</font>"
			else
				C << "<font color='red'>Admin PM from-<b>[key_name(src, C, 1)]</b>: [keywordparsedmsg]</font>"
				src << "<font color='blue'>Admin PM to-<b>[key_name(C, src, 1)]</b>: [keywordparsedmsg]</font>"
		else		//recipient is an admin but sender is not
			for(var/datum/adminticket/T in admintickets)
				if(T.permckey == src.ckey && T.resolved == "No")
					T.logs += "<span class='notice'>[src] TO [C]: [msg] </span>"
					ticket = T
				else if(T.permckey == src.ckey)
					ticket = T
			if(ticket && ticket.resolved == "No")
				C << "<font color='red'>Reply PM from-<b>[key_name(src, C, 1)]</b>: [keywordparsedmsg] (<a href='?src=\ref[ticket];resolve=\ref[ticket]'>R</a>)</font>"
			else
				C << "<font color='red'>Reply PM from-<b>[key_name(src, C, 1)]</b>: [keywordparsedmsg]</font>"
			src << "<font color='blue'>PM to-<b>Admins</b>: [msg]</font>"

		//play the recieving admin the adminhelp sound (if they have them enabled)
		if(C.prefs.toggles & SOUND_ADMINHELP)
			C << 'sound/effects/adminhelp.ogg'
		else
			if(holder)	//sender is an admin but recipient is not. Do BIG RED TEXT
				C << "<font color='red' size='4'><b>-- Administrator private message --</b></font>"
				C << "<font color='red'>Admin PM from-<b>[key_name(src, C, 0)]</b>: [msg]</font>"
				C << "<font color='red'><i>Click on the administrator's name to reply.</i></font>"
				src << "<font color='blue'>Admin PM to-<b>[key_name(C, src, 1)]</b>: [msg]</font>"

				//always play non-admin recipients the adminhelp sound
				C << 'sound/effects/adminhelp.ogg'

				//AdminPM popup for ApocStation and anybody else who wants to use it. Set it with POPUP_ADMIN_PM in config.txt ~Carn
				if(config.popup_admin_pm)
					spawn()	//so we don't hold the caller proc up
						var/sender = src
						var/sendername = key
						var/reply = input(C, msg,"Admin PM from-[sendername]", "") as text|null		//show message and await a reply
						if(C && reply)
							if(sender)
								C.cmd_admin_pm(sender,reply)										//sender is still about, let's reply to them
							else
								adminhelp(reply)													//sender has left, adminhelp instead
						return

			else		//neither are admins
				src << "<font color='red'>Error: Admin-PM: Non-admin to non-admin PM communication is forbidden.</font>"
				return

	if(irc)
		log_admin("PM: [key_name(src)]->IRC: [rawmsg]")
		for(var/client/X in admins)
			X << "<B><font color='blue'>PM: [key_name(src, X, 0)]-&gt;IRC:</B> \blue [keywordparsedmsg]</font>" //inform X
	else
		if(holder)	//sender is an admin but recipient is not. Do BIG RED TEXT
			for(var/datum/adminticket/T in admintickets)
				if(T.permckey == C.ckey && T.resolved == "No")
					T.logs += "<span class='notice'>[src] TO [C]: [msg] </span>"
					ticket = T
				else if(T.permckey == C.ckey)
					ticket = T

			C << "<font color='red' size='4'><b>-- Administrator private message --</b></font>"
			C << "<font color='red'>Admin PM from-<b>[key_name(src, C, 0)]</b>: [msg]</font>"
			C << "<font color='red'><i>Click on the administrator's name to reply.</i></font>"
			if(ticket && ticket.resolved == "No")
				src << "<font color='blue'>Admin PM to-<b>[key_name(C, src, 1)]</b>: [msg] (<a href='?src=\ref[ticket];resolve=\ref[ticket]'>R</a>)</font>"
			else
				src << "<font color='blue'>Admin PM to-<b>[key_name(C, src, 1)]</b>: [msg]</font>"
			//always play non-admin recipients the adminhelp sound
			C << 'sound/effects/adminhelp.ogg'

			//AdminPM popup for ApocStation and anybody else who wants to use it. Set it with POPUP_ADMIN_PM in config.txt ~Carn
			if(config.popup_admin_pm)
				spawn()	//so we don't hold the caller proc up
					var/sender = src
					var/sendername = key
					var/reply = input(C, msg,"Admin PM from-[sendername]", "") as text|null		//show message and await a reply
					if(C && reply)
						if(sender)
							C.cmd_admin_pm(sender,reply)
							for(var/datum/adminticket/T in admintickets)
								if(T.permckey == C.ckey && T.resolved == "No")
									T.logs += "<span class='danger'>[sendername] TO [C]: [msg] </span>"										//sender is still about, let's reply to them
						else
							adminhelp(reply)													//sender has left, adminhelp instead
					return

		else		//neither are admins
			src << "<font color='red'>Error: Admin-PM: Non-admin to non-admin PM communication is forbidden.</font>"
			return

	log_admin("PM: [key_name(src)]->[key_name(C)]: [msg]")

	//we don't use message_admins here because the sender/receiver might get it too
	for(var/client/X in admins)
		if(X.key!=key && X.key!=C.key)	//check client/X is an admin and isn't the sender or recipient
			X << "<B><font color='blue'>PM: [key_name(src, X, 0)]-&gt;[key_name(C, X, 0)]:</B> \blue [keywordparsedmsg]</font>" //inform X
#undef IRCREPLYCOUNT