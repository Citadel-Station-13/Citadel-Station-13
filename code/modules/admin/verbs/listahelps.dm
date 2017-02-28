/datum/adminticket
	var/active = TICKET_INACTIVE		//Is the adminhelp active, eg admin responded?
	var/admin = TICKET_UNASSIGNED		//The handling admin? Like come on.
	var/id = "" 						//ID of the ticket, very important as its used to find adminhelps.
	var/ticket_logs = list() 					//The logs of the adminhelp.
	var/mob								//The mob adminhelping mob.
	var/msg	= "" 						//The adminhelp message.
	var/permckey = "" 					//The perm ckey, never removed essentially.
	var/permuser = "" 					//Same as above!
	var/replying = TICKET_UNREPLIED 	//Is someone responding to the adminhelp?
	var/resolved = TICKET_UNRESOLVED 	//Is it resolved? Its much easier to have a "Yes" or a "No", as you can directly concat it into strings making life that much easier.
	var/uckey 							//The saved ckey of the adminhelping user.
	var/uID = ""						//The UNIQUE id, made by putting part of the ckey and the ID together. Used internally in code.
	var/user = "" 						//The user of the ahelp.


/client/proc/list_ahelps(user, resolved)
	if(!check_rights(R_ADMIN))
		src << "<font color='red'>Error: Only administrators may use this command.</font>"
		return

	for(var/I in admintickets)
		var/datum/adminticket/T = I

		if(resolved)
			user << "Resolved Ahelps:"
			usr << "<span class='adminnotice'><b><font color='red'>#[T.id] By:</font> <A HREF='?priv_msg=[T.permckey];ahelp_reply=1'>[key_name(T.permuser)]</A></b><b> Ckey:</b> [T.permckey] <b>Name:</b> [T.permuser] <b>Unique id:</b> [T.uID]</span>"
			usr << "	<b>Controls:</b> [ADMIN_QUE(mob)] [ADMIN_PP(mob)] [ADMIN_VV(mob)] [ADMIN_SM(mob)] [ADMIN_FLW(mob)] [ADMIN_TP(mob)]"
			usr << "	<b>Message:</b> [T.msg]"
			usr << "	<b>Handling Admin:</b> [T.admin]"
			usr << "	<b>Replied To:</b> [T.active]/<b><a href='?src=\ref[T];view_logs=\ref[T]'>(LOGS)</a></b>"
			if(T.resolved == TICKET_UNRESOLVED)
				usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Resolve)</a>"
			else
				usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Unresolve)</a>"

		else
			user << "Current Unresolved Ahelps:"
			if(T.resolved == TICKET_UNRESOLVED)
				usr << "<span class='adminnotice'><b><font color=red>#[T.id] By:</font> <A HREF='?priv_msg=[T.permckey];ahelp_reply=1'>[key_name(T.permuser)]</A></b><b> Ckey:</b> [T.permckey] <b>Name:</b> [T.permuser] <b>Unique ID:</b> [T.uID]</span>"
				usr << "	<b>Controls:</b> [ADMIN_QUE(mob)] [ADMIN_PP(mob)] [ADMIN_VV(mob)] [ADMIN_SM(mob)] [ADMIN_FLW(mob)] [ADMIN_TP(mob)]"
				usr << "	<b>Message:</b> [T.msg]"
				usr << "	<b>Handling Admin:</b> [T.admin]"
				usr << "	<b>Replied To:</b> [T.active]/<b><a href='?src=\ref[T];view_logs=\ref[T]'>(LOGS)</a></b>"
				if(T.resolved == TICKET_UNRESOLVED)
					usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Resolve)</a>"
				else
					usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Unresolve)</a>"

/client/proc/ahelp_count(modifier)
	var/amount
	for(var/I in admintickets)
		var/datum/adminticket/T = I
		if(T.resolved == TICKET_UNRESOLVED)
			amount++
		if(T.resolved == TICKET_RESOLVED)
			amount++
	return amount


/datum/adminticket/proc/listtickets()
	set category = "Admin Help"
	set name = "List Adminhelps"
	set desc = "List all current adminhelps"

	if(!check_rights(R_ADMIN))
		src << "<font color='red'>Error: Only administrators may use this command.</font>"
		return

	var/count = 0

	for(var/datum/adminticket/T in admintickets)
		count++

	usr << "<b>Current Ahelps:</b>"

	if(count < 1)
		usr << "	None"
		return
	for(var/I in admintickets)
		var/datum/adminticket/T = I
		usr << "<span class='adminnotice'><b><font color=red>#[T.id] By:</font> <A HREF='?priv_msg=[T.permckey];ahelp_reply=1'>[key_name(T.permuser)]</b></A><b> Ckey:</b> [T.permckey] <b>Name:</b> [T.permuser] <b>Unique ID:</b> [T.uID]</span>"
		usr << "	<b>Controls:</b> [ADMIN_QUE(mob)] [ADMIN_PP(mob)] [ADMIN_VV(mob)] [ADMIN_SM(mob)] [ADMIN_FLW(mob)] [ADMIN_TP(mob)]"
		usr << "	<b>Message:</b> [T.msg]"
		usr << "	<b>Handling Admin:</b> [T.admin]"
		usr << "	<b>Replied To:</b> [T.active]/<b><a href='?src=\ref[T];view_logs=\ref[T]'>(LOGS)</a></b>"
		if(T.resolved == TICKET_UNRESOLVED)
			usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Resolve)</a>"
		else
			usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Unresolve)</a>"

