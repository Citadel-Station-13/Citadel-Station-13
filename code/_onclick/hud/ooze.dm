///Hud type with targetting dol and a nutrition bar
/datum/hud/ooze/New(mob/living/owner)
	..()

	var/atom/movable/screen/using

	zone_select = new /atom/movable/screen/zone_sel()
	zone_select.icon = ui_style
	zone_select.hud = src
	zone_select.update_icon()
	static_inventory += zone_select

	using = new /atom/movable/screen/resist()
	using.icon = ui_style
	using.screen_loc = ui_pull_resist
	using.hud = src
	hotkeybuttons += using

	pull_icon = new /atom/movable/screen/pull()
	pull_icon.icon = ui_style
	pull_icon.screen_loc = ui_pull_resist
	pull_icon.hud = src
	pull_icon.update_icon()
	static_inventory += pull_icon

	//mob health doll! assumes whatever sprite the mob is
	healthdoll = new /atom/movable/screen/healthdoll/living()
	healthdoll.hud = src
	infodisplay += healthdoll

	alien_plasma_display = new /atom/movable/screen/ooze_nutrition_display //Just going to use the alien plasma display because making new vars for each object is braindead.
	alien_plasma_display.hud = src
	infodisplay += alien_plasma_display

/atom/movable/screen/ooze_nutrition_display
	icon = 'icons/mob/screen_alien.dmi'
	icon_state = "power_display"
	name = "nutrition"
	screen_loc = ui_alienplasmadisplay
