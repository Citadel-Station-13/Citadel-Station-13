/mob/living/silicon/robot/modules/medihound
	set_module = /obj/item/robot_module/medihound

/mob/living/silicon/robot/modules/k9
	set_module = /obj/item/robot_module/k9

/mob/living/silicon/robot/modules/scrubpup
	set_module = /obj/item/robot_module/scrubpup

/mob/living/silicon/robot/modules/borgi
	set_module = /obj/item/robot_module/borgi

/mob/living/silicon/robot/proc/get_cit_modules()
	var/list/modulelist = list()
	modulelist["MediHound"] = /obj/item/robot_module/medihound
	if(!CONFIG_GET(flag/disable_secborg))
		modulelist["Security K-9"] = /obj/item/robot_module/k9
	modulelist["Scrub Puppy"] = /obj/item/robot_module/scrubpup
	modulelist["Borgi"] = /obj/item/robot_module/borgi
	return modulelist

/obj/item/robot_module
	var/sleeper_overlay
	var/icon/cyborg_icon_override
	var/has_snowflake_deadsprite
	var/cyborg_pixel_offset
	var/moduleselect_alternate_icon
	var/dogborg = FALSE

/obj/item/robot_module/k9
	name = "Security K-9 Unit"
	basic_modules = list(
		/obj/item/restraints/handcuffs/cable/zipties,
		/obj/item/storage/bag/borgdelivery,
		/obj/item/dogborg/jaws/big,
		/obj/item/dogborg/pounce,
		/obj/item/clothing/mask/gas/sechailer/cyborg,
		/obj/item/soap/tongue,
		/obj/item/analyzer/nose,
		/obj/item/dogborg/sleeper/K9,
		/obj/item/gun/energy/disabler/cyborg,
		/obj/item/pinpointer/crew)
	emag_modules = list(/obj/item/gun/energy/laser/cyborg)
	ratvar_modules = list(/obj/item/clockwork/slab/cyborg/security,
		/obj/item/clockwork/weapon/ratvarian_spear)
	cyborg_base_icon = "k9"
	moduleselect_icon = "k9"
	moduleselect_alternate_icon = 'modular_citadel/icons/ui/screen_cyborg.dmi'
	can_be_pushed = FALSE
	hat_offset = INFINITY
	sleeper_overlay = "ksleeper"
	cyborg_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
	has_snowflake_deadsprite = TRUE
	dogborg = TRUE
	cyborg_pixel_offset = -16

/obj/item/robot_module/k9/do_transform_animation()
	..()
	to_chat(loc,"<span class='userdanger'>While you have picked the Security K-9 module, you still have to follow your laws, NOT Space Law. \
	For Crewsimov, this means you must follow criminals' orders unless there is a law 1 reason not to.</span>")

/obj/item/robot_module/k9/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/list/sechoundmodels = list("Default")
	if(R.client && R.client.ckey in list("nezuli"))
		sechoundmodels += "Alina"
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in sechoundmodels
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "k9"
			moduleselect_icon = "k9"
		if("Alina")
			cyborg_base_icon = "alina-sec"
			special_light_key = "alina"
			sleeper_overlay = "alinasleeper"
	return ..()

/obj/item/robot_module/medihound
	name = "MediHound"
	basic_modules = list(
		/obj/item/dogborg/jaws/small,
		/obj/item/storage/bag/borgdelivery,
		/obj/item/analyzer/nose,
		/obj/item/soap/tongue,
		/obj/item/extinguisher/mini,
		/obj/item/healthanalyzer,
		/obj/item/dogborg/sleeper/medihound,
		/obj/item/roller/robo,
		/obj/item/reagent_containers/borghypo,
		/obj/item/twohanded/shockpaddles/cyborg/hound,
		/obj/item/stack/medical/gauze/cyborg,
		/obj/item/pinpointer/crew,
		/obj/item/sensor_device)
	emag_modules = list(/obj/item/dogborg/pounce)
	ratvar_modules = list(/obj/item/clockwork/slab/cyborg/medical,
		/obj/item/clockwork/weapon/ratvarian_spear)
	cyborg_base_icon = "medihound"
	moduleselect_icon = "medihound"
	moduleselect_alternate_icon = 'modular_citadel/icons/ui/screen_cyborg.dmi'
	can_be_pushed = FALSE
	hat_offset = INFINITY
	sleeper_overlay = "msleeper"
	cyborg_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
	has_snowflake_deadsprite = TRUE
	dogborg = TRUE
	cyborg_pixel_offset = -16

