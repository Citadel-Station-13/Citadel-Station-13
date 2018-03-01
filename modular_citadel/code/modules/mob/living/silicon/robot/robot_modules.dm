/mob/living/silicon/robot/proc/get_cit_modules()
	var/list/modulelist = list()
	modulelist["MediHound"] = /obj/item/robot_module/medihound
	if(!CONFIG_GET(flag/disable_secborg))
		modulelist["Security K-9"] = /obj/item/robot_module/k9
	modulelist["Scrub Puppy"] = /obj/item/robot_module/scrubpup
	return modulelist

/obj/item/robot_module
	var/sleeper_overlay
	var/icon/cyborg_icon_override
	var/has_snowflake_deadsprite
	var/cyborg_pixel_offset
	var/moduleselect_alternate_icon

/obj/item/robot_module/k9
	name = "Security K-9 Unit module"
	basic_modules = list(
		/obj/item/restraints/handcuffs/cable/zipties/cyborg/dog,
		/obj/item/dogborg/jaws/big,
		/obj/item/dogborg/pounce,
		/obj/item/clothing/mask/gas/sechailer/cyborg,
		/obj/item/soap/tongue,
		/obj/item/device/analyzer/nose,
		/obj/item/device/dogborg/sleeper/K9,
		/obj/item/gun/energy/disabler/cyborg,
		/obj/item/pinpointer/crew)
	emag_modules = list(/obj/item/gun/energy/laser/cyborg)
	ratvar_modules = list(/obj/item/clockwork/slab/cyborg/security,
		/obj/item/clockwork/weapon/ratvarian_spear)
	cyborg_base_icon = "k9"
	moduleselect_icon = "security"
	can_be_pushed = FALSE
	hat_offset = INFINITY
	sleeper_overlay = "ksleeper"
	cyborg_icon_override = 'icons/mob/widerobot.dmi'
	has_snowflake_deadsprite = TRUE
	cyborg_pixel_offset = -16

/obj/item/robot_module/k9/do_transform_animation()
	..()
	to_chat(loc,"<span class='userdanger'>While you have picked the Security K-9 module, you still have to follow your laws, NOT Space Law. \
	For Asimov, this means you must follow criminals' orders unless there is a law 1 reason not to.</span>")

/obj/item/robot_module/medihound
	name = "MediHound module"
	basic_modules = list(
		/obj/item/dogborg/jaws/small,
		/obj/item/device/analyzer/nose,
		/obj/item/soap/tongue,
		/obj/item/device/healthanalyzer,
		/obj/item/device/dogborg/sleeper/medihound,
		/obj/item/reagent_containers/borghypo/hound,
		/obj/item/twohanded/shockpaddles/hound,
		/obj/item/stack/medical/gauze/cyborg,
		/obj/item/device/sensor_device)
	emag_modules = list(/obj/item/dogborg/pounce)
	ratvar_modules = list(/obj/item/clockwork/slab/cyborg/medical,
		/obj/item/clockwork/weapon/ratvarian_spear)
	cyborg_base_icon = "medihound"
	moduleselect_icon = "medical"
	can_be_pushed = FALSE
	hat_offset = INFINITY
	sleeper_overlay = "msleeper"
	cyborg_icon_override = 'icons/mob/widerobot.dmi'
	has_snowflake_deadsprite = TRUE
	cyborg_pixel_offset = -16

/obj/item/robot_module/medihound/do_transform_animation()
	..()
	to_chat(loc, "<span class='userdanger'>Under ASIMOV, you are an enforcer of the PEACE and preventer of HUMAN HARM. \
	You are not a security module and you are expected to follow orders and prevent harm above all else. Space law means nothing to you.</span>")

/obj/item/robot_module/scrubpup
	name = "Janitor"
	basic_modules = list(
		/obj/item/dogborg/jaws/small,
		/obj/item/device/analyzer/nose,
		/obj/item/soap/tongue/scrubpup,
		/obj/item/device/lightreplacer/cyborg,
		/obj/item/device/dogborg/sleeper/compactor)
	emag_modules = list(/obj/item/dogborg/pounce)
	ratvar_modules = list(
		/obj/item/clockwork/slab/cyborg/janitor,
		/obj/item/clockwork/replica_fabricator/cyborg)
	cyborg_base_icon = "scrubpup"
	moduleselect_icon = "janitor"
	hat_offset = INFINITY
	clean_on_move = TRUE
	sleeper_overlay = "jsleeper"
	cyborg_icon_override = 'icons/mob/widerobot.dmi'
	has_snowflake_deadsprite = TRUE
	cyborg_pixel_offset = -16

/obj/item/robot_module/scrubpup/respawn_consumable(mob/living/silicon/robot/R, coeff = 1)
	..()
	var/obj/item/device/lightreplacer/LR = locate(/obj/item/device/lightreplacer) in basic_modules
	if(LR)
		for(var/i in 1 to coeff)
			LR.Charge(R)

/obj/item/robot_module/scrubpup/do_transform_animation()
	..()
	to_chat(loc,"<span class='userdanger'>As tempting as it might be, do not begin binging on important items. Eat your garbage responsibly. People are not included under Garbage.</span>")


/obj/item/robot_module/medical/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Default", "Droid")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "medical"
		if("Droid")
			cyborg_base_icon = "medical"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
			hat_offset = 4
	return ..()

/obj/item/robot_module/security/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Default", "Default - Treads", "Droid")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "sec"
		if("Default - Treads")
			cyborg_base_icon = "sec-tread"
			special_light_key = "sec"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
		if("Droid")
			cyborg_base_icon = "Security"
			special_light_key = "service"
			hat_offset = 0
	return ..()

/obj/item/robot_module/engineering/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Default", "Default - Treads")
	if(!borg_icon)
		return FALSE
	switch(borg_icon)
		if("Default")
			cyborg_base_icon = "engineer"
		if("Default - Treads")
			cyborg_base_icon = "engi-tread"
			special_light_key = "engineer"
			cyborg_icon_override = 'modular_citadel/icons/mob/robots.dmi'
	return ..()

/obj/item/robot_module/miner/be_transformed_to(obj/item/robot_module/old_module)
	var/mob/living/silicon/robot/R = loc
	var/borg_icon = input(R, "Select an icon!", "Robot Icon", null) as null|anything in list("Lavaland", "Asteroid", "Droid")
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
	return ..()