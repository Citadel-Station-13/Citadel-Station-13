//The ammo/gun is stored in a back slot item
/obj/item/minigunpack2
	name = " Laser Gatling Pack"
	desc = "A massive battery pack with an attached laser gatling gun!"
	icon = 'icons/obj/guns/minigun.dmi'
	icon_state = "holstered"
	item_state = "backpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_HUGE
	var/obj/item/gun/energy/minigun/gun
	var/armed = 0 //whether the gun is attached, 0 is attached, 1 is the gun is wielded.
	var/overheat = 0
	var/overheat_max = 50
	var/heat_diffusion = 2

/obj/item/minigunpack2/Initialize()
	. = ..()
	gun = new(src)
	START_PROCESSING(SSobj, src)

/obj/item/minigunpack2/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/minigunpack2/process()
	overheat = max(0, overheat - heat_diffusion)

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/minigunpack2/attack_hand(var/mob/living/carbon/user)
	if(src.loc == user)
		if(!armed)
			if(user.get_item_by_slot(SLOT_BACK) == src)
				armed = 1
				if(!user.put_in_hands(gun))
					armed = 0
					to_chat(user, "<span class='warning'>You need a free hand to hold the gun!</span>")
					return
				update_icon()
				user.update_inv_back()
		else
			to_chat(user, "<span class='warning'>You are already holding the gun!</span>")
	else
		..()

/obj/item/minigunpack2/attackby(obj/item/W, mob/user, params)
	if(W == gun) //Don't need armed check, because if you have the gun assume its armed.
		user.dropItemToGround(gun, TRUE)
	else
		..()

/obj/item/minigunpack2/dropped(mob/user)
	if(armed)
		user.dropItemToGround(gun, TRUE)

/obj/item/minigunpack2/MouseDrop(atom/over_object)
	. = ..()
	if(armed)
		return
	if(iscarbon(usr))
		var/mob/M = usr

		if(!over_object)
			return

		if(!M.incapacitated())

			if(istype(over_object, /obj/screen/inventory/hand))
				var/obj/screen/inventory/hand/H = over_object
				M.putItemFromInventoryInHandIfPossible(src, H.held_index)


/obj/item/minigunpack2/update_icon()
	if(armed)
		icon_state = "notholstered"
	else
		icon_state = "holstered"

/obj/item/minigunpack2/proc/attach_gun(var/mob/user)
	if(!gun)
		gun = new(src)
	gun.forceMove(src)
	armed = 0
	if(user)
		to_chat(user, "<span class='notice'>You attach the [gun.name] to the [name].</span>")
	else
		src.visible_message("<span class='warning'>The [gun.name] snaps back onto the [name]!</span>")
	update_icon()
	user.update_inv_back()


/obj/item/gun/energy/minigun
	name = "laser gatling gun"
	desc = "An advanced laser cannon with an incredible rate of fire. Requires a bulky backpack power source to use."
	icon = 'icons/obj/guns/minigun.dmi'
	icon_state = "minigun_spin"
	item_state = "minigun"
	flags_1 = CONDUCT_1
	slowdown = 1
	slot_flags = null
	w_class = WEIGHT_CLASS_HUGE
	materials = list()
	ammo_type = list(/obj/item/ammo_casing/energy/laser/weak)
	burst_size = 2
	automatic = 1
	can_charge = 0
	selfcharge = EGUN_SELFCHARGE
	charge_tick = 2
	charge_delay = 5
	weapon_weight = WEAPON_HEAVY
	item_flags = NEEDS_PERMIT | SLOWS_WHILE_IN_HAND
	var/obj/item/minigunpack2/ammo_pack

/obj/item/gun/energy/minigun/Initialize()
	if(istype(loc, /obj/item/minigunpack2)) //We should spawn inside an ammo pack so let's use that one.
		ammo_pack = loc
	else
		return INITIALIZE_HINT_QDEL //No pack, no gun

	return ..()

/obj/item/gun/energy/minigun/attack_self(mob/living/user)
	return

/obj/item/gun/energy/minigun/dropped(mob/user)
	if(ammo_pack)
		ammo_pack.attach_gun(user)
	else
		qdel(src)

/obj/item/gun/energy/minigun/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 15)
	if(ammo_pack)
		if(ammo_pack.overheat < ammo_pack.overheat_max)
			ammo_pack.overheat += burst_size
			..()
		else
			to_chat(user, "The gun's heat sensor locked the trigger to prevent lens damage.")

/obj/item/gun/energy/minigun/afterattack(atom/target, mob/living/user, flag, params)
	if(!ammo_pack || ammo_pack.loc != user)
		to_chat(user, "You need the backpack power source to fire the gun!")
	. = ..()

/obj/item/gun/energy/minigun/dropped(mob/living/user)
	ammo_pack.attach_gun(user)

