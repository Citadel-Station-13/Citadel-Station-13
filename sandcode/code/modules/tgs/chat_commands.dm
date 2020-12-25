/datum/tgs_chat_command/who
	name = "who"
	help_text = "Lists everyone currently on the server"
	admin_only = FALSE

/datum/tgs_chat_command/who/Run(datum/tgs_chat_user/sender, params)
	return tgswho()

/datum/tgs_chat_command/awho
	name = "awho"
	help_text = "Lists everyone + sneaky admins currently on the server"
	admin_only = TRUE

/datum/tgs_chat_command/awho/Run(datum/tgs_chat_user/sender, params)
	return tgsadminwho()

/datum/tgs_chat_command/restart
	name = "restart"
	help_text = "Forces a restart on the server"
	admin_only = TRUE

/datum/tgs_chat_command/restart/Run(datum/tgs_chat_user/sender)
	to_chat(world, "<span class='boldwarning'>Server restart - Initialized by [sender.friendly_name]</span>")
	send2irc("Server", "[sender.friendly_name] forced a restart.")
	return addtimer(CALLBACK(src, world.TgsEndProcess()), 10)
