/proc/keywords_lookup(msg,irc)

	//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
	var/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as", "i")

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	//generate keywords lookup
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()
	var/founds = ""
	for(var/mob/M in mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)	indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=L.len, i>=1, i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i=1, i<surname_found, i++)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	var/ai_found = 0
	msg = ""
	var/list/mobs_found = list()
	for(var/original_word in msglist)
		var/word = ckey(original_word)
		if(word)
			if(!(word in adminhelp_ignored_words))
				if(word == "ai")
					ai_found = 1
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							if(!ai_found && isAI(found))
								ai_found = 1
							var/is_antag = 0
							if(found.mind && found.mind.special_role)
								is_antag = 1
							founds += "Name: [found.name]([found.real_name]) Ckey: [found.ckey] [is_antag ? "(Antag)" : null] "
							msg += "[original_word]<font size='1' color='[is_antag ? "red" : "black"]'>(<A HREF='?_src_=holder;adminmoreinfo=\ref[found]'>?</A>|<A HREF='?_src_=holder;adminplayerobservefollow=\ref[found]'>F</A>)</font> "
							continue
		msg += "[original_word] "
	if(irc)
		if(founds == "")
			return "Search Failed"
		else
			return founds

	return msg


/client/var/adminhelptimerid = 0

/client/proc/giveadminhelpverb()
	src.verbs |= /client/verb/adminhelp
	adminhelptimerid = 0

