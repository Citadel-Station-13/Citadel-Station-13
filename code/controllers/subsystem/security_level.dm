// NOT THE SAME AS TG! THIS IS BAREMETAL JUST TO MAKE COMSIGS WORK!
SUBSYSTEM_DEF(security_level)
	name = "Security Level"
	can_fire = FALSE // We will control when we fire in this subsystem
	init_order = INIT_ORDER_SECURITY_LEVEL

/**
 * Sets a new security level as our current level
 *
 * This is how everything should change the security level.
 *
 * Arguments:
 * * new_level - The new security level that will become our current level
 */
/datum/controller/subsystem/security_level/proc/set_level(new_level)
	if(!isnum(new_level))
		new_level = SECLEVEL2NUM(new_level)

	//Will not be announced if you try to set to the same level as it already is
	if(new_level >= SEC_LEVEL_GREEN && new_level <= SEC_LEVEL_DELTA && new_level != GLOB.security_level)
		switch(new_level)
			if(SEC_LEVEL_GREEN)
				minor_announce(CONFIG_GET(string/alert_green), "Attention! Security level lowered to green:")
				if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
					if(GLOB.security_level >= SEC_LEVEL_RED)
						SSshuttle.emergency.modTimer(4)
					else if(GLOB.security_level == SEC_LEVEL_AMBER)
						SSshuttle.emergency.modTimer(2.5)
					else
						SSshuttle.emergency.modTimer(1.66)
				GLOB.security_level = SEC_LEVEL_GREEN
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()
			if(SEC_LEVEL_BLUE)
				if(GLOB.security_level < SEC_LEVEL_BLUE)
					minor_announce(CONFIG_GET(string/alert_blue_upto), "Attention! Security level elevated to blue:",1)
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						SSshuttle.emergency.modTimer(0.6)
				else
					minor_announce(CONFIG_GET(string/alert_blue_downto), "Attention! Security level lowered to blue:")
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						if(GLOB.security_level >= SEC_LEVEL_RED)
							SSshuttle.emergency.modTimer(2.4)
						else
							SSshuttle.emergency.modTimer(1.5)
				GLOB.security_level = SEC_LEVEL_BLUE
				sound_to_playing_players('sound/misc/voybluealert.ogg', volume = 50) // Citadel change - Makes alerts play a sound
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()
			if(SEC_LEVEL_AMBER)
				if(GLOB.security_level < SEC_LEVEL_AMBER)
					minor_announce(CONFIG_GET(string/alert_amber_upto), "Attention! Security level elevated to amber:",1)
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						if(GLOB.security_level == SEC_LEVEL_GREEN)
							SSshuttle.emergency.modTimer(0.4)
						else
							SSshuttle.emergency.modTimer(0.66)
				else
					minor_announce(CONFIG_GET(string/alert_amber_downto), "Attention! Security level lowered to amber:")
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						SSshuttle.emergency.modTimer(1.6)
				GLOB.security_level = SEC_LEVEL_AMBER
				sound_to_playing_players('sound/effects/alert.ogg', volume = 50) // Citadel change - Makes alerts play a sound
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()
			if(SEC_LEVEL_RED)
				if(GLOB.security_level < SEC_LEVEL_RED)
					minor_announce(CONFIG_GET(string/alert_red_upto), "Attention! Code red!",1)
					if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
						if(GLOB.security_level == SEC_LEVEL_GREEN)
							SSshuttle.emergency.modTimer(0.25)
						else if(GLOB.security_level == SEC_LEVEL_BLUE)
							SSshuttle.emergency.modTimer(0.416)
						else
							SSshuttle.emergency.modTimer(0.625)
				else
					minor_announce(CONFIG_GET(string/alert_red_downto), "Attention! Code red!")
				GLOB.security_level = SEC_LEVEL_RED
				sound_to_playing_players('sound/misc/voyalert.ogg', volume = 50) // Citadel change - Makes alerts play a sound

				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()
				for(var/obj/machinery/computer/shuttle/pod/pod in GLOB.machines)
					pod.admin_controlled = FALSE
			if(SEC_LEVEL_DELTA)
				minor_announce(CONFIG_GET(string/alert_delta), "Attention! Delta security level reached!",1)
				if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
					if(GLOB.security_level < SEC_LEVEL_BLUE)
						SSshuttle.emergency.modTimer(0.25)
					else if(GLOB.security_level == SEC_LEVEL_BLUE)
						SSshuttle.emergency.modTimer(0.416)
					else
						SSshuttle.emergency.modTimer(0.625)
				GLOB.security_level = SEC_LEVEL_DELTA
				sound_to_playing_players('sound/misc/deltakalaxon.ogg') // Citadel change - Makes alerts play a sound
				for(var/obj/machinery/firealarm/FA in GLOB.machines)
					if(is_station_level(FA.z))
						FA.update_icon()
				for(var/obj/machinery/computer/shuttle/pod/pod in GLOB.machines)
					pod.admin_controlled = FALSE
		if(new_level >= SEC_LEVEL_RED)
			for(var/obj/machinery/door/D in GLOB.machines)
				if(D.red_alert_access)
					D.visible_message("<span class='notice'>[D] whirrs as it automatically lifts access requirements!</span>")
					playsound(D, 'sound/machines/boltsup.ogg', 50, TRUE)
		SEND_SIGNAL(src, COMSIG_SECURITY_LEVEL_CHANGED, new_level)
		SSblackbox.record_feedback("tally", "security_level_changes", 1, NUM2SECLEVEL(GLOB.security_level))
		SSnightshift.check_nightshift()
	else
		return
