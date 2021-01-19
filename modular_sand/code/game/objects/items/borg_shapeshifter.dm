/obj/item/borg_shapeshifter
	name = "cyborg chameleon projector"
	icon = 'icons/obj/device.dmi'
	icon_state = "shield0"
	flags_1 = CONDUCT_1
	item_flags = NOBLUDGEON
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/friendlyName
	var/savedName
	var/savedIcon
	var/savedBubbleIcon
	var/savedOverride
	var/savedPixelOffset
	var/savedModuleName
	var/active = FALSE
	var/activationCost = 150
	var/activationUpkeep = 5
	var/disguise = null
	var/disguise_icon_override = null
	var/disguise_pixel_offset = null
	var/disguise_dogborg = FALSE
	var/mob/listeningTo
	var/list/signalCache = list( // list here all signals that should break the camouflage
			COMSIG_PARENT_ATTACKBY,
			COMSIG_ATOM_ATTACK_HAND,
			COMSIG_MOVABLE_IMPACT_ZONE,
			COMSIG_ATOM_BULLET_ACT,
			COMSIG_ATOM_EX_ACT,
			COMSIG_ATOM_FIRE_ACT,
			COMSIG_ATOM_EMP_ACT,
			)
	var/mob/living/silicon/robot/user // needed for process()
	var/animation_playing = FALSE
	var/list/borgmodels = list(
							"(Standard) Default", 
							"(Standard) Heavy",
							"(Standard) Sleek", 
							"(Standard) Marina",
							"(Standard) Robot",
							"(Standard) Eyebot",
							"(Medical) Default",
							"(Medical) Heavy",
							"(Medical) Sleek",
							"(Medical) Marina",
							"(Medical) Droid",
							"(Medical) Eyebot",
							"(Medical) Medihound",
							"(Medical) Medihound Dark",
							"(Medical) Vale",
							"(Engineering) Default",
							"(Engineering) Default - Treads",
							"(Engineering) Loader",
							"(Engineering) Handy",
							"(Engineering) Sleek",
							"(Engineering) Can",
							"(Engineering) Marina",
							"(Engineering) Spider",
							"(Engineering) Heavy",
							"(Miner) Lavaland",
							"(Miner) Asteroid",
							"(Miner) Droid",
							"(Miner) Sleek",
							"(Miner) Marina",
							"(Miner) Can",
							"(Miner) Heavy",
							"(Service) Waitress",
							"(Service) Butler",
							"(Service) Bro",
							"(Service) Can",
							"(Service) Tophat",
							"(Service) Sleek",
							"(Service) Heavy",
							"(Janitor) Default",
							"(Janitor) Marina",
							"(Janitor) Sleek",
							"(Janitor) Can")

/obj/item/borg_shapeshifter/Initialize()
	. = ..()
	friendlyName = pick(GLOB.ai_names)

/obj/item/borg_shapeshifter/Destroy()
	return ..()

/obj/item/borg_shapeshifter/dropped(mob/user)
	. = ..()
	disrupt(user)

/obj/item/borg_shapeshifter/equipped(mob/user)
	. = ..()
	disrupt(user)

/**
  * check_menu: Checks if we are allowed to interact with a radial menu
  *
  * Arguments:
  * * user The mob interacting with a menu
  */
/obj/item/borg_shapeshifter/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/borg_shapeshifter/attack_self(mob/living/silicon/robot/user)
	if (user && user.cell && user.cell.charge >  activationCost)
		if (isturf(user.loc))
			toggle(user)
		else
			to_chat(user, "<span class='warning'>You can't use [src] while inside something!</span>")
	else
		to_chat(user, "<span class='warning'>You need at least [activationCost] charge in your cell to use [src]!</span>")

