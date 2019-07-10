/datum/controller/subsystem/shuttle/proc/autoEnd() //CIT CHANGE - allows shift to end after 2 hours have passed.
	if((world.realtime - SSshuttle.realtimeofstart) > auto_call && EMERGENCY_IDLE_OR_RECALLED) //2 hours
		SSshuttle.emergency.request(silent = TRUE)
		priority_announce("The shift has come to an end and the shuttle called. [seclevel2num(get_security_level()) == SEC_LEVEL_RED ? "Red Alert state confirmed: Dispatching priority shuttle. " : "" ]It will arrive in [emergency.timeLeft(600)] minutes.", null, 'sound/ai/shuttlecalled.ogg', "Priority")
		log_game("Round time limit reached. Shuttle has been auto-called.")
		message_admins("Round time limit reached. Shuttle called.")
		emergencyNoRecall = TRUE