/obj/item/robot_module/medihound/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/list/medhoundmodels = list("Default", "Dark")
	if(R.client && R.client.ckey in list("nezuli"))
		medhoundmodels += "Alina"
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in medhoundmodels
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "medihound"
		if("Dark")
			cyborg_base_icon = "medihounddark"
			sleeper_overlay = "mdsleeper"
		if("Alina")
			cyborg_base_icon = "alina-med"
			special_light_key = "alina"
			sleeper_overlay = "alinasleeper"
	return ..()

/obj/item/robot_module/scrubpup
	name = "Scrub Pup"
	basic_modules = list(
		/obj/item/dogborg/jaws/small,
		/obj/item/analyzer/nose,
		/obj/item/soap/tongue/scrubpup,
		/obj/item/lightreplacer/cyborg,
		/obj/item/extinguisher/mini,
		/obj/item/dogborg/sleeper/compactor)
	emag_modules = list(/obj/item/dogborg/pounce)
	ratvar_modules = list(
		/obj/item/clockwork/slab/cyborg/janitor,
		/obj/item/clockwork/replica_fabricator/cyborg)
	cyborg_base_icon = "scrubpup"
	moduleselect_icon = "janitor"
	hat_offset = INFINITY
	clean_on_move = TRUE
	sleeper_overlay = "jsleeper"
	cyborg_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
	has_snowflake_deadsprite = TRUE
	cyborg_pixel_offset = -16
	dogborg = TRUE

/obj/item/robot_module/scrubpup/respawn_consumable(mob/living/silicon/robot/R, coeff = 1)
	..()
	var/obj/item/lightreplacer/LR = locate(/obj/item/lightreplacer) in basic_modules
	if(LR)
		for(var/i in 1 to coeff)
			LR.Charge(R)

/obj/item/robot_module/scrubpup/do_transform_animation()
	..()
	to_chat(loc,"<span class='userdanger'>As tempting as it might be, do not begin binging on important items. Eat your garbage responsibly. People are not included under Garbage.</span>")

/obj/item/robot_module/borgi
	name = "Borgi"
	basic_modules = list(
		/obj/item/dogborg/jaws/small,
		/obj/item/storage/bag/borgdelivery,
		/obj/item/analyzer/nose,
		/obj/item/soap/tongue,
		/obj/item/healthanalyzer,
		/obj/item/extinguisher/mini,
		/obj/item/borg/cyborghug)
	emag_modules = list(/obj/item/dogborg/pounce)
	ratvar_modules = list(
		/obj/item/clockwork/slab/cyborg,
		/obj/item/clockwork/weapon/ratvarian_spear,
		/obj/item/clockwork/replica_fabricator/cyborg)
	cyborg_base_icon = "borgi"
	moduleselect_icon = "borgi"
	moduleselect_alternate_icon = 'modular_citadel/icons/ui/screen_cyborg.dmi'
	hat_offset = INFINITY
	cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
	has_snowflake_deadsprite = TRUE

/*
/obj/item/robot_module/orepup
	name = "Ore Pup"
	basic_modules = list(
		/obj/item/storage/bag/ore/cyborg,
		/obj/item/analyzer/nose,
		/obj/item/storage/bag/borgdelivery,
		/obj/item/dogborg/sleeper/ore,
		/obj/item/pickaxe/drill/cyborg,
		/obj/item/shovel,
		/obj/item/crowbar/cyborg,
		/obj/item/weldingtool/mini,
		/obj/item/extinguisher/mini,
		/obj/item/t_scanner/adv_mining_scanner,
		/obj/item/gun/energy/kinetic_accelerator/cyborg,
		/obj/item/gps/cyborg)
	emag_modules = list(/obj/item/dogborg/pounce)
	ratvar_modules = list(
		/obj/item/clockwork/slab/cyborg/miner,
		/obj/item/clockwork/weapon/ratvarian_spear,
		/obj/item/borg/sight/xray/truesight_lens)
	cyborg_base_icon = "orepup"
	moduleselect_icon = "orepup"
	sleeper_overlay = "osleeper"
	cyborg_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
	has_snowflake_deadsprite = TRUE
	cyborg_pixel_offset = -16

/obj/item/robot_module/miner/do_transform_animation()
	var/mob/living/silicon/robot/R = loc
	R.cut_overlays()
	R.setDir(SOUTH)
	flick("orepup_transform", R)
	do_transform_delay()
	R.update_headlamp()
*/

