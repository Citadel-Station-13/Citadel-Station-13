/client/var/mentorhelptimerid = 0	//a timer id for returning the mhelp verb
/client/var/datum/mentor_help/current_mticket	//the current ticket the (usually) not-mentor client is dealing with

//
//TICKET MANAGER
//

GLOBAL_DATUM_INIT(mhelp_tickets, /datum/mentor_help_tickets, new)

/datum/mentor_help_tickets
	var/list/active_tickets = list()
	var/list/closed_tickets = list()
	var/list/resolved_tickets = list()

	var/obj/effect/statclick/ticket_list/astatclick = new(null, null, MHELP_ACTIVE)
	var/obj/effect/statclick/ticket_list/cstatclick = new(null, null, MHELP_CLOSED)
	var/obj/effect/statclick/ticket_list/rstatclick = new(null, null, MHELP_RESOLVED)

/datum/mentor_help_tickets/Destroy()
	QDEL_LIST(active_tickets)
	QDEL_LIST(closed_tickets)
	QDEL_LIST(resolved_tickets)
	QDEL_NULL(astatclick)
	QDEL_NULL(cstatclick)
	QDEL_NULL(rstatclick)
	return ..()

/datum/mentor_help_tickets/proc/TicketByID(id)
	var/list/lists = list(active_tickets, closed_tickets, resolved_tickets)
	for(var/I in lists)
		for(var/J in I)
			var/datum/mentor_help/MH = J
			if(MH.id == id)
				return J

/datum/mentor_help_tickets/proc/TicketsByCKey(ckey)
	. = list()
	var/list/lists = list(active_tickets, closed_tickets, resolved_tickets)
	for(var/I in lists)
		for(var/J in I)
			var/datum/mentor_help/MH = J
			if(MH.initiator_ckey == ckey)
				. += MH

//private
/datum/mentor_help_tickets/proc/ListInsert(datum/mentor_help/new_ticket)
	var/list/ticket_list
	switch(new_ticket.state)
		if(MHELP_ACTIVE)
			ticket_list = active_tickets
		if(MHELP_CLOSED)
			ticket_list = closed_tickets
		if(MHELP_RESOLVED)
			ticket_list = resolved_tickets
		else
			CRASH("Invalid ticket state: [new_ticket.state]")
	var/num_closed = ticket_list.len
	if(num_closed)
		for(var/I in 1 to num_closed)
			var/datum/mentor_help/MH = ticket_list[I]
			if(MH.id > new_ticket.id)
				ticket_list.Insert(I, new_ticket)
				return
	ticket_list += new_ticket

//opens the ticket listings for one of the 3 states
/datum/mentor_help_tickets/proc/BrowseTickets(state)
	var/list/l2b
	var/title
	switch(state)
		if(MHELP_ACTIVE)
			l2b = active_tickets
			title = "Active Tickets"
		if(MHELP_CLOSED)
			l2b = closed_tickets
			title = "Closed Tickets"
		if(MHELP_RESOLVED)
			l2b = resolved_tickets
			title = "Resolved Tickets"
	if(!l2b)
		return
	var/list/dat = list("<html><head><title>[title]</title></head>")
	dat += "<A href='?_src_=holder;[HrefToken()];mhelp_tickets=[state]'>Refresh</A><br><br>"
	for(var/I in l2b)
		var/datum/mentor_help/MH = I
		dat += "<span class='adminnotice'><span class='mentorhelp'>Ticket #[MH.id]</span>: <A href='?_src_=holder;[HrefToken()];mhelp=\ref[MH];MHELP_action=ticket'>[MH.initiator_key_name]: [MH.name]</A></span><br>"

	usr << browse(dat.Join(), "window=mhelp_list[state];size=600x480")

//Tickets statpanel
/datum/mentor_help_tickets/proc/stat_entry()
	var/num_disconnected = 0
	stat("Active Tickets:", astatclick.update("[active_tickets.len]"))
	for(var/I in active_tickets)
		var/datum/mentor_help/MH = I
		if(MH.initiator)
			stat("#[MH.id]. [MH.initiator_key_name]:", MH.statclick.update())
		else
			++num_disconnected
	if(num_disconnected)
		stat("Disconnected:", astatclick.update("[num_disconnected]"))
	stat("Closed Tickets:", cstatclick.update("[closed_tickets.len]"))
	stat("Resolved Tickets:", rstatclick.update("[resolved_tickets.len]"))

