//Teleporters themselves. Also holy crap, what a code crunch i did on this!
/obj/machinery/cryopod/tele
	name = "CentCom Teleporter"
	desc = "Suited for everyone who wishes to leave the station and go back to CentCom.\n<span class='notice'>This is not for actually getting into CentCom, you will leave the round.</span>"
	icon = 'icons/obj/machines/implantchair.dmi'
	icon_state = "implantchair_open"
	tele = TRUE

	on_store_message = "has been teleported to CentCom."
	on_store_name = "Teleporter Oversight"
