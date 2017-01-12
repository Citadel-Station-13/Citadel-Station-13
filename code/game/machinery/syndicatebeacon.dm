//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//  Beacon randomly spawns in space
//	When a non-traitor (no special role in /mind) uses it, he is given the choice to become a traitor
//	If he accepts there is a random chance he will be accepted, rejected, or rejected and killed
//	Bringing certain items can help improve the chance to become a traitor


/obj/machinery/syndicate_beacon
	name = "ominous beacon"
	desc = "This looks suspicious..."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndbeacon"

	anchored = 1
	density = 1

	var/temptext = ""
	var/selfdestructing = 0
	var/charges = 1

/obj/machinery/syndicate_beacon/attack_hand(mob/user)
	usr.set_machine(src)
	var/dat = "<font color=#005500><i>Scanning [pick("retina pattern", "voice print", "fingerprints", "dna sequence")]...<br>Identity confirmed,<br></i></font>"
	if(istype(user, /mob/living/carbon/human) || istype(user, /mob/living/silicon/ai))
		if(is_special_character(user))
			dat += "<font color=#07700><i>Operative record found. Greetings, Agent [user.name].</i></font><br>"
		else if(charges < 1)
			dat += "<TT>Connection severed.</TT><BR>"
		else
			var/honorific = "Mr."
			if(user.gender == FEMALE)
				honorific = "Ms."
			dat += "<font color=red><i>Identity not found in operative database. What can the Syndicate do for you today, [honorific] [user.name]?</i></font><br>"
			if(!selfdestructing)
				dat += "<br><br><A href='?src=\ref[src];betraitor=1;traitormob=\ref[user]'>\"[pick("I want to switch teams.", "I want to work for you.", "Let me join you.", "I can be of use to you.", "You want me working for you, and here's why...", "Give me an objective.", "How's the 401k over at the Syndicate?")]\"</A><BR>"
	dat += temptext
	user << browse(dat, "window=syndbeacon")
	onclose(user, "syndbeacon")

/obj/machinery/syndicate_beacon/Topic(href, href_list)
	if(..())
		return
	if(href_list["betraitor"])
		if(charges < 1)
			src.updateUsrDialog()
			return
		var/mob/M = locate(href_list["traitormob"])
		if(M.mind.special_role)
			temptext = "<i>We have no need for you at this time. Have a pleasant day.</i><br>"
			src.updateUsrDialog()
			return
		charges -= 1
		switch(rand(1,2))
			if(1)
				temptext = "<font color=red><i><b>Double-crosser. You planned to betray us from the start. Allow us to repay the favor in kind.</b></i></font>"
				src.updateUsrDialog()
				addtimer(src, "selfdestruct", rand(50, 200))
				return
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/N = M
			ticker.mode.equip_traitor(N)
			ticker.mode.traitors += N.mind
			N.mind.special_role = "traitor"
			var/objective = "Free Objective"
			switch(rand(1,100))
				if(1 to 50)
					objective = "Steal [pick("a hand teleporter", "the Captain's antique laser gun", "a jetpack", "the Captain's ID", "the Captain's jumpsuit")]."
				if(51 to 60)
					objective = "Destroy 70% or more of the station's plasma tanks."
				if(61 to 70)
					objective = "Cut power to 80% or more of the station's tiles."
				if(71 to 80)
					objective = "Destroy the AI."
				if(81 to 90)
					objective = "Kill all monkeys aboard the station."
				else
					objective = "Make certain at least 80% of the station evacuates on the shuttle."
			var/datum/objective/custom_objective = new(objective)
			custom_objective.owner = N.mind
			N.mind.objectives += custom_objective

			var/datum/objective/escape/escape_objective = new
			escape_objective.owner = N.mind
			N.mind.objectives += escape_objective


			M << "<B>You have joined the ranks of the Syndicate and become a traitor to the station!</B>"

			var/obj_count = 1
			for(var/datum/objective/OBJ in M.mind.objectives)
				M << "<B>Objective #[obj_count]</B>: [OBJ.explanation_text]"
				obj_count++

	src.updateUsrDialog()
	return