/datum/adminticket/proc/listunresolvedtickets()
	set category = "Admin Help"
	set name = "List Unresolved Adminhelps"
	set desc = "List all current unresolved adminhelps"

	if(!check_rights(R_ADMIN))
		src << "<font color='red'>Error: Only administrators may use this command.</font>"
		return

	var/count = 0

	for(var/I in admintickets)
		var/datum/adminticket/T = I
		if(T.resolved == TICKET_UNRESOLVED)
			count++

	usr << "<b>Current Unresolved Ahelps:</b>"

	if(count < 1)
		usr << "	None"
		return

	for(var/I in admintickets)
		var/datum/adminticket/T = I
		if(T.resolved == TICKET_UNRESOLVED)
			usr << "<span class='adminnotice'><b><font color=red>#[T.id] By:</font> <A HREF='?priv_msg=[T.permckey];ahelp_reply=1'>[key_name(T.permuser)]</b></A><b> Ckey:</b> [T.permckey] <b>Name:</b> [T.permuser] <b>Unique ID:</b> [T.uID]</span>"
			usr << "	<b>Controls:</b> [ADMIN_QUE(mob)] [ADMIN_PP(mob)] [ADMIN_VV(mob)] [ADMIN_SM(mob)] [ADMIN_FLW(mob)] [ADMIN_TP(mob)]"
			usr << "	<b>Message:</b> [T.msg]"
			usr << "	<b>Handling Admin:</b> [T.admin]"
			usr << "	<b>Replied To:</b> [T.active]/<b><a href='?src=\ref[T];view_logs=\ref[T]'>(LOGS)</a></b>"
			if(T.resolved == TICKET_UNRESOLVED)
				usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Resolve)</a>"
			else
				usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Unresolve)</a>"

/client/proc/listhandlingahelp()
	set category = "Admin Help"
	set name = "View Handling Ahelps"
	set desc = "List all current handling ahelps"

	if(!check_rights(R_ADMIN))
		src << "<font color='red'>Error: Only administrators may use this command.</font>"
		return

	var/count = 0

	for(var/I in admintickets)
		var/datum/adminticket/T = I
		if(T.resolved == TICKET_UNRESOLVED && T.admin == ckey)
			count++

	if(count < 1)
		usr << "<b>You don't have any ACTIVE ahelps!</b>"
		return
	for(var/I in admintickets)
		var/datum/adminticket/T = I
		if(T.resolved == TICKET_UNRESOLVED && T.admin == ckey)
			usr << "<span class='adminnotice'><b><font color=red>#[T.id] By:</font> <A HREF='?priv_msg=[T.permckey];ahelp_reply=1'>[key_name(T.permuser)]</A></b><b> Ckey:</b> [T.permckey] <b>Name:</b> [T.permuser] <b>Unique ID:</b> [T.uID]</span>"
			usr << "	<b>Controls:</b> [ADMIN_QUE(mob)] [ADMIN_PP(mob)] [ADMIN_VV(mob)] [ADMIN_SM(mob)] [ADMIN_FLW(mob)] [ADMIN_TP(mob)]"
			usr << "	<b>Message:</b> [T.msg]"
			usr << "	<b>Handling Admin:</b> [T.admin]"
			usr << "	<b>Replied To:</b> [T.active]/<b><a href='?src=\ref[T];view_logs=\ref[T]'>(LOGS)</a></b>"
			if(T.resolved == TICKET_UNRESOLVED)
				usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Resolve)</a>"
			else
				usr << "	<b>Resolved:</b> [T.resolved] <a href='?src=\ref[T];resolve=\ref[T]'>(Unresolve)</a>"

