/client/verb/bunker_auto_authorize()
	set name = "Auto Authorize Panic Bunker"
	set desc = "Authorizes your account in the panic bunker of any servers connected to this function."
	set category = "OOC"

	world.send_cross_server_bunker_overrides(key, src)

/world/proc/send_cross_server_bunker_overrides(key, client/C)
	var/comms_key = CONFIG_GET(string/comms_key)
	if(!comms_key)
		return
	var/list/message = list()
	message["ckey"] = key
	message["source"] = "[CONFIG_GET(string/cross_comms_name)]"
	message["key"] = comms_key
	message["auto_bunker_override"] = TRUE
	var/list/servers = CONFIG_GET(keyed_list/cross_server_bunker_override)
	if(!length(servers))
		to_chat(C, "<span class='boldwarning'>AUTOBUNKER: No servers are configured to receive from this one.</span>")
		return
	var/logtext = "[key] ([key_name(C)]) has initiated an autobunker authentication with linked servers."
	message_admins(logtext)
	log_admin(logtext)
	for(var/name in servers)
		var/returned = world.Export("[servers[name]]?[list2params(message)]")
		switch(returned)
			if("Bad Key")
				to_chat(C, "<span class='boldwarning'>AUTOBuNKER: [name] failed to authenticate with this server.</span>")
			if("Function Disabled")
				to_chat(C, "<span class='boldwarning'>AUTOBUNKER: [name] has autobunker receive disabled.</span>")
			if("Success")
				to_chat(C, "<span class='boldwarning'>AUTOBUNKER: Successfully authenticated with [name]. Panic bunker bypass granted to [key].</span>.")
			else
				to_chat(C, "<span class='boldwarning'>AUTOBUNKER: Unknown error ([name]).</span>")
