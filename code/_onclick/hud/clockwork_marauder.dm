/datum/hud/marauder
	var/obj/screen/hosthealth
	var/obj/screen/blockchance
	var/obj/screen/counterchance

/datum/hud/marauder/New(mob/living/simple_animal/hostile/clockwork/guardian/owner)
	..()
	var/obj/screen/using

	healths = new /obj/screen/healths/clock()
	infodisplay += healths

	hosthealth = new /obj/screen/healths/clock()
	hosthealth.screen_loc = ui_internal
	infodisplay += hosthealth

	using = new /obj/screen/marauder/emerge()
	using.screen_loc = ui_zonesel
	static_inventory += using

/datum/hud/marauder/Destroy()
	blockchance = null
	counterchance = null
	hosthealth = null
	return ..()

/mob/living/simple_animal/hostile/clockwork/guardian/create_mob_hud()
	if(client && !hud_used)
		hud_used = new /datum/hud/marauder(src, ui_style2icon(client.prefs.UI_style))

/obj/screen/marauder
	icon = 'icons/mob/clockwork_mobs.dmi'

/obj/screen/marauder/emerge
	icon_state = "clockguard_emerge"
	name = "Emerge/Return"
	desc = "Emerge or Return."

/obj/screen/marauder/emerge/Click()
	if(istype(usr, /mob/living/simple_animal/hostile/clockwork/guardian))
		var/mob/living/simple_animal/hostile/clockwork/guardian/G = usr
		if(G.is_in_host())
			G.try_emerge()
		else
			G.return_to_host()
