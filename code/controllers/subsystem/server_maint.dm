SUBSYSTEM_DEF(server_maint)
	name = "Server Tasks"
	wait = 6000
	flags = SS_NO_TICK_CHECK

/datum/controller/subsystem/server_maint/Initialize(timeofday)
	if (config.hub)
		world.visibility = 1
	..()

/datum/controller/subsystem/server_maint/fire()
	//handle kicking inactive players
	if(config.kick_inactive > 0)
		for(var/client/C in GLOB.clients)
			if(C.is_afk(INACTIVITY_KICK))
				if(!istype(C.mob, /mob/dead))
					log_access("AFK: [key_name(C)]")
					to_chat(C, "<span class='danger'>You have been inactive for more than 10 minutes and have been disconnected.</span>")
					qdel(C)

	if(config.sql_enabled)
		sql_poll_population()