/client/verb/viewmyahelp()
	set category = "Admin"
	set name = "View my Ahelps"
	set desc = "List your ahelps"

	var/count = 0

	for(var/I in admintickets)
		var/datum/adminticket/T = I
		if(T.permckey == ckey)
			count++

	if(count < 1)
		usr << "<b>You don't have any ahelps!</b>"
		return

	usr << "<b>Resolved Ahelps</b>"

	var/rpass = FALSE

	for(var/I in admintickets)
		var/datum/adminticket/T = I

		if(T.permckey == ckey && T.resolved == TICKET_RESOLVED)
			rpass = TRUE
			usr << "<span class='adminnotice'><b><font color=red>Adminhelp ID: #[T.id] </font></b></span>"
			usr << "	<b>Message:</b> [T.msg]"
			usr << "	<b>Handling Admin:</b> [T.admin]"
			usr << "	<b>Replied To:</b> [T.active]/<b><a href='?src=\ref[T];view_logs=\ref[T]'>(LOGS)</a></b>"
			usr << "	<b>Resolved:</b> [T.resolved]"

	if(rpass == FALSE)
		usr << "	None"

	usr << "<b>Unresolved Ahelps</b>"

	var/upass = FALSE

	for(var/I in admintickets)
		var/datum/adminticket/T = I
		if(T.permckey == ckey && T.resolved == TICKET_UNRESOLVED)
			upass = TRUE
			usr << "<span class='adminnotice'><b><font color=red>Adminhelp ID: #[T.id] </font></b></span>"
			usr << "	<b>Message:</b> [T.msg]"
			usr << "	<b>Handling Admin:</b> [T.admin]"
			usr << "	<b>Replied To:</b> [T.active]/<b><a href='?src=\ref[T];view_logs=\ref[T]'>(LOGS)</a></b>"
			usr << "	<b>Resolved:</b> [T.resolved]"

	if(upass == FALSE)
		usr << "	None"

/client/proc/createticket(player, message, uckey, mob)
	var/datum/adminticket/A = new()
	A.user = player
	A.msg = message
	A.uckey = uckey
	A.permckey = uckey
	A.permuser = A.user
	admintickets += A
	A.ticket_logs += "<b>ADMINHELP:</b> [A.permckey]([A.permuser]): [A.msg]"
	A.mob = mob

	var/index = 0
	for(var/I in admintickets)
		var/datum/adminticket/T = I
		index++
		T.id = index
		T.uID = "[T.permckey][T.id]"

/client/verb/resolveticketself()
	set category = "Admin"
	set name = "Resolve My Adminhelp"
	set desc = "Resolve my own adminhelp"

	var/pass = FALSE
	var/datum/adminticket/ticket
	for(var/I in admintickets)
		var/datum/adminticket/T = I
		if(T.permckey == ckey && T.resolved != TICKET_RESOLVED)
			T.resolved = TICKET_RESOLVED
			pass = TRUE

	switch(pass)
		if(TRUE)
			src << "<b>You have resolved your current adminhelp.</b>"
			message_admins("[src] has resolved his adminhelp (#[ticket.id])")
		if(FALSE)
			src << "<b>Error, you do not have any active adminhelps.</b>"

/client/proc/resolvehandlingahelp()
	set category = "Admin Help"
	set name = "Resolve Handling Ahelp"
	set desc = "Resolve my own adminhelp"

	if(!check_rights(R_ADMIN))
		src << "<font color='red'>Error: Only administrators may use this command.</font>"
		return

	var/count = 0

	var/datum/adminticket/ticket
	for(var/I in admintickets)
		var/datum/adminticket/T = I
		if(T.admin == ckey && T.resolved != TICKET_RESOLVED)
			count++

		if(count >= 1)
			usr << "<b>Adminhelp #[T.id]([T.uID]) resolved.</b>"
			message_admins("Adminhelp ID: #[T.id]([T.uID]) was resolved by [usr.ckey]")
			ticket.user << "<b>Your adminhelp (#[T.id]) has been resolved by [usr.ckey]</b>"
			ticket.user << 'sound/machines/twobeep.ogg'
			ticket.resolved = TICKET_RESOLVED

		if(count < 1)
			usr << "<b>You are not currently handling any adminhelps!</b>"

/datum/adminticket/proc/viewlogs(NuID, mob/user)
	var/dat = "<h3>View Logs for ahelp [NuID]</h3>"
	var/datum/adminticket/ticket

	var/pass = FALSE

	for(var/I in admintickets)
		var/datum/adminticket/T = I
		if(NuID == T.uID)
			pass = TRUE

	if(pass == FALSE)
		src << "Error, log system not found for [NuID]... "
		return

	dat += "<table>"
	for(var/text in ticket.ticket_logs)
		dat += "<tr><td>[text]</td></tr>"
	dat += "</table>"

	var/datum/browser/popup = new(user, "ahelp logs", ticket.permuser, 500, 500)
	popup.set_content(dat)
	popup.open()

/datum/adminticket/Topic(href, href_list)
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		usr << "Error: you are not an admin!"
		return

	if(href_list["view_logs"])
		var/datum/adminticket/T = locate(href_list["view_logs"])
		viewlogs(T.uID, usr)
	if(href_list["resolve"])
		var/datum/adminticket/T = locate(href_list["resolve"]) in admintickets
		if(T && istype(T))
			message_admins("Adminhelp ID: #[T.id]([T.uID]) was [T.resolved == "Yes" ? "unresolved" : "resolved"] by [usr.ckey]")
			T.user << "<b>Your adminhelp (#[T.id]) has been [T.resolved == "Yes" ? "unresolved" : "resolved"] by [usr.ckey]</b>"
			T.user << 'sound/machines/twobeep.ogg'
			T.resolved = "[T.resolved == "Yes" ? "No" : "Yes"]"