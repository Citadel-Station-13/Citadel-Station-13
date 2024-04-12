#define IRC_STATUS_THROTTLE 5

/datum/tgs_chat_command/ircstatus
	name = "status"
	help_text = "Gets the admincount, playercount, gamemode, and true game mode of the server"
	admin_only = TRUE
	var/last_irc_status = 0

/datum/tgs_chat_command/ircstatus/Run(datum/tgs_chat_user/sender, params)
	var/rtod = REALTIMEOFDAY
	if(rtod - last_irc_status < IRC_STATUS_THROTTLE)
		return
	last_irc_status = rtod
	var/list/adm = get_admin_counts()
	var/list/allmins = adm["total"]
	var/status = "Admins: [allmins.len] (Active: [english_list(adm["present"])] AFK: [english_list(adm["afk"])] Stealth: [english_list(adm["stealth"])] Skipped: [english_list(adm["noflags"])]). "
	status += "Players: [GLOB.clients.len] (Active: [get_active_player_count(0,1,0)]). Mode: [SSticker.mode ? SSticker.mode.name : "Not started"]."
	return status

/datum/tgs_chat_command/irccheck
	name = "check"
	help_text = "Gets the playercount, gamemode, and address of the server"
	var/last_irc_check = 0

/datum/tgs_chat_command/irccheck/Run(datum/tgs_chat_user/sender, params)
	var/rtod = REALTIMEOFDAY
	if(rtod - last_irc_check < IRC_STATUS_THROTTLE)
		return
	last_irc_check = rtod
	var/server = CONFIG_GET(string/server)
	return "[GLOB.round_id ? "Round #[GLOB.round_id]: " : ""][GLOB.clients.len] players on [SSmapping.config.map_name]; Round [SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "Active" : "Finishing") : "Starting"] -- [server ? server : "[world.internet_address]:[world.port]"]"
	//CIT CHANGE obfuscates the gamemode for TGS bot commands on discord by removing Mode:[GLOB.master_mode]
/datum/tgs_chat_command/ahelp
	name = "ahelp"
	help_text = "<ckey|ticket #> <message|ticket <close|resolve|icissue|reject|reopen <ticket #>|list>>"
	admin_only = TRUE

/datum/tgs_chat_command/ahelp/Run(datum/tgs_chat_user/sender, params)
	var/list/all_params = splittext(params, " ")
	if(all_params.len < 2)
		return "Insufficient parameters"
	var/target = all_params[1]
	all_params.Cut(1, 2)
	var/id = text2num(target)
	if(id != null)
		var/datum/admin_help/AH = GLOB.ahelp_tickets.TicketByID(id)
		if(AH)
			target = AH.initiator_ckey
		else
			return "Ticket #[id] not found!"
	var/res = IrcPm(target, all_params.Join(" "), sender.friendly_name)
	if(res != "Message Successful")
		return res

/datum/tgs_chat_command/namecheck
	name = "namecheck"
	help_text = "Returns info on the specified target"
	admin_only = TRUE

/datum/tgs_chat_command/namecheck/Run(datum/tgs_chat_user/sender, params)
	params = trim(params)
	if(!params)
		return "Insufficient parameters"
	log_admin("Chat Name Check: [sender.friendly_name] on [params]")
	message_admins("Name checking [params] from [sender.friendly_name]")
	return keywords_lookup(params, 1)

/datum/tgs_chat_command/adminwho
	name = "adminwho"
	help_text = "Lists administrators currently on the server"
	admin_only = TRUE

/datum/tgs_chat_command/adminwho/Run(datum/tgs_chat_user/sender, params)
	return ircadminwho()

GLOBAL_LIST(round_end_notifiees)

/datum/tgs_chat_command/notify
	name = "notify"
	help_text = "Pings the invoker when the round ends"
	admin_only = FALSE

/datum/tgs_chat_command/notify/Run(datum/tgs_chat_user/sender, params)
	if(!SSticker.IsRoundInProgress() && SSticker.HasRoundStarted())
		return "[sender.mention], the round has already ended!"
	LAZYINITLIST(GLOB.round_end_notifiees)
	GLOB.round_end_notifiees[sender.mention] = TRUE
	return "I will notify [sender.mention] when the round ends."

/datum/tgs_chat_command/sdql
	name = "sdql"
	help_text = "Runs an SDQL query"
	admin_only = TRUE

/datum/tgs_chat_command/sdql/Run(datum/tgs_chat_user/sender, params)
	if(GLOB.AdminProcCaller)
		return "Unable to run query, another admin proc call is in progress. Try again later."
	GLOB.AdminProcCaller = "CHAT_[sender.friendly_name]"	//_ won't show up in ckeys so it'll never match with a real admin
	var/list/results = world.SDQL2_query(params, GLOB.AdminProcCaller, GLOB.AdminProcCaller)
	GLOB.AdminProcCaller = null
	if(!results)
		return "Query produced no output"
	var/list/text_res = results.Copy(1, 3)
	var/list/refs = results.len > 3 ? results.Copy(4) : null
	if(refs)
		var/list/L = list()
		for(var/ref in refs)
			var/atom/A = locate(ref)
			if(A)
				L += "[A]"
			else
				L += "[ref]"
		refs = L
	. = "[text_res.Join("\n")][refs ? "\nRefs: [refs.Join(" ")]" : ""]"

