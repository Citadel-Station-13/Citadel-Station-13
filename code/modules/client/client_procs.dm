	////////////
	//SECURITY//
	////////////
#define UPLOAD_LIMIT		1048576	//Restricts client uploads to the server to 1MB //Could probably do with being lower.

#define LIMITER_SIZE	5
#define CURRENT_SECOND	1
#define SECOND_COUNT	2
#define CURRENT_MINUTE	3
#define MINUTE_COUNT	4
#define ADMINSWARNED_AT	5
	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/

/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	// asset_cache
	if(href_list["asset_cache_confirm_arrival"])
		//to_chat(src, "ASSET JOB [href_list["asset_cache_confirm_arrival"]] ARRIVED.")
		var/job = text2num(href_list["asset_cache_confirm_arrival"])
		//because we skip the limiter, we have to make sure this is a valid arrival and not somebody tricking us
		//	into letting append to a list without limit.
		if (job && job <= last_asset_job && !(job in completed_asset_jobs))
			completed_asset_jobs += job
			return

	if (!holder && config.minutetopiclimit)
		var/minute = round(world.time, 600)
		if (!topiclimiter)
			topiclimiter = new(LIMITER_SIZE)
		if (minute != topiclimiter[CURRENT_MINUTE])
			topiclimiter[CURRENT_MINUTE] = minute
			topiclimiter[MINUTE_COUNT] = 0
		topiclimiter[MINUTE_COUNT] += 1
		if (topiclimiter[MINUTE_COUNT] > config.minutetopiclimit)
			var/msg = "Your previous action was ignored because you've done too many in a minute."
			if (minute != topiclimiter[ADMINSWARNED_AT]) //only one admin message per-minute. (if they spam the admins can just boot/ban them)
				topiclimiter[ADMINSWARNED_AT] = minute
				msg += " Administrators have been informed."
				log_game("[key_name(src)] Has hit the per-minute topic limit of [config.minutetopiclimit] topic calls in a given game minute")
				message_admins("[key_name_admin(src)] [ADMIN_FLW(usr)] [ADMIN_KICK(usr)] Has hit the per-minute topic limit of [config.minutetopiclimit] topic calls in a given game minute")
			to_chat(src, "<span class='danger'>[msg]</span>")
			return

	if (!holder && config.secondtopiclimit)
		var/second = round(world.time, 10)
		if (!topiclimiter)
			topiclimiter = new(LIMITER_SIZE)
		if (second != topiclimiter[CURRENT_SECOND])
			topiclimiter[CURRENT_SECOND] = second
			topiclimiter[SECOND_COUNT] = 0
		topiclimiter[SECOND_COUNT] += 1
		if (topiclimiter[SECOND_COUNT] > config.secondtopiclimit)
			to_chat(src, "<span class='danger'>Your previous action was ignored because you've done too many in a second</span>")
			return

/*
	if(href_list["mentor_msg"])
		if(config.mentors_mobname_only)
			var/mob/M = locate(href_list["mentor_msg"])
			cmd_mentor_pm(M,null)
		else
			cmd_mentor_pm(href_list["mentor_msg"],null)
		return
*/

	//Logs all hrefs
	if(config && config.log_hrefs && GLOB.href_logfile)
		GLOB.href_logfile << "<small>[time_stamp(show_ds = TRUE)] [src] (usr:[usr])</small> || [hsrc ? "[hsrc] " : ""][href]<br>"

	// Admin PM
	if(href_list["priv_msg"])
		cmd_admin_pm(href_list["priv_msg"],null)
		return

	switch(href_list["_src_"])
		if("holder")
			hsrc = holder
		if("usr")
			hsrc = mob
		if("prefs")
			if (inprefs)
				return
			inprefs = TRUE
			. = prefs.process_link(usr,href_list)
			inprefs = FALSE
			return
		if("vars")
			return view_var_Topic(href,href_list,hsrc)

	..()	//redirect to hsrc.Topic()

/client/proc/is_content_unlocked()
	if(!prefs.unlock_content)
		to_chat(src, "Become a BYOND member to access member-perks and features, as well as support the engine that makes this game possible. Only 10 bucks for 3 months! <a href='http://www.byond.com/membership'>Click Here to find out more</a>.")
		return 0
	return 1