/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "<span class='danger'>Speech is currently admin-disabled.</span>"
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		src << "<span class='danger'>Error: Admin-PM: You cannot send adminhelps (Muted).</span>"
		return
	if(src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return
	var/ref_mob = "\ref[mob]"
	for(var/datum/adminticket/T in admintickets)
		if(T.permckey == src.ckey && T.resolved == "No")
			if(alert(usr,"You already have an adminhelp open, would you like to bump it?", "Bump Adminhelp", "Yes", "No") == "Yes")
				T.logs += "[src.ckey] has bumped this adminhelp!"
				if(T.admin == "N/A")
					usr << "<b>Due to the fact your Adminhelp had no assigned admin, admins have been pinged.</b>"
					message_admins("[src.ckey] has bumped their adminhelp #[T.ID], still no assigned admin!")
					msg = "<span class='adminnotice'><b><font color=red>ADMINHELP: </font><A HREF='?priv_msg=[ckey];ahelp_reply=1'>[key_name(src)]</A> (<A HREF='?_src_=holder;adminmoreinfo=[ref_mob]'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=[ref_mob]'>PP</A>) (<A HREF='?_src_=vars;Vars=[ref_mob]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=[ref_mob]'>SM</A>) (<A HREF='?_src_=holder;traitor=[ref_mob]'>TP</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=[ref_mob]'>FLW</A>) (<a href='?src=\ref[T];resolve=\ref[T]'>R</a>):</b> [T.msg]</span>"
					for(var/client/X in admins)
						if(X.prefs.toggles & SOUND_ADMINHELP)
							X << 'sound/effects/adminhelp.ogg'
						X << msg
				else
					usr << "<b>Admins have been notified.</b>"
					message_admins("[src.ckey] has bumped their adminhelp #[T.ID].")
				src.verbs -= /client/verb/adminhelp
				adminhelptimerid = addtimer(src,"giveadminhelpverb",1200, FALSE)
				return
			usr << "<b>Thank you for your patience.</b>"
			return

	src.verbs -= /client/verb/adminhelp
	adminhelptimerid = addtimer(CALLBACK(src, .proc/giveadminhelpverb), 1200)

	//clean the input msg
	if(!msg)
		return
	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg)	return
	var/original_msg = msg

	//remove our adminhelp verb temporarily to prevent spamming of admins.
	src.verbs -= /client/verb/adminhelp
	adminhelptimerid = addtimer(CALLBACK(src, .proc/giveadminhelpverb), 1200) //2 minute cooldown of admin helps

	createticket(src, msg, src.ckey, mob)

	var/datum/adminticket/ticket

	if(!mob)
		return						//this doesn't happen

	var/ref_mob = "\ref[mob]"
	var/ref_client = "\ref[src]"
	msg = "<span class='adminnotice'><b><font color=red>HELP: </font><A HREF='?priv_msg=[ckey];ahelp_reply=1'>[key_name(src)]</A> (<A HREF='?_src_=holder;adminmoreinfo=[ref_mob]'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=[ref_mob]'>PP</A>) (<A HREF='?_src_=vars;Vars=[ref_mob]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=[ref_mob]'>SM</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=[ref_mob]'>FLW</A>) (<A HREF='?_src_=holder;traitor=[ref_mob]'>TP</A>) (<A HREF='?_src_=holder;rejectadminhelp=[ref_client]'>REJT</A>):</b> [msg]</span>"


	//send this msg to all admins

	for(var/client/X in admins)
		if(X.prefs.toggles & SOUND_ADMINHELP)
			X << 'sound/effects/adminhelp.ogg'
		window_flash(X)
		X << msg


	//show it to the person adminhelping too
	src << "<span class='adminnotice'>PM to-<b>Admins</b>: [original_msg]</span>"

	//send it to irc if nobody is on and tell us how many were on
	var/admin_number_present = send2irc_admin_notice_handler("adminhelp", ckey, original_msg)
	log_admin("ADMINHELP: [key_name(src)]: [original_msg] - heard by [admin_number_present] non-AFK admins who have +BAN.")
	feedback_add_details("admin_verb","AH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/proc/calculate_admins(type, requiredflags = R_BAN)
	var/admin_number_total = 0		//Total number of admins
	var/admin_number_afk = 0		//Holds the number of admins who are afk
	var/admin_number_ignored = 0	//Holds the number of admins without +BAN (so admins who are not really admins)
	var/admin_number_decrease = 0	//Holds the number of admins with are afk, ignored or both
	for(var/client/X in admins)
		admin_number_total++;
		var/invalid = 0
		if(requiredflags != 0 && !check_rights_for(X, requiredflags))
			admin_number_ignored++
			invalid = 1
		if(X.is_afk())
			admin_number_afk++
			invalid = 1
		if(X.holder.fakekey)
			admin_number_ignored++
			invalid = 1
		if(invalid)
			admin_number_decrease++
	switch(type)
		if("ignored")
			return admin_number_ignored
		if("total")
			return admin_number_total
		if("away")
			return admin_number_afk
		if("present")
			return admin_number_total - admin_number_decrease
	return 0


/proc/send2irc_admin_notice_handler(type, source, msg)
	var/afk_admins = calculate_admins("away")
	var/total_admins = calculate_admins("total")
	var/ignored_admins = calculate_admins("ignored")
	var/admin_number_present = calculate_admins("present")	//Number of admins who are neither afk nor invalid
	var/irc_message_afk = "[msg] - All admins AFK ([afk_admins]/[total_admins]) or skipped ([ignored_admins]/[total_admins])"
	var/irc_message_normal = "[msg] - heard by [admin_number_present] non-AFK admins who have +BAN."
	var/irc_message_adminless = "[msg] - No admins online"

	switch(type)
		if("adminhelp")
			if(config.announce_adminhelps)
				send2irc(source, irc_message_normal)
			else
				if(admin_number_present <= 0)
					if(!afk_admins && !ignored_admins)
						send2irc(source, irc_message_adminless)
						send2admindiscord(source, irc_message_adminless)
					else if(afk_admins >= 1)
						send2irc(source, irc_message_afk)
						send2admindiscord(source, irc_message_afk)
					else
						send2irc(source, irc_message_normal)
						send2admindiscord(source, irc_message_normal)
		if("watchlist")
			if(config.announce_watchlist)
				send2irc(source, irc_message_normal)
			else
				if(admin_number_present <= 0)
					if(!afk_admins && !ignored_admins)
						send2irc(source, irc_message_adminless)
						send2admindiscord(source, irc_message_adminless)
					else if(afk_admins >= 1)
						send2irc(source, irc_message_afk)
						send2admindiscord(source, irc_message_afk)
					else
						send2irc(source, irc_message_normal)
						send2admindiscord(source, irc_message_normal)
			return admin_number_present

/proc/send2irc(msg,msg2)
	if(config.useircbot)
		shell("python nudge.py [msg] \"[msg2]\"")
	return