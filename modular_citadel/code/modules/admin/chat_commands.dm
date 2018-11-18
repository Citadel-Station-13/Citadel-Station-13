/datum/tgs_chat_command/wheelofsalt
	name = "wheelofsalt"
	help_text = "What are Citadel Station 13 players salting about today? Spin the wheel and find out!"

/datum/tgs_chat_command/wheelofsalt/Run(datum/tgs_chat_user/sender, params)
	var/saltresult = "The wheel of salt [pick("clatters","vibrates","clanks","groans","moans","squeaks","emits a[pick(" god-forsaken"," lewd"," creepy"," generic","n orgasmic")] [pick("airhorn","bike horn","trumpet","clown","latex","vore","dog")] noise")] as it spins violently... And it seems the salt of the day is the "
	var/saltprimarysubject = "[pick("combat","medical","grab","furry","wall","orgasm","cat","ERP","lizard","dog","latex","vision cone","atmospherics","table","chem","vore","dogborg","Skylar Lineman","Mekhi Anderson","Peppermint","rework","cum","dick","cockvore","Medihound","sleeper","belly sleeper","door wires","flightsuit","coder privilege","Developer abuse","ban reason","github self merge","red panda","beret","male catgirl","powergame","Discord server","Clitadel","Cargonia","Solarian Republic","Main and RP merger","Salt","chem dispenser theft","Botany","moth","BWOINK","anal vore","stamina")]"
	var/saltsecondarysubject = "[pick("rework","changes","r34","ban","removal","addition","leak","proposal","fanart","introduction","tabling","ERP","bikeshedding","sprites","semen keg","argument","theft","nerf","screeching","salt")]"
	saltresult += "[saltprimarysubject] [saltsecondarysubject]"
	return "[saltresult]!"

/datum/tgs_chat_command/despacito
	name = "despacito"			//someone please high effort this sometime and make it a full on ytdl search
	help_text = "This is so sad."

/datum/tgs_chat_command/despacito/Run()
	return "https://www.youtube.com/watch?v=kJQP7kiw5Fk"
