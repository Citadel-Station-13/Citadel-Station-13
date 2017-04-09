/obj/machinery/computer/shuttle/ferry
	name = "transport ferry console"
	circuit = /obj/item/weapon/circuitboard/computer/ferry
	shuttleId = "ferry"
	possible_destinations = "ferry_home;ferry_away"
	req_access = list(GLOB.access_cent_general)

	var/aiControlDisabled = 1

/obj/machinery/computer/shuttle/ferry/proc/canAIControl(mob/user)
	return ((aiControlDisabled != 1));

/obj/machinery/computer/shuttle/ferry/attack_ai(mob/user)
	if(!src.canAIControl(user))
		return

/obj/machinery/computer/shuttle/ferry/request
	name = "ferry console"
	circuit = /obj/item/weapon/circuitboard/computer/ferry/request
	var/last_request //prevents spamming admins
	var/cooldown = 600
	possible_destinations = "ferry_home;ferry_away"
	req_access = list(GLOB.access_cent_general)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/machinery/computer/shuttle/ferry/request/Topic(href, href_list)
	..()
	if(href_list["request"])
		if(last_request && (last_request + cooldown > world.time))
			return
		last_request = world.time
		to_chat(usr, "<span class='notice'>Your request has been recieved by Centcom.</span>")
		to_chat(GLOB.admins, "<b>FERRY: <font color='blue'>[key_name_admin(usr)] (<A HREF='?_src_=holder;adminmoreinfo=\ref[usr]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[usr]'>FLW</A>) (<A HREF='?_src_=holder;secrets=moveferry'>Move Ferry</a>)</b> is requesting to move the transport ferry to Centcom.</font>")