/obj/machinery/syndicate_beacon/proc/selfdestruct()
	selfdestructing = 1
	spawn() explosion(src.loc, rand(3,8), rand(1,3), 1, 10)

////////////////////////////////////////
//Singularity beacon
////////////////////////////////////////
/obj/machinery/power/singularity_beacon
	name = "ominous beacon"
	desc = "This looks suspicious..."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "beacon"

	anchored = 0
	density = 1
	layer = BELOW_MOB_LAYER //so people can't hide it and it's REALLY OBVIOUS
	stat = 0

	var/active = 0
	var/icontype = "beacon"


/obj/machinery/power/singularity_beacon/proc/Activate(mob/user = null)
	if(surplus() < 1500)
		if(user) user << "<span class='notice'>The connected wire doesn't have enough current.</span>"
		return
	for(var/obj/singularity/singulo in world)
		if(singulo.z == z)
			singulo.target = src
	icon_state = "[icontype]1"
	active = 1
	machines |= src
	if(user)
		user << "<span class='notice'>You activate the beacon.</span>"


/obj/machinery/power/singularity_beacon/proc/Deactivate(mob/user = null)
	for(var/obj/singularity/singulo in world)
		if(singulo.target == src)
			singulo.target = null
	icon_state = "[icontype]0"
	active = 0
	if(user)
		user << "<span class='notice'>You deactivate the beacon.</span>"


/obj/machinery/power/singularity_beacon/attack_ai(mob/user)
	return


/obj/machinery/power/singularity_beacon/attack_hand(mob/user)
	if(anchored)
		return active ? Deactivate(user) : Activate(user)
	else
		user << "<span class='warning'>You need to screw the beacon to the floor first!</span>"
		return


/obj/machinery/power/singularity_beacon/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W,/obj/item/weapon/screwdriver))
		if(active)
			user << "<span class='warning'>You need to deactivate the beacon first!</span>"
			return

		if(anchored)
			anchored = 0
			user << "<span class='notice'>You unscrew the beacon from the floor.</span>"
			disconnect_from_network()
			return
		else
			if(!connect_to_network())
				user << "<span class='warning'>This device must be placed over an exposed, powered cable node!</span>"
				return
			anchored = 1
			user << "<span class='notice'>You screw the beacon to the floor and attach the cable.</span>"
			return
	else
		return ..()

/obj/machinery/power/singularity_beacon/Destroy()
	if(active)
		Deactivate()
	return ..()

//stealth direct power usage
/obj/machinery/power/singularity_beacon/process()
	if(!active)
		return PROCESS_KILL
	else
		if(surplus() > 1500)
			add_load(1500)
		else
			Deactivate()


/obj/machinery/power/singularity_beacon/syndicate
	icontype = "beaconsynd"
	icon_state = "beaconsynd0"

// SINGULO BEACON SPAWNER
/obj/item/device/sbeacondrop
	name = "suspicious beacon"
	icon = 'icons/obj/radio.dmi'
	icon_state = "beacon"
	desc = "A label on it reads: <i>Warning: Activating this device will send a special beacon to your location</i>."
	origin_tech = "bluespace=6;syndicate=5"
	w_class = 2
	var/droptype = /obj/machinery/power/singularity_beacon/syndicate


/obj/item/device/sbeacondrop/attack_self(mob/user)
	if(user)
		user << "<span class='notice'>Locked In.</span>"
		new droptype( user.loc )
		playsound(src, 'sound/effects/pop.ogg', 100, 1, 1)
		qdel(src)
	return

/obj/item/device/sbeacondrop/bomb
	desc = "A label on it reads: <i>Warning: Activating this device will send a high-ordinance explosive to your location</i>."
	droptype = /obj/machinery/syndicatebomb
	origin_tech = "bluespace=5;syndicate=5"

/obj/item/device/sbeacondrop/powersink
	desc = "A label on it reads: <i>Warning: Activating this device will send a power draining device to your location</i>."
	droptype = /obj/item/device/powersink
	origin_tech = "bluespace=4;syndicate=5"
