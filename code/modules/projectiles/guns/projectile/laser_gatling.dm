

//The ammo/gun is stored in a back slot item
/obj/item/weapon/minigunpack
	name = "backpack power source"
	desc = "The massive external power source for the laser gatling gun"
	icon = 'icons/obj/guns/minigun.dmi'
	icon_state = "holstered"
	item_state = "backpack"
	slot_flags = SLOT_BACK
	w_class = 5
	var/obj/item/weapon/gun/projectile/minigun/gun = null
	var/armed = 0 //whether the gun is attached, 0 is attached, 1 is the gun is wielded.
	var/overheat = 0
	var/overheat_max = 40
	var/heat_diffusion = 1

/obj/item/weapon/minigunpack/New()
	gun = new(src)
	START_PROCESSING(SSobj, src)
	..()

/obj/item/weapon/minigunpack/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/weapon/minigunpack/process()
	overheat = max(0, overheat - heat_diffusion)

/obj/item/weapon/minigunpack/attack_hand(var/mob/living/carbon/user)
	if(src.loc == user)
		if(!armed)
			if(user.get_item_by_slot(slot_back) == src)
				armed = 1
				if(!user.put_in_hands(gun))
					armed = 0
					user << "<span class='warning'>You need a free hand to hold the gun!</span>"
					return
				update_icon()
				gun.forceMove(user)
				user.update_inv_back()
		else
			user << "<span class='warning'>You are already holding the gun!</span>"
	else
		..()

/obj/item/weapon/minigunpack/attackby(obj/item/weapon/W, mob/user, params)
	if(W == gun) //Don't need armed check, because if you have the gun assume its armed.
		user.unEquip(gun,1)
	else
		..()

/obj/item/weapon/minigunpack/dropped(mob/user)
	if(armed)
		user.unEquip(gun,1)

/obj/item/weapon/minigunpack/MouseDrop(atom/over_object)
	if(armed)
		return
	if(iscarbon(usr))
		var/mob/M = usr

		if(!over_object)
			return

		if(!M.restrained() && !M.stat)

			if(istype(over_object, /obj/screen/inventory/hand))
				var/obj/screen/inventory/hand/H = over_object
				if(!M.unEquip(src))
					return
				switch(H.slot_id)
					if(slot_r_hand)
						M.put_in_r_hand(src)
					if(slot_l_hand)
						M.put_in_l_hand(src)


/obj/item/weapon/minigunpack/update_icon()
	if(armed)
		icon_state = "notholstered"
	else
		icon_state = "holstered"

/obj/item/weapon/minigunpack/proc/attach_gun(var/mob/user)
	if(!gun)
		gun = new(src)
	gun.forceMove(src)
	armed = 0
	if(user)
		user << "<span class='notice'>You attach the [gun.name] to the [name].</span>"
	else
		src.visible_message("<span class='warning'>The [gun.name] snaps back onto the [name]!</span>")
	update_icon()
	user.update_inv_back()


/obj/item/weapon/gun/projectile/minigun
	name = "laser gatling gun"
	desc = "An advanced laser cannon with an incredible rate of fire. Requires a bulky backpack power source to use."
	icon = 'icons/obj/guns/minigun.dmi'
	icon_state = "minigun_spin"
	item_state = "minigun"
	origin_tech = "combat=6;powerstorage=5;magnets=4"
	flags = CONDUCT | HANDSLOW
	slowdown = 1
	slot_flags = null
	w_class = 5
	materials = list()
	burst_size = 3
	automatic = 0
	fire_delay = 1
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/weapons/Laser.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/minigun
	var/obj/item/weapon/minigunpack/ammo_pack

/obj/item/weapon/gun/projectile/minigun/attack_self(mob/living/user)
	return

/obj/item/weapon/gun/projectile/minigun/dropped(mob/user)
	if(ammo_pack)
		ammo_pack.attach_gun(user)
	else
		qdel(src)

/obj/item/weapon/gun/projectile/minigun/shoot_live_shot(mob/living/user as mob|obj, pointblank = 0, mob/pbtarget = null, message = 1)
	if(ammo_pack)
		if(ammo_pack.overheat < ammo_pack.overheat_max)
			. = ..()
			ammo_pack.overheat++
		else
			user << "The gun's heat sensor locked the trigger to prevent lens damage."

/obj/item/weapon/gun/projectile/minigun/afterattack(atom/target, mob/living/user, flag, params)
	if(!ammo_pack || ammo_pack.loc != user)
		user << "You need the backpack power source to fire the gun!"
	..()

/obj/item/weapon/gun/projectile/minigun/New()
	if(!ammo_pack)
		if(istype(loc,/obj/item/weapon/minigunpack)) //We should spawn inside a ammo pack so let's use that one.
			ammo_pack = loc
		else
			qdel(src)//No pack, no gun
	..()

/obj/item/weapon/gun/projectile/minigun/dropped(mob/living/user)
	ammo_pack.attach_gun(user)

/obj/item/weapon/gun/projectile/minigun/process_chamber(eject_casing = 0, empty_chamber = 1)
	..()