/client/proc/handle_spam_prevention(message, mute_type)
	if(config.automute_on && !holder && src.last_message == message)
		src.last_message_count++
		if(src.last_message_count >= SPAM_TRIGGER_AUTOMUTE)
			to_chat(src, "<span class='danger'>You have exceeded the spam filter limit for identical messages. An auto-mute was applied.</span>")
			cmd_admin_mute(src, mute_type, 1)
			return 1
		if(src.last_message_count >= SPAM_TRIGGER_WARNING)
			to_chat(src, "<span class='danger'>You are nearing the spam filter limit for identical messages.</span>")
			return 0
	else
		last_message = message
		src.last_message_count = 0
		return 0

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		to_chat(src, "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>")
		return 0
/*	//Don't need this at the moment. But it's here if it's needed later.
	//Helps prevent multiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait [round(time_to_wait/10)] seconds.</font>")
		return 0
	fileaccess_timer = world.time + FTPDELAY	*/
	return 1


	///////////
	//CONNECT//
	///////////
#if (PRELOAD_RSC == 0)
GLOBAL_LIST(external_rsc_urls)
#endif


/client/New(TopicData)
	var/tdata = TopicData //save this for later use
	TopicData = null							//Prevent calls to client.Topic from connect

	if(connection != "seeker" && connection != "web")//Invalid connection type.
		return null

#if (PRELOAD_RSC == 0)
	var/static/next_external_rsc = 0
	if(external_rsc_urls && external_rsc_urls.len)
		next_external_rsc = Wrap(next_external_rsc+1, 1, external_rsc_urls.len+1)
		preload_rsc = external_rsc_urls[next_external_rsc]
#endif

	GLOB.clients += src
	GLOB.directory[ckey] = src

	GLOB.ahelp_tickets.ClientLogin(src)

	//Admin Authorisation
	var/localhost_addresses = list("127.0.0.1", "::1")
	if(address && (address in localhost_addresses))
		var/datum/admin_rank/localhost_rank = new("!localhost!", 65535)
		if(localhost_rank)
			var/datum/admins/localhost_holder = new(localhost_rank, ckey)
			localhost_holder.associate(src)
	if(config.autoadmin)
		if(!GLOB.admin_datums[ckey])
			var/datum/admin_rank/autorank
			for(var/datum/admin_rank/R in GLOB.admin_ranks)
				if(R.name == config.autoadmin_rank)
					autorank = R
					break
			if(!autorank)
				to_chat(world, "Autoadmin rank not found")
			else
				var/datum/admins/D = new(autorank, ckey)
				GLOB.admin_datums[ckey] = D
	holder = GLOB.admin_datums[ckey]
	if(holder)
		GLOB.admins |= src
		holder.owner = src

	//Mentor Authorisation
