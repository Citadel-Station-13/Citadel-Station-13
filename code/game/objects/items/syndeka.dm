/obj/item/borgroller
	name = "collision autotargeter"
	icon = 'icons/obj/device.dmi'
	icon_state = "shield0"
	flags_1 = CONDUCT_1
	force = 5

/obj/item/borgroller/afterattack(atom/target, mob/living/silicon/robot/user, proximity_flag, click_parameters)//	deploy time
	if(istype(user))
		user.shielded = FALSE
		user.update_icons()
		if(istype(target, /obj))
			user.visible_message("<span class='notice'>[user] whirrs and charges at [target]!</span>", "<span class='notice'>You charge at [target]!</span>")
		walk_towards(user,target,0.1,10)
		user.cell.charge -= 100
		user.icon_state = "synd_hatin"
		var/turf/T = get_turf(target)
		var/safety = 15
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

/obj/item/borgshield
	name = "personal shielding"
	desc = "A powerful experimental module that turns aside or absorbs incoming attacks at the cost of charge."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "eshield1"
	var/active = FALSE 					//If the shield is on

/obj/item/borgshield/attack_self(var/mob/living/silicon/robot/user)
	active = !active
	user.shielded = active
	user.update_icons()

