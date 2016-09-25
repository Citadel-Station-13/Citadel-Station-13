	////////////
	//SECURITY//
	////////////
#define UPLOAD_LIMIT		1048576	//Restricts client uploads to the server to 1MB //Could probably do with being lower.

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
		//src << "ASSET JOB [href_list["asset_cache_confirm_arrival"]] ARRIVED."
		var/job = text2num(href_list["asset_cache_confirm_arrival"])
		completed_asset_jobs += job
		return
	// Admin PM
	if(href_list["priv_msg"])
		if (href_list["ahelp_reply"])
			cmd_ahelp_reply(href_list["priv_msg"])
			return
		cmd_admin_pm(href_list["priv_msg"],null)
		return

	//Logs all hrefs
	if(config && config.log_hrefs && href_logfile)
		href_logfile << "<small>[time2text(world.timeofday,"hh:mm")] [src] (usr:[usr])</small> || [hsrc ? "[hsrc] " : ""][href]<br>"

	switch(href_list["_src_"])
		if("holder")
			hsrc = holder
		if("usr")
			hsrc = mob
		if("prefs")
			return prefs.process_link(usr,href_list)
		if("vars")
			return view_var_Topic(href,href_list,hsrc)

	..()	//redirect to hsrc.Topic()

/client/proc/is_content_unlocked()
	if(!prefs.unlock_content)
		src << "Become a BYOND member to access member-perks and features, as well as support the engine that makes this game possible. Only 10 bucks for 3 months! <a href='http://www.byond.com/membership'>Click Here to find out more</a>."
		return 0
	return 1

/client/proc/handle_spam_prevention(message, mute_type)
	if(config.automute_on && !holder && src.last_message == message)
		src.last_message_count++
		if(src.last_message_count >= SPAM_TRIGGER_AUTOMUTE)
			src << "<span class='danger'>You have exceeded the spam filter limit for identical messages. An auto-mute was applied.</span>"
			cmd_admin_mute(src, mute_type, 1)
			return 1
		if(src.last_message_count >= SPAM_TRIGGER_WARNING)
			src << "<span class='danger'>You are nearing the spam filter limit for identical messages.</span>"
			return 0
	else
		last_message = message
		src.last_message_count = 0
		return 0

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		src << "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>"
		return 0
/*	//Don't need this at the moment. But it's here if it's needed later.
	//Helps prevent multiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		src << "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait [round(time_to_wait/10)] seconds.</font>"
		return 0
	fileaccess_timer = world.time + FTPDELAY	*/
	return 1


	///////////
	//CONNECT//
	///////////
#if (PRELOAD_RSC == 0)
var/list/external_rsc_urls
var/next_external_rsc = 0
#endif


/client/New(TopicData)

	TopicData = null							//Prevent calls to client.Topic from connect

	if(connection != "seeker" && connection != "web")//Invalid connection type.
		return null

#if (PRELOAD_RSC == 0)
	if(external_rsc_urls && external_rsc_urls.len)
		next_external_rsc = Wrap(next_external_rsc+1, 1, external_rsc_urls.len+1)
		preload_rsc = external_rsc_urls[next_external_rsc]
