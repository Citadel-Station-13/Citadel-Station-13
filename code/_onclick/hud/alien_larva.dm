/datum/hud/larva
	ui_style = 'icons/mob/screen_alien.dmi'

/datum/hud/larva/New(mob/owner)
	..()
	var/obj/screen/using

	action_intent = new /obj/screen/act_intent/alien()
	action_intent.icon_state = mymob.a_intent
	action_intent.hud = src
	static_inventory += action_intent

	healths = new /obj/screen/healths/alien()
	healths.hud = src
	infodisplay += healths

	alien_queen_finder = new /obj/screen/alien/alien_queen_finder()
	alien_queen_finder.hud = src
	infodisplay += alien_queen_finder

	pull_icon = new /obj/screen/pull()
	pull_icon.icon = 'icons/mob/screen_alien.dmi'
	pull_icon.hud = src
	pull_icon.update_icon()
	pull_icon.screen_loc = ui_pull_resist
	hotkeybuttons += pull_icon

	using = new/obj/screen/language_menu
	using.screen_loc = ui_alien_language_menu
	using.hud = src
	static_inventory += using

	zone_select = new /obj/screen/zone_sel/alien()
	zone_select.hud = src
	zone_select.update_icon()
	static_inventory += zone_select