/*	var/mentor = GLOB.mentor_datums[ckey]
	if(mentor)
		verbs += /client/proc/cmd_mentor_say
		verbs += /client/proc/show_mentor_memo
		GLOB.mentors |= src */

	//preferences datum - also holds some persistent data for the client (because we may as well keep these datums to a minimum)
	prefs = GLOB.preferences_datums[ckey]
	if(!prefs)
		prefs = new /datum/preferences(src)
		GLOB.preferences_datums[ckey] = prefs
	else
		prefs.parent = src
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning
	if(world.byond_version >= 511 && byond_version >= 511 && prefs.clientfps)
		vars["fps"] = prefs.clientfps
	sethotkeys(1)						//set hoykeys from preferences (from_pref = 1)

	log_access("Login: [key_name(src)] from [address ? address : "localhost"]-[computer_id] || BYOND v[byond_version]")
	var/alert_mob_dupe_login = FALSE
	if(config.log_access)
		for(var/I in GLOB.clients)
			if(I == src)
				continue
			var/client/C = I
			if(C.key && (C.key != key) )
				var/matches
				if( (C.address == address) )
					matches += "IP ([address])"
				if( (C.computer_id == computer_id) )
					if(matches)
						matches += " and "
					matches += "ID ([computer_id])"
					alert_mob_dupe_login = TRUE
				if(matches)
					if(C)
						message_admins("<font color='red'><B>Notice: </B><font color='blue'>[key_name_admin(src)] has the same [matches] as [key_name_admin(C)].</font>")
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(C)].")
					else
						message_admins("<font color='red'><B>Notice: </B><font color='blue'>[key_name_admin(src)] has the same [matches] as [key_name_admin(C)] (no longer logged in). </font>")
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(C)] (no longer logged in).")

	. = ..()	//calls mob.Login()

	if(alert_mob_dupe_login)
		set waitfor = FALSE
		alert(mob, "You have logged in already with another key this round, please log out of this one NOW or risk being banned!")

	connection_time = world.time
	connection_realtime = world.realtime
	connection_timeofday = world.timeofday
	winset(src, null, "command=\".configure graphics-hwmode on\"")
	if (byond_version < config.client_error_version)		//Out of date client.
		to_chat(src, "<span class='danger'><b>Your version of byond is too old:</b></span>")
		to_chat(src, config.client_error_message)
		to_chat(src, "Your version: [byond_version]")
		to_chat(src, "Required version: [config.client_error_version] or later")
		to_chat(src, "Visit http://www.byond.com/download/ to get the latest version of byond.")
		if (holder)
			to_chat(src, "Because you are an admin, you are being allowed to walk past this limitation, But it is still STRONGLY suggested you upgrade")
		else
			qdel(src)
			return 0
	else if (byond_version < config.client_warn_version)	//We have words for this client.
		to_chat(src, "<span class='danger'><b>Your version of byond may be getting out of date:</b></span>")
		to_chat(src, config.client_warn_message)
		to_chat(src, "Your version: [byond_version]")
		to_chat(src, "Required version to remove this message: [config.client_warn_version] or later")
		to_chat(src, "Visit http://www.byond.com/download/ to get the latest version of byond.")

	if (connection == "web" && !holder)
		if (!config.allowwebclient)
			to_chat(src, "Web client is disabled")
			qdel(src)
			return 0
		if (config.webclientmembersonly && !IsByondMember())
			to_chat(src, "Sorry, but the web client is restricted to byond members only.")
			qdel(src)
			return 0

	if( (world.address == address || !address) && !GLOB.host )
		GLOB.host = key
		world.update_status()

	if(holder)
		add_admin_verbs()
		to_chat(src, get_message_output("memo"))
		adminGreet()
		if((global.comms_key == "default_pwd" || length(global.comms_key) <= 6) && global.comms_allowed) //It's the default value or less than 6 characters long, but it somehow didn't disable comms.
			to_chat(src, "<span class='danger'>The server's API key is either too short or is the default value! Consider changing it immediately!</span>")

