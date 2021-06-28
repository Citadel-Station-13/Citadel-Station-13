// SETUP

/proc/TopicHandlers()
	. = list()
	var/list/all_handlers = subtypesof(/datum/world_topic)
	for(var/I in all_handlers)
		var/datum/world_topic/WT = I
		var/keyword = initial(WT.keyword)
		if(!keyword)
			warning("[WT] has no keyword! Ignoring...")
			continue
		var/existing_path = .[keyword]
		if(existing_path)
			warning("[existing_path] and [WT] have the same keyword! Ignoring [WT]...")
		else if(keyword == "key")
			warning("[WT] has keyword 'key'! Ignoring...")
		else
			.[keyword] = WT

// DATUM

/datum/world_topic
	var/keyword
	var/log = TRUE
	var/key_valid
	var/require_comms_key = FALSE

/datum/world_topic/proc/TryRun(list/input, addr)
	key_valid = config && (CONFIG_GET(string/comms_key) == input["key"])
	if(require_comms_key && !key_valid)
		return "Bad Key"
	input -= "key"
	. = Run(input, addr)
	if(islist(.))
		. = list2params(.)

/datum/world_topic/proc/Run(list/input, addr)
	CRASH("Run() not implemented for [type]!")

// TOPICS

/datum/world_topic/ping
	keyword = "ping"
	log = FALSE

/datum/world_topic/ping/Run(list/input, addr)
	. = 0
	for (var/client/C in GLOB.clients)
		++.

/datum/world_topic/playing
	keyword = "playing"
	log = FALSE

/datum/world_topic/playing/Run(list/input, addr)
	return GLOB.player_list.len

/datum/world_topic/pr_announce
	keyword = "announce"
	require_comms_key = TRUE
	var/static/list/PRcounts = list()	//PR id -> number of times announced this round

/datum/world_topic/pr_announce/Run(list/input, addr)
	var/list/payload = json_decode(input["payload"])
	var/id = "[payload["pull_request"]["id"]]"
	if(!PRcounts[id])
		PRcounts[id] = 1
	else
		++PRcounts[id]
		if(PRcounts[id] > PR_ANNOUNCEMENTS_PER_ROUND)
			return

	var/final_composed = "<span class='announce'>PR: [input[keyword]]</span>"
	for(var/client/C in GLOB.clients)
		C.AnnouncePR(final_composed)

/datum/world_topic/auto_bunker_passthrough
	keyword = "auto_bunker_override"
	require_comms_key = TRUE

/datum/world_topic/auto_bunker_passthrough/Run(list/input)
	if(!CONFIG_GET(flag/allow_cross_server_bunker_override))
		return "Function Disabled"
	var/ckeytobypass = input["ckey"]
	var/is_new_ckey = !(ckey(ckeytobypass) in GLOB.bunker_passthrough)
	var/sender = input["source"] || "UNKNOWN"
	GLOB.bunker_passthrough |= ckey(ckeytobypass)
	GLOB.bunker_passthrough[ckey(ckeytobypass)] = world.realtime
	SSpersistence.SavePanicBunker() //we can do this every time, it's okay
	if(!is_new_ckey)
		log_admin("AUTO BUNKER: [ckeytobypass] given access (incoming comms from [sender]).")
		message_admins("AUTO BUNKER: [ckeytobypass] given access (incoming comms from [sender]).")
		send2adminchat("Panic Bunker", "AUTO BUNKER: [ckeytobypass] given access (incoming comms from [sender]).")
	return "Success"

/datum/world_topic/ahelp_relay
	keyword = "Ahelp"
	require_comms_key = TRUE

/datum/world_topic/ahelp_relay/Run(list/input, addr)
	relay_msg_admins("<span class='adminnotice'><b><font color=red>HELP: </font> [input["source"]] [input["message_sender"]]: [input["message"]]</b></span>")

/datum/world_topic/comms_console
	keyword = "Comms_Console"
	require_comms_key = TRUE

