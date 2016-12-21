//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/upload
	var/mob/living/silicon/current = null //The target of future law uploads
	icon_screen = "command"

/obj/machinery/computer/upload/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/weapon/aiModule))
		var/obj/item/weapon/aiModule/M = O
		if(src.stat & (NOPOWER|BROKEN|MAINT))
			return
		if(!current)
			user << "<span class='caution'>You haven't selected anything to transmit laws to!</span>"
			playsound(src, 'sound/machines/terminal_error.ogg', 50, 0)
			return
		if(!can_upload_to(current))
			user << "<span class='caution'>Upload failed!</span> Check to make sure [current.name] is functioning properly."
			playsound(src, 'sound/machines/terminal_error.ogg', 50, 0)
			current = null
			return
		var/turf/currentloc = get_turf(current)
		if(currentloc && user.z != currentloc.z)
			user << "<span class='caution'>Upload failed!</span> Unable to establish a connection to [current.name]. You're too far away!"
			playsound(src, 'sound/machines/terminal_error.ogg', 50, 0)
			current = null
			return
		M.install(current.laws, user)
		playsound(src, 'sound/machines/terminal_processing.ogg', 50, 0)
	else
		return ..()

/obj/machinery/computer/upload/proc/can_upload_to(mob/living/silicon/S)
	if(S.stat == DEAD || S.syndicate)
		return 0
	return 1

/obj/machinery/computer/upload/ai
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI."
	circuit = /obj/item/weapon/circuitboard/computer/aiupload

/obj/machinery/computer/upload/ai/attack_hand(mob/user)
	if(..())
		return

	src.current = select_active_ai(user)

	if (!src.current)
		user << "<span class='caution'>No active AIs detected!</span>"
		playsound(src, 'sound/machines/terminal_error.ogg', 50, 0)
	else
		user << "[src.current.name] selected for law changes."
		playsound(src, 'sound/machines/terminal_select.ogg', 50, 0)

/obj/machinery/computer/upload/ai/can_upload_to(mob/living/silicon/ai/A)
	if(!A || !isAI(A))
		return 0
	if(A.control_disabled)
		return 0
	return ..()


/obj/machinery/computer/upload/borg
	name = "cyborg upload console"
	desc = "Used to upload laws to Cyborgs."
	circuit = /obj/item/weapon/circuitboard/computer/borgupload

/obj/machinery/computer/upload/borg/attack_hand(mob/user)
	if(..())
		return

	src.current = select_active_free_borg(user)

	if(!src.current)
		user << "<span class='caution'>No active unslaved cyborgs detected!</span>"
		playsound(src, 'sound/machines/terminal_error.ogg', 50, 0)
	else
		user << "[src.current.name] selected for law changes."
		playsound(src, 'sound/machines/terminal_select.ogg', 50, 0)

/obj/machinery/computer/upload/borg/can_upload_to(mob/living/silicon/robot/B)
	if(!B || !isrobot(B))
		return 0
	if(B.scrambledcodes || B.emagged)
		return 0
	return ..()
