/client/proc/panicbunker()
	set category = "Server"
	set name = "Toggle Panic Bunker"
	if (!CONFIG_GET(flag/sql_enabled))
		to_chat(usr, "<span class='adminnotice'>The Database is not enabled!</span>")
		return

	var/new_pb = !CONFIG_GET(flag/panic_bunker)
	CONFIG_SET(flag/panic_bunker, new_pb)

	log_admin("[key_name(usr)] has toggled the Panic Bunker, it is now [new_pb ? "on" : "off"]")
	message_admins("[key_name_admin(usr)] has toggled the Panic Bunker, it is now [new_pb ? "enabled" : "disabled"].")
	if (new_pb && !SSdbcore.Connect())
		message_admins("The Database is not connected! Panic bunker will not work until the connection is reestablished.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Panic Bunker", "[new_pb ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	send2irc("Panic Bunker", "[key_name(usr)] has toggled the Panic Bunker, it is now [new_pb ? "enabled" : "disabled"].")

/client/proc/addbunkerbypass(ckeytobypass as text)
	set category = "Special Verbs"
	set name = "Add PB Bypass"
	set desc = "Allows a given ckey to connect despite the panic bunker for a given round."
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(usr, "<span class='adminnotice'>The Database is not enabled!</span>")
		return

	GLOB.bunker_passthrough |= ckey(ckeytobypass)
	GLOB.bunker_passthrough[ckey(ckeytobypass)] = world.realtime
	SSpersistence.SavePanicBunker() //we can do this every time, it's okay
	log_admin("[key_name(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")
	message_admins("[key_name_admin(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")
	send2irc("Panic Bunker", "[key_name(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")

/client/proc/revokebunkerbypass(ckeytobypass as text)
	set category = "Special Verbs"
	set name = "Revoke PB Bypass"
	set desc = "Revoke's a ckey's permission to bypass the panic bunker for a given round."
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(usr, "<span class='adminnotice'>The Database is not enabled!</span>")
		return

	GLOB.bunker_passthrough -= ckey(ckeytobypass)
	SSpersistence.SavePanicBunker()
	log_admin("[key_name(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")
	message_admins("[key_name_admin(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")
	send2irc("Panic Bunker", "[key_name(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")