/datum/world_topic/comms_console/Run(list/input, addr)
	minor_announce(input["message"], "Incoming message from [input["message_sender"]]")
	for(var/obj/machinery/computer/communications/console in GLOB.machines)
		console.override_cooldown()

/datum/world_topic/news_report
	keyword = "News_Report"
	require_comms_key = TRUE

/datum/world_topic/news_report/Run(list/input, addr)
	minor_announce(input["message"], "Breaking Update From [input["message_sender"]]")

/datum/world_topic/server_hop
	keyword = "server_hop"

/datum/world_topic/server_hop/Run(list/input, addr)
	var/expected_key = input[keyword]
	for(var/mob/dead/observer/O in GLOB.player_list)
		if(O.key == expected_key)
			if(O.client?.address == addr)
				new /obj/screen/splash(O.client, TRUE)
			break

/datum/world_topic/adminmsg
	keyword = "adminmsg"
	require_comms_key = TRUE

/datum/world_topic/adminmsg/Run(list/input, addr)
	return IrcPm(input[keyword], input["msg"], input["sender"])

/datum/world_topic/namecheck
	keyword = "namecheck"
	require_comms_key = TRUE

/datum/world_topic/namecheck/Run(list/input, addr)
	//Oh this is a hack, someone refactor the functionality out of the chat command PLS
	var/datum/tgs_chat_command/namecheck/NC = new
	var/datum/tgs_chat_user/user = new
	user.friendly_name = input["sender"]
	user.mention = user.friendly_name
	return NC.Run(user, input["namecheck"])

/datum/world_topic/adminwho
	keyword = "adminwho"
	require_comms_key = TRUE

/datum/world_topic/adminwho/Run(list/input, addr)
	return ircadminwho()

/datum/world_topic/status
	keyword = "status"

/datum/world_topic/status/Run(list/input, addr)
	if(!key_valid) //If we have a key, then it's safe to trust that this isn't a malicious packet. Also prevents the extra info from leaking
		if(GLOB.topic_status_lastcache >= world.time)
			return GLOB.topic_status_cache
		GLOB.topic_status_lastcache = world.time + 5
	. = list()
	.["version"] = GLOB.game_version
	.["mode"] = "hidden"	//CIT CHANGE - hides the gamemode in topic() calls to prevent meta'ing the gamemode
	.["respawn"] = config ? CONFIG_GET(flag/respawns_enabled) : FALSE
	.["enter"] = GLOB.enter_allowed
	.["vote"] = CONFIG_GET(flag/allow_vote_mode)
	.["ai"] = CONFIG_GET(flag/allow_ai)
	.["host"] = world.host ? world.host : null
	.["round_id"] = GLOB.round_id
	.["players"] = GLOB.clients.len
	.["revision"] = GLOB.revdata.commit
	.["revision_date"] = GLOB.revdata.date

	var/list/adm = get_admin_counts()
	var/list/presentmins = adm["present"]
	var/list/afkmins = adm["afk"]
	.["admins"] = presentmins.len + afkmins.len //equivalent to the info gotten from adminwho
	.["gamestate"] = SSticker.current_state

	.["map_name"] = SSmapping.config?.map_name || "Loading..."

	if(key_valid)
		.["active_players"] = get_active_player_count()
		if(SSticker.HasRoundStarted())
			.["real_mode"] = SSticker.mode.name
			// Key-authed callers may know the truth behind the "secret"

	.["security_level"] = NUM2SECLEVEL(GLOB.security_level)
	.["round_duration"] = SSticker ? round((world.time-SSticker.round_start_time)/10) : 0
	// Amount of world's ticks in seconds, useful for calculating round duration

	//Time dilation stats.
	.["time_dilation_current"] = SStime_track.time_dilation_current
	.["time_dilation_avg"] = SStime_track.time_dilation_avg
	.["time_dilation_avg_slow"] = SStime_track.time_dilation_avg_slow
	.["time_dilation_avg_fast"] = SStime_track.time_dilation_avg_fast

	if(SSshuttle && SSshuttle.emergency)
		.["shuttle_mode"] = SSshuttle.emergency.mode
		// Shuttle status, see /__DEFINES/stat.dm
		.["shuttle_timer"] = SSshuttle.emergency.timeLeft()
		// Shuttle timer, in seconds

	if(!key_valid)
		GLOB.topic_status_cache = .

