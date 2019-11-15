/obj/item/borgroller
	name = "collision autotargeter"
	icon = 'icons/obj/device.dmi'
	icon_state = "shield0"
	flags_1 = CONDUCT_1
	force = 5

/obj/item/borgroller/afterattack(atom/target, mob/living/silicon/user, proximity_flag, click_parameters)//	deploy time
	if(istype(user))
		user.visible_message("<span class='notice'>[user] whirrs and charges!</span>", "<span class='notice'>You roll up and charge!/span>")
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

/mob/living/silicon/robot/syndeka/proc/toggle_movemode()
	uneq_module(held_items[1])
	uneq_module(held_items[2])
	uneq_module(held_items[3])

/obj/item/melee/borgclaw
	name = "robot claws"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "2knife"
	flags_1 = CONDUCT_1
	force = 25