#endif

	clients += src
	directory[ckey] = src

	//Admin Authorisation
	var/localhost_addresses = list("127.0.0.1", "::1")
	if(address && (address in localhost_addresses))
		var/datum/admin_rank/localhost_rank = new("!localhost!", 65535)
		if(localhost_rank)
			var/datum/admins/localhost_holder = new(localhost_rank, ckey)
			localhost_holder.associate(src)
	if(protected_config.autoadmin)
		if(!admin_datums[ckey])
			var/datum/admin_rank/autorank
			for(var/datum/admin_rank/R in admin_ranks)
				if(R.name == protected_config.autoadmin_rank)
					autorank = R
					break
			if(!autorank)
				world << "Autoadmin rank not found"
			else
				var/datum/admins/D = new(autorank, ckey)
				admin_datums[ckey] = D
	holder = admin_datums[ckey]
	if(holder)
		admins |= src
		holder.owner = src

	if(check_rights(R_ADMIN))
		if(ahelp_count(0) > 0)
			list_ahelps(src, 0)

	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = preferences_datums[ckey]
	if(!prefs)
		prefs = new /datum/preferences(src)
		preferences_datums[ckey] = prefs
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning

	. = ..()	//calls mob.Login()

	if (byond_version < config.client_error_version)		//Out of date client.
		src << "<span class='danger'><b>Your version of byond is too old:</b></span>"
		src << config.client_error_message
		src << "Your version: [byond_version]"
		src << "Required version: [config.client_error_version] or later"
		src << "Visit http://www.byond.com/download/ to get the latest version of byond."
		if (holder)
			src << "Because you are an admin, you are being allowed to walk past this limitation, But it is still STRONGLY suggested you upgrade"
		else
			del(src)
			return 0
	else if (byond_version < config.client_warn_version)	//We have words for this client.
		src << "<span class='danger'><b>Your version of byond may be getting out of date:</b></span>"
		src << config.client_warn_message
		src << "Your version: [byond_version]"
		src << "Required version to remove this message: [config.client_warn_version] or later"
		src << "Visit http://www.byond.com/download/ to get the latest version of byond."

	if (connection == "web")
		if (!config.allowwebclient)
			src << "Web client is disabled"
			del(src)
			return 0
		if (config.webclientmembersonly && !IsByondMember())
			src << "Sorry, but the web client is restricted to byond members only."
			del(src)
			return 0

	if( (world.address == address || !address) && !host )
		host = key
		world.update_status()

	if(holder)
		add_admin_verbs()
		admin_memo_output("Show")
		adminGreet()
		if((global.comms_key == "default_pwd" || length(global.comms_key) <= 6) && global.comms_allowed) //It's the default value or less than 6 characters long, but it somehow didn't disable comms.
			src << "<span class='danger'>The server's API key is either too short or is the default value! Consider changing it immediately!</span>"

	add_verbs_from_config()
	set_client_age_from_db()

	if (isnum(player_age) && player_age == -1) //first connection
		if (config.panic_bunker && !holder && !(ckey in deadmins))
			log_access("Failed Login: [key] - New account attempting to connect during panic bunker")
			message_admins("<span class='adminnotice'>Failed Login: [key] - New account attempting to connect during panic bunker</span>")
			src << "Sorry but the server is currently not accepting connections from never before seen players."
			del(src)
			return 0

		if (config.notify_new_player_age >= 0)
			message_admins("New user: [key_name_admin(src)] is connecting here for the first time.")
			if (config.irc_first_connection_alert)
				send2irc_adminless_only("New-user", "[key_name(src)] is connecting for the first time!")

		player_age = 0 // set it from -1 to 0 so the job selection code doesn't have a panic attack

	else if (isnum(player_age) && player_age < config.notify_new_player_age)
		message_admins("New user: [key_name_admin(src)] just connected with an age of [player_age] day[(player_age==1?"":"s")]")

	if(!IsGuestKey(key) && dbcon.IsConnected())
		findJoinDate()

	sync_client_with_db()

	check_ip_intel()

	send_resources()

	if(!void)
		void = new()
		void = void.MakeGreed()

	screen += void

	if(prefs.lastchangelog != changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		src << "<span class='info'>You have unread updates in the changelog.</span>"
		if(config.aggressive_changelog)
			changelog()
		else
			winset(src, "infowindow.changelog", "font-style=bold")

	if(ckey in clientmessages)
		for(var/message in clientmessages[ckey])
			src << message
		clientmessages.Remove(ckey)

	if(config && config.autoconvert_notes)
		convert_notes_sql(ckey)

	if(!winexists(src, "asset_cache_browser")) // The client is using a custom skin, tell them.
		src << "<span class='warning'>Unable to access asset cache browser, if you are using a custom skin file, please allow DS to download the updated version, if you are not, then make a bug report. This is not a critical issue but can cause issues with resource downloading, as it is impossible to know when extra resources arrived to you.</span>"


	//This is down here because of the browse() calls in tooltip/New()
	if(!tooltips)
		tooltips = new /datum/tooltip(src)


//////////////
//DISCONNECT//
//////////////

/client/Del()
	if(holder)
		adminGreet(1)
		holder.owner = null
		admins -= src
	directory -= ckey
	clients -= src
	return ..()


/client/proc/set_client_age_from_db()
	if (IsGuestKey(src.key))
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/sql_ckey = sanitizeSQL(src.ckey)

	var/DBQuery/query = dbcon.NewQuery("SELECT id, datediff(Now(),firstseen) as age FROM [format_table_name("player")] WHERE ckey = '[sql_ckey]'")
	if (!query.Execute())
		return

	while (query.NextRow())
		player_age = text2num(query.item[2])
		return

	//no match mark it as a first connection for use in client/New()
	player_age = -1


/client/proc/sync_client_with_db()
	if (IsGuestKey(src.key))
		return

	establish_db_connection()
	if (!dbcon.IsConnected())
		return

	var/sql_ckey = sanitizeSQL(src.ckey)

	var/DBQuery/query_ip = dbcon.NewQuery("SELECT ckey FROM [format_table_name("player")] WHERE ip = '[address]' AND ckey != '[sql_ckey]'")
	query_ip.Execute()
	related_accounts_ip = ""
	while(query_ip.NextRow())
		related_accounts_ip += "[query_ip.item[1]], "

	var/DBQuery/query_cid = dbcon.NewQuery("SELECT ckey FROM [format_table_name("player")] WHERE computerid = '[computer_id]' AND ckey != '[sql_ckey]'")
	query_cid.Execute()
	related_accounts_cid = ""
	while (query_cid.NextRow())
		related_accounts_cid += "[query_cid.item[1]], "

	var/watchreason = check_watchlist(sql_ckey)
	if(watchreason)
		message_admins("<font color='red'><B>Notice: </B></font><font color='blue'>[key_name_admin(src)] is on the watchlist and has just connected - Reason: [watchreason]</font>")
		send2irc_adminless_only("Watchlist", "[key_name(src)] is on the watchlist and has just connected - Reason: [watchreason]")

	var/admin_rank = "Player"
	if (src.holder && src.holder.rank)
		admin_rank = src.holder.rank.name

	var/sql_ip = sanitizeSQL(src.address)
	var/sql_computerid = sanitizeSQL(src.computer_id)
	var/sql_admin_rank = sanitizeSQL(admin_rank)


	var/DBQuery/query_insert = dbcon.NewQuery("INSERT INTO [format_table_name("player")] (id, ckey, firstseen, lastseen, ip, computerid, lastadminrank) VALUES (null, '[sql_ckey]', Now(), Now(), '[sql_ip]', '[sql_computerid]', '[sql_admin_rank]') ON DUPLICATE KEY UPDATE lastseen = VALUES(lastseen), ip = VALUES(ip), computerid = VALUES(computerid), lastadminrank = VALUES(lastadminrank)")
	query_insert.Execute()

	//Logging player access
	var/serverip = "[world.internet_address]:[world.port]"
	var/DBQuery/query_accesslog = dbcon.NewQuery("INSERT INTO `[format_table_name("connection_log")]` (`id`,`datetime`,`serverip`,`ckey`,`ip`,`computerid`) VALUES(null,Now(),'[serverip]','[sql_ckey]','[sql_ip]','[sql_computerid]');")
	query_accesslog.Execute()

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
/client/proc/is_afk(duration=3000)
	if(inactivity > duration)
		return inactivity
	return 0

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
		getFilesSlow(src, SSasset.cache, register_asset = FALSE)


//Hook, override it to run code when dir changes
//Like for /atoms, but clients are their own snowflake FUCK
/client/proc/setDir(newdir)
	dir = newdir