/datum/world_topic/jsonstatus
	keyword = "jsonstatus"

/datum/world_topic/jsonstatus/Run(list/input, addr)
	. = list()
	.["mode"] = "hidden" // GLOB.master_mode - woops we don't want people to know if there's secret/extended :)
	.["round_id"] = "[GLOB.round_id]"
	.["players"] = GLOB.clients.len
	var/list/adm = get_admin_counts()
	var/list/presentmins = adm["present"]
	var/list/afkmins = adm["afk"]
	.["admins"] = presentmins.len + afkmins.len //equivalent to the info gotten from adminwho
	.["security_level"] = "[NUM2SECLEVEL(GLOB.security_level)]"
	.["round_duration"] = WORLDTIME2TEXT("hh:mm:ss")
	.["map"] = SSmapping.config.map_name
	return json_encode(.)

/datum/world_topic/jsonplayers
	keyword = "jsonplayers"

/datum/world_topic/jsonplayers/Run(list/input, addr)
	. = list()
	for(var/client/C in GLOB.clients)
		if(C.holder?.fakekey)
			. += C.holder.fakekey
			continue
		. += C.key
	return json_encode(.)

/datum/world_topic/jsonmanifest
	keyword = "jsonmanifest"

/datum/world_topic/jsonmanifest/Run(list/input, addr)
	var/list/command = list()
	var/list/security = list()
	var/list/engineering = list()
	var/list/medical = list()
	var/list/science = list()
	var/list/cargo = list()
	var/list/civilian = list()
	var/list/misc = list()
	for(var/datum/data/record/R in GLOB.data_core.general)
		var/name = R.fields["name"]
		var/rank = R.fields["rank"]
		var/real_rank = rank // make_list_rank(R.fields["real_rank"])
		if(real_rank in GLOB.security_positions)
			security[name] = rank
		else if(real_rank in GLOB.engineering_positions)
			engineering[name] = rank
		else if(real_rank in GLOB.medical_positions)
			medical[name] = rank
		else if(real_rank in GLOB.science_positions)
			science[name] = rank
		else if(real_rank in GLOB.supply_positions)
			cargo[name] = rank
		else if(real_rank in GLOB.civilian_positions)
			civilian[name] = rank
		else
			misc[name] = rank
		// mixed departments, /datum/department when
		if(real_rank in GLOB.command_positions)
			command[name] = rank

	. = list()
	.["Command"] = command
	.["Security"] = security
	.["Engineering"] = engineering
	.["Medical"] = medical
	.["Science"] = science
	.["Cargo"] = cargo
	.["Civilian"] = civilian
	.["Misc"] = misc
	return json_encode(.)

/datum/world_topic/jsonrevision
	keyword = "jsonrevision"

/datum/world_topic/jsonrevision/Run(list/input, addr)
	var/datum/getrev/revdata = GLOB.revdata
	var/list/data = list(
		"date" = copytext(revdata.date, 1, 11),
		"dd_version" = world.byond_version,
		"dd_build" = world.byond_build,
		"dm_version" = DM_VERSION,
		"dm_build" = DM_BUILD,
		"revision" = revdata.commit,
		"round_id" = "[GLOB.round_id]",
		"testmerge_base_url" = "[CONFIG_GET(string/githuburl)]/pull/"
	)
	if (revdata.testmerge.len)
		for (var/datum/tgs_revision_information/test_merge/TM in revdata.testmerge)
			data["testmerges"] += list(list(
				"id" = TM.number,
				"desc" = TM.title,
				"author" = TM.author
			))

	return json_encode(data)
