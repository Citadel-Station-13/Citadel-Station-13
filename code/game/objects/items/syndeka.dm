/obj/item/borgroller
	name = "collision autotargeter"
	icon = 'icons/obj/device.dmi'
	icon_state = "shield0"
	flags_1 = CONDUCT_1
	force = 5

/obj/item/borgroller/afterattack(atom/target, mob/living/silicon/user, proximity_flag, click_parameters)//	deploy time
	if(istype(user))
		if(istype(target, /obj))
			user.visible_message("<span class='notice'>[user] whirrs and charges at [target]!</span>", "<span class='notice'>You charge at [target]!</span>")
		walk_towards(user,target,0.1,10)
		user.icon_state = "synd_hatin"
		var/turf/T = get_turf(target)
		var/safety = 10
		while((get_turf(user) != T) && (safety > 0) && !(target.Adjacent(user)))
			sleep(1)
			safety--
	if(target.Adjacent(user))
		if(istype(target, /obj))
			var/obj/O = target
			user.visible_message("<span class='notice'>[user] collides with [O]!</span>", "<span class='notice'>You collide with [O]!</span>")
			O.take_damage(20, BRUTE, "melee", 1, 100) //20 brute, melee, 100% armor pen. Pretty robust.
		if(istype(target, /mob/living/carbon))
			var/mob/living/carbon/C = target
			user.visible_message("<span class='notice'>[user] smashes into [C]!</span>", "<span class='notice'>You violently impact [C]!</span>")
			C.Knockdown(1, TRUE, FALSE, 0.1, 45) //45 stam, 0.1 hardstun and 1sec softstun
			C.apply_damage_type(20, BRUTE)
		user.icon_state = "synd_rollin"
		walk(user,0)
	return TRUE


/obj/item/melee/borgclaw
	name = "robot claws"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "2knife"
	flags_1 = CONDUCT_1
	force = 25

/obj/item/borgshield //the shield "flashes" when hit.
	name = "personal shielding"
	desc = "A powerful experimental module that turns aside or absorbs incoming attacks at the cost of charge."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "eshield1"
	var/active = TRUE 					//If the shield is on
	var/flash_count = 0				//Counter for how many times the shield has been flashed
	var/overload_threshold = 3		//Number of flashes it takes to overload the shield
	var/shield_refresh = 5 SECONDS	//Time it takes for the shield to reboot after destabilizing
	var/overload_time = 0			//Stores the time of overload
	var/last_flash = 0				//Stores the time of last flash

/obj/item/borgshield/Initialize()
	START_PROCESSING(SSobj, src)
	..()

/obj/item/borgshield/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/borgshield/attack_self(var/mob/living/silicon/robot/user)
	active = !active
	user.shielded = active

/obj/item/borgshield/process()
	if(flash_count && (last_flash + shield_refresh < world.time))
		flash_count = 0
		last_flash = 0
	else if(overload_time + shield_refresh < world.time)
		active = 1
		flash_count = 0
		overload_time = 0
		var/mob/living/user = src.loc
		user.visible_message("<span class='danger'>[user]'s shield reactivates!</span>", "<span class='danger'>Your shield reactivates!.</span>")
		user.update_icons()

/obj/item/borgshield/proc/adjust_flash_count(var/mob/living/user, amount)
	if(active)			//Can't destabilize a shield that's not on
		flash_count += amount

		if(amount > 0)
			last_flash = world.time
			if(flash_count >= overload_threshold)
				overload(user)

/obj/item/borgshield/proc/overload(var/mob/living/silicon/robot/user)
	active = 0
	user.shielded = active
	user.visible_message("<span class='danger'>[user]'s shield destabilizes!</span>", "<span class='danger'>Your shield destabilizes!.</span>")
	user.update_icons()
	overload_time = world.time