/datum/tgs_chat_command/reload_admins
	name = "reload_admins"
	help_text = "Forces the server to reload admins."
	admin_only = TRUE

/datum/tgs_chat_command/reload_admins/Run(datum/tgs_chat_user/sender, params)
	ReloadAsync()
	log_admin("[sender.friendly_name] reloaded admins via chat command.")
	return "Admins reloaded."

/datum/tgs_chat_command/reload_admins/proc/ReloadAsync()
	set waitfor = FALSE
	load_admins()

/datum/tgs_chat_command/addbunkerbypass
	name = "whitelist"
	help_text = "whitelist <ckey>"
	admin_only = TRUE

/datum/tgs_chat_command/addbunkerbypass/Run(datum/tgs_chat_user/sender, params)
	if(!CONFIG_GET(flag/sql_enabled))
		return "The Database is not enabled!"

	GLOB.bunker_passthrough |= ckey(params)
	GLOB.bunker_passthrough[ckey(params)] = world.realtime
	SSpersistence.SavePanicBunker() //we can do this every time, it's okay
	log_admin("[sender.friendly_name] has added [params] to the current round's bunker bypass list.")
	message_admins("[sender.friendly_name] has added [params] to the current round's bunker bypass list.")
	return "[params] has been added to the current round's bunker bypass list."

// More (silly) chat commands citadel added.
/datum/tgs_chat_command/wheelofsalt
	name = "wheelofsalt"
	help_text = "What are Citadel Station 13 players salting about today? Spin the wheel and find out!"

/datum/tgs_chat_command/wheelofsalt/Run(datum/tgs_chat_user/sender, params)
	var/saltresult = "The wheel of salt [pick("clatters","screams","vibrates","clanks","resonates","groans","moans","squeaks","emits a[pick(" god-forsaken"," lewd"," creepy"," generic","n orgasmic"," demonic")] [pick("airhorn","bike horn","trumpet","clown","latex","vore","dog","laughing")] noise")] as it spins violently... And it seems the salt of the day is the "
	var/saltprimarysubject = "[pick("combat","medical","grab","furry","wall","orgasm","cat","ERP","lizard","dog","latex","vision cone","atmospherics","table","chem","vore","dogborg","Skylar Lineman","Mekhi Anderson","Peppermint","rework","cum","dick","cockvore","Medihound","sleeper","belly sleeper","door wires","flightsuit","coder privilege","Developer abuse","ban reason","github self merge","red panda","beret","male catgirl","powergame","hexacrocin removal","Discord server","Clitadel","Cargonia","Solarian Republic","Main and RP merger","bluespace","salt","chem dispenser theft","Botany","moth","BWOINK","anal vore","stamina","Mason Jakops","mining","noodle","milf","Lavaland","Necropolis","Ashwalker","Chase Redtail","Drew Mint","Pavel Marsk","Joker Amari","Durgit","chaplain","Antag","nanite","Syndicate","Nar-Sie","Ratvar","Cult","maint","Foam-Force","AI","cyborg","ghost","clockwork","cyberpunk","vaporwave","Clown","Leon Beech","Mime","security","research","Megafauna","Bubblegum","Ash Drake","Legion","Colossus","White Shuttle","Changeling","Cowboy","Space Ninja","Polly","Revolutionary","Skyrim","forbidden fruits","xenomorph","blob","Nuclear Operative","crossdressing")]"
	var/saltsecondarysubject = "[pick("rework","changes","r34","ban","removal","addition","leak","proposal","fanart","introduction","tabling","ERP","bikeshedding","crossdressing","sprites","semen keg","argument","theft","nerf","screeching","salt","creampie","lewding","murder","kissing","marriage","replacement","fucking","ship","netflix adaptation","dance","remaster","system","voyeur","decoration","pre-order","bukkake","seduction","worship","gangbang","handholding")]"
	if(prob(10))
		saltresult += "@here for your salt, all day every day"
		if(prob(1))
			saltresult += " @everyone gets some salt this time too"
	else
		saltresult += "[saltprimarysubject] [saltsecondarysubject]"
	return "[saltresult]!"

/datum/tgs_chat_command/valentine
	name = "valentine"
	help_text = "Get a random flirt line."

/datum/tgs_chat_command/valentine/Run(datum/tgs_chat_user/sender, params)
	return "[pick(GLOB.flirts)]"

/datum/tgs_chat_command/despacito
	name = "despacito"			//someone please high effort this sometime and make it a full on ytdl search
	help_text = "This is so sad."

/datum/tgs_chat_command/despacito/Run()
	return "https://www.youtube.com/watch?v=kJQP7kiw5Fk"

/datum/tgs_chat_command/polly
	name = "polly"
	help_text = "The Lewder, more applicable Polly speak for Citadel Station 13."
	var/list/speech_buffer

/datum/tgs_chat_command/polly/Run()
	LAZYINITLIST(speech_buffer) //I figure this is just safe to do for everything at this point
	if(length(speech_buffer))	//Let's not look up the whole json EVERY TIME, just the first time.
		return "[pick(speech_buffer)]"
	else
		var/json_file = file("data/npc_saves/Poly.json")
		if(!fexists(json_file))
			return "**BAWWWWWK!** LEAVE THE HEADSET! ***BAWKKKKK!!***"
		var/list/json = json_decode(file2text(json_file))
		speech_buffer = json["phrases"]
		return "[pick(speech_buffer)]"