/*	if(mentor && !holder)
		mentor_memo_output("Show") */

	add_verbs_from_config()
	set_client_age_from_db()

	if (isnum(player_age) && player_age == -1) //first connection
		if (config.panic_bunker && !holder && !(ckey in GLOB.deadmins))
			log_access("Failed Login: [key] - New account attempting to connect during panic bunker")
			message_admins("<span class='adminnotice'>Failed Login: [key] - New account attempting to connect during panic bunker</span>")
			to_chat(src, "Sorry but the server is currently not accepting connections from never before seen players.")
			if(config.allow_panic_bunker_bounce && tdata != "redirect")
				to_chat(src, "<span class='notice'>Sending you to [config.panic_server_name].</span>")
				winset(src, null, "command=.options")
				src << link("[config.panic_address]?redirect")
			qdel(src)
			return 0

		if (config.notify_new_player_age >= 0)
			message_admins("New user: [key_name_admin(src)] is connecting here for the first time.")
			if (config.irc_first_connection_alert)
				send2irc_adminless_only("New-user", "[key_name(src)] is connecting for the first time!")

		player_age = 0 // set it from -1 to 0 so the job selection code doesn't have a panic attack

	else if (isnum(player_age) && player_age < config.notify_new_player_age)
		message_admins("New user: [key_name_admin(src)] just connected with an age of [player_age] day[(player_age==1?"":"s")]")

	if(!IsGuestKey(key) && SSdbcore.IsConnected())
		findJoinDate()

	sync_client_with_db(tdata)
	get_message_output("watchlist entry", ckey)
	check_ip_intel()

	send_resources()

	if(!void)
		void = new()

	screen += void

	if(prefs.lastchangelog != GLOB.changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		to_chat(src, "<span class='info'>You have unread updates in the changelog.</span>")
		if(config.aggressive_changelog)
			changelog()
		else
			winset(src, "infowindow.changelog", "font-style=bold")

	if(ckey in GLOB.clientmessages)
		for(var/message in GLOB.clientmessages[ckey])
			to_chat(src, message)
		GLOB.clientmessages.Remove(ckey)

	if(config && config.autoconvert_notes)
		convert_notes_sql(ckey)
	to_chat(src, get_message_output("message", ckey))
	if(!winexists(src, "asset_cache_browser")) // The client is using a custom skin, tell them.
		to_chat(src, "<span class='warning'>Unable to access asset cache browser, if you are using a custom skin file, please allow DS to download the updated version, if you are not, then make a bug report. This is not a critical issue but can cause issues with resource downloading, as it is impossible to know when extra resources arrived to you.</span>")


	//This is down here because of the browse() calls in tooltip/New()
	if(!tooltips)
		tooltips = new /datum/tooltip(src)

	hook_vr("client_new",list(src))

//////////////
//DISCONNECT//
//////////////

/client/Del()
	log_access("Logout: [key_name(src)]")
	if(holder)
		adminGreet(1)
		holder.owner = null
		GLOB.admins -= src

	GLOB.ahelp_tickets.ClientLogout(src)
	GLOB.directory -= ckey
	GLOB.clients -= src
	if(movingmob != null)
		movingmob.client_mobs_in_contents -= mob
		UNSETEMPTY(movingmob.client_mobs_in_contents)
	return ..()

/client/Destroy()
	return QDEL_HINT_HARDDEL_NOW

/client/proc/set_client_age_from_db()
	if (IsGuestKey(src.key))
		return

	if(!SSdbcore.Connect())
		return

	var/sql_ckey = sanitizeSQL(src.ckey)

	var/datum/DBQuery/query_get_client_age = SSdbcore.NewQuery("SELECT id, datediff(Now(),firstseen) as age FROM [format_table_name("player")] WHERE ckey = '[sql_ckey]'")
	if(!query_get_client_age.Execute())
		return

	while(query_get_client_age.NextRow())
		player_age = text2num(query_get_client_age.item[2])
		return

	//no match mark it as a first connection for use in client/New()
	player_age = -1


/client/proc/sync_client_with_db(connectiontopic)
	if (IsGuestKey(src.key))
		return

	if (!SSdbcore.Connect())
		return

	var/sql_ckey = sanitizeSQL(ckey)

	var/datum/DBQuery/query_get_ip = SSdbcore.NewQuery("SELECT ckey FROM [format_table_name("player")] WHERE ip = INET_ATON('[address]') AND ckey != '[sql_ckey]'")
	query_get_ip.Execute()
	related_accounts_ip = ""
	while(query_get_ip.NextRow())
		related_accounts_ip += "[query_get_ip.item[1]], "

	var/datum/DBQuery/query_get_cid = SSdbcore.NewQuery("SELECT ckey FROM [format_table_name("player")] WHERE computerid = '[computer_id]' AND ckey != '[sql_ckey]'")
	if(!query_get_cid.Execute())
		return
	related_accounts_cid = ""
	while (query_get_cid.NextRow())
		related_accounts_cid += "[query_get_cid.item[1]], "

	var/admin_rank = "Player"
	if (src.holder && src.holder.rank)
		admin_rank = src.holder.rank.name
	else
		if (check_randomizer(connectiontopic))
			return

	var/sql_ip = sanitizeSQL(src.address)
	var/sql_computerid = sanitizeSQL(src.computer_id)
	var/sql_admin_rank = sanitizeSQL(admin_rank)


	var/datum/DBQuery/query_log_player = SSdbcore.NewQuery("INSERT INTO [format_table_name("player")] (id, ckey, firstseen, lastseen, ip, computerid, lastadminrank) VALUES (null, '[sql_ckey]', Now(), Now(), INET_ATON('[sql_ip]'), '[sql_computerid]', '[sql_admin_rank]') ON DUPLICATE KEY UPDATE lastseen = VALUES(lastseen), ip = VALUES(ip), computerid = VALUES(computerid), lastadminrank = VALUES(lastadminrank)")
	if(!query_log_player.Execute())
		return

	//Logging player access

	var/datum/DBQuery/query_log_connection = SSdbcore.NewQuery("INSERT INTO `[format_table_name("connection_log")]` (`id`,`datetime`,`server_ip`,`server_port`,`ckey`,`ip`,`computerid`) VALUES(null,Now(),INET_ATON('[world.internet_address]'),'[world.port]','[sql_ckey]',INET_ATON('[sql_ip]'),'[sql_computerid]')")
	query_log_connection.Execute()

/client/proc/check_randomizer(topic)
	. = FALSE
	if (connection != "seeker")
		return
	topic = params2list(topic)
	if (!config.check_randomizer)
		return
	var/static/cidcheck = list()
	var/static/tokens = list()
	var/static/cidcheck_failedckeys = list() //to avoid spamming the admins if the same guy keeps trying.
	var/static/cidcheck_spoofckeys = list()

	var/oldcid = cidcheck[ckey]

	if (oldcid)
		if (!topic || !topic["token"] || !tokens[ckey] || topic["token"] != tokens[ckey])
			if (!cidcheck_spoofckeys[ckey])
				message_admins("<span class='adminnotice'>[key_name(src)] appears to have attempted to spoof a cid randomizer check.</span>")
				cidcheck_spoofckeys[ckey] = TRUE
			cidcheck[ckey] = computer_id
			tokens[ckey] = cid_check_reconnect()

			sleep(10) //browse is queued, we don't want them to disconnect before getting the browse() command.
			qdel(src)
			return TRUE

		if (oldcid != computer_id) //IT CHANGED!!!
			cidcheck -= ckey //so they can try again after removing the cid randomizer.

			to_chat(src, "<span class='userdanger'>Connection Error:</span>")
			to_chat(src, "<span class='danger'>Invalid ComputerID(spoofed). Please remove the ComputerID spoofer from your byond installation and try again.</span>")

			if (!cidcheck_failedckeys[ckey])
				message_admins("<span class='adminnotice'>[key_name(src)] has been detected as using a cid randomizer. Connection rejected.</span>")
				send2irc_adminless_only("CidRandomizer", "[key_name(src)] has been detected as using a cid randomizer. Connection rejected.")
				cidcheck_failedckeys[ckey] = TRUE
				note_randomizer_user()

			log_access("Failed Login: [key] [computer_id] [address] - CID randomizer confirmed (oldcid: [oldcid])")

			qdel(src)
			return TRUE
		else
			if (cidcheck_failedckeys[ckey])
				message_admins("<span class='adminnotice'>[key_name_admin(src)] has been allowed to connect after showing they removed their cid randomizer</span>")
				send2irc_adminless_only("CidRandomizer", "[key_name(src)] has been allowed to connect after showing they removed their cid randomizer.")
				cidcheck_failedckeys -= ckey
			if (cidcheck_spoofckeys[ckey])
				message_admins("<span class='adminnotice'>[key_name_admin(src)] has been allowed to connect after appearing to have attempted to spoof a cid randomizer check because it <i>appears</i> they aren't spoofing one this time</span>")
				cidcheck_spoofckeys -= ckey
			cidcheck -= ckey
	else
		var/sql_ckey = sanitizeSQL(ckey)
		var/datum/DBQuery/query_cidcheck = SSdbcore.NewQuery("SELECT computerid FROM [format_table_name("player")] WHERE ckey = '[sql_ckey]'")
		query_cidcheck.Execute()

		var/lastcid
		if (query_cidcheck.NextRow())
			lastcid = query_cidcheck.item[1]

		if (computer_id != lastcid)
			cidcheck[ckey] = computer_id
			tokens[ckey] = cid_check_reconnect()

			sleep(10) //browse is queued, we don't want them to disconnect before getting the browse() command.
			qdel(src)
			return TRUE

/client/proc/cid_check_reconnect()
	var/token = md5("[rand(0,9999)][world.time][rand(0,9999)][ckey][rand(0,9999)][address][rand(0,9999)][computer_id][rand(0,9999)]")
	. = token
	log_access("Failed Login: [key] [computer_id] [address] - CID randomizer check")
	var/url = winget(src, null, "url")
	//special javascript to make them reconnect under a new window.
	src << browse("<a id='link' href='byond://[url]?token=[token]'>byond://[url]?token=[token]</a><script type='text/javascript'>document.getElementById(\"link\").click();window.location=\"byond://winset?command=.quit\"</script>", "border=0;titlebar=0;size=1x1")
	to_chat(src, "<a href='byond://[url]?token=[token]'>You will be automatically taken to the game, if not, click here to be taken manually</a>")

/client/proc/note_randomizer_user()
	var/const/adminckey = "CID-Error"
	var/sql_ckey = sanitizeSQL(ckey)
	//check to see if we noted them in the last day.
	var/datum/DBQuery/query_get_notes = SSdbcore.NewQuery("SELECT id FROM [format_table_name("messages")] WHERE type = 'note' AND targetckey = '[sql_ckey]' AND adminckey = '[adminckey]' AND timestamp + INTERVAL 1 DAY < NOW()")
	if(!query_get_notes.Execute())
		return
	if(query_get_notes.NextRow())
		return
	//regardless of above, make sure their last note is not from us, as no point in repeating the same note over and over.
	query_get_notes = SSdbcore.NewQuery("SELECT adminckey FROM [format_table_name("messages")] WHERE targetckey = '[sql_ckey]' ORDER BY timestamp DESC LIMIT 1")
	if(!query_get_notes.Execute())
		return
	if(query_get_notes.NextRow())
		if (query_get_notes.item[1] == adminckey)
			return
	create_message("note", sql_ckey, adminckey, "Detected as using a cid randomizer.", null, null, 0, 0)


/client/proc/check_ip_intel()
	set waitfor = 0 //we sleep when getting the intel, no need to hold up the client connection while we sleep
	if (config.ipintel_email)
		var/datum/ipintel/res = get_ip_intel(address)
		if (res.intel >= config.ipintel_rating_bad)
			message_admins("<span class='adminnotice'>Proxy Detection: [key_name_admin(src)] IP intel rated [res.intel*100]% likely to be a Proxy/VPN.</span>")
		ip_intel = res.intel


/client/proc/add_verbs_from_config()
	if(config.see_own_notes)
		verbs += /client/proc/self_notes


#undef TOPIC_SPAM_DELAY
#undef UPLOAD_LIMIT
#undef MIN_CLIENT_VERSION

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration = config.inactivity_period)
	if(inactivity > duration)
		return inactivity
	return FALSE

// Byond seemingly calls stat, each tick.
// Calling things each tick can get expensive real quick.
// So we slow this down a little.
// See: http://www.byond.com/docs/ref/info.html#/client/proc/Stat
/client/Stat()
	. = ..()
	if (holder)
		sleep(1)
	else
		sleep(5)
		stoplag()

//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/client/proc/send_resources()
	//get the common files
	getFiles(
		'html/search.js',
		'html/panels.css',
		'html/browser/common.css',
		'html/browser/scannernew.css',
		'html/browser/playeroptions.css',
		)
	spawn (10) //removing this spawn causes all clients to not get verbs.
		//Precache the client with all other assets slowly, so as to not block other browse() calls
		getFilesSlow(src, SSassets.cache, register_asset = FALSE)


//Hook, override it to run code when dir changes
//Like for /atoms, but clients are their own snowflake FUCK
/client/proc/setDir(newdir)
	dir = newdir

/client/vv_edit_var(var_name, var_value)
	switch (var_name)
		if ("holder")
			return FALSE
		if ("ckey")
			return FALSE
		if ("key")
			return FALSE


/client/proc/change_view(new_size)
	if (isnull(new_size))
		CRASH("change_view called without argument.")

	view = new_size