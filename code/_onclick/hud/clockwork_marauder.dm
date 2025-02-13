/datum/hud/marauder
	var/atom/movable/screen/hosthealth
	var/atom/movable/screen/blockchance
	var/atom/movable/screen/counterchance

/datum/hud/marauder/New(mob/living/simple_animal/hostile/clockwork/guardian/owner)
	..()
	var/atom/movable/screen/using

	healths = new /atom/movable/screen/healths/clock(null, src)
	infodisplay += healths

	hosthealth = new /atom/movable/screen/healths/clock(null, src)
	hosthealth.screen_loc = ui_internal
	infodisplay += hosthealth

	using = new /atom/movable/screen/marauder/emerge(null, src)
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

/atom/movable/screen/marauder
	icon = 'icons/mob/clockwork_mobs.dmi'

/atom/movable/screen/marauder/emerge
	icon_state = "clockguard_emerge"
	name = "Emerge/Return"
	desc = "Emerge or Return."

/atom/movable/screen/marauder/emerge/Click()
	if(istype(usr, /mob/living/simple_animal/hostile/clockwork/guardian))
		var/mob/living/simple_animal/hostile/clockwork/guardian/G = usr
		if(G.is_in_host())
			G.try_emerge()
		else
			G.return_to_host()
