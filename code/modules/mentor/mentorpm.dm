#define IRCREPLYCOUNT 2


//allows right clicking mobs to send an mentor PM to their client, forwards the selected mob's client to cmd_mentor_pm

//shows a list of clients we could send PMs to, then forwards our choice to cmd_mentor_pm
/client/proc/cmd_mentor_pm_panel()
	set category = "Mentor"
	set name = "Mentor PM"
	if(!holder)
		to_chat(src, "<font color='red'>Error: Mentor-PM-Panel: Only mentoristrators may use this command.</font>")
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
	var/target = input(src,"To whom shall we send a message?","Mentor PM",null) as null|anything in sortList(targets)
	cmd_mentor_pm(targets[target],null)
	SSblackbox.add_details("mentor_verb","Mentor PM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_mhelp_reply(whom)
	if(prefs.muted & MUTE_MENTORHELP)
		to_chat(src, "<font color='red'>Error: Mentor-PM: You are unable to use Mentor help (muted).</font>")
		return
	var/client/C
	if(istext(whom))
		if(cmptext(copytext(whom,1,2),"@"))
			whom = findStealthKey(whom)
		C = GLOB.directory[whom]
	else if(istype(whom, /client))
		C = whom
	if(!C)
		if(holder)
			to_chat(src, "<font color='red'>Error: Mentor-PM: Client not found.</font>")
		return

	var/datum/mentor_help/MH = C.current_mticket

	if(MH)
		to_chat(GLOB.admins, "[key_name_admin(src)] has started replying to [key_name(C, 0, 0)]'s mentor help.")
	var/msg = input(src,"Message:", "Mentor message to [key_name(C, 0, 0)]") as text|null
	if (!msg)
		to_chat(GLOB.admins, "[key_name_admin(src)] has cancelled their reply to [key_name(C, 0, 0)]'s mentor help.")
		return
	cmd_mentor_pm(whom, msg)

//takes input from cmd_mentor_pm_context, cmd_mentor_pm_panel or /client/Topic and sends them a PM.
//Fetching a message if needed. src is the sender and C is the target client
/client/proc/cmd_mentor_pm(whom, msg)
	if(prefs.muted & MUTE_MENTORHELP)
		to_chat(src, "<font color='red'>Error: Mentor-PM: You are unable to use mentor PM-s (muted).</font>")
		return

	if(!holder && !current_mticket)	//no ticket?
		to_chat(src, "<font color='red'>You can no longer reply to this ticket, please open another one by using the Mentorhelp verb if need be.</font>")
		to_chat(src, "<font color='blue'>Message: [msg]</font>")
		return

	var/client/recipient
	var/irc = 0
	if(istext(whom))
		if(cmptext(copytext(whom,1,2),"@"))
			whom = findStealthKey(whom)
		if(whom == "IRCKEY")
			irc = 1
		else
			recipient = GLOB.directory[whom]
	else if(istype(whom, /client))
		recipient = whom


	if(irc)
		if(!ircreplyamount)	//to prevent people from spamming irc
			return
		if(!msg)
			msg = input(src,"Message:", "Mentor message to Mentors") as text|null

		if(!msg)
			return
		if(holder)
			to_chat(src, "<font color='red'>Error: Use the Mentor Discord channel, nerd.</font>")
			return


	else
		if(!recipient)
			if(holder)
				to_chat(src, "<font color='red'>Error: Mentor-PM: Client not found.</font>")
				to_chat(src, msg)
			else
				current_mticket.MessageNoRecipient(msg)
			return

		//get message text, limit it's length.and clean/escape html
		if(!msg)
			msg = input(src,"Message:", "Mentor message to [key_name(recipient, 0, 0)]") as text|null

			if(!msg)
				return

			if(prefs.muted & MUTE_MENTORHELP)
				to_chat(src, "<font color='red'>Error: Mentor-PM: You are unable to use mentor PM-s (muted).</font>")
				return

			if(!recipient)
				if(holder)
					to_chat(src, "<font color='red'>Error: Mentor-PM: Client not found.</font>")
				else
					current_mticket.MessageNoRecipient(msg)
				return

	if (src.handle_spam_prevention(msg,MUTE_MENTORHELP))
		return

	//clean the message if it's not sent by a high-rank admin
	if(!check_rights(R_SERVER|R_DEBUG,0)||irc)//no sending html to the poor bots
		msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
		if(!msg)
			return

	var/rawmsg = msg

	if(holder)
		msg = emoji_parse(msg)

	var/keywordparsedmsg = keywords_lookup(msg)

	if(irc)
		to_chat(src, "<font color='blue'>PM to-<b>Mentors</b>: [rawmsg]</font>")
		var/datum/mentor_help/MH = mentor_ticket_log(src, "<font color='red'>Reply PM from-<b>[key_name(src, TRUE, TRUE)] to <i>IRC</i>: [keywordparsedmsg]</font>")
		ircreplyamount--
		send2irc("[MH ? "#[MH.id] " : ""]Reply: [ckey]", rawmsg)

	if(irc)
		log_mentor("PM: [key_name(src)]->IRC: [rawmsg]")
		for(var/client/X in GLOB.mentors)
			to_chat(X, "<font color='blue'><B>PM: [key_name(src, X, 0)]-&gt;IRC:</B> [keywordparsedmsg]</font>")
	else
		window_flash(recipient, ignorepref = TRUE)
		log_mentor("PM: [key_name(src)]->[key_name(recipient)]: [rawmsg]")
		//we don't use message_mentors here because the sender/receiver might get it too
		for(var/client/X in GLOB.mentors)
			if(X.key!=key && X.key!=recipient.key)	//check client/X is an mentor and isn't the sender or recipient
				to_chat(X, "<font color='blue'><B>PM: [key_name(src, X, 0)]-&gt;[key_name(recipient, X, 0)]:</B> [keywordparsedmsg]</font>" )



#define IRC_MHELP_USAGE "Usage: ticket <close|resolve|reject|reopen \[ticket #\]|list>"
/proc/MIrcPm(target,msg,sender)
	target = ckey(target)
	var/client/C = GLOB.directory[target]

	var/datum/mentor_help/ticket = C ? C.current_mticket : GLOB.mhelp_tickets.CKey2ActiveTicket(target)
	var/compliant_msg = trim(lowertext(msg))
	var/irc_tagged = "[sender](IRC)"
	var/list/splits = splittext(compliant_msg, " ")
	if(splits.len && splits[1] == "ticket")
		if(splits.len < 2)
			return IRC_MHELP_USAGE
		switch(splits[2])
			if("close")
				if(ticket)
					ticket.Close(irc_tagged)
					return "Ticket #[ticket.id] successfully closed"
			if("resolve")
				if(ticket)
					ticket.Resolve(irc_tagged)
					return "Ticket #[ticket.id] successfully resolved"
			if("reject")
				if(ticket)
					ticket.Reject(irc_tagged)
					return "Ticket #[ticket.id] successfully rejected"
			if("reopen")
				if(ticket)
					return "Error: [target] already has ticket #[ticket.id] open"
				var/fail = splits.len < 3 ? null : -1
				if(!isnull(fail))
					fail = text2num(splits[3])
				if(isnull(fail))
					return "Error: No/Invalid ticket id specified. [IRC_MHELP_USAGE]"
				var/datum/mentor_help/MH = GLOB.mhelp_tickets.TicketByID(fail)
				if(!MH)
					return "Error: Ticket #[fail] not found"
				if(MH.initiator_ckey != target)
					return "Error: Ticket #[fail] belongs to [MH.initiator_ckey]"
				MH.Reopen()
				return "Ticket #[ticket.id] successfully reopened"
			if("list")
				var/list/tickets = GLOB.mhelp_tickets.TicketsByCKey(target)
				if(!tickets.len)
					return "None"
				. = ""
				for(var/I in tickets)
					var/datum/mentor_help/MH = I
					if(.)
						. += ", "
					if(MH == ticket)
						. += "Active: "
					. += "#[MH.id]"
				return
			else
				return IRC_MHELP_USAGE
		return "Error: Ticket could not be found"

	var/static/stealthkey
	var/mentorname = config.showircname ? irc_tagged : "Mentoristrator"

	if(!C)
		return "Error: No client"

	if(!stealthkey)
		stealthkey = GenIrcStealthKey()

	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg)
		return "Error: No message"

	to_chat(GLOB.admins, "IRC message from [sender] to [key_name_admin(C)] : [msg]")
	log_mentor("IRC PM: [sender] -> [key_name(C)] : [msg]")
	msg = emoji_parse(msg)

	to_chat(C, "<font color='red' size='4'><b>-- Mentoristrator private message --</b></font>")
	to_chat(C, "<font color='red'>Mentor PM from-<b><a href='?priv_msg=[stealthkey]'>[mentorname]</A></b>: [msg]</font>")
	to_chat(C, "<font color='red'><i>Click on the mentoristrator's name to reply.</i></font>")

	mentor_ticket_log(C, "<font color='blue'>PM From [irc_tagged]: [msg]</font>")

	window_flash(C, ignorepref = TRUE)
	//always play non-mentor recipients the mentorhelp sound
	SEND_SOUND(C, 'sound/effects/-adminhelp.ogg')

	C.ircreplyamount = IRCREPLYCOUNT

	return "Message Successful"

#undef IRCREPLYCOUNT
