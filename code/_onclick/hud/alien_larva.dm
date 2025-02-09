/datum/hud/larva
	ui_style = 'icons/mob/screen_alien.dmi'

/datum/hud/larva/New(mob/owner)
	..()
	var/atom/movable/screen/using

	action_intent = new /atom/movable/screen/act_intent/alien(null, src)
	action_intent.icon_state = mymob.a_intent
	static_inventory += action_intent

	healths = new /atom/movable/screen/healths/alien(null, src)
	infodisplay += healths

	alien_queen_finder = new /atom/movable/screen/alien/alien_queen_finder(null, src)
	infodisplay += alien_queen_finder

	pull_icon = new /atom/movable/screen/pull(null, src)
	pull_icon.icon = 'icons/mob/screen_alien.dmi'
	pull_icon.update_icon()
	pull_icon.screen_loc = ui_pull_resist
	hotkeybuttons += pull_icon

	using = new/atom/movable/screen/language_menu(null, src)
	using.screen_loc = ui_alien_language_menu
	static_inventory += using

	zone_select = new /atom/movable/screen/zone_sel/alien(null, src)
	zone_select.update_icon()
	static_inventory += zone_select
