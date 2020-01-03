#define PING_BUFFER_TIME 25

SUBSYSTEM_DEF(server_maint)
	name = "Server Tasks"
	wait = 10
	flags = SS_POST_FIRE_TIMING
	priority = FIRE_PRIORITY_SERVER_MAINT
	init_order = INIT_ORDER_SERVER_MAINT
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	var/list/currentrun

	var/last_isbanned_flood_prune = 0
	var/isbanned_flood_prune_delay = 10 SECONDS

/datum/controller/subsystem/server_maint/Initialize(timeofday)
	if (CONFIG_GET(flag/hub))
		world.update_hub_visibility(TRUE)
	return ..()

/datum/controller/subsystem/server_maint/fire(resumed = FALSE)
	if(!resumed)
		if(listclearnulls(GLOB.clients))
			log_world("Found a null in clients list!")
		if(listclearnulls(GLOB.player_list))
			log_world("Found a null in player list!")
		src.currentrun = GLOB.clients.Copy()

	var/list/currentrun = src.currentrun
	var/round_started = SSticker.HasRoundStarted()

	var/kick_inactive = CONFIG_GET(flag/kick_inactive)
	var/afk_period
	if(kick_inactive)
		afk_period = CONFIG_GET(number/afk_period)
	for(var/I in currentrun)
		var/client/C = I
		//handle kicking inactive players
		if(round_started && kick_inactive && C.is_afk(afk_period))
			var/cmob = C.mob
			if(!(isobserver(cmob) || (isdead(cmob) && C.holder)))
				log_access("AFK: [key_name(C)]")
				to_chat(C, "<span class='danger'>You have been inactive for more than [DisplayTimeText(afk_period)] and have been disconnected.</span>")
				qdel(C)

		if (!(!C || world.time - C.connection_time < PING_BUFFER_TIME || C.inactivity >= (wait-1)))
			winset(C, null, "command=.update_ping+[world.time+world.tick_lag*TICK_USAGE_REAL/100]")

		if (MC_TICK_CHECK) //one day, when ss13 has 1000 people per server, you guys are gonna be glad I added this tick check
			return

	if((last_isbanned_flood_prune + isbanned_flood_prune_delay) < world.time)
		last_isbanned_flood_prune = world.time
		prune_isbanned_floodcheck_list()

/datum/controller/subsystem/server_maint/Shutdown()
	kick_clients_in_lobby("<span class='boldannounce'>The round came to an end with you in the lobby.</span>", TRUE) //second parameter ensures only afk clients are kicked
	var/server = CONFIG_GET(string/server)
	for(var/thing in GLOB.clients)
		if(!thing)
			continue
		var/client/C = thing
		var/datum/chatOutput/co = C.chatOutput
		if(co)
			co.ehjax_send(data = "roundrestart")
		if(server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[server]")
	var/tgsversion = world.TgsVersion()
	if(tgsversion)
		SSblackbox.record_feedback("text", "server_tools", 1, tgsversion)

/datum/controller/subsystem/server_maint/proc/prune_isbanned_floodcheck_list()
	set waitfor = FALSE
	for(var/key in GLOB.isbanned_key_floodcheck)
		var/msg = "SERVER MAINTENANCE: Lingering key in GLOB.isbanned_key_floodcheck: [key] - [GLOB.isbanned_key_floodcheck[key]]. Contact a coder!"
		message_admins(msg)
		log_admin(msg)
	GLOB.isbanned_key_floodcheck.len = 0		//Is this the best way/is it even necessary to prune these lists?
	for(var/cid in GLOB.isbanned_cid_floodcheck)
		var/msg = "SERVER MAINTENANCE: Lingering cid in GLOB.isbanned_key_floodcheck: [cid] - [GLOB.isbanned_key_floodchec[cid]]. Contact a coder!"
		message_admins(msg)
		log_admin(msg)
	GLOB.isbanned_cid_floodcheck.len = 0		//ditto
	for(var/ip in GLOB.isbanned_ip_floodcheck)
		var/msg = "SERVER MAINTENANCE: Lingering ip in GLOB.isbanned_key_floodcheck: [ip] - [GLOB.isbanned_ip_floodcheck[ip]]. Contact a coder!"
		message_admins(msg)
		log_admin(msg)
	GLOB.isbanned_ip_floodcheck.len = 0			//ditto

#undef PING_BUFFER_TIME
