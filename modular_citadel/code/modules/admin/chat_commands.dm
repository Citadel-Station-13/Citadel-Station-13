/datum/tgs_chat_command/wheelofsalt
	name = "wheelofsalt"
	help_text = "What are Citadel Station 13 players salting about today? Spin the wheel and find out!"

/datum/tgs_chat_command/wheelofsalt/Run(datum/tgs_chat_user/sender, params)
	var/saltresult = "The wheel of salt [pick("clatters","screams","vibrates","clanks","resonates","groans","moans","squeaks","emits a[pick(" god-forsaken"," lewd"," creepy"," generic","n orgasmic"," demonic")] [pick("airhorn","bike horn","trumpet","clown","latex","vore","dog","laughing")] noise")] as it spins violently... And it seems the salt of the day is the "
	var/saltprimarysubject = "[pick("combat","medical","grab","furry","wall","orgasm","cat","ERP","lizard","dog","latex","vision cone","atmospherics","table","chem","vore","dogborg","Skylar Lineman","Mekhi Anderson","Peppermint","rework","cum","dick","cockvore","Medihound","sleeper","belly sleeper","door wires","flightsuit","coder privilege","Developer abuse","ban reason","github self merge","red panda","beret","male catgirl","powergame","hexacrocin","Discord server","Clitadel","Cargonia","Solarian Republic","Main and RP merger","bluespace","salt","chem dispenser theft","Botany","moth","BWOINK","anal vore","stamina","Mason Jakops","mining","noodle","milf","Lavaland","Necropolis","Ashwalker","Chase Redtail","Drew Mint","Pavel Marsk","Joker Amari","Durgit","chaplain","Antag","nanite","Syndicate","Nar-Sie","Ratvar","Cult","maint","Foam-Force","AI","cyborg","ghost","clockwork","cyberpunk","vaporwave","Clown","Leon Beech","Mime","security","research","Megafauna","Bubblegum","Ash Drake","Legion","Colossus","White Shuttle","Changeling","Cowboy","Space Ninja","Poly","Revolutionary","Skyrim","forbidden fruits","xenomorph","blob","Nuclear Operative","crossdressing")]"
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

/datum/tgs_chat_command/poly
	name = "poly"
	help_text = "The Lewder, more applicable Poly speak for Citadel Station 13."
	var/list/speech_buffer

/datum/tgs_chat_command/poly/Run()
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