/obj/item/borg_shapeshifter/proc/toggle(mob/living/silicon/robot/user)
	if(active)
		playsound(src, 'sound/effects/pop.ogg', 100, TRUE, -6)
		to_chat(user, "<span class='notice'>You deactivate \the [src].</span>")
		deactivate(user)
	else
		if(animation_playing)
			to_chat(user, "<span class='notice'>\the [src] is recharging.</span>")
			return
		var/mob/living/silicon/robot/R = loc
		var/static/list/module_icons = sortList(list(
		"Standard" = image(icon = 'icons/mob/robots.dmi', icon_state = "robot"),
		"Medical" = image(icon = 'icons/mob/robots.dmi', icon_state = "medical"),
		"Engineer" = image(icon = 'icons/mob/robots.dmi', icon_state = "engineer"),
		"Security" = image(icon = 'icons/mob/robots.dmi', icon_state = "sec"),
		"Service" = image(icon = 'icons/mob/robots.dmi', icon_state = "service_f"),
		"Miner" = image(icon = 'icons/mob/robots.dmi', icon_state = "miner"),
		"Peacekeeper" = image(icon = 'icons/mob/robots.dmi', icon_state = "peace"),
		"Clown" = image(icon = 'icons/mob/robots.dmi', icon_state = "clown"),
		"Syndicate" = image(icon = 'icons/mob/robots.dmi', icon_state = "synd_sec")
		))
		var/module_selection = show_radial_menu(R, R , module_icons, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)
		if(!module_selection)
			return FALSE

		switch(module_selection)
			if("Standard")
				var/static/list/standard_icons = sortList(list(
					"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "robot")
				))
				var/borg_icon = show_radial_menu(R, R , standard_icons, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)
				if(!borg_icon)
					return FALSE
				switch(borg_icon)
					if("Default")
						disguise = "robot"
						disguise_icon_override = 'icons/mob/robots.dmi'
					else
						return FALSE

			if("Medical")
				var/static/list/med_icons = list(
					"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "medical"),
					"Droid" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "medical"),
					"Sleek" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "sleekmed"),
					"Marina" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "marinamed"),
					"Eyebot" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "eyebotmed"),
					"Heavy" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "heavymed"),
					"Drake" = image(icon = 'modular_sand/icons/mob/cyborg/drakemech.dmi', icon_state = "drakemedbox")
				)
				var/list/L = list("Medihound" = "medihound", "Medihound Dark" = "medihounddark", "Vale" = "valemed")
				for(var/a in L)
					var/image/wide = image(icon = 'modular_citadel/icons/mob/widerobot.dmi', icon_state = L[a])
					wide.pixel_x = -16
					med_icons[a] = wide
				med_icons = sortList(med_icons)
				var/borg_icon = show_radial_menu(R, R , med_icons, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)
				if(!borg_icon)
					return FALSE
				switch(borg_icon)
					if("Default")
						disguise = "medical"
						disguise_icon_override = 'icons/mob/robots.dmi'
					if("Droid")
						disguise = "medical"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Sleek")
						disguise = "sleekmed"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Marina")
						disguise = "marinamed"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Eyebot")
						disguise = "eyebotmed"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Heavy")
						disguise = "heavymed"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Medihound")
						disguise = "medihound"
						disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					if("Medihound Dark")
						disguise = "medihounddark"
						disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					if("Vale")
						disguise = "valemed"
						disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					if("Drake")
						disguise = "drakemed"
						disguise_icon_override = 'modular_sand/icons/mob/cyborg/drakemech.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					else
						return FALSE

			if("Engineer")
				var/static/list/engi_icons = list(
					"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "engineer"),
					"Default - Treads" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "engi-tread"),
					"Loader" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "loaderborg"),
					"Handy" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "handyeng"),
					"Sleek" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "sleekeng"),
					"Can" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "caneng"),
					"Marina" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "marinaeng"),
					"Spider" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "spidereng"),
					"Heavy" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "heavyeng"),
					"Drake" = image(icon = 'modular_sand/icons/mob/cyborg/drakemech.dmi', icon_state = "drakeengbox")
				)
				var/list/L = list("Pup Dozer" = "pupdozer", "Vale" = "valeeng")
				for(var/a in L)
					var/image/wide = image(icon = 'modular_citadel/icons/mob/widerobot.dmi', icon_state = L[a])
					wide.pixel_x = -16
					engi_icons[a] = wide
				engi_icons = sortList(engi_icons)
				var/borg_icon = show_radial_menu(R, R , engi_icons, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)
				if(!borg_icon)
					return FALSE
				switch(borg_icon)
					if("Default")
						disguise = "engineer"
						disguise_icon_override = 'icons/mob/robots.dmi'
					if("Default - Treads")
						disguise = "engi-tread"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Loader")
						disguise = "loaderborg"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Handy")
						disguise = "handyeng"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Sleek")
						disguise = "sleekeng"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Can")
						disguise = "caneng"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Marina")
						disguise = "marinaeng"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Spider")
						disguise = "spidereng"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Heavy")
						disguise = "heavyeng"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Pup Dozer")
						disguise = "pupdozer"
						disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					if("Vale")
						disguise = "valeeng"
						disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					if("Alina")
						disguise = "alina-eng"
						disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					if("Drake")
						disguise = "drakeeng"
						disguise_icon_override = 'modular_sand/icons/mob/cyborg/drakemech.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					else
						return FALSE
			if("Security")
				var/static/list/sec_icons = list(
					"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "sec"),
					"Default - Treads" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "sec-tread"),
					"Sleek" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "sleeksec"),
					"Can" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "cansec"),
					"Marina" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "marinasec"),
					"Spider" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "spidersec"),
					"Heavy" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "heavysec"),
					"Drake" = image(icon = 'modular_sand/icons/mob/cyborg/drakemech.dmi', icon_state = "drakesecbox")
				)
				var/list/L = list("K9" = "k9", "Vale" = "valesec", "K9 Dark" = "k9dark")
				for(var/a in L)
					var/image/wide = image(icon = 'modular_citadel/icons/mob/widerobot.dmi', icon_state = L[a])
					wide.pixel_x = -16
					sec_icons[a] = wide
				sec_icons = sortList(sec_icons)
				var/borg_icon = show_radial_menu(R, R , sec_icons, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)
				if(!borg_icon)
					return FALSE
				switch(borg_icon)
					if("Default")
						disguise = "sec"
						disguise_icon_override = 'icons/mob/robots.dmi'
					if("Default - Treads")
						disguise = "sec-tread"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Sleek")
						disguise = "sleeksec"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Marina")
						disguise = "marinasec"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Can")
						disguise = "cansec"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Spider")
						disguise = "spidersec"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Heavy")
						disguise = "heavysec"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("K9")
						disguise = "k9"
						disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					if("Alina")
						disguise = "alina-sec"
						disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					if("K9 Dark")
						disguise = "k9dark"
						disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					if("Vale")
						disguise = "valesec"
						disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					if("Drake")
						disguise = "drakesec"
						disguise_icon_override = 'modular_sand/icons/mob/cyborg/drakemech.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					else
						return FALSE
			if("Service")
				var/static/list/service_icons = list(
					"(Service) Waitress" = image(icon = 'icons/mob/robots.dmi', icon_state = "service_f"),
					"(Service) Butler" = image(icon = 'icons/mob/robots.dmi', icon_state = "service_m"),
					"(Service) Bro" = image(icon = 'icons/mob/robots.dmi', icon_state = "brobot"),
					"(Service) Can" = image(icon = 'icons/mob/robots.dmi', icon_state = "kent"),
					"(Service) Tophat" = image(icon = 'icons/mob/robots.dmi', icon_state = "tophat"),
					"(Service) Sleek" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "sleekserv"),
					"(Service) Heavy" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "heavyserv"),
					"(Janitor) Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "janitor"),
					"(Janitor) Marina" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "marinajan"),
					"(Janitor) Sleek" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "sleekjan"),
					"(Janitor) Can" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "canjan"),
					"(Janitor) Heavy" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "heavyres"),
					"(Janitor) Drake" = image(icon = 'modular_sand/icons/mob/cyborg/drakemech.dmi', icon_state = "drakejanitbox")
				)
				var/list/L = list("(Service) DarkK9" = "k50", "(Service) Vale" = "valeserv", "(Service) ValeDark" = "valeservdark",
								"(Janitor) Scrubpuppy" = "scrubpup")
				for(var/a in L)
					var/image/wide = image(icon = 'modular_citadel/icons/mob/widerobot.dmi', icon_state = L[a])
					wide.pixel_x = -16
					service_icons[a] = wide
				service_icons = sortList(service_icons)
				var/borg_icon = show_radial_menu(R, R , service_icons, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)
				if(!borg_icon)
					return FALSE
				switch(borg_icon)
					if("(Service) Waitress")
						disguise = "service_f"
						disguise_icon_override = 'icons/mob/robots.dmi'
					if("(Service) Butler")
						disguise = "service_m"
						disguise_icon_override = 'icons/mob/robots.dmi'
					if("(Service) Bro")
						disguise = "brobot"
						disguise_icon_override = 'icons/mob/robots.dmi'
					if("(Service) Can")
						disguise = "kent"
						disguise_icon_override = 'icons/mob/robots.dmi'
					if("(Service) Tophat")
						disguise = "tophat"
						disguise_icon_override = 'icons/mob/robots.dmi'
					if("(Service) Sleek")
						disguise = "sleekserv"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("(Service) Heavy")
						disguise = "heavyserv"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("(Service) DarkK9")
						disguise = "k50"
						disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					if("(Service) Vale")
						disguise = "valeserv"
						disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					if("(Service) ValeDark")
						disguise = "valeservdark"
						disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					if("(Janitor) Default")
						disguise = "janitor"
						disguise_icon_override = 'icons/mob/robots.dmi'
					if("(Janitor) Marina")
						disguise = "marinajan"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("(Janitor) Sleek")
						disguise = "sleekjan"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("(Janitor) Can")
						disguise = "canjan"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("(Janitor) Heavy")
						disguise = "heavyres"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("(Janitor) Scrubpuppy")
						disguise = "scrubpup"
						disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					if("(Janitor) Drake")
						disguise = "drakejanit"
						disguise_icon_override = 'modular_sand/icons/mob/cyborg/drakemech.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					else
						return FALSE
			if("Miner")
				var/static/list/mining_icons = list(
					"Lavaland" = image(icon = 'icons/mob/robots.dmi', icon_state = "miner"),
					"Asteroid" = image(icon = 'icons/mob/robots.dmi', icon_state = "minerOLD"),
					"Droid" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "miner"),
					"Sleek" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "sleekmin"),
					"Marina" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "marinamin"),
					"Can" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "canmin"),
					"Heavy" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "heavymin"),
					"Drake" = image(icon = 'modular_sand/icons/mob/cyborg/drakemech.dmi', icon_state = "drakeminebox")
				)
				var/list/L = list("Blade" = "blade", "Vale" = "valemine")
				for(var/a in L)
					var/image/wide = image(icon = 'modular_citadel/icons/mob/widerobot.dmi', icon_state = L[a])
					wide.pixel_x = -16
					mining_icons[a] = wide
				mining_icons = sortList(mining_icons)
				var/borg_icon = show_radial_menu(R, R , mining_icons, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)
				if(!borg_icon)
					return FALSE
				switch(borg_icon)
					if("Lavaland")
						disguise = "miner"
						disguise_icon_override = 'icons/mob/robots.dmi'
					if("Asteroid")
						disguise = "minerOLD"
						disguise_icon_override = 'icons/mob/robots.dmi'
					if("Droid")
						disguise = "miner"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Sleek")
						disguise = "sleekmin"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Can")
						disguise = "canmin"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Marina")
						disguise = "marinamin"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Spider")
						disguise = "spidermin"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Heavy")
						disguise = "heavymin"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Blade")
						disguise = "blade"
						disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					if("Vale")
						disguise = "valemine"
						disguise_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					if("Drake")
						disguise = "drakemine"
						disguise_icon_override = 'modular_sand/icons/mob/cyborg/drakemech.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					else
						return FALSE
			if("Peacekeeper")
				var/static/list/peace_icons = sortList(list(
					"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "peace"),
					"Borgi" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "borgi"),
					"Spider" = image(icon = 'modular_citadel/icons/mob/robots.dmi', icon_state = "whitespider"),
					"Drake" = image(icon = 'modular_sand/icons/mob/cyborg/drakemech.dmi', icon_state = "drakepeacebox")
				))
				var/borg_icon = show_radial_menu(R, R , peace_icons, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)
				if(!borg_icon)
					return FALSE
				switch(borg_icon)
					if("Default")
						disguise = "peace"
						disguise_icon_override = 'icons/mob/robots.dmi'
					if("Spider")
						disguise = "whitespider"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Borgi")
						disguise = "borgi"
						disguise_icon_override = 'modular_citadel/icons/mob/robots.dmi'
					if("Drake")
						disguise = "drakepeace"
						disguise_icon_override = 'modular_sand/icons/mob/cyborg/drakemech.dmi'
						disguise_pixel_offset = -16
						disguise_dogborg = TRUE
					else
						return FALSE
			if("Clown")
				var/static/list/clown_icons = sortList(list(
					"Default" = image(icon = 'icons/mob/robots.dmi', icon_state = "clown")
				))
				var/borg_icon = show_radial_menu(R, R , clown_icons, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)
				if(!borg_icon)
					return FALSE
				switch(borg_icon)
					if("Default")
						disguise = "clown"
						disguise_icon_override = 'icons/mob/robots.dmi'
					else
						return FALSE
			if("Syndicate")
				var/static/list/syndicatejack_icons = sortList(list(
					"Saboteur" = image(icon = 'icons/mob/robots.dmi', icon_state = "synd_engi"),
					"Medical" = image(icon = 'icons/mob/robots.dmi', icon_state = "synd_medical"),
					"Assault" = image(icon = 'icons/mob/robots.dmi', icon_state = "synd_sec")
				))
				var/borg_icon = show_radial_menu(R, R , syndicatejack_icons, custom_check = CALLBACK(src, .proc/check_menu, R), radius = 42, require_near = TRUE)
				if(!borg_icon)
					return FALSE
				switch(borg_icon)
					if("Saboteur")
						disguise = "synd_engi"
						disguise_icon_override = 'icons/mob/robots.dmi'
					if("Medical")
						disguise = "synd_medical"
						disguise_icon_override = 'icons/mob/robots.dmi'
					if("Assault")
						disguise = "synd_sec"
						disguise_icon_override = 'icons/mob/robots.dmi'
					else
						return FALSE
			else
				return FALSE

		animation_playing = TRUE
		to_chat(user, "<span class='notice'>You activate \the [src].</span>")
		playsound(src, 'sound/effects/seedling_chargeup.ogg', 100, TRUE, -6)
		var/start = user.filters.len
		var/X,Y,rsq,i,f
		for(i=1, i<=7, ++i)
			do
				X = 60*rand() - 30
				Y = 60*rand() - 30
				rsq = X*X + Y*Y
			while(rsq<100 || rsq>900)
			user.filters += filter(type="wave", x=X, y=Y, size=rand()*2.5+0.5, offset=rand())
		for(i=1, i<=7, ++i)
			f = user.filters[start+i]
			animate(f, offset=f:offset, time=0, loop=3, flags=ANIMATION_PARALLEL)
			animate(offset=f:offset-1, time=rand()*20+10)
		if (do_after(user, 50, target=user) && user.cell.use(activationCost))
			playsound(src, 'sound/effects/bamf.ogg', 100, TRUE, -6)
			to_chat(user, "<span class='notice'>You are now disguised as the Nanotrasen cyborg \"[friendlyName]\".</span>")
			activate(user, module_selection)
		else
			to_chat(user, "<span class='warning'>The chameleon field fizzles.</span>")
			do_sparks(3, FALSE, user)
			for(i=1, i<=min(7, user.filters.len), ++i) // removing filters that are animating does nothing, we gotta stop the animations first
				f = user.filters[start+i]
				animate(f)
		user.filters = null
		animation_playing = FALSE

