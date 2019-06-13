GLOBAL_VAR_INIT(doomball, FALSE)
/client/proc/doomball() //Gives everyone kilts, berets, claymores, and pinpointers, with the objective to hijack the emergency shuttle.
	if(!SSticker.HasRoundStarted())
		alert("The game hasn't started yet!")
		return
	GLOB.doomball = TRUE

	send_to_playing_players("<span class='boldannounce'><font size=6>You feel the power of battle Royale flowing through your veins. TIME TO DOOMBALL!</font></span>")

	for(var/obj/item/disk/nuclear/N in GLOB.poi_list)
		var/datum/component/stationloving/component = N.GetComponent(/datum/component/stationloving)
		if (component)
			component.relocate() //Gets it out of bags and such

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == DEAD || !(H.client))
			continue
		H.make_doomballer()

	message_admins("<span class='adminnotice'>[key_name_admin(usr)] used Doomball!</span>")
	log_admin("[key_name(usr)] used DOOMBALL.")
	addtimer(CALLBACK(SSshuttle.emergency, /obj/docking_port/mobile/emergency.proc/request, null, 1), 50)

/client/proc/only_one_delayed()
	send_to_playing_players("<span class='userdanger'>You feel the power of battle Royale flowing through your veins. TIME TO DOOMBALL!</span>")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] used (delayed) Doomball!</span>")
	log_admin("[key_name(usr)] used delayed Doomball.")
	addtimer(CALLBACK(src, .proc/only_one), 420)

/mob/living/carbon/human/proc/make_doomballer()
mind.add_antag_datum(/datum/antagonist/dodgeball)