/obj/item/robot_module/medical/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Default", "Heavy", "Sleek", "Marina", "Droid", "Eyebot")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "medical"
		if("Droid")
			cyborg_base_icon = "medical"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
			hat_offset = 4
		if("Sleek")
			cyborg_base_icon = "sleekmed"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Marina")
			cyborg_base_icon = "marinamed"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Eyebot")
			cyborg_base_icon = "eyebotmed"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Heavy")
			cyborg_base_icon = "heavymed"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
	return ..()

/obj/item/robot_module/janitor/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/list/janimodels = list("Default", "Sleek", "Marina", "Can", "Heavy")
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in janimodels
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "janitor"
		if("Marina")
			cyborg_base_icon = "marinajan"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Sleek")
			cyborg_base_icon = "sleekjan"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Can")
			cyborg_base_icon = "canjan"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Heavy")
			cyborg_base_icon = "heavyres"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
	return ..()

/obj/item/robot_module/peacekeeper/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Default", "Spider")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "peace"
		if("Spider")
			cyborg_base_icon = "whitespider"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
	return ..()

/obj/item/robot_module/security/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Default", "Default - Treads", "Heavy", "Sleek", "Can", "Marina", "Spider")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "sec"
		if("Default - Treads")
			cyborg_base_icon = "sec-tread"
			special_light_key = "sec"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Sleek")
			cyborg_base_icon = "sleeksec"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Marina")
			cyborg_base_icon = "marinasec"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Can")
			cyborg_base_icon = "cansec"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Spider")
			cyborg_base_icon = "spidersec"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Heavy")
			cyborg_base_icon = "heavysec"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
	return ..()

/obj/item/robot_module/butler/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Waitress", "Heavy", "Sleek", "Butler", "Tophat", "Kent", "Bro")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Waitress")
			cyborg_base_icon = "service_f"
		if("Butler")
			cyborg_base_icon = "service_m"
		if("Bro")
			cyborg_base_icon = "brobot"
		if("Kent")
			cyborg_base_icon = "kent"
			special_light_key = "medical"
			hat_offset = 3
		if("Tophat")
			cyborg_base_icon = "tophat"
			special_light_key = null
			hat_offset = INFINITY //He is already wearing a hat
		if("Sleek")
			cyborg_base_icon = "sleekserv"
			special_light_key = "sleekserv"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Heavy")
			cyborg_base_icon = "heavyserv"
			special_light_key = "heavyserv"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
	return ..()

/obj/item/robot_module/engineering/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/list/engymodels = list("Default", "Default - Treads", "Heavy", "Sleek", "Marina", "Can", "Spider", "Loader","Handy", "Pup Dozer")
	if(R.client && R.client.ckey in list("nezuli"))
		engymodels += "Alina"
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in engymodels
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "engineer"
		if("Default - Treads")
			cyborg_base_icon = "engi-tread"
			special_light_key = "engineer"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Loader")
			cyborg_base_icon = "loaderborg"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
			has_snowflake_deadsprite = TRUE
		if("Handy")
			cyborg_base_icon = "handyeng"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Sleek")
			cyborg_base_icon = "sleekeng"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Can")
			cyborg_base_icon = "caneng"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Marina")
			cyborg_base_icon = "marinaeng"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Spider")
			cyborg_base_icon = "spidereng"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Heavy")
			cyborg_base_icon = "heavyeng"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Pup Dozer")
			cyborg_base_icon = "pupdozer"
			can_be_pushed = FALSE
			hat_offset = INFINITY
			cyborg_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
			has_snowflake_deadsprite = TRUE
			dogborg = TRUE
			cyborg_pixel_offset = -16
		if("Alina")
			cyborg_base_icon = "alina-eng"
			special_light_key = "alina"
			can_be_pushed = FALSE
			hat_offset = INFINITY
			cyborg_icon_override = 'modular_citadel/icons/mob/widerobot.dmi'
			has_snowflake_deadsprite = TRUE
			dogborg = TRUE
			cyborg_pixel_offset = -16
	return ..()

/obj/item/robot_module/miner/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Lavaland", "Heavy", "Sleek", "Marina", "Can", "Spider", "Asteroid", "Droid")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Lavaland")
			cyborg_base_icon = "miner"
		if("Asteroid")
			cyborg_base_icon = "minerOLD"
			special_light_key = "miner"
		if("Droid")
			cyborg_base_icon = "miner"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
			hat_offset = 4
		if("Sleek")
			cyborg_base_icon = "sleekmin"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Can")
			cyborg_base_icon = "canmin"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Marina")
			cyborg_base_icon = "marinamin"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Spider")
			cyborg_base_icon = "spidermin"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Heavy")
			cyborg_base_icon = "heavymin"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
	return ..()
