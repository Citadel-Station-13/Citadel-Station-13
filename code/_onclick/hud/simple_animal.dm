/datum/hud/living/simple_animal
	ui_style = 'icons/mob/screen_gen.dmi'
/datum/hud/living/simple_animal/New(mob/living/owner)
	..()
	pull_icon = new /obj/screen/pull()
	pull_icon.icon = ui_style
	pull_icon.update_icon()
	pull_icon.screen_loc = ui_living_pull
	pull_icon.hud = src
	static_inventory += pull_icon

	//mob health doll! assumes whatever sprite the mob is
	healthdoll = new /obj/screen/healthdoll/living()
	healthdoll.hud = src
	infodisplay += healthdoll
