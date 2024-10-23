/obj/machinery/posialert
	name = "automated positronic alert console"
	desc = "A console that will ping when a positronic personality is available for download."
	icon = 'icons/obj/machines/terminals.dmi'
	icon_state = "posialert"
	var/inuse = FALSE
	var/online = TRUE

	var/obj/item/radio/radio
	var/radio_key = /obj/item/encryptionkey/headset_sci
	var/science_channel = "Science"

/obj/machinery/posialert/Initialize(mapload, ndir, building)
	. = ..()
	radio = new(src)
	radio.keyslot = new radio_key
	radio.listening = 0
	radio.recalculateChannels()
	if(building)
		setDir(ndir)
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -32 : 32)
		pixel_y = (dir & 3)? (dir ==1 ? -32 : 32) : 0


/obj/machinery/posialert/Destroy()
	QDEL_NULL(radio)
	return ..()

/obj/item/wallframe/posialert
	name = "automated positronic alert console frame"
	desc = "Used to build positronic alert consoles, just secure to the wall."
	icon_state = "newscaster"
	custom_materials = list(/datum/material/iron=14000, /datum/material/glass=8000)
	result_path = /obj/machinery/posialert

/obj/machinery/posialert/attack_hand(mob/living/user)
	online = !online
	to_chat(user, "<span class='warning'>You turn the posi-alert system [online ? "on" : "off"]!</span>")
	return

/obj/machinery/posialert/attack_ghost(mob/user)
	. = ..()
	if(!online)
		return
	if(inuse)
		return
	inuse = TRUE
	flick("posialertflash",src)
	visible_message("There are positronic personalities available!")
	radio.talk_into(src, "There are positronic personalities available!", science_channel)
	playsound(loc, 'sound/machines/ping.ogg', 50)
	addtimer(CALLBACK(src, PROC_REF(liftcooldown)), 300)

/obj/machinery/posialert/proc/liftcooldown()
	inuse = FALSE