//Reassociate still open ticket if one exists
/datum/mentor_help_tickets/proc/ClientLogin(client/C)
	C.current_mticket = CKey2ActiveTicket(C.ckey)
	if(C.current_mticket)
		C.current_mticket.initiator = C
		C.current_mticket.AddInteraction("Client reconnected.")

//Dissasociate ticket
/datum/mentor_help_tickets/proc/ClientLogout(client/C)
	if(C.current_mticket)
		C.current_mticket.AddInteraction("Client disconnected.")
		C.current_mticket.initiator = null
		C.current_mticket = null

//Get a ticket given a ckey
/datum/mentor_help_tickets/proc/CKey2ActiveTicket(ckey)
	for(var/I in active_tickets)
		var/datum/mentor_help/MH = I
		if(MH.initiator_ckey == ckey)
			return MH

//
//TICKET LIST STATCLICK
//

/obj/effect/statclick/ticket_list
	var/current_mstate

/obj/effect/statclick/ticket_list/New(loc, name, state)
	current_mstate = state
	..()

/obj/effect/statclick/ticket_list/Click()
	GLOB.mhelp_tickets.BrowseTickets(current_mstate)

//
//TICKET DATUM
//

/datum/mentor_help
	var/id
	var/name
	var/state = MHELP_ACTIVE

	var/opened_at
	var/closed_at

	var/client/initiator	//semi-misnomer, it's the person who mhelped/was bwoinked
	var/initiator_ckey
	var/initiator_key_name
	var/heard_by_no_mentors = FALSE

	var/list/_interactions	//use AddInteraction() or, preferably, mentor_ticket_log()

	var/obj/effect/statclick/mhelp/statclick

	var/static/ticket_counter = 0