/obj/item/borg_shapeshifter/process()
	if (user)
		if (!user.cell || !user.cell.use(activationUpkeep))
			disrupt(user)
	else
		return PROCESS_KILL

/obj/item/borg_shapeshifter/proc/activate(mob/living/silicon/robot/user, disguiseModuleName)
	START_PROCESSING(SSobj, src)
	src.user = user
	savedName = user.name
	savedIcon = user.module.cyborg_base_icon
	savedBubbleIcon = user.bubble_icon //tf is that
	savedOverride = user.module.cyborg_icon_override
	savedPixelOffset = user.module.cyborg_pixel_offset
	savedModuleName = user.module.name
	user.name = friendlyName
	user.module.name = disguiseModuleName
	user.module.cyborg_base_icon = disguise
	user.module.cyborg_icon_override = disguise_icon_override
	user.module.cyborg_pixel_offset = disguise_pixel_offset
	user.module.dogborg = disguise_dogborg
	user.bubble_icon = "robot"
	active = TRUE
	user.update_icons()

	if(listeningTo == user)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, signalCache)
	RegisterSignal(user, signalCache, .proc/disrupt)
	listeningTo = user

/obj/item/borg_shapeshifter/proc/deactivate(mob/living/silicon/robot/user)
	STOP_PROCESSING(SSobj, src)
	if(listeningTo)
		UnregisterSignal(listeningTo, signalCache)
		listeningTo = null
	do_sparks(5, FALSE, user)
	user.name = savedName
	user.module.name = savedModuleName
	user.module.cyborg_base_icon = savedIcon
	user.module.cyborg_icon_override = savedOverride
	user.module.cyborg_pixel_offset = 0
	user.module.dogborg = FALSE
	user.bubble_icon = savedBubbleIcon
	active = FALSE
	user.update_icons()
	disguise_pixel_offset = 0
	disguise_dogborg = FALSE
	src.user = user

/obj/item/borg_shapeshifter/proc/disrupt(mob/living/silicon/robot/user)
	if(active)
		to_chat(user, "<span class='danger'>Your chameleon field deactivates.</span>")
		deactivate(user)

/obj/item/borg_shapeshifter/stable
	signalCache = list()
	activationCost = 0
	activationUpkeep = 0

/obj/item/borg_shapeshifter/stable/activate(mob/living/silicon/robot/user, disguiseModuleName)
	friendlyName = user.name
	. = ..()