//call this on its own to create a ticket, don't manually assign current_mticket
//msg is the title of the ticket: usually the mhelp text
//is_bwoink is TRUE if this ticket was started by an mentor PM
/datum/mentor_help/New(msg, client/C, is_bwoink)
	//clean the input msg
	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg || !C || !C.mob)
		qdel(src)
		return

	id = ++ticket_counter
	opened_at = world.time

	name = msg

	initiator = C
	initiator_ckey = initiator.ckey
	initiator_key_name = key_name(initiator, FALSE, TRUE)
	if(initiator.current_mticket)	//This is a bug
		stack_trace("Multiple mhelp current_tickets")
		initiator.current_mticket.AddInteraction("Ticket erroneously left open by code")
		initiator.current_mticket.Close()
	initiator.current_mticket = src

	TimeoutVerb()

	statclick = new(null, src)
	_interactions = list()

	if(is_bwoink)
		AddInteraction("<font color='blue'>[key_name_admin(usr)] PM'd [LinkedReplyName()]</font>")
		message_admins("<font color='blue'>Ticket [TicketHref("#[id]")] created</font>")
	else
		MessageNoRecipient(msg)

		//send it to irc if nobody is on and tell us how many were on
		var/mentor_number_present = send2irc_mentorless_only(initiator_ckey, "Ticket #[id]: [name]")
		log_mentor("Ticket #[id]: [key_name(initiator)]: [name] - heard by [mentor_number_present] non-AFK mentors who have +BAN.")
		if(mentor_number_present <= 0)
			to_chat(C, "<span class='notice'>No active mentors are online, your mentorhelp was sent to the mentor irc.</span>")
			heard_by_no_mentors = TRUE

	GLOB.mhelp_tickets.active_tickets += src

/datum/mentor_help/Destroy()
	RemoveActive()
	GLOB.mhelp_tickets.closed_tickets -= src
	GLOB.mhelp_tickets.resolved_tickets -= src
	return ..()

/datum/mentor_help/proc/AddInteraction(formatted_message)
	if(heard_by_no_mentors && usr && usr.ckey != initiator_ckey)
		heard_by_no_mentors = FALSE
		send2irc(initiator_ckey, "Ticket #[id]: Answered by [key_name(usr)]")
	_interactions += "[gameTimestamp()]: [formatted_message]"

//Removes the mhelp verb and returns it after 2 minutes
/datum/mentor_help/proc/TimeoutVerb()
	initiator.verbs -= /client/verb/mentorhelp
	initiator.mentorhelptimerid = addtimer(CALLBACK(initiator, /client/proc/givementorhelpverb), 1200, TIMER_STOPPABLE) //2 minute cooldown of mentor helps

//private
/datum/mentor_help/proc/FullMontyMentor(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"
	. = ADMIN_FLW(initiator.mob)
	if(state == MHELP_ACTIVE)
		. += ClosureLinks(ref_src)

//private
/datum/mentor_help/proc/ClosureLinks(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"
	. = " (<A HREF='?_src_=holder;[HrefToken(TRUE)];mhelp=[ref_src];mhelp_action=reject'>REJT</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];mhelp=[ref_src];mhelp_action=close'>CLOSE</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];mhelp=[ref_src];mhelp_action=resolve'>RSLVE</A>)"

//private
/datum/mentor_help/proc/LinkedReplyName(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"
	return "<A HREF='?_src_=holder;[HrefToken()];mhelp=[ref_src];mhelp_action=reply'>[initiator_key_name]</A>"

//private
/datum/mentor_help/proc/TicketHref(msg, ref_src, action = "ticket")
	if(!ref_src)
		ref_src = "\ref[src]"
	return "<A HREF='?_src_=holder;[HrefToken()];mhelp=[ref_src];mhelp_action=[action]'>[msg]</A>"

//message from the initiator without a target, all mentors will see this
//won't bug irc
/datum/mentor_help/proc/MessageNoRecipient(msg)
	var/ref_src = "\ref[src]"
	//Message to be sent to all mentors
	var/mentor_msg = "<span class='adminnotice'><span class='adminhelp'>Ticket [TicketHref("#[id]", ref_src)]</span><b>: [LinkedReplyName(ref_src)] [ADMIN_FLW(ref_src)]:</b> [keywords_lookup(msg)]</span>"

	AddInteraction("<font color='red'>[LinkedReplyName(ref_src)]: [msg]</font>")

	//send this msg to all mentors
	for(var/client/X in GLOB.mentors)
		if(X.prefs.toggles & SOUND_MENTORHELP)
			SEND_SOUND(X, sound('sound/effects/-adminhelp.ogg'))
		window_flash(X, ignorepref = TRUE)
		to_chat(X, mentor_msg)

	//show it to the person mentorhelping too
	to_chat(initiator, "<span class='adminnotice'>PM to-<b>Mentors</b>: [msg]</span>")

//Reopen a closed ticket
/datum/mentor_help/proc/Reopen()
	if(state == MHELP_ACTIVE)
		to_chat(usr, "<span class='warning'>This ticket is already open.</span>")
		return

	if(GLOB.mhelp_tickets.CKey2ActiveTicket(initiator_ckey))
		to_chat(usr, "<span class='warning'>This user already has an active ticket, cannot reopen this one.</span>")
		return

	statclick = new(null, src)
	GLOB.mhelp_tickets.active_tickets += src
	GLOB.mhelp_tickets.closed_tickets -= src
	GLOB.mhelp_tickets.resolved_tickets -= src
	switch(state)
		if(MHELP_CLOSED)
			SSblackbox.dec("mhelp_close")
		if(MHELP_RESOLVED)
			SSblackbox.dec("mhelp_resolve")
	state = MHELP_ACTIVE
	closed_at = null
	if(initiator)
		initiator.current_mticket = src

	AddInteraction("<font color='purple'>Reopened by [key_name_admin(usr)]</font>")
	var/msg = "<span class='adminhelp'>Ticket [TicketHref("#[id]")] reopened by [key_name_admin(usr)].</span>"
	to_chat(GLOB.admins, msg)
	log_mentor(msg)
	SSblackbox.inc("mhelp_reopen")
	TicketPanel()	//can only be done from here, so refresh it

//private
/datum/mentor_help/proc/RemoveActive()
	if(state != MHELP_ACTIVE)
		return
	closed_at = world.time
	QDEL_NULL(statclick)
	GLOB.mhelp_tickets.active_tickets -= src
	if(initiator && initiator.current_mticket == src)
		initiator.current_mticket = null

//Mark open ticket as closed/meme
/datum/mentor_help/proc/Close(key_name = key_name_admin(usr), silent = FALSE)
	if(state != MHELP_ACTIVE)
		return
	RemoveActive()
	state = MHELP_CLOSED
	GLOB.mhelp_tickets.ListInsert(src)
	AddInteraction("<font color='red'>Closed by [key_name].</font>")
	if(!silent)
		SSblackbox.inc("mhelp_close")
		var/msg = "Ticket [TicketHref("#[id]")] closed by [key_name]."
		to_chat(GLOB.admins, msg)
		log_mentor(msg)

//Mark open ticket as resolved/legitimate, returns mhelp verb
/datum/mentor_help/proc/Resolve(key_name = key_name_admin(usr), silent = FALSE)
	if(state != MHELP_ACTIVE)
		return
	RemoveActive()
	state = MHELP_RESOLVED
	GLOB.mhelp_tickets.ListInsert(src)

	addtimer(CALLBACK(initiator, /client/proc/givementorhelpverb), 50)

	AddInteraction("<font color='green'>Resolved by [key_name].</font>")
	if(!silent)
		SSblackbox.inc("mhelp_resolve")
		var/msg = "Ticket [TicketHref("#[id]")] resolved by [key_name]"
		to_chat(GLOB.admins, msg)
		log_mentor(msg)

//Close and return mhelp verb, use if ticket is incoherent
/datum/mentor_help/proc/Reject(key_name = key_name_admin(usr))
	if(state != MHELP_ACTIVE)
		return

	if(initiator)
		initiator.givementorhelpverb()

		SEND_SOUND(initiator, sound('sound/effects/adminhelp.ogg'))

		to_chat(initiator, "<font color='red' size='4'><b>- Mentor Help request Rejected! -</b></font>")
		to_chat(initiator, "<font color='red'><b>Your mentor request was rejected.</b> The mentor help has been returned to you so that you may try again.</font>")
		to_chat(initiator, "Mentor helps are for serious requests for assistance.")

	SSblackbox.inc("mhelp_reject")
	var/msg = "Ticket [TicketHref("#[id]")] rejected by [key_name]"
	to_chat(GLOB.admins, msg)
	log_mentor(msg)
	AddInteraction("Rejected by [key_name].")
	Close(silent = TRUE)

//Show the ticket panel
/datum/mentor_help/proc/TicketPanel()
	var/list/dat = list("<html><head><title>Ticket #[id]</title></head>")
	var/ref_src = "\ref[src]"
	dat += "<h4>mentor Help Ticket #[id]: [LinkedReplyName(ref_src)]</h4>"
	dat += "<b>State: "
	switch(state)
		if(MHELP_ACTIVE)
			dat += "<font color='red'>OPEN</font>"
		if(MHELP_RESOLVED)
			dat += "<font color='green'>RESOLVED</font>"
		if(MHELP_CLOSED)
			dat += "CLOSED"
		else
			dat += "UNKNOWN"
	dat += "</b>[GLOB.TAB][TicketHref("Refresh", ref_src)][GLOB.TAB][TicketHref("Re-Title", ref_src, "retitle")]"
	if(state != MHELP_ACTIVE)
		dat += "[GLOB.TAB][TicketHref("Reopen", ref_src, "reopen")]"
	dat += "<br><br>Opened at: [gameTimestamp(wtime = opened_at)] (Approx [(world.time - opened_at) / 600] minutes ago)"
	if(closed_at)
		dat += "<br>Closed at: [gameTimestamp(wtime = closed_at)] (Approx [(world.time - closed_at) / 600] minutes ago)"
	dat += "<br><br>"
	if(initiator)
		dat += "<b>Actions:</b> [ADMIN_FLW(ref_src)]<br>"
	else
		dat += "<b>DISCONNECTED</b>[GLOB.TAB][ClosureLinks(ref_src)]<br>"
	dat += "<br><b>Log:</b><br><br>"
	for(var/I in _interactions)
		dat += "[I]<br>"

	usr << browse(dat.Join(), "window=mhelp[id];size=620x480")

/datum/mentor_help/proc/Retitle()
	var/new_title = input(usr, "Enter a title for the ticket", "Rename Ticket", name) as text|null
	if(new_title)
		name = new_title
		//not saying the original name cause it could be a long ass message
		var/msg = "Ticket [TicketHref("#[id]")] titled [name] by [key_name_admin(usr)]"
		to_chat(GLOB.admins, msg)
		log_mentor(msg)
	TicketPanel()	//we have to be here to do this

//Forwarded action from mentor/Topic
/datum/mentor_help/proc/Action(action)
	testing("mhelp action: [action]")
	switch(action)
		if("ticket")
			TicketPanel()
		if("retitle")
			Retitle()
		if("reject")
			Reject()
		if("reply")
			usr.client.cmd_mhelp_reply(initiator)
		if("close")
			Close()
		if("resolve")
			Resolve()
		if("reopen")
			Reopen()

//
// TICKET STATCLICK
//

/obj/effect/statclick/mhelp
	var/datum/mentor_help/mhelp_datum

/obj/effect/statclick/mhelp/Initialize(mapload, datum/mentor_help/MH)
	mhelp_datum = MH
	. = ..()

/obj/effect/statclick/mhelp/update()
	return ..(mhelp_datum.name)

/obj/effect/statclick/mhelp/Click()
	mhelp_datum.TicketPanel()

/obj/effect/statclick/mhelp/Destroy()
	mhelp_datum = null
	return ..()

//
// CLIENT PROCS
//

/client/proc/givementorhelpverb()
	src.verbs |= /client/verb/mentorhelp
	deltimer(mentorhelptimerid)
	mentorhelptimerid = 0

/client/verb/mentorhelp(msg as text)
	set category = "Mentor"
	set name = "mentorhelp"

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_MENTORHELP)
		to_chat(src, "<span class='danger'>Error: mentor-PM: You cannot send mentor requests (Muted).</span>")
		return
	if(handle_spam_prevention(msg,MUTE_MENTORHELP))
		return

	if(!msg)
		return

	SSblackbox.add_details("mentor_verb","mentorhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(current_mticket)
		if(alert(usr, "You already have a ticket open. Is this for the same issue?",,"Yes","No") != "No")
			if(current_mticket)
				current_mticket.MessageNoRecipient(msg)
				current_mticket.TimeoutVerb()
				return
			else
				to_chat(usr, "<span class='warning'>Ticket not found, creating new one...</span>")
		else
			current_mticket.AddInteraction("[key_name_admin(usr)] opened a new ticket.")
			current_mticket.Close()

	new /datum/mentor_help(msg, src, FALSE)

//mentor proc
/client/proc/cmd_mentor_ticket_panel()
	set name = "Show Ticket List"
	set category = "Mentor"

	if(!check_rights(R_MENTOR, TRUE))
		return

	var/browse_to

	switch(input("Display which ticket list?") as null|anything in list("Active Tickets", "Closed Tickets", "Resolved Tickets"))
		if("Active Tickets")
			browse_to = MHELP_ACTIVE
		if("Closed Tickets")
			browse_to = MHELP_CLOSED
		if("Resolved Tickets")
			browse_to = MHELP_RESOLVED
		else
			return

	GLOB.mhelp_tickets.BrowseTickets(browse_to)

//
// LOGGING
//

//Use this proc when an mentor takes action that may be related to an open ticket on what
//what can be a client, ckey, or mob
/proc/mentor_ticket_log(what, message)
	var/client/C
	var/mob/Mob = what
	if(istype(Mob))
		C = Mob.client
	else
		C = what
	if(istype(C) && C.current_mticket)
		C.current_mticket.AddInteraction(message)
		return C.current_mticket
	if(istext(what))	//ckey
		var/datum/mentor_help/MH = GLOB.mhelp_tickets.CKey2ActiveTicket(what)
		if(MH)
			MH.AddInteraction(message)
			return MH

//
// HELPER PROCS
//

/proc/get_mentor_counts(requiredflags = R_BAN)
	. = list("total" = list(), "noflags" = list(), "afk" = list(), "stealth" = list(), "present" = list())
	for(var/client/X in GLOB.mentors)
		.["total"] += X
		if(requiredflags != 0 && !check_rights_for(X, requiredflags))
			.["noflags"] += X
		else if(X.is_afk())
			.["afk"] += X
		else if(X.holder.fakekey)
			.["stealth"] += X
		else
			.["present"] += X

/proc/send2irc_mentorless_only(source, msg, requiredflags = R_BAN)
	var/list/ments = get_mentor_counts(requiredflags)
	var/list/activements = ments["present"]
	. = activements.len
	if(. <= 0)
		var/final = ""
		var/list/afkments = ments["afk"]
		var/list/allments = ments["total"]
		if(!afkments.len)
			final = "[msg] - No mentors online"
		else
			final = "[msg] - All mentors are AFK\[[english_list(afkments)]\]! Total: [allments.len] "
		send2irc(source,final)
		send2otherserver(source,final)

/*
/proc/send2irc(msg,msg2)
	if(world.RunningService())
		world.ExportService("[SERVICE_REQUEST_IRC_ADMIN_CHANNEL_MESSAGE] [msg] | [msg2]")
	else if(config.useircbot)
		shell("python nudge.py [msg] [msg2]") */

/proc/ircmentorwho()
	var/list/message = list("mentors: ")
	var/list/mentor_keys = list()
	for(var/ment in GLOB.mentors)
		var/client/C = ment
		mentor_keys += "[C.is_afk() ? "(AFK)" : ""]"

	for(var/mentor in mentor_keys)
		if(LAZYLEN(message) > 1)
			message += ", [mentor]"
		else
			message += "[mentor]"

	return jointext(message, "